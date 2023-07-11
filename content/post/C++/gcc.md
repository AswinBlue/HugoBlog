---
title: "Gcc"
date: 2023-07-10T22:13:06+09:00
lastmod: 2023-07-10T22:13:06+09:00
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
# GCC
C / C++ 언어를 컴파일 해 주는 도구이다. 리눅스에서는 apt 명령으로 설치 가능하며, 윈도우에서는 Mingw을 이용하여 설치 가능하다.
gcc는 컴파일러를 포함한 패키지일 뿐, 내부적인 컴파일러는 따로 있다. (cc1 등)

## GCC 컴파일 동작 순서
`gcc main.c` 파일을 동작시키면 main.c파일을 컴파일하여 실행파일인 a.out 파일을 생성하게 된다.  
하지만 내부적으로는 아래와 같은 과정을 거치게 된다. 
1. c언어로 구현된 .c 파일을 전처리가 완료된 .i 파일로 변환한다.   
`gcc -E main.c -o a.i` : main.c 파일을 a.i 파일로 전처리
2. 전처리된 .i 파일을 어셈블리어로 변환   
`gcc -S a.i -o a.s` : a.i 파일을 a.s 어셈블리어로 어셈블
3. 각 벤더들이 만든 어셈블리어를 목적파일로 변환
`gcc -c a.s -o a.o` : 어셈블리 파일을 목적 파일 EOL(Executable Linux File)로 변환. 하지만 바로 실행할 수는 없다. 
  - `file a.o` 명령어를 입력 해 보면 "LSB relocatable" 이라고 표시된다. 즉, 재배치 가능하다는 의미로, 실행 할 수 있는 상태는 아니라는 뜻이다. 
4. 목적파일에서 참조하는 다른 목적파일들을 linking하여 최종 실행파일을 생성한다.  
`gcc a.o -o out` : a.o 목적파일로 실행 가능한 파일을 생성한다.
- `file out` 명령어를 입력 해 보면 "LBS executable" 라고 출력된다.

- `gcc -v --save-temps -o out` : 위 전체 과정을 실행하며 중간 생성물을 남기고, 실행 결과도 출력

## 명령어 옵션
- `-o`: 목적파일의 이름을 설정. (실행파일은 default로 a.out이 된다. 전통적인 unix의 실팽하일 이름)
- `-g`: gdb(GNU debugger) 로 디버깅 할 때, 소스를 보면서 디버깅 할 수 있게 컴파일 하는 옵션. 디버깅 심벌이 들어가면서 소스 크기가 크게 증가한다.
