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
1. 전처리 : c언어로 구현된 .c 파일을 전처리가 완료된 .i 파일로 변환한다.   
`gcc -E main.c -o a.i` : main.c 파일을 a.i 파일로 전처리
2. 컴파일 : 전처리된 .i 파일을 어셈블리어로 변환   
`gcc -S a.i -o a.s` : a.i 파일을 a.s 어셈블리어로 어셈블
3. 어셈블: 각 벤더들이 만든 어셈블리어를 목적파일로 변환(어셈블리 언어를 기계어로 변환)
`gcc -c a.s -o a.o` : 어셈블리 파일을 목적 파일 EOL(Executable Linux File)로 변환. 하지만 바로 실행할 수는 없다. 
  - `file a.o` 명령어를 입력 해 보면 "LSB relocatable" 이라고 표시된다. 즉, 재배치 가능하다는 의미로, 실행 할 수 있는 상태는 아니라는 뜻이다. 
4. 링킹: 목적파일에서 참조하는 다른 목적파일들을 linking하여 최종 실행파일을 생성한다.  
`gcc a.o -o out` : a.o 목적파일로 실행 가능한 파일을 생성한다.
- `file out` 명령어를 입력 해 보면 "LBS executable" 라고 출력된다.
- `gcc -v --save-temps -o out` : 위 전체 과정을 실행하며 중간 생성물을 남기고, 실행 결과도 출력
- 리눅스에서 `ldd` 명령으로 링킹시 라이브러리 의존성을 확인할 수 있다.
- ASLR을 지원하는 커널의 경우, `-no-pie` 옵션을 넣으면 PIE( position independent executable) 영역을 생성하지 않아 ASLR 기능을 끌 수 있다.


## 라이브러리
- 헤더파일에서 include를 하여 사용할 수 있는 목적파일을 라이브러리라고 칭한다. 
  - 라이브러리는 링킹을 통해 프로그램에 포함되며, 링킹 방식에 따라 '정적 라이브러리'와 '동적 라이브러리'로 분류된다.
  - 정적 라이브러리는 정적 링킹에 의해 생성되며, 라이브러리가 코드의 object 파일이 자체에 포함되는 형태이다.
    - 정적 라이브러리는 파일의 크기가 커지고, 라이브러리 버전 변경시 파일이 매번 변경되어야 하는 단점이 있다.
    - `gcc -static` 와 같이 static 옵션을 넣어 설정 가능하다.
  - 동적 라이브러리는 동적 링킹에 의해 생성되며, 라이브러리 코드의 object 파일이 별도로 존재하고, 링커가 라이브러리 코드의 주소를  사용자의 코드와 연결시켜주는 형태이다.
    - 빌드시 별도 옵션을 넣지 않으면 dynamic linking 으로 동작한다.
    - 동적 할당을 수행하면 각 프로세스는 외부 라이브러리 코드의 함수를 PLT(Procedure Linkage Table) 와 GOT(Global Offsets Table)를 통해 접근하게 된다.
- C에서 라이브러리 파일은 `lib` 으로 시작하는 규칙을 지니며 `.a` 확장자를 가진다
- `gcc -c CFILE.c -o OBJ.o` 명령으로 `OBJ.o` 목적파일을 생성했다면, `ar rcv libmylib.a OBJ.o` 명령으로 `libmylib.a`라는 사용자 정의 라이브러리/정적 라이브러리를 생성 가능하다. 
- `ar t libmylib.a` 로 라이브러리가 가리키는 파일을 검색하면 `OBJ.j` 파일을 확인할 수 있다. 
- 라이브러리를 함께 컴파일 할 때 `gcc main.c libmylib.a` 와 같이 컴파일 할 수도 있지만, 라이브러리를 제대로 활용하는 방법은 `gcc main.c -lmylib` 와 같이 `-l` 옵션을 이용한다.   
  > 정적 라이브러리 이름에서 앞쪽의 lib 부분과 뒤쪽의 .a 부분을 제외한 부분이 라이브러리 이름이다. 
  > 위 예시에서는 `mylib`이 라이브러리 이름이다.
- 리눅스에서 `ldd` 명령으로 링킹시 라이브러리 의존성을 확인할 수 있다.
- gcc는 소스코드 컴파일 시 표준 라이브러리의 파일들을 모두 탐색하도록 되어있다.
  - `ld --verbose | grep SEARCH_DIR | tr -s ' ;' '\n'` 명령어로 확인하면 포함시킨 경로를 확인할 수 있다.
  - SEARCH_DIR("=/usr/local/lib/x86_64-linux-gnu")
  - SEARCH_DIR("=/lib/x86_64-linux-gnu")
  - SEARCH_DIR("=/usr/lib/x86_64-linux-gnu")
  - SEARCH_DIR("=/usr/lib/x86_64-linux-gnu64")
  - SEARCH_DIR("=/usr/local/lib64")
  - SEARCH_DIR("=/lib64")
  - SEARCH_DIR("=/usr/lib64")
  - SEARCH_DIR("=/usr/local/lib")
  - SEARCH_DIR("=/lib")
  - SEARCH_DIR("=/usr/lib")
  - SEARCH_DIR("=/usr/x86_64-linux-gnu/lib64")
  - SEARCH_DIR("=/usr/x86_64-linux-gnu/lib")

## 명령어 옵션
- `-o`: 생성될 파일의 이름을 설정. ('SRC.c' 를 넣으면 결과물은 'SRC.o', 'SRC.s' 형태로 나오지만, 실팽파일은 a.out 형태가 된다. 전통적인 unix의 방식)
- `-c`: 목적파일 "*.o" 파일 생성
- `-E`: 전처리된 "*.i" 파일 생성
- `-S`: 어셈블된 "*.s" 파일 생성

> 아무 옵션도 넣지 않으면 실행 파일을 만드는 것이 기본

- `-g`: gdb(GNU debugger) 로 디버깅 할 때, 소스를 보면서 디버깅 할 수 있게 컴파일 하는 옵션. 디버깅 심벌이 들어가면서 소스 크기가 크게 증가한다.
- `-l`: 컴파일시 라이브러리를 추가하는 명령어 `gcc -l라이브러리이름` 형태로 사용한다. (ex: `gcc -lmylib` 으로 libmylib.a 라이브러리 첨가 가능)
- `-L`: 링크할 라이브러리를 찾을 위치를 추가할 수 있다. `gcc -L/usr/local/library` 와 같이 경로를 추가할 수 있다.
 > `LIBRARY_PATH` 환경변수를 참조하도록 되어있으며, `LIBRARY_PATH는` 일반적으로 `/usr/lib` 경로를 포함한다. 
- `-I`: include path를 지정해 주는 옵션. `gcc -I.` (현재위치 추가 명령)와 같이 특정 위치를 include 하도록 할 수 있다. 이렇게 설정한 경로는 .c 파일에서 `include<>` 명령으로 라이브러리를 참조할 수 있게 한다. 
 > `-I` 옵션으로 경로를 지정하지 않으면 `include""` 형태로 같은 경로상의 라이브러리를 참조할 수는 있다.
 - `-Wall` : warning level all, 모든 오류를 출력한다.