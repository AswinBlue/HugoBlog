---
title: "x86-64 어셈블리어 기초: 핵심 명령어, 레지스터 구조, 스택 프레임 및 바이너리 빌드"
description: "x86-64 아키텍처 기반 어셈블리어의 핵심 명령어(mov, lea, push, pop), 범용 및 세그먼트 레지스터 구조, 함수 프롤로그/에필로그 스택 프레임 및 카나리 원리, nasm을 활용한 바이너리 컴파일 과정을 총정리합니다."
slug: "x86-64-assembly-instructions-registers-stack-frame"
date: 2024-02-21T20:10:48+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Assembly"]
tags: ["assembly", "x86-64", "register", "stack-frame", "nasm"]
ShowToc: true
TocOpen: true
---

# x86-64 어셈블리어 기초

## 어셈블리어의 구성과 피연산자
어셈블리어는 기계어(Machine Code)와 1:1로 대응되는 사람이 읽을 수 있는 가장 저수준의 프로그래밍 언어입니다.
일반적으로 **명령어(Opcode)**와 **피연산자(Operand)**로 구성됩니다.

피연산자 자리에는 다음과 같은 요소들이 올 수 있습니다.
- **상수 (Immediate Value)**: 정수 리터럴 (예: `0x10`, `100`)
- **레지스터 (Register)**: CPU 내부 저장 장치 (예: `rax`, `rbx`)
- **메모리 (Memory)**: 대괄호(`[]`)로 감싼 메모리 주소 표현식 (예: `[rax + rcx*8 + 0x10]`)

### 크기 지정자 (Size Directive)
메모리 피연산자가 가리키는 데이터의 바이트 크기를 명시하기 위해 크기 지정자를 사용합니다.
- `BYTE PTR`: 1바이트 (8비트)
- `WORD PTR`: 2바이트 (16비트)
- `DWORD PTR`: 4바이트 (32비트, Double Word)
- `QWORD PTR`: 8바이트 (64비트, Quad Word)

## 핵심 명령어 세트 (Instruction Set)

### 데이터 이동 및 주소 계산 (mov, lea)
1. **mov dst, src**
   - `src`의 "값"을 `dst`에 대입합니다. 메모리에서 메모리로의 직접 전송은 불가능합니다.
   - `mov rdi, rsi`: `rsi` 값을 `rdi`에 복사
   - `mov QWORD PTR [rdi], rsi`: `rsi`의 값을 `rdi`가 가리키는 메모리 주소에 저장
   - `mov rax, [rbp - 8]`: `rbp - 8` 주소에 저장된 값을 `rax`에 복사
2. **lea dst, src**
   - Load Effective Address의 약자로, `src`의 "유효 주소값" 자체를 계산하여 `dst`에 대입합니다.
   - `lea rsi, [rbx + 8 * rcx]`: `rbx + 8 * rcx` 산술 연산 결과 주소값을 `rsi`에 저장 (역참조하지 않음)
   - `lea rax, [rax + 4]`: 산술 덧셈 최적화 용도로도 자주 활용됩니다.

### 산술 및 논리 연산 (add, sub, inc, dec, xor 등)
- `add dst, src`: `dst = dst + src` (결과에 따라 플래그 설정)
- `sub dst, src`: `dst = dst - src`
- `inc op` / `dec op`: `op`의 값을 1 증가 / 감소
- `and dst, src`: 비트 단위 AND 연산
- `or dst, src`: 비트 단위 OR 연산
- `xor dst, src`: 비트 단위 XOR 연산 (`xor rax, rax` 구문은 `rax`를 0으로 초기화할 때 성능과 코드 크기 최적화를 위해 표준적으로 사용됨)
- `not op`: 비트 반전 (1의 보수)

### 비교 및 분기 명령어 (cmp, test, jmp, je, jg)
- `cmp op1, op2`: 두 값(`op1 - op2`)을 가상으로 빼서 결과에 따라 플래그 레지스터(ZF, SF, OF, CF)를 설정합니다 (`op1` 값 자체는 보존됨).
- `test op1, op2`: 두 값(`op1 & op2`)을 가상으로 AND 연산하여 0인지 검사합니다 (`test rax, rax`로 NULL 포인터 여부 판별).
- `jmp addr`: 조건 없이 지정한 주소(`addr`)로 실행 흐름(`rip`)을 이동합니다.
- `je addr` (Jump if Equal): 이전 `cmp` 결과 두 피연산자가 같으면(`ZF == 1`) 분기합니다.
- `jg addr` (Jump if Greater): 부호 있는 비교에서 `op1 > op2`일 경우 분기합니다.
- `jl addr` (Jump if Less): `op1 < op2`일 경우 분기합니다.

