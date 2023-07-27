---
title: "Make"
date: 2023-07-13T18:35:05+09:00
lastmod: 2023-07-13T18:35:05+09:00
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

# make
- 분할 컴파일을 통해 컴파일 작업 효율을 올리고, 이 과정을 자동화 하기 위해 일괄처리를 도와주는 도구이다. 
- batch 파일로 컴파일 하면, 변경점을 감지하지 못해 batch파일을 수정하지 않고서는 분할 컴파일을 수행할 수 없다.
- make파일은 파일들 간의 의존성을 정의하여, 특정 파일이 수정되면 어떤 파일을 컴파일 해야하는지 알아서 판단해 준다.
- 리눅스 시스템의 수정 시간을 확인하여, 빌드 결과물이 생성된 시간과 소스가 수정된 시간을 비교해서 컴파일 혹은 링킹이 다시 필요한지 판단하는 원리이다.

## 기본구조
- 파일 이름은 `Makefile` 으로 생성한다.
```
TARGET:DEPENDENCIES
   COMMANDS
```
  - COMMANDS 앞에는 공백이 아니라 **tab문자**이다. 
  - COMMAND를 실행하여 TARGET파일 생성한다는 의미이다.
  - TARGET을 생성할 때 DEPENDENCIES 파일들이 필요하다. DEPENDENCIES파일이 수정되면 TARGET파일도 다시 컴파일 해야한다는 의미이다.
- `# 주석` : 주석은 #으로 달 수 있다. 
- `    @COMMANDS`: make파일은 실행시 '실행한 명령 원문' 과 '실행 결과' 를 모두 쉘이 출력한다. `@`를 붙이면 명령 원문은 출력하지 않는다.
- 기본 형태를 약간 변형하여 명령어를 생성할 수도 있다. 
  - `DEPENDENCIES` 를 없이 `TARGET` 과 `COMMANDS` 만 남기면, `make TARGET` 명령을 입력시 해당 `COMMANDS` 만 수행되도록 할 수 있다.
    ```
    clean:
        rm -f ${OBJ}${TARGET}
        # make clean 명령시 위 동작 수행

    install:
        ...
        # 동일한 형태로 다른 명령도 작성 가능
    ```

### make 파일 정의 COMMANDS
- 대부분의 명령들은 쉘 명령과 유사하다.
- `echo <VALUE>` : VALUE 값을 출력한다. 
- `VARIABLE = VALUE` : VARIABLE 이라는 이름의 변수를 선언하고, VALUE 값을 대입함
  - 변수 선언시 자기 자신을 참조하는 형태(recursive)는 `=` 연산자로 사용 불가능하다. (ex: `VARIABLE = ${VARIABLE} + DATA`)
  - 대신 `:=` 연산과 `+=` 연산을 사용 가능하다.
  - ex) `VARIABLE := ${VARIABLE} + DATA`, `VARIABLE += DATA`
- `$(VARIABLE)` : VARIABLE 변수에 해당하는 값을 호출 (`${VARIABLE}` 과 동일)
  - TIP: 컴파일 도구를 변수로 지정해 놓으면 좋다. `CC=gcc` -> `$(CC) -c file.c`
  - TIP: 최종 파일 이름을 변수로 지정해 놓으면 좋다. `PROJECT_NAME=myProject` -> `gcc -o $(PROJECT_NAME) file1.o file2.o`
  - TIP: .o파일을 만드는 `-c` 옵션을 `CFLAGS` 로 변수로 사용하면 좋다.    
  -> `CFLAGS = -I./include -c` 와 같이 include path 및 기타 설정이 가능하다.
  - TIP: 링킹을 위한 `LFLAGS` 또한 같은 맥락에서 변수로 활용하면 좋다.
- `${VARIABLE:ASIS=TOBE}` : VALUE 변수에서 ASIS라는 구문을 TOBE라는 구문으로 치환한다. (ex: `PROJECT_NAME:my=your`-> ${PROJECT_NAME} == yourProject)

### 내장 매크로
- make 파일의 target-dependency-command 라인들에 일일이 파일 이름을 써 넣고 수정하기 번거롭기에, 아래와 같이 매크로를 활용해 좀더 편리하게 작업을 수행할 수 있도록 한다.
  - 내장 매크로를 활용하면 command에 파일 이름을 직접쓰지 않아도 되게 된다.
- `$<` : DEPENDENCIES 중 가장 선두
- `$^` : DEPENDENCIES 전체를 의미
- `$@` : TARGET을 의미
- `$*` : 확장자가 없는 TARGET을 의미
- `$?` : DEPENDENCIES 중 TARGET보다 수정 시간이 늦은 파일들
- `.c.o:` : Makefile 안에서 언급된 모든 xxx.o 파일을 만들기 위해 동일한 이름을 가진 xxx.c 파일들을 컴파일하여 xxx.o 파일을 생성한다.
- `%.o : %.c` : `.c.o` 와 동일한 효과를 낸다. 좀더 신규 스타일이다.
- 최종 예시를 보면 다음과 같다.
```
CC = gcc
CFLAGS = -c
TARGET = a.out
OBJ = main.o func1.o

${TARGET} : ${OBJ}
    ${CC} ${OBJ} -o ${TARGET}  # gcc main.o func1.o -o a.out 와 동일

.c.o :  # 위에서 언급된 모든 .o 파일(OBJ)을 만들기 위해 .c 파일로 .o 파일 생성
    ${CC} ${CFLAGS} $<  # $<는 가장 선두의 dependency를 의미함. 즉 gcc -c xxx.c 와 동일
```

## 쉘 명령어
- `make` : 현재 경로에 있는 `Makefile` 을 실행한다. 
- `make install` : 해당 경로의 소스를 컴파일하여 /usr/local/lib, /usr/local/bin 폴더로 .so파일과 .bin파일 복사
- `make -f <FILE_NAME>` : Makefile 대신 FILE_NAME 을 make파일로 가정하고 실행한다.
- `make -p` : 설정된 매크로 옵션들을 확인 가능
