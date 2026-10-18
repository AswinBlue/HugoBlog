---
title: "컴퓨터 시스템 핵심: CPU 메모리 세그먼트, x86-64 레지스터, ELF 컴파일과 ptmalloc"
date: 2023-01-19T21:59:14+09:00
lastmod: 2023-01-19T21:59:14+09:00
description: "CPU 메모리 세그먼트 구조, x86-64 레지스터 체계, SYSV 함수 호출 규약부터 C 언어 컴파일 과정(ELF/PLT/GOT) 및 Linux ptmalloc 메모리 관리 기법까지 핵심 원리를 정리합니다."
slug: "computer-science-cpu-memory-compile-ptmalloc"
categories: ["ComputerScience"]
tags: ["computer-science", "operating-system", "x86-64", "memory-management", "compiler", "linux"]
ShowToc: true
TocOpen: true
draft: false
---

# 컴퓨터 시스템 핵심 원리 (Computer Science)

## CPU와 메모리 구조

### 프로세스 메모리 세그먼트 (Segment)
프로세스가 사용하는 가상 메모리는 역할에 따라 세그먼트(Segment)로 분할되며, 리눅스 시스템은 크게 5가지 영역으로 관리합니다:
1. `코드 세그먼트 (Code / Text)`: 실행 가능한 기계어 코드가 위치하는 읽기 전용(Read-Only) 영역입니다.
2. `데이터 세그먼트 (Data)`: 프로그램 실행에 필요한 전역 변수와 전역 상수가 저장됩니다.
   - 읽기/쓰기가 가능한 초기화된 전역 변수는 Data 영역에 저장됩니다.
   - 읽기 전용 상수는 rodata(Read-Only Data) 세그먼트에 배치됩니다.
3. `BSS 세그먼트 (Block Started by Symbol)`: 컴파일 시점에 초기화되지 않은 전역 변수가 위치하는 영역입니다.
   - 프로그램 로드 시 운영체제에 의해 모두 0으로 자동 초기화됩니다. C 언어에서 초기화하지 않은 전역 변수가 0을 갖는 이유입니다.
4. `힙 세그먼트 (Heap)`: 프로그래머가 런타임에 동적으로 할당하고 해제하는 메모리 영역입니다. 낮은 주소에서 높은 주소 방향(스택과 마주보는 방향)으로 자라납니다.
5. `스택 세그먼트 (Stack)`: 지역 변수, 함수 매개변수, 복귀 주소(Return Address)가 저장되는 임시 메모리 공간입니다.
   - 메모리의 가장 높은 주소에서 낮은 주소 방향으로 확장되며, 함수 호출 및 반환에 따라 자동으로 관리됩니다.

### 명령어 집합 구조 (ISA)
- **ISA(Instruction Set Architecture)**: 하드웨어(CPU)와 소프트웨어 간의 명령어 인터페이스 규격입니다.
- x86-64, ARM, MIPS, RISC-V 등이 대표적이며, 아키텍처에 따라 레지스터 수, 명령어 형식, 주소 지정 방식이 결정됩니다.

### x86-64 아키텍처 레지스터 체계
x86-64 아키텍처는 용도에 따라 다음과 같은 레지스터들을 제공합니다:
1. 범용 레지스터 (General Purpose Register, 64bit):
   - `rax`: 함수 반환값 저장 (Accumulator)
   - `rcx`: 반복문 카운터 (Counter)
   - `rdx`: 입출력 연산 및 세 번째 함수 인자 전달 (Data)
   - `rbx`: 메모리 베이스 주소 지정 (Base)
   - `rsp`: 현재 스택의 최상단 위치를 가리키는 스택 포인터 (Stack Pointer)
   - `rbp`: 현재 스택 프레임의 기준점을 가리키는 베이스 포인터 (Base Pointer)
   - `rsi`: 데이터 복사 시 출발지 주소 (Source Index)
   - `rdi`: 데이터 복사 시 목적지 주소 (Destination Index)
   - `r8 ~ r15`: x86-64 확장에서 추가된 범용 레지스터
2. 세그먼트 레지스터 (Segment Register, 16bit):
   - `cs`, `ds`, `ss`, `es`, `fs`, `gs`가 있으며, 64비트 모드에서는 주로 스레드 로컬 스토리지(TLS) 및 메모리 보호용으로 활용됩니다.
3. 명령어 포인터 레지스터 (IP):
   - `rip`: CPU가 다음에 실행할 기계어 코드의 메모리 주소를 보관합니다.
4. 플래그 레지스터 (RFLAGS, 64bit):
   - CPU의 연산 결과 및 상태 플래그를 저장합니다:
     - `CF` (Carry Flag): 부호 없는 연산의 올림/내림 발생 여부
     - `ZF` (Zero Flag): 연산 결과가 0인지 여부
     - `SF` (Sign Flag): 연산 결과의 부호(음수 여부)
     - `OF` (Overflow Flag): 부호 있는 정수 연산의 오버플로우 발생 여부

