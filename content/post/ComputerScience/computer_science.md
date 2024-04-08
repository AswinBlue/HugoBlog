---
title: "Computer_science"
date: 2023-01-19T21:59:14+09:00
lastmod: 2023-01-19T21:59:14+09:00
tags: ["CS",]
categories: ["theory",]
imgs:  []
cover:  ""  # image show on top
readingTime:  true  # show reading time after article date
toc:  true
comments:  false
justify:  false  # text-align: justify;
single:  false  # display as a single page, hide navigation on bottom, like as about page.
license:  "BY-SA"  # CC License, https://creativecommons.org/licenses/?lang=ko
draft: false
---
# Computer Science
## CPU
### Segment
- 프로세스가 사용하는 메모리를 Segment라 칭하며, 리눅스에서는 5가지 종류로 이를 분류한다. 
  1. 코드 세그먼트 : 실행 가능한 코드가 위치한 영역으로, text segment라고도 부른다.
  2. 데이터 세그먼트 : 코드 실행에 필요한 데이터가 있는 영역으로, 전역변수 및 전역 상수들이 위치한다.
    - 읽기/쓰기가 모두 가능한 데이터들은 data segment에 저장된다.
    - 읽기만 가능한 상수 데이터들은 rodata(read-only) segment 에 저장된다.
  3. BSS 세그먼트 : Block Started by Symbol 의 약자로, 컴파일시점에 값이 정해지지 않은 전역변수가 저장되는 영역이다. 
    - 이 영역은 프로그램 시작시 모두 0으로 초기화 된다. C에서 전역변수가 0 으로 초기화되는 이유가 이 때문이다.
  4. 힙 세그먼트 : 동적으로 할당되는 데이터들을 저장하는 영역이다. 스택과 마주보는 방향으로 증가한다.
  5. 스택 세그먼트 : 프로세스의 스택이 위치하는 영역으로, 지역변수 및 함수 인자들이 저장된다. 
    - 스택 세그먼트는 메모리 마지막 주소(가장 큰 주소)부터 시작해서 힙과 마주보는 방향으로 증가한다.
	- 운영체제가 프로세스 동작 상황에 따라 스택 영역을 관리한다.
  
- 세그먼트는 위에서 언급된 순서대로 메모리에 배치되며, 스택 세그먼트만 특이하게 메모리 가장 마지막을 기준으로 할당된다.

### ISA
- Instruction Set Architecture 의 약자로, 명령어 집합 구조라 해석한다.
- x86-64, ARM, MIPS, AVR 등이 대표적인 예시이다.

- 컴퓨터 구조는 '기능구조' 'ISA' '마이크로 아키텍처' '하드웨어 및 컴퓨팅 방법론' 과 같이 레벨에 따라 분류가 가능하다. 

### x86-64 아키텍처 레지스터
- x86-64 아키텍처는 아래와 같이 레지스터를 용도에 따라 구분한다. 
  1. 범용 레지스터(General Register) : 8byte를 저장 가능
    - 아래 용도로 주로 사용되지만 그외 용도로도 다양하게 사용 가능한 레지스터.
    - rax (accumulator register) : 함수의 반환 값
    - rbx (base register) : x64에서는 주된 용도 없음
    - rcx (counter register) : 반복문의 반복 횟수, 각종 연산의 시행 횟수
  	- rdx (data register) : x64에서는 주된 용도 없음
    - rsi (source index) : 데이터를 옮길 때 원본을 가리키는 포인터
    - rdi (destination index) : 데이터를 옮길 때 목적지를 가리키는 포인터
  	- rsp (stack pointer) : 사용중인 스택의 위치를 가리키는 포인터
  	- rbp (stack base pointer) : 스택의 바닥을 가리키는 포인터
  2. 세그먼트 레지스터(Segment Register) : 16bit를 저장 가능
  	- 과거에는 사용 가능한 물리 메모리의 크기를 늘리기 위해 사용했으나, x64 아키텍처에서는 주소영역이 확장되면서 주로 메모리 보호를 위해 사용
    - cs, ss, ds, es, fs, gs 종류가 존재
  	- cs, ds, ss 레지스터는 코드 영역과 데이터, 스택 메모리 영역을 가리킬 때 사용
  3. 명령어 포인터 레지스터(Instruction Pointer Register, IP) : 8byte 크기
    - CPU가 실행할 코드 위치를 가리키는 역할
    - 종류로는 rip 가 있다.
  4. 플래그 레지스터(Flag Register) : 64bit
    - 프로세서의 현재 상태를 저장하고 있는 레지스터
  	- 64비트로 CPU의 현재 상태를 표시한다. 주로 우측 20여개를 사용
	  - CF(Carry Flag) : 부호 없는 수의 연산 결과가 비트의 범위를 넘을 경우 설정 됩니다.
	  - ZF(Zero Flag) : 연산의 결과가 0일 경우 설정 됩니다.
	  - SF(Sign Flag) : 연산의 결과가 음수일 경우 설정 됩니다.
	  - OF(Overflow Flag) : 부호 있는 수의 연산 결과가 비트 범위를 넘을 경우 설정 됩니다.
	  
