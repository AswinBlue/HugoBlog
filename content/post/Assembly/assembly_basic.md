---
title: "Assembly_basic"
date: 2024-02-21T20:10:48+09:00
lastmod: 2024-02-21T20:10:48+09:00
tags: []
categories: []
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


# Assembly
- 기계어로 1대1 대응 가능한 언어로, human readable 한 언어 중 가장 기계어에 가까운 언어이다. 기계어로 컴파일 직전에 어셈블리어로 변환을 거친다.
- operation code(명령어) 와 operand(피연산자) 로 구성된다.
- 명령어는 데이터 이동, 산술연산, 논리연산, 비교, 분기, 스택, 프로시저, 시스템콜의 종류가 있다. 
- 피연산자 자리에는 상수(Immediate Value), 레지스터(Register), 메모리(Memory)가 올 수 있다.  
  - 숫자를 넣으면 상수이다. 
  - [] 로 둘러싸인 숫자는 메모리이다.
  - 메모리 피연산자 앞에는 메모리의 크기를 나타내는 크기 지정자(Size Directive)가 붙을 수 있다.
    - WORD: 16bit
    - DWORD: 32bit
    - QWORD: 64bit


## 명령어
1. mov
   - "값"을 레지스터리나 메모리에 저장하는 명령
   - `mov dst, src` : src 값을 dst에 덮어씀
   - dst = 레지스터, src = 레지스터 : src가 가리키는 주소의 값을 dst가 가리키는 주소의 값에 덮어씀
   - dst = 메모리, src = 레지스터 : src가 가리키는 주소의 값을 dst가 가리키는 주소의 값에 덮어씀
   - dst = 레지스터, src = 메모리 : src가 가리키는 주소의 값을 dst가 가리키는 주소의 값에 덮어씀
   - dst = 메모리, src = 메모리 : 불가능
   - `mov dst, [mem + 4]` : mem + 4 주소에 저장된 값을 dst에 덮어씀
   - dst 값으로는 주소나 포인터가 올 수 있다.
2. lea
   - "주소"를 레지스터리나 메모리에 저장하는 명령
   - `lea dst, src` : src값을 dst에 덮어씀 (src는 주소값)
   - `lea dst, [mem + 4]` : mem 값에 4를 더한 값을 dst에 덮어씀
3. add 
   - `add dst, src` : dst 에 있는 값에 src 값을 더해 dst에 덮어씀
   - dst는 주소, src는 값
4. sub
   - `sub dst, src:` : dst 에 있는 값에 src 값을 빼고 dst 주소에 덮어씀
   - dst는 주소, src는 값
5. inc
   - `inc op` : op 에 있는 값을 1 증가시킴
   - op는 주소
6. dec
   - `dec op` : op 에 있는 값을 1 감소시킴
   - op는 주소
7. and
   - `and dst, src` : src와 dst 값을 and 연산한 결과를 dst에 저장
8. or
   - `or dst, src` : src와 dst 값을 or 연산한 결과를 dst에 저장
9. xor
   - `xor dst, src` : src와 dst 값을 xor 연산한 결과를 dst에 저장
10. not
   - `not op` : op 값을 not 연산한 값을 op에 저장
11. comp
    - `cmp rax, rbx` : rax 값과 rbx 값을 비교한 후, 결과에 따라 플래그 설정
    - if rax == rbx: ZF = 1
12. test
    - `test rax, rbx` : rax 값과 rbx 값을 and 연산 후, 결과에 따라 플래그 설정
13. jmp
    - `jmp addr` : addr 주소로 rip를 이동한다.
14. je
    - `je addr` : 직전에 비교한 `cmp rax rbx` 연산에서  rax == rbx 라면 addr로 rip 를 이동한다.
15. jg
    - `jg addr` : 직전에 비교한 `cmp rax rbx` 연산에서  rax > rbx 라면 addr로 rip 를 이동한다.
16. push
    - `push val` : 스택의 최상단에 'val' 값을 집어넣는다. 
    - rsp 를 한칸 위로 옮기고, 그 위치에 'val'을 대입한다.
    - `rsp -= 8; [rsp] = val` 동작과 동일하다. 
    - `push val` 형태로는 4byte 데이터밖에 주입할 수 없으므로, 4byte를 초과하는 데이터를 주입할 때는 값을 레지스터에 대입하고, 레지스터를 push한다.
      ```
         mov rax 0x0102030405060708
         push rax
      ```
17. pop
    - `pop rax` : 스택의 최상단에 있는 값을 'rax' 주소에 대입한다. 
    - rsp 위치의 값을 반환하고, rsp 를 한칸 밑으로 옮긴다.
    - `rsp += 8; reg = [rsp-8]` 동작과 동일하다.
18. call
    - `call addr` 'addr' 위치의 프로시저를 호출
    - 'push' 명령과 'jump' 명령으로 구현할 수 있다. 
      - 스택에 다음 실행 주소를 push한다. (push rip + 8)
      - rip를 실행시키고 싶은 명령어가 적힌 주소로 이동한다. (jump)
