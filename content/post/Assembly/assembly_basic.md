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


## 명령어
1. mov
   - 특정 값을 레지스터리나 메모리에 저장하는 명령
   - `mov dst, src` : src 값을 dst에 덮어씀(src는 상수값)
   - `mov dst, [mem + 4]` : mem + 4 주소에 저장된 값을 dst에 덮어씀
   - dst 값으로는 주소나 포인터가 올 수 있다.
2. lea
   - 특정 주소를 레지스터리나 메모리에 저장하는 명령
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
1. rsp : 스택의 최상단의 주소
2. rip : 현재 명령 실행 주소
3. rdi : 함수 실행시 첫 번째 인자의 주소
4. esi : 함수 실행시 두 번째 인자의 주소
5. rbp : (Base Register Pointer)스택 복귀 주소
6. rax : (Extended Accumulator Register)사칙연산에서 자동으로 피연산자로 사용되는 리턴 주소
   - 시스템 콜의 실질적인 번호를 가리킴
   - rbx : (Extended Base register)메모리 주소를 저장하는 용도로 사용
   - rcx : (Extended Counter Register)CPU loop counter
   - rdx : (Extended Data Register)
7. eax : (Extended AX) 논리 연산(덧셈, 뺄셈 등)의 결과값이 저장되는 위치
   - 피연산자와 별개로 데이터가 저장된다.
8. ax
9. al
10. ah

## 프로시저
- 특정 주소의 명령어를 실행하도록 하는 코드이다.
- 프로시저를 사용하면 가독성이 높아지고, 반복되는 코드를 절약할 수 있다.

## 스택프레임
- 각 함수들은 실행되면서 지역변수와 임시 값들을 저장해야 하는데, 이 값들은 스택 영역에 저장된다. 
- 하지만 특정 함수가 사용하고 있는 스택 영역을 다른 함수가 침범하여 사용하지 못하게 하기 위해 함수별로 스택 프레임을 두고 스택 영역을 공용으로 사용하지 못하게 관리한다.
