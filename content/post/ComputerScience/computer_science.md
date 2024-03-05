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

# CPU
## Segment
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

## ISA
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