### 스택 및 함수 제어 (push, pop, call, leave, ret)
- `push val`: 스택 포인터 `rsp`를 8 감소시키고, 스택 최상단에 `val`을 저장합니다 (`sub rsp, 8; mov [rsp], val`과 동일).
- `pop reg`: `rsp`가 가리키는 스택 최상단 값을 `reg`에 꺼내오고 `rsp`를 8 증가시킵니다 (`mov reg, [rsp]; add rsp, 8`과 동일).
- `call addr`: 다음 실행할 명령어 주소(리턴 주소)를 스택에 `push`하고 `addr`로 무조건 점프합니다.
- `leave`: 함수 에필로그 시 스택 프레임을 해제합니다 (`mov rsp, rbp; pop rbp`와 동일).
- `ret`: 스택 최상단에 저장된 리턴 주소를 꺼내 `rip`로 복원하여 호출자 함수로 복귀합니다 (`pop rip`와 동일).

### 시스템 콜 (System Call)
리눅스 x86-64 환경에서는 `syscall` 어셈블리 명령어를 통해 커널 서비스를 호출합니다.
- 시스템 콜 번호는 `rax` 레지스터에 설정합니다.
- 호출 인자는 순서대로 `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9` 레지스터에 적재합니다.
- 시스템 콜 수행 결과 및 반환값은 `rax`에 저장됩니다.

## x86-64 레지스터 아키텍처

### 범용 레지스터 (General-Purpose Registers)
x86-64 아키텍처는 16개의 64비트 범용 레지스터(`rax`, `rbx`, `rcx`, `rdx`, `rsi`, `rdi`, `rbp`, `rsp`, `r8` ~ `r15`)를 제공합니다.
- `rax`: 누산기(Accumulator), 산술 연산 결과 및 함수/시스템 콜 반환값 저장
- `rbx`: 베이스 레지스터, 메모리 주소 포인터 보관
- `rcx`: 카운터 레지스터, 반복문(Loop) 카운터
- `rdx`: 데이터 레지스터, I/O 및 곱셈/나눗셈 보조, 시스템 콜 3번째 인자
- `rsi`: Source Index, 데이터 복사 시 원본 주소 및 함수 2번째 인자
- `rdi`: Destination Index, 데이터 복사 시 목적지 주소 및 함수 1번째 인자
- `rbp`: Base Pointer, 현재 스택 프레임의 베이스(시작) 주소를 가리키는 프레임 포인터
- `rsp`: Stack Pointer, 스택의 최상단(Top) 주소를 가리키는 포인터
- `r8` ~ `r11`: 임시 레지스터 및 함수 인자 전달용
- `r12` ~ `r15`: 피호출자 보존(Callee-Saved) 범용 레지스터

### 레지스터 비트 분할 구조
하위 호환성을 위해 64비트 레지스터는 하위 32비트, 16비트, 8비트 단위로 개별 접근이 가능합니다.

| 64비트 전역 | 32비트 (하위) | 16비트 (하위) | 8비트 (하위) | 8비트 (상위) |
|---|---|---|---|---|
| `rax` | `eax` | `ax` | `al` | `ah` |
| `rbx` | `ebx` | `bx` | `bl` | `bh` |
| `rcx` | `ecx` | `cx` | `cl` | `ch` |
| `rdx` | `edx` | `dx` | `dl` | `dh` |
| `rsi` | `esi` | `si` | `sil` | - |
| `rdi` | `edi` | `di` | `dil` | - |
| `rbp` | `ebp` | `bp` | `bpl` | - |
| `rsp` | `esp` | `sp` | `spl` | - |
| `r8` | `r8d` | `r8w` | `r8b` | - |
| `r15` | `r15d` | `r15w` | `r15b` | - |