- CPU의 레지스터들은 32비트 크기를 가지며, eax, ebx, ecx, edx, esi, edi, esp, ebp 가 있다. 

## 함수 호출 규약
- 함수 호출시에는 호출자의 상태와 반환주소를 저장하고, 피호출자가 요구하는 인자, 피호출자의 반환값을 처리해야 한다. 
- 이러한 함수 호출 및 반환 매커니즘약을 "함수 호출 규약(convention)" 이라한다.
- 함수 호출 규약은 컴파일러에 의해 적용되며, 컴파일러가 target CPU의 종류에 따라 적합한 규약을 적용 해 준다.
  - 예를 들어, 레지스터가 적은 아키텍처에서는 스택을 통해 함수 인자를 전달하고, 반대의 경우는 적은 인자는 레지스터를 통해, 많은 인자는 스택을 통해 전달하는 방식을 취한다.
  - CPU가 같더라도 컴파일러에 따라 함수 호출 규약이 달라질 수 있다.
    - ex) cdecl, stdcall, fastcall, thiscall
  - 스택 혹은 레지스터에 인자를 넣을 때 마지막 인자부터 첫 번째 인자까지 순서대로 집어넣는다.
### SYSV
- SYSV 규약으로 만들어진 대표적인 예로는 리눅스가 있다.
- SYSV ABI(Application Binary Interface) 함수 호출 규약에는 ELF 포맷, 링킹 방법 등이 정의되어 있다.

#### SYSV 규약의 특징
- 함수 호출시 인자를 순서대로 RDI, RSI(ESI), RDX(EDX), RCX(ECX), R8(R8D), R9(R9D) 에 저장하며 더 많은 인자를 받을 땐 스택을 사용한다.

## 컴파일
- high level language를 기계어로 변환하는 작업을 컴파일이라 하고, 컴파일은 네가지 변환기를 거친다. 
  1. Preprocessor(전처리기) : c언어로 구현된 .c 파일을 전처리가 완료된 .i 파일로 변환
  2. Compiler(컴파일러) : 전처리된 .i 파일을 어셈블리어로 변환   
  3. Assembler(어셈블): 각 벤더들이 만든 어셈블리어를 목적파일로 변환(어셈블리 언어를 기계어로 변환)
  4. Linker(링커): 목적파일에서 참조하는 다른 목적파일들을 linking 하여 최종 실행파일을 생성

### PLT / GOT
- user가 작성한 코드가 동적 라이브러리를 참조하는 경우 PLT(Procedure Linkage Table)와 GOT(Global Offset Table) 를 사용하여 라이브러리 내의 함수를 참조한다. 
- ASLR(Address Space Layout Randomization) 을 적용한다면 로딩시 라이브러리 코드들은 랜덤한 메모리 위치를 배정받을 것이며 함수의 이름을 바탕으로 심볼을 검색해 PLT와 GOT에 알맞은 주소값을 찾아 넣게 된다. 
  - 이 과정을 runtime resolve 라 한다.
  - 동적 라이브러리의 함수를 최초로 호출할 땐 라이브러리를 검색해서 함수의 주소를 조회하지만, 한 번 사용한 다음에는 GOT에 주소를 기록 해 놓아서 다음에 사용할 땐 GOT만 조회하여 함수를 사용할 수 있도록 한다. 이 동작을 resolve 라 한다.
  - `_dl_runtime_resolve_fxsave` 함수가 실행되면서 resolve 한 값을 GOT에 저장한다. 
  - 함수를 호출하면 PLT 값을 참조해 GOT의 특정 영역을 확인하고, GOT에서 함수의 주소를 읽어와 실행시킨다. GOT에 주소가 없다면 PLT에 적힌 값을 사용하여 resolve 동작을 수행한다.
- ELF는 GOT를 활용하여 라이브러리 호출 비용을 절약한다.
- 프로그램을 실행하며 실시간으로 GOT를 채워가는 방식을 Lazy Building이라 하는데, 프로그램 실행 중 GOT에 쓰기 권한이 부여되어야 하기 때문에 해킹에 취약하다.
  - 공격자가 ELF에서 프로세스의 흐름에 관여하는 `.init_array`, `.fini_array` 과 같은 데이터 세그먼트들을 다른 함수로 덮어쓰면 프로세스의 흐름이 변경될 수 있다.
  - 