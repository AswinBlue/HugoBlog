---
title: "x86-64 리버스 엔지니어링: 정적·동적 바이너리 분석과 IDA 및 Ghidra 활용법"
description: "바이너리 역공학을 위한 정적 및 동적 분석 방법론과 대표적인 디컴파일러 도구인 IDA Pro와 Ghidra의 필수 단축키, 화면 구성, 윈도우 API 패턴 분석, 바이너리 패치 및 스크립트 자동화 기법을 체계적으로 정리합니다."
slug: "x86-64-reverse-engineering-ida-ghidra-guide"
date: 2024-05-12T14:42:07+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Security"]
tags: ["reverse-engineering", "ida-pro", "ghidra", "security", "binary-analysis"]
ShowToc: true
TocOpen: true
---

# x86-64 리버스 엔지니어링 기초

## 소프트웨어 역공학 개요
리버스 엔지니어링(Reverse Engineering)은 완성된 실행 바이너리를 기계어 및 디스어셈블리 수준에서 분석하여 프로그램의 설계 구조, 알고리즘, 취약점을 역으로 파악하는 기술입니다.

### 정적 분석 (Static Analysis)
- 대상 프로그램을 직접 실행시키지 않고 바이너리 구조와 코드 흐름을 분석하는 기법입니다.
- **장점**: 전체적인 프로그램 제어 흐름(CFG)을 조망하기 쉽고, 악성코드 실행 위험 없이 안전하며 환경 구성에 구애받지 않습니다.
- **한계**: 패커(Packer)나 난독화(Obfuscation) 기법이 적용된 경우 순수 정적 분석만으로는 내부 로직 규명이 어렵습니다.

### 동적 분석 (Dynamic Analysis)
- 디버거(GDB, x64dbg)를 통해 프로그램을 실제 실행시키면서 레지스터와 메모리 변화를 관찰하는 기법입니다.
- **장점**: 런타임에 메모리에 복호화되는 실제 문자열과 분기 결과를 실시간으로 빠르게 확인할 수 있습니다.
- **한계**: 안티 디버깅(Anti-Debugging) 장치가 적용되어 있거나 특정 입력 조건이 갖춰지지 않으면 원하는 코드 경로에 진입하기 어렵습니다.

## IDA Pro 핵심 기능 및 분석 기법
Hex-Rays 사의 IDA Pro는 세계적인 표준 상용 역공학 도구로, 강력한 디스어셈블러와 Hex-Rays C 디컴파일러(F5)를 내장하고 있습니다.

### 필수 단축키 정리
- `F5`: 선택한 함수의 어셈블리 코드를 사람이 읽기 쉬운 C 의사코드(Pseudocode)로 역컴파일
- `x` (Cross-Reference): 상호 참조 검색. 특정 함수나 전역 변수를 호출/참조하는 모든 위치 목록을 표시
- `Shift + F12`: 바이너리에 포함된 모든 정적 문자열(String Window)을 인덱싱하여 검색
- `g`: 특정 가상 메모리 주소 또는 함수 이름으로 즉시 점프
- `ESC`: 이전 커서 위치로 히스토리 스택 복귀
- `Ctrl + Enter`: 앞으로 이동 (이전 점프 취소)
- `n`: 함수, 레이블 또는 변수 이름을 가독성 있게 변경 (Rename)
- `Y`: 변수 또는 함수의 데이터 타입/시그니처를 재정의 (Set Type)
- `F2`: 브레이크포인트(중단점) 설정 또는 Hex View에서 바이트 수정
- `F9`: 동적 디버거 실행 (Run)
- `F8`: 함수 내부로 들어가지 않고 다음 명령어로 건너뜀 (Step Over)
- `F7`: 함수 내부로 진입 (Step Into)
- `Ctrl + F2`: 디버깅 세션 즉시 강제 종료
- `r`: 16진수 상수 값을 ASCII 문자로 변환하여 표시
- `Shift + E`: 선택한 블록의 헥스 바이트 데이터를 원하는 포맷(C 배열 등)으로 내보내기 (Export Data)

### 핵심 뷰(View) 인터페이스
- **IDA View**: 어셈블리 코드 리스팅 화면으로, 스페이스바(`Space`)를 눌러 텍스트 뷰와 그래프 뷰(CFG 블록 다이어그램)를 전환할 수 있습니다.
- **Functions Window**: 식별된 모든 함수 심볼 목록을 표시합니다 (`Ctrl + F`로 검색).
- **Strings Window**: 감지된 문자열 목록을 보여주며, 더블 클릭 시 해당 문자열이 위치한 `.rodata` 또는 `.data` 섹션으로 이동합니다.
- **Stack of Function**: 함수의 로컬 변수 오프셋과 스택 프레임 레이아웃을 시각화합니다.