19. leave
   - rsp를 rbp + 8 위치로 이동한다. 
   - rbp도 갱신한다.
   - `mov rsp, rbp; pop rbp` 명령과 동일하다.
20. ret
    - rip를 rsp가 가리키는 스택의 주소에 담긴 값으로 이동한다.
    - `pop rip` 명령과 동일하다.

### 시스템콜
- 운영체제는 하드웨어 및 소프트웨어를 총괄하며, 접근 권한을 제한하여 해킹으로부터 컴퓨터를 보호하기 위해 커널 모드와 유저 모드로 권한을 분리한다. 
- 시스템 콜은 유저모드에서 시스템에게 커널 모드에서 실행할 수 있는 동작들을 요청하는 동작이다. 
  - 유저가 시스템 콜을 호출하면 커널은 이를 실행하고, 결과를 유저에게 반환한다.
## 레지스터
### 범용 레지스터
1. rsp : 스택의 최상단의 주소
2. rip : 현재 명령 실행 주소
3. rdi : 함수 실행시 첫 번째 인자의 주소 / 시스템 콜 실행시 첫 번째 인자의 주소 / (destination index) 데이터 이동시 목적지를 가리키는 주소
4. esi : 함수 실행시 두 번째 인자의 주소
5. rsi : 시스템 콜 실행시 두 번째 인자의 주소 / (source index) 데이터 이동시 원본을 가리키는 주소
6. rbp : (Base Register Pointer)스택 복귀 주소
   - rbp 주소에는 함수가 종료되고 함수를 호출한 함수(caller) 의 스택 프레임으로 rbp를 이동하기 위한 주소 SFP(Stack Frame Pointer) 가 저장된다. 함수 호출시 호출자(caller)의 SFP를 stack에 넣고, 실행된 함수가 끝날 때 이를 pop하여 함수가 호출된 코드 라인으로 복귀할 수 있다.
   - 즉, 함수 호출 시마다 `push rbp` 코드를 보게 될 것이다.
7. rax : (Extended Accumulator Register)사칙연산에서 자동으로 피연산자로 사용되는 리턴 주소
   - 시스템 콜의 실질적인 번호를 가리킴
   - 시스템 콜의 반환값도 rax에 저장됨
   - rbx : (Extended Base register)메모리 주소를 저장하는 용도로 사용
   - rcx : (Extended Counter Register)CPU loop counter
   - rdx : 시스템 콜 실행 시 세 번째 인자의 주소 / (Extended Data Register)
8. eax : (Extended AX) 논리 연산(덧셈, 뺄셈 등)의 결과값이 저장되는 위치
   - 피연산자와 별개로 데이터가 저장된다.
   - rax 값에서 마지막 4byte 길이만 잘려서 저장된다.
9.  ax : eax가 사용되기 이전, CPU의 word가 16bit 일 때 사용되던 레지스터
   - 큰 의미는 없지만 관습처럼 사용되며 eax에서 하위 2byte를 자른 값을 나타낸다.
   - ax는 다시 ah와 al로 한 byte씩 나뉜다.
     - ah : ax에서 상위 1byte
     - al : ax에서 하위 1byte

 byte_4   | byte_3 | byte_2 | byte_1
---|---|---|---
 eax_4|eax_3|eax_2|eax_1 
 | | |ax_2|ax_1
 | | |ah|al
10. esp : 스택 최상단의 주소값 (Stack pointer register)
   - x86에서 사용하는 값으로, x64에서는 rsp로 대체된다.
   - PUSH, POP, SUB, CALL 명령을 수행 할 때 마다 자동으로 변경된다.
   - PUSH, POP 의 기준이 되는 포인터이다.
11. ebp : 스택 프레임 최하단의 주소값 (Base pointer register)
   - x86에서 사용하는 값으로, x64에서는 rbp로 대체된다.
   - 새로운 함수가 호출 될 경우, EBP 값이 스택에 push되어, 이전 함수의 EBP값이 스택에 쌓이게 된다. 

### 세그먼트 레지스터
- cs, ss, ds, es, fs, gs
  - cs : code segment
  - ds : data segment
  - es : extra segment
  - fs, gs : 앞선 세 개의 segment를 만들고 여유분 두개를 추가한 것. cs/ds/es는 CPU가 명확한 사용 용도를 가지는 반면 fs/gs는 정해진 용도가 없어 OS가 임의로 사용 가능
    - 리눅스에서는 fs를 Thread Local Storage(TLS) 의 포인터로 사용한다. 

### 명령어 포인터 레지스터
- Instruction Pointer Register, IP

