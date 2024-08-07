---
title: "Computer Science"
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
  1. `코드 세그먼트` : 실행 가능한 코드가 위치한 영역으로, text segment라고도 부른다.
  2. `데이터 세그먼트` : 코드 실행에 필요한 데이터가 있는 영역으로, 전역변수 및 전역 상수들이 위치한다.
    - 읽기/쓰기가 모두 가능한 데이터들은 data segment에 저장된다.
    - 읽기만 가능한 상수 데이터들은 rodata(read-only) segment 에 저장된다.
  3. `BSS 세그먼트` : Block Started by Symbol 의 약자로, 컴파일시점에 값이 정해지지 않은 전역변수가 저장되는 영역이다. 
    - 이 영역은 프로그램 시작시 모두 0으로 초기화 된다. C에서 전역변수가 0 으로 초기화되는 이유가 이 때문이다.
    - 읽기와 쓰기가 모두 가능한 영역이다.
  4. `힙 세그먼트` : 동적으로 할당되는 데이터들을 저장하는 영역이다. 스택과 마주보는 방향으로 증가한다.
  5. `스택 세그먼트` : 프로세스의 스택이 위치하는 영역으로, 지역변수 및 함수 인자들이 저장된다. 
    - 스택 세그먼트는 메모리 마지막 주소(가장 큰 주소)부터 시작해서 힙과 마주보는 방향으로 증가한다.
	- 운영체제가 프로세스 동작 상황에 따라 스택 영역을 관리한다.
  
- 세그먼트는 위에서 언급된 순서대로 메모리에 배치되며, 스택 세그먼트만 특이하게 메모리 가장 마지막을 기준으로 할당된다.

### ISA
- `Instruction Set Architecture` 의 약자로, 명령어 집합 구조라 해석한다.
- 하드웨어의 종류에 따라 다른 ISA 가 사용되며, x86-64, ARM, MIPS, AVR 등이 대표적인 예시이다.

- 컴퓨터 구조는 '기능구조' 'ISA' '마이크로 아키텍처' '하드웨어 및 컴퓨팅 방법론' 과 같이 레벨에 따라 분류가 가능하다. 

### x86-64 아키텍처 레지스터
- x86-64 아키텍처는 아래와 같이 레지스터를 용도에 따라 구분한다. 
  1. 범용 레지스터(General Register) : 8byte를 저장 가능
  	- r0 ~ r15까지 16개의 레지스터로 구성되며, 주로 r0 ~ r7 까지가 프로그램 구동시 기본으로 사용되며, 나머지는 정해진 용도 없이 reserved 된 레지스터이다. 
    - r0 ~ r7 레지스터는 아래 용도로 주로 사용되고, 명칭도 붙는다. 
      - r0) rax (accumulator register) : 함수의 반환 값
      - r1) rcx (counter register) : 반복문의 반복 횟수, 각종 연산의 시행 횟수
      - r2) rdx (data register) : 시스템 콜 실행 시 세 번째 인자의 주소
      - r3) rbx (base register) : 메모리 주소를 저장하는 용도로 사용
      - r4) rsp (stack pointer) : 사용중인 스택의 위치를 가리키는 포인터
  	  - r5) rbp (stack base pointer) : 스택의 바닥을 가리키는 포인터
      - r6) rsi (source index) : 데이터를 옮길 때 원본을 가리키는 포인터
      - r7) rdi (destination index) : 데이터를 옮길 때 목적지를 가리키는 포인터
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
- 즉, `rdi, rsi, rdx, rcx, r8, r9, [rsp], [rsp+8], [rsp+0x10], [rsp+0x18], [rsp+0x20]` 순서로 레지스터 및 stack 의 메모리를 참조하게 된다.

