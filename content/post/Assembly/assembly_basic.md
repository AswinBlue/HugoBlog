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
 - `mov dst, src` : src 값을 dst에 덮어씀
 - dst 값으로는 주소나 포인터가 올 수 있다.
2. add 
 - `add dst, src` : dst 에 있는 값에 src 값을 더해 dst에 덮어씀
 - dst는 주소, src는 값
3. sub
 - `sub dst, src:` : dst 에 있는 값에 src 값을 빼고 dst 주소에 덮어씀
 - dst는 주소, src는 값
4. inc
 - `inc op` : op 에 있는 값을 1 증가시킴
 - op는 주소
5. dec
 - `dec op` : op 에 있는 값을 1 감소시킴
 - op는 주소

6. and
 - `and dst, src` : src와 dst 값을 and 연산한 결과를 dst에 저장
7. or
 - `or dst, src` : src와 dst 값을 or 연산한 결과를 dst에 저장
8. xor
 - `xor dst, src` : src와 dst 값을 xor 연산한 결과를 dst에 저장
9. not
 - `not op` : op 값을 not 연산한 값을 op에 저장
10. comp
 - `cmp rax, rbx` : rax 값과 rbx 값을 비교한 후, 결과에 따라 플래그 설정
   - if rax == rbx: ZF = 1
11. test
 - `test rax, rbx` : rax 값과 rbx 값을 and 연산 후, 결과에 따라 플래그 설정
12. jmp
 - `jmp addr` : addr 주소로 rip를 이동한다.
13. je
 - `je addr` : 직전에 비교한 `cmp rax rbx` 연산에서  rax == rbx 라면 addr로 rip 를 이동한다.
14. jg
 - `jg addr` : 직전에 비교한 `cmp rax rbx` 연산에서  rax > rbx 라면 addr로 rip 를 이동한다.