### 플래그 레지스터
- CF(Carry Flag) : 부호 없는 수의 연산 결과가 비트의 범위를 넘을 경우 1로 세팅
- ZF(Zero Flag) : 연산의 결과가 0일 경우 1로 세팅
- SF(Sign Flag) : 연산의 결과가 음수일 경우 1로 세팅
- OF(Overflow Flag) : 부호 있는 수의 연산 결과가 비트 범위를 넘을 경우 1로 세팅

## 프로시저
- 특정 주소의 명령어를 실행하도록 하는 코드이다.
- 프로시저를 사용하면 가독성이 높아지고, 반복되는 코드를 절약할 수 있다.

## Section
- object 파일 안에서 재배치 될 수 있는 가장 작은 단위를 섹션(section) 이라 한다. 
- `objdump -h` 로 목적파일의 Section을 확인할 수 있다.

## 스택프레임
- 각 함수들은 실행되면서 지역변수와 임시 값들을 저장해야 하는데, 이 값들은 스택 영역에 저장된다. 
- 하지만 특정 함수가 사용하고 있는 스택 영역을 다른 함수가 침범하여 사용하지 못하게 하기 위해 함수별로 스택 프레임을 두고 스택 영역을 공용으로 사용하지 못하게 관리한다.
- 함수가 호출될 떄 마다 스택프레임이 형성되며, 스택프레임 형성을 어셈블리어로 표현하면 다음과 같다.
  ```
  push EIP  # 함수 완료 후 실행할 코드의 주소를 스택에 저장
  push EBP  #  함수 완료 후 EBP 포인터를 복구시킬 값을 스택에 저장한다. (이를 SFP라 한다.)
  mov EBP ESP # 스택의 top 주소를 EBP에 대입한다. (EBP를 갱신하여 새로운 스택 프레임의 base를 세팅한다.)
  sub ESP, VALUE  # 지역변수가 설정될 영역만큼(VALUE) ESP 주소를 옮긴다. (EBP - ESP 만큼이 지역변수 영역)
  ```
  - x64라면 EIP 대신 rip, EBP 대신 rbp, ESP 대신 rsp를 사용한다.
- 구성된 스택 프레임은 아래와 같이 형성된다.
   ```
   ----------  <- ESP(rsp)
   지역변수
   ----------  <- EBP(rbp)
   SFP
   ----------  <- EBP(rbp) + 0x04 (x64라면 +0x08)
   return address (EIP)
   ----------
   ```
- 만약 Stack canary 기법이 적용되었다면 아래와 같이 canary가 추가된다.
   ```
   ----------  <- ESP(rsp)
   지역변수
   ----------  <- EBP(rbp) - 0x04 (x64라면 -0x08)
   Canary (8byte length)
   ----------  <- EBP(rbp)
   SFP
   ----------  <- EBP(rbp) + 0x04 (x64라면 +0x08)
   return address (EIP)
   ----------
   ```
- 함수가 종료되면 다음 절차가 수행된다.
  ```
  mov ESP, EBP  # 지역변수 공간을 해제
  pop EBP  # SFP에 정보를 가져와 ebp에 대입
  RET  # pop EIP; jmp EIP 동작을 수행한다.
  ```

## .asm to bin
- .asm 파일을 바이트 코드로 변경하려면 "nasm" 이라는 모듈을 사용하면 된다. 
- `nasm -f elf YOUR_FILE.asm` 명령으로 .o 파일을 생성할 수 있다.
  - 만약 구동중인 컴퓨터가 x86-64 구조라면 elf 대신 elf64를 입력한다.
  - 컴퓨터 구조별 명령은  `nasm -fh` 로 확인이 가능하다. 
  - 생성된 .o 파일은 `objdump -d YOUR_OBJ.o` 명령으로 내용 확인이 가능하다.
  - 만약 assembly 파일 안에 main 함수를 정의하였다면 `gcc YOUR_OBJ.o -o YOUR_OUT.out` 명령어로 실행 가능한 ELF 파일을 생성할 수도 있다. 
- `objcopy --dump-section .YOUR_SECTION=YOUR_BIN.bin YOUR_OBJ.o` 명령으로 .o 파일을 .bin 파일로 변환할 수 있다. 
  - `section .text` 로 어셈블리 영역이 시작된다면 YOUR_SECTION=text 가된다.
  - ex) test.asm 파일이 아래와 같은 경우, 
      ```
         section .text  ; 아래에 text 라는 section을 정의한다.
         global main    ; main 함수를 전역으로 선언한다.
         main:          ; main 함수의 내용을 구현한다.
         push 0x00      ; 구현부
         ...
      ```

   - `nasm -f elf64 test.asm` 을 수행한 후, `objcopy --dump-section .text=test.bin test.o` 을 수행하면 test.bin 파일을 얻어낼 수 있다.
  - 생성한 바이너리 파일을 `xxd YOUR_BIN.bin` 명령으로 내용을 출력할 수 있다. 이는 `objdump -s YOUR_OBJ.o` 명령의 출력 형태와 동일하다