---

## 함수 호출 규약 (Calling Convention)
함수 호출 시 인자 전달 방식, 스택 정리 책임자, 반환값 전달 규칙을 정의한 표준입니다.

### SYSV ABI 규약
- 리눅스 64비트 환경의 표준 함수 호출 규약입니다.
- **SYSV 규약의 특징**:
  - 함수 호출 시 첫 6개 인자는 레지스터를 통해 순서대로 전달됩니다: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`
  - 7번째 이상의 인자부터는 스택(`[rsp]`, `[rsp+8]`, ...)을 통해 역순으로 푸시되어 전달됩니다.
  - 함수 반환값은 `rax`(필요시 `rdx` 추가)에 저장됩니다.

---

## C 컴파일 과정과 바이너리 구조
고급 언어로 작성된 소스 코드가 실행 파일로 변환되는 4단계:
1. `전처리기 (Preprocessor)`: 주석 제거, `#include` 헤더 병합, 매크로 치환 (`.c` -> `.i`)
2. `컴파일러 (Compiler)`: 전처리된 코드를 아키텍처에 맞는 어셈블리어로 변환 및 최적화 (`.i` -> `.s`)
3. `어셈블러 (Assembler)`: 어셈블리어를 기계어로 번역하여 목적 파일(Object file) 생성 (`.s` -> `.o`)
4. `링커 (Linker)`: 여러 목적 파일과 라이브러리를 결합하여 최종 실행 가능한 바이너리(ELF) 생성

### ELF 포맷
- **ELF(Executable and Linkable Format)**: 리눅스의 표준 바이너리 실행 및 링킹 포맷입니다.
- 실행 파일, 공유 라이브러리(`.so`), 재배치 가능한 목적 파일(`.o`) 모두 ELF 형식을 따릅니다.

### 동적 링킹과 PLT / GOT
- 외부 공유 라이브러리 함수를 호출할 때 성능과 보안을 최적화하기 위해 사용되는 구조입니다:
  - `PLT (Procedure Linkage Table)`: 코드 영역에 위치하며 라이브러리 함수 호출을 중계하는 점프 테이블
  - `GOT (Global Offset Table)`: 데이터 영역에 위치하며 런타임에 확인된 실제 라이브러리 함수의 메모리 주소를 보관하는 테이블
- **Lazy Binding 메커니즘**:
  - 함수 최초 호출 시: `Code -> PLT -> 동적 링커(_dl_runtime_resolve) 호출 -> 함수 실제 주소 탐색 -> GOT에 주소 기록 -> 함수 실행`
  - 이후 호출 시: `Code -> PLT -> GOT 확인 -> 실제 함수 직접 실행` (재탐색 오버헤드 제거)
- 보안 강화 기법으로 프로그램 시작 시 모든 GOT 주소를 미리 바인딩하고 쓰기 권한을 박탈하는 `Full RELRO`가 적용되기도 합니다.

### 메모리 관리와 ptmalloc
- **ptmalloc (pthread malloc) 개요**:
  - GNU C 라이브러리(glibc)의 기본 동적 메모리 할당자입니다.
  - 멀티스레드 환경에서 락(Lock) 경합을 줄이기 위해 Arena 단위로 힙 메모리를 관리합니다.
  - 내부 단편화와 외부 단편화를 줄이기 위해 16바이트 단위로 메모리를 정렬하여 `chunk` 단위로 관리합니다.

- **Chunk 헤더 구조**:
  - `prev_size`: 이전 인접 청크의 크기
  - `size`: 현재 청크의 크기 (하위 3비트는 플래그로 활용: A=NON_MAIN_ARENA, M=IS_MMAPPED, P=PREV_INUSE)
  - 해제된 청크는 추가로 이전/다음 청크를 가리키는 `fd(Forward pointer)`와 `bk(Backward pointer)`를 헤더에 기록합니다.

- **해제된 메모리 관리 (Bins)**:
  - `tcache (Thread Local Cache)`: 스레드마다 독립적으로 유지되는 단일 연결 리스트로, 락 없이 즉시 할당/해제 (LIFO)
  - `fastbin`: 작은 크기(32~176 바이트)의 청크를 단일 연결 리스트로 빠르게 재할당 (LIFO)
  - `smallbin`: 1024바이트 미만의 청크를 이중 원형 연결 리스트로 관리 (FIFO, 병합 지원)
  - `largebin`: 1024바이트 이상의 대형 청크를 크기순으로 정렬하여 관리
  - `unsortedbin`: 해제된 청크가 일시적으로 보관되는 버퍼로, 재사용 요청 시 적절한 bin으로 분류