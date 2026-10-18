---
title: "Windows PE 파일 구조 및 Win32 API 기반 윈도우 시스템 프로그래밍 기초"
description: "윈도우 운영체제의 실행 파일 표준 포맷인 PE(Portable Executable) 구조(DOS/NT 헤더, 섹션 테이블)와 가상 메모리 매핑 원리, 섹션별 접근 권한(RX, RW, R) 및 Win32 시스템 프로그래밍 기초를 총정리합니다."
slug: "windows-pe-format-and-win32-system-programming"
date: 2024-05-12T16:02:25+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WindowApp"]
tags: ["windows", "win32", "pe-format", "system-programming", "reverse-engineering"]
ShowToc: true
TocOpen: true
---

Windows 운영체제에서 실행 가능한 모든 바이너리(EXE, DLL, SYS 등)는 **PE(Portable Executable)**라는 표준 파일 포맷을 따릅니다. 리눅스의 ELF(Executable and Linkable Format)에 대응되는 개념으로, 윈도우 로더(Windows Loader)가 파일을 메모리에 매핑하고 실행하기 위한 메타데이터와 코드가 정밀하게 정의되어 있습니다.

이 글에서는 PE 파일 포맷의 계층적 구조(DOS Header, NT Header, Section Table), 가상 메모리 주소 매핑 원리, 주요 섹션의 메모리 보호 권한, 그리고 Win32 시스템 프로그래밍의 핵심 개념을 정리합니다.

---

## 1. Windows PE(Portable Executable) 파일 포맷 개요

PE 포맷은 32비트(PE32) 및 64비트(PE32+) 환경 모두에서 일관된 구조를 유지하며, 디스크에 저장된 오프셋(RAW)과 메모리에 로드된 가상 주소(VA)를 연결합니다.

### 1.1. VA(Virtual Address)와 RVA(Relative Virtual Address)
- **ImageBase**: 실행 파일이 가상 메모리에 매핑될 때의 시작 기준 주소입니다. (32비트 EXE 기본값: `0x00400000`, 64비트: `0x0000000140000000`)
- **RVA (상대 가상 주소)**: ImageBase를 기준으로 떨어진 상대적 오프셋 거리입니다.
- **VA (절대 가상 주소)**: 프로세스 가상 메모리 공간 상의 실제 주소로, `VA = ImageBase + RVA` 수식으로 계산됩니다.

---

## 2. PE 헤더의 계층적 구조

PE 파일은 크게 헤더 영역(Headers)과 실제 데이터 및 코드가 담긴 섹션(Sections)으로 구성됩니다.

```text
+-----------------------+
|      DOS Header       |  (e_magic: 'MZ', e_lfanew: NT Header 오프셋)
+-----------------------+
|       DOS Stub        |  ("This program cannot be run in DOS mode")
+-----------------------+
|       NT Header       |  (Signature: 'PE\0\0')
|  - File Header        |  (머신 아키텍처, 섹션 개수, 타임스탬프)
|  - Optional Header    |  (ImageBase, EntryPoint, 메모리 정렬 크기)
+-----------------------+
|     Section Table     |  (.text, .data, .rdata 등 각 섹션의 헤더 배열)
+-----------------------+
|     Section .text     |  (CPU 기계어 코드)
+-----------------------+
|     Section .data     |  (전역/정적 변수)
+-----------------------+
|     Section .rdata    |  (상수 및 IAT/Import Directory)
+-----------------------+
```

### 2.1. DOS Header 및 DOS Stub
과거 MS-DOS와의 하위 호환성을 위해 유지되는 영역입니다.
- `e_magic`: 파일의 시작을 알리는 매직 넘버 `0x5A4D` (`MZ`).
- `e_lfanew`: 실제 윈도우 NT Header가 시작되는 파일 오프셋 위치를 가리키는 필수 포인터입니다.