### 세그먼트 및 특수 레지스터 (cs, ds, fs, rip)
- `rip` (Instruction Pointer): CPU가 다음에 실행할 기계어 명령어의 가상 메모리 주소를 가리킵니다.
- `cs` (Code), `ds` (Data), `ss` (Stack): 과거 16비트 리얼 모드의 잔재로, x86-64 보호 모드에서는 대부분 0 기반 플랫 메모리 모델을 사용합니다.
- `fs`, `gs`: 특정 운영체제 목적에 맞게 자유롭게 사용 가능한 세그먼트 레지스터입니다. 리눅스에서는 `fs` 세그먼트 레지스터를 스레드 로컬 스토리지(TLS) 포인터 및 스택 카나리 기준 주소(`fs:0x28`)로 사용합니다.

### 플래그 레지스터 (RFLAGS)
연산 결과의 상태와 CPU 제어 플래그를 보관합니다.
- **CF (Carry Flag)**: 부호 없는(Unsigned) 연산 결과 자릿수 올림/내림 발생 시 1
- **ZF (Zero Flag)**: 연산 결과가 0인 경우 1
- **SF (Sign Flag)**: 연산 결과가 음수인 경우 (최상위 비트 1) 1
- **OF (Overflow Flag)**: 부호 있는(Signed) 연산 결과 오버플로우 발생 시 1

## 함수 스택 프레임 (Stack Frame) 원리

### 스택 프레임 형성 (프롤로그와 에필로그)
함수가 호출될 때 지역 변수와 호출 복귀 주소를 안전하게 관리하기 위해 스택 프레임이 구성됩니다.

```text
스택 주소 (High Memory)
+------------------------------------+
|  함수 리턴 주소 (Return Address)    |  <-- rbp + 8
+------------------------------------+
|  이전 프레임 포인터 (Saved RBP)      |  <-- rbp (SFP)
+------------------------------------+
|  스택 카나리 (Stack Canary, 8B)     |  <-- rbp - 8 (선택적 보호)
+------------------------------------+
|  함수 지역 변수 영역                |
+------------------------------------+  <-- rsp
스택 주소 (Low Memory)
```

1. **함수 호출 (call)**: 호출자가 리턴 주소를 스택에 `push`하고 피호출자 함수로 진입합니다.
2. **함수 프롤로그 (Prologue)**:
   ```nasm
   push rbp          ; 이전 함수의 RBP를 스택에 보존 (SFP)
   mov rbp, rsp      ; 현재 RSP를 새로운 RBP로 설정하여 프레임 베이스 고정
   sub rsp, 0x20     ; 지역 변수 공간 32바이트 할당
   ```
3. **함수 에필로그 (Epilogue)**:
   ```nasm
   mov rsp, rbp      ; 지역 변수 공간 해제
   pop rbp           ; 이전 함수의 RBP 복원
   ret               ; 스택의 리턴 주소를 꺼내 호출자로 복귀 (pop rip)
   ```

### 스택 카나리 (Stack Canary)
버퍼 오버플로우 공격으로 리턴 주소가 변조되는 것을 탐지하기 위한 보호 기법입니다.
- 함수 진입 시 `fs:0x28`에 저장된 무작위 8바이트 값(첫 바이트가 `0x00`인 널 바이트 포함 난수)을 `rbp - 8`에 삽입합니다.
- 함수 종료 직전 스택의 카나리 값과 `fs:0x28`의 원본 값을 `xor` 비교하여 불일치할 경우 `__stack_chk_fail()`을 호출하고 프로세스를 강제 종료합니다.

## 어셈블리 소스 컴파일 및 바이너리 추출
NASM(Netwide Assembler)을 사용하여 어셈블리 소스코드를 ELF 바이너리로 빌드할 수 있습니다.

```nasm
; hello.asm
section .data
    msg db "Hello, x86-64 Assembly!", 0x0A
    len equ $ - msg

section .text
    global _start

_start:
    ; write(1, msg, len)
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg        ; buffer
    mov rdx, len        ; count
    syscall

    ; exit(0)
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; status 0
    syscall
```

```bash
# 1. 64비트 ELF 오브젝트 파일로 어셈블
nasm -f elf64 hello.asm -o hello.o

# 2. 링커를 통한 실행 바이너리 생성
ld hello.o -o hello

# 3. 특정 섹션만 순수 바이너리로 추출 (셸코드 생성 시 활용)
objcopy --dump-section .text=shellcode.bin hello.o

# 4. 헥스덤프로 기계어 바이트코드 확인
xxd shellcode.bin
```