### 역난독화 및 윈도우 API 패턴
디컴파일 결과에 자주 등장하는 내부 런타임 매크로를 파이썬 코드로 치환하여 역산할 수 있습니다.

- **비트 회전 연산 (ROL / ROR)**:
  ```python
  # 8비트 좌측 순환 시프트 (ROL1)
  def rol1(v, s):
      return ((v << s) | (v >> (8 - s))) & 0xFF

  # 8비트 우측 순환 시프트 (ROR1)
  def ror1(v, s):
      return ((v >> s) | (v << (8 - s))) & 0xFF
  ```
- **1의 개수 카운트 (__popcnt)**:
  ```python
  def popcnt(v):
      return bin(v).count('1')
  ```
- **윈도우 GUI 실행 패턴**:
  - `WinMain`: GUI 애플리케이션의 최초 진입점
  - `RegisterClassExW`: 윈도우 클래스를 등록하며, 구조체의 `lpfnWndProc` 멤버가 실제 윈도우 메시지 이벤트를 처리하는 핵심 비즈니스 로직 함수입니다.

### 바이너리 패치 (Patch Program)
- 어셈블리 명령어를 수정하여 분기 조건을 강제로 변경(`jnz` -> `jmp` 등)할 수 있습니다.
- IDA 메뉴: `Edit` -> `Patch program` -> `Assemble`에서 명령어를 직접 입력하여 수정합니다.
- 파일에 영구 반영: `Edit` -> `Patch program` -> `Apply patches to input file`을 선택하여 원본 바이너리에 수정 사항을 기록합니다.

## Ghidra 오픈소스 디컴파일러 활용
미국 국가안보국(NSA)에서 공개한 오픈소스 소프트웨어 역공학 프레임워크로, Java 기반으로 동작하며 다양한 아키텍처(x86, ARM, MIPS, RISC-V 등)의 고성능 C 디컴파일러를 무료로 제공합니다.

### Code Browser 핵심 구성 요소
- **디컴파일러 창 (Decompile Window)**: C 언어 형태로 실시간 복원된 코드를 출력하며 변수 선택 시 어셈블리와 양방향 동기화 하이라이팅을 지원합니다.
- **디스어셈블 리스팅 (Listing Window)**: 바이트코드와 어셈블리 명령어, 주석을 표시합니다.
- **심볼 트리 (Symbol Tree)**: 임포트(Import)된 외부 라이브러리 함수, 익스포트(Export) 함수, 로컬 레이블을 계층형 트리로 관리합니다.
- **프로그램 트리 (Program Trees)**: `.text`, `.data`, `.rdata` 등 바이너리의 섹션 메모리 맵 구조를 탐색합니다.
- **데이터 타입 매니저 (Data Type Manager)**: C 구조체(`struct`)나 열거형을 직접 정의하고 분석 창에 적용할 수 있습니다.
- **함수 호출 관계 그래프 (Function Call Graph)**: 프로그램 전체의 호출 관계망을 시각적으로 탐색합니다.

### 함수 시그니처 및 데이터 타입 수정
Ghidra에서 추론된 변수 타입이 부정확한 경우 직관적인 GUI로 정정할 수 있습니다.
- 함수 이름 우클릭 -> `Edit Function Signature`: 반환 타입, 호출 규약(`__stdcall`, `__cdecl`, `__fastcall`), 파라미터 타입 및 이름을 재정의합니다.
- 변수 이름 우클릭 -> `Rename Variable` (`L` 키): 변수명을 직관적인 의미로 변경합니다.
- 변수 우클릭 -> `Retype Variable` (`Ctrl + L` 키): `char *`, `int`, 사용자 정의 구조체 포인터 등으로 올바른 타입을 지정합니다.

### Ghidra 스크립트 기반 자동화
- Ghidra는 Java 및 Python(Jython) 기반의 강력한 스크립팅 API를 내장하고 있습니다.
- `Window` -> `Script Manager`를 통해 반복적인 패턴 탐색, XOR 복호화 루틴, 심볼 자동 복구 스크립트를 작성하고 일괄 실행할 수 있습니다.