## 컴파일
- high level language를 기계어로 변환하는 작업을 컴파일이라 하고, C언어로 작성된 코드는 컴파일시 네가지 변환기를 거친다. 
  1. Preprocessor(전처리기) : c언어로 구현된 .c 파일을 전처리가 완료된 .i 파일로 변환
     - 주석 제거, 매크로 치환, 파일 병합 과정을 거친다.
  2. Compiler(컴파일러) : 전처리된 .i 파일을 어셈블리어로 변환   
     - 조건을 만족한다면 컴파일러에 따라 코드를 최적화 하여 어셈블리어로 변환한다.
     - `gcc` 컴파일러는 `-O -O0 -O1 -O2 -O3 -Os -Ofast -Og` 옵션으로 최적화 여부를 설정할 수 있다.
  3. Assembler(어셈블): 각 벤더들이 만든 어셈블리어를 목적파일로 변환(어셈블리 언어를 기계어로 변환)
     - `ELF`(리눅스 실행파일) 형식의 파일을 생성한다.
     - 어셈블리 코드가 기계어로 번역된다.
  4. Linker(링커): 목적파일에서 참조하는 다른 목적파일들을 linking 하여 최종 실행파일을 생성

- 기계어를 어셈블 언어로 만드는 어셈블의 역과정을 `Disassemble` 이라 한다.
- 어셈블리어를 고급 언어로 만드는 컴파일읠 역과정을 `Decompile` 이라 한다.
- [컴파일 명령어 참조](../../c++/gcc/#명령어-옵션)


### ELF
- ELF란 `Executable and Linkable Format` 의 약자로, 실행 가능하고 링킹 타임에 다른 프로그램에서 링크 할 수 있는 형태의 파일이다. 
- 라이브러리들이 주로 ELF 파일 형태이며, 리눅스에서는 `*.o` 형태를 가진다.

### PLT / GOT
- user가 작성한 코드가 동적 라이브러리를 참조하는 경우 PLT(Procedure Linkage Table)와 GOT(Global Offset Table) 를 사용하여 라이브러리 내의 함수를 참조한다. 
- `라이브러리 함수 호출 -> PLT 참조 -> GOT 참조 -> 실제 함수 주소 반환` 의 순서로 코드가 동작하게 된다. 
- 예를들어 printf 함수를 호출한다고 하면 아래와 같은 절차대로 PLT 와 GOT 테이블을 참조하며, printf 함수는 library의 0xBBBB 위치의 코드에 매핑되어 실행된다.
  ```
    Code        PLT              GOT              Library
    ...         ...              ...              ...
    printf  ->  printf:0xAAAA -> 0xAAAA:0xBBBB -> 0xBBBB
    ...         ...              ...              ...
  ```
- ASLR(Address Space Layout Randomization) 을 적용한다면 로딩시 라이브러리 코드들은 랜덤한 메모리 위치를 배정받을 것이며 함수의 이름을 바탕으로 심볼을 검색해 PLT와 GOT 에 알맞은 주소값을 찾아 넣게 된다. 
  - GOT 에 알맞은 값을 채우는 과정을 runtime resolve 라 한다.
  - 동적 라이브러리의 함수를 최초로 호출할 땐 라이브러리를 검색해서 함수의 주소를 조회하지만, 한 번 사용한 다음에는 GOT 에 주소를 기록 해 놓아서 다음에 사용할 땐 GOT 만 조회하여 함수를 사용할 수 있도록 한다. 이 동작을 `resolve` 라 한다.
  - `_dl_runtime_resolve_fxsave` 함수가 실행되면서 resolve 한 값을 GOT 에 저장한다. 
  - 함수를 호출하면 PLT 값을 참조해 GOT 의 특정 영역을 확인하고, GOT 에서 함수의 주소를 읽어와 실행시킨다. GOT 에 주소가 없다면 PLT에 적힌 값을 사용하여 resolve 동작을 수행한다.
- ELF는 GOT 를 활용하여 라이브러리 호출 비용을 절약한다.
- 프로그램을 실행하며 실시간으로 GOT 를 채워가는 방식을 Lazy Building이라 하는데, 프로그램 실행 중 GOT 에 쓰기 권한이 부여되어야 하기 때문에 해킹에 취약하다.
  - 공격자가 ELF에서 프로세스의 흐름에 관여하는 `.init_array`, `.fini_array` 과 같은 데이터 세그먼트들을 다른 함수로 덮어쓰면 프로세스의 흐름이 변경될 수 있다.
  - `.plt` section 은 code 영역이라 write 권한이 없어 overwrite가 불가능하고, `.got` 영역 에는 `Full RELRO` 가 적용되어있지 않다면 overwrite 가 가능하다.
### 메모리 관리
#### ptmalloc (pthread malloc)
- 메모리 활용성을 높이기 위해 메모리 할당 및 해제 방법을 정의한 전략으로 아래와 같은 기능이 있다.
  1. 해제된 메모리 크기에 따라 알맞게 재활용
  2. 해제된 메모리의 위치를 저장하여 빠르게 접근
  3. 외부/내부 메모리 파편화 방지를 위해 16byte 단위로 메모리 할당
     - 보편적으로 메모리 할당 요청은 정확히 같은 크기보다 비슷한 크기로 할당이 많이 된다. 이 경우 16바이트 안의 오차는 모두 같은 크기의 메모리로 할당되므로 외부 단편화를 줄일 수 있다.

- 메모리를 할당하면 `chunk` 라는 객체가 생성되며, `chunk` 에는 메모리를 관리하기 위한 헤더 정보가 있다.
  - 할당중(사용중)인 chunk 의 헤더와 해제된(빈) chunk 의 헤더가 다르다. 할당중인 chunk 는 16byte 의 헤더를 갖고, 해제된 chunk 의 헤더는 32byte 의 헤더를 갖는다. 
  - 헤더에는 아래 정보들이 기록되어 있다.
    1. `prev_size` : (8byte) 인접한 chunk 중, 앞쪽에 위치한 chunk 의 크기
    2. `size` : (8byte) 헤더를 포함한 현재 chunk 의 크기
       - x64 환경에서 ptmalloc 은 메모리를 16byte 크기로 할당하기 때문에 size 헤더의 마지막 3byte는 flag 로 사용하며 각각 allocated arena(A), mmap’d(M), prev-in-use(P) 를 의미한다.
    3. `fd` : (8byte) 해제된 chunk 에만 적용되며, 이전 chunk 의 주소를 가리키는 포인터이다.
    4. `bk` : (8byte) 해제된 chunk 에만 적용되며, 다음 chunk 의 주소를 가리키는 포인터이다.
 - chunk + 16 부분은, 할당된 메모리에서는 data 영역 주소를 가리키지만 해제된 메모리에서는 `fd` 와 `bk` 라는 값을 기록하게 된다.
    - 할당된 메모리

    0 ~ 7 byte | 8 ~ 15 byte |
    ------|------
    prev_size | size (8~12: size, 13: A, 14:M, 15:P) |
    data | data...

    - 해제된 메모리

    0 ~ 7 byte | 8 ~ 15 byte |
    ------|------
    prev_size | size (8~12: size, 13: A, 14:M, 15:P) |
    fd | bk |
  
- 할당되지 않은 메모리는 `top chunk` 라는 모집합에서 관리되며, alloc 요청이 들어오면 `top chunk` 의 메모리를 일부 분리하여 `chunk` 단위로 관리한다.
- 할당된 메모리는 `linked list` 형태로 서로 연결된다. 
  - `top chunk` 에 인접한 미할당 `chunk` 는 다시 `top chunk` 로 자동으로 병합된다.

- 메모리가 해제되면 `chunk` 를 바로 삭제하지 않고 `bin` 이라는 객체에 저장한다. 
  - `bin` 은 총 128개의 항목을 담을 수 있는 배열이며, 62개의 `smallbin`(bin[1:64]) 과 63개의 `largebin`(bin[64:127]) 을 포함하고 있다. (0과 127번 index는 reserved)

fastbin | smallbin | largebin | unsortedbin | tcache
--------|----------|----------|-------------|--------
32 ~ 176 | 32 ~ 1024 | >= 1024 | (< 32) or (> 176) | 32 ~ 1040

 - 메모리 해제시 tcache 에 먼저 chunk 가 담기고, tcache가 full 이면 unsortedbin / fastbin 에 담긴다.
 - 이후 unsortedbin 이 탐색될 때 chunk들이 크기에 따라 smallbin / largebin 에 할당된다.

  1. `smallbin`
     - `smallbin` 에는 32 byte 이상 1024 byte 미만의 `size` 를 갖는 해제된 `chunk` 들이 `linked list` 형태로 저장된다. 
     - `smallbin` 은 `circular doubly-linked list` 로 구성되어 `FIFO` 의 속성을 갖는다.
     - index가 작으면 더 작은 크기의 chunk를 갖도록 구성되며, index가 1씩 커질 때 마다 chunk의 크기가 16byte 더 크다. (`smallbin[0]`는 32byte, `smallbin[1]`는 48byte, ...)
     - 메모리상 인접한 주소의 두 chunk 가 같은 `smallbin` 에 들어가 있으면 자동으로 병합(`consolidation`) 된다.
  2. `fastbin`
     - 일반적으로 작은 크기의 메모리들이 더 빈번하게 발생하므로, 이를 더 효율적으로 관리해야 할 필료가 있다. ptmalloc 에서는 `smallbin` 중 특히 작은 크기의 메모리를 `fastbin` 으로 관리하며, 메모리 단편화 보다는 속도에 관점을 두고 처리한다.
     - 32byte 이상 176byte 이하의 chunk 들이 보관되며, 크기에 따라 총 10개의 fastbin 이 존재한다.
     - `fastbin` 은 `single linked list` 이며, `LIFO` 로 동작한다.
     - `fastbin` 의 chunk 들은 `consolidation` 작업을 수행하지 않는다.
  3. `largebin`
     - 1024 byte 크기 이상의 chunk 들을 보관하며, 총 63개의 largebin 이 존재한다. 
     - index가 작으면 더 작은 크기의 chunk를 갖도록 구성되며, index가 1씩 커질 때 마다 chunk의 크기는 log 에 비례하여 증가한다. (`largebin[0]`는 1024 ~ 1088 byte, `smallbin[32]`는 3072 ~ 3584 byte, ...)
     - 메모리 재사용 요청이 들어오면 가장 비슷한 크기의 chunk 를 반환한다.
     - `smallbin` 과 마찬가지로 `doubly-linked list` 로 구성되고 `consolidation` 을 수행한다.
     - 하나의 `fastbin` linked list 상에서 chunk 들은 메모리 크기 순으로 정렬되어있다. 
  4. `unsortedbin`
     - `fastbin` 에 해당되지 않는 chunk 들이 해제 된 경우 임시로 들어가는 bin 으로, 단 한개만 존재한다.
     - `largebin` 요청시, `unsortedbin` 을 먼저 탐색하고 `largebin` 을 확인한다.
     - `smallbin` 요청시, `fastbin` -> `smallbin` -> `unsortedbin` 을 탐색한다.
     - `unsortedbin` 는 `top chunk` 와 맞닿아 있으므로 `top chunk` 와 `unsortedbin` 사이에 할당된 메모리가 없다면 `unsortedbin` 과 `top chunk` 는 병합된다.
       - ex1) [unsorted bin] [top chunk] : 자동 병합
       - ex2) [unsorted bin] [allocated memory1] [top chunk] : 병합 불가
     - `unsortedbin` 의 첫 chunk 는 libc 영역의 특정 구역과 연결된다. 즉, 첫 chunk 의 `fd` 와 `bk` 영역에는 libc 영역의 주소가 기록되고, 이는 exploit에 활용될 수 있다.
     - `unsortedbin` 에서 chunk 확인 요청이 들어오면, chunk 들을 순회하며 알맞은 크기의 chunk 를 찾고, 순회하는 동안 방문한 chunk 들은 알맞은 `bin` 에 분류한다.
     - `unsortedbin` 을 사용하면 `bin` 분류에 소요되는 자원을 절약할 수 있다.

  - 위 `bin` 들은 `arena` 라는 객체에 담겨 보관된다. 
  5. `tcache`
     - `thread local cache` 를 뜻하며, thread 마다 독립적으로 존재하는 cache 이다. 
     - fastbin 과 동일한 LIFO 방식의 단일 linked list 이며, thread 당 64개가 존재한다.
     - 하나의 tcache 에는 최대 7 개의 chunk 만 보관 가능하도록 제한되어 있다.
     - thread 마다 tcache 가 존재하므로 race condition 처리를 하지 않아도 되기 때문에 병목현상을 줄일 수 있는 기법이다.
     - glibc 2.26 버전에서 처음 추가되었고, 초기에는 보안이 간소화 되어있어 취약점이 많았다. 
       - 이후 tcache_entry 항목을 추가하며 Doubly Free Bug 에 대한 방어책을 마련했다.