### 2.2. NT Header (`IMAGE_NT_HEADERS`)
- **Signature**: `0x00004550` (`PE\0\0`)
- **File Header**: 타깃 아키텍처(x86: `0x014C`, x64: `0x8664`), 섹션의 개수(`NumberOfSections`), 심볼 테이블 정보 포함.
- **Optional Header**: 실행 진입점(`AddressOfEntryPoint`), 메모리 정렬 단위(`SectionAlignment`), 파일 정렬 단위(`FileAlignment`) 등 윈도우 로더가 프로세스를 초기화하는 데 필요한 핵심 파라미터가 담겨 있습니다.

### 2.3. Section Table (`IMAGE_SECTION_HEADER`)
각 섹션의 이름, 가상 메모리 크기(`VirtualSize`), 가상 메모리 RVA(`VirtualAddress`), 디스크 파일 크기(`SizeOfRawData`), 디스크 오프셋(`PointerToRawData`), 그리고 메모리 보호 특성(`Characteristics`)을 정의하는 헤더 배열입니다.

---

## 3. 주요 PE 섹션(Section)의 역할 및 접근 권한

보안(DEP/NX) 및 메모리 보호를 위해 각 섹션에는 엄격한 읽기/쓰기/실행 권한이 부여됩니다.

### 3.1. `.text` 섹션 (코드 영역)
- **역할**: 컴파일된 기계어 명령어가 위치하는 실행 코드 본문 영역입니다.
- **메모리 권한**: **`IMAGE_SCN_MEM_EXECUTE | IMAGE_SCN_MEM_READ` (RX - 읽기 및 실행 가능)**
- 임의 코드 주입 및 메모리 변조를 막기 위해 일반적인 환경에서는 쓰기(Write) 권한이 철저히 차단됩니다.

### 3.2. `.data` 섹션 (가변 데이터 영역)
- **역할**: 초기화된 전역 변수(Global Variable) 및 정적 변수(Static Variable)가 저장됩니다.
- **메모리 권한**: **`IMAGE_SCN_MEM_READ | IMAGE_SCN_MEM_WRITE` (RW - 읽기 및 쓰기 가능)**

### 3.3. `.rdata` 및 `.rsrc` 섹션 (읽기 전용 데이터 및 리소스)
- **`.rdata`**: 문자열 상수, C++ 가상 함수 테이블(vtable), 외부 DLL 함수 임포트 정보인 IAT(Import Address Table)가 위치합니다. 권한은 **`IMAGE_SCN_MEM_READ` (R - 읽기 전용)**입니다.
- **`.rsrc`**: 아이콘, 커서, 메뉴, 대화상자 등 애플리케이션 리소스가 저장됩니다.

---

## 4. Win32 API와 이벤트 기반 윈도우 프로시저(WndProc)

C/C++ 기반의 네이티브 윈도우 프로그래밍은 커널 오브젝트 핸들(Handle)과 운영체제 메시지 루프를 기반으로 동작합니다.

### 4.1. 메시지 큐와 윈도우 프로시저
운영체제는 키보드, 마우스 입력 등의 하드웨어 이벤트를 감지하면 해당 애플리케이션의 메시지 큐(Message Queue)에 메시지(`WM_LBUTTONDOWN`, `WM_PAINT`, `WM_DESTROY` 등)를 전달합니다. 애플리케이션은 메시지 루프(`GetMessage` &rarr; `DispatchMessage`)를 순회하며 콜백 함수인 **윈도우 프로시저(WndProc)**로 디스패치하여 화면을 제어합니다.

```c
// Win32 기본 윈도우 프로시저 콜백 함수 구조
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    switch (message) {
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);
        TextOut(hdc, 20, 20, TEXT("Win32 시스템 프로그래밍"), 14);
        EndPaint(hWnd, &ps);
        break;
    }
    case WM_DESTROY:
        PostQuitMessage(0); // 메시지 루프 종료 신호 전송
        break;
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return 0;
}
```
PE 포맷과 Win32 API의 상호작용 원리를 이해하는 것은 리버스 엔지니어링, 보안 취약점 분석, 그리고 시스템 레벨 소프트웨어 개발의 핵심 바탕이 됩니다.