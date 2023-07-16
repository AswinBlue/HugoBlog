---
title: "System_programming"
date: 2023-07-15T08:35:21+09:00
lastmod: 2023-07-15T08:35:21+09:00
tags: ["linux", "system_programming"]
categories: ["dev",]
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

# System Programming
- 프로그램이 동작하는 구조는 크게 application, kernel, HW 로 분리할 수 있다.
```
_____________
|  Library  |
¯¯¯¯¯¯¯¯¯¯¯¯¯   Application level
------------------------------
_____________
|System call|
¯¯¯¯¯¯¯¯¯¯¯¯¯   Kernel level
------------------------------
_____________
|  Hardware  |
¯¯¯¯¯¯¯¯¯¯¯¯¯   H/W level
------------------------------
```
- application level에서는 library를 사용하며, 이 코드들은 library buffer를 사용한다. (open(), read(), write(), close() ...)
- Kernel level에서는 System call을 사용하며 system buffer를 사용한다.
- application level 함수를 사용하면, 보통 library buffer를 1차적으로 사용하고, 내부적으로 system call을 수행해 system buffer를 2차적으로 사용하게 된다.
  - printf는 c library 함수이며, '\n'을 만나야 화면상에 출력을 한다.
  - '\n'이 입력되기 전 까지 문자열들은 library buffer에 기록된다.
  - fprintf는 '\n'과 상관없이 문자열을 출력한다. 즉 library buffer를 사용하지 않는다. 


## 파일 입출력

### fgetc
- C에서 파일에 접근하기 위해서는 `fopen` 함수를 사용한다. 
- `fopen`은 파일 포인터를 반환하며, 코드 내에서 파일 포인터로 해당 파일에 접근이가능하다.
- `fgetc(FPTR)` 함수는 fopen으로 연 파일 포인터를 참조해서 char 하나를 읽고 반환한다.
  - fgetc 함수의 반환 값은 int 형태이다.
  - text file을 읽을 땐, 0xFF값이 내용에 올 수 없지만, binary file을 읽을 땐 중간에 0xFF 값이 올 수 있다.
  - char 형태로 0xFF를 읽으면 -1값에 해당하기 때문에, EOF와 구분이 불가능하여 char 대신 int를 반환하도록 되어있다.

### 파일 구조체
- `fopen`은 파일 구조체의 주소(포인터)를 반환한다.
- 파일 구조체는 아래와 같은 내용을 담고 있다.
  - _flags: 
  - _IO_read_ptr : 다음 명령시 파일을 읽거나 쓸 위치
  - _IO_read_end: kernel에서 데이터를 받아서 저장할 버퍼의 끝 위치.
  - _IO_read_base: kernel에서 데이터를 받아서 저장할 버퍼의 시작 위치. 파일에 대한 읽기 명령(fgetc/fgets등) 이 발생했을 때, kernel은 4096byte(BUF_SIZE) 만큼 데이터를 미리 읽어서 이곳에 채워둔다.
  - _fileno: 파일의 offset, kernel에서 해당 파일에 정해준 index(kernel 함수에서 사용할 수 있다.)
- fopen 시에 파일 구조체가 생성 및 초기화 되지만, _IO_read_* 인자들은 파일 접근이 이루어짐과 동시에 값이 적용된다.


### EOF
- 파일을 끝까지 읽었다고 판단하는 것은, EOF 문자(-1) 으로 판단한다. 
  - 하지만 실제파일을 읽어보면 마지막에 -1값이 실제로 들어있지는 않다. 
  - **EOF 값은 file I/O 함수의 리턴값일 뿐 실제 파일에 기입된 값이 아니다.**
  - file I/O 함수는 i-node에 기록된 파일의 크기를 기반으로 파일 끝을 판단한다.

> - ASKII 코드 중 주요 문자의 값 참조
>  - a: 97
>  - A: 68
>  - 0: 48
>  - \n: 10
>  - \r: 13
>  - (공백): 32
>  - \t: 9
>  - \0: 0

- `fguts(BUFF, SIZE, FPTR)` 함수는 fopen으로 연 파일 포인터를 참조해서 line 하나를 읽어온다.
- `fputs(BUFF, FPTR)` 함수는 fopen으로 연 파일 포인터를 참조해서 line 하나를 출력한다. 
  - 리눅스에서 표준 입력/출력/에러는 기본적으로 파일 포인터를 열어둔다. 각각 아래 문자열 혹은 번호로 참조 가능하다.
  > `stdin` : 표준 입력 (== 0)   
  > `stdout` : 표준 출력 (== 1)   
  > `stderr`: 표준 에러 (== 2 )     
  -> 파일 포인터 대신 `stdout` 을 입력하면 표준 출력으로 문자열이 출력된다. (ex: `fputc(BUF, stdout)`)
  
### file offset
- `fopen` 으로 파일을 열게 되면 user는 파일의 읽고 쓸 위치를 설정하지 않는다.
- 파일을 읽고 쓸 위치를 file offset이라고 하며, kernel 내부의 파일 구조체를 사용하여 kernel에서 자체적으로 관리된다.

### 입출력 속도
1) fgetc / fputc : 바이트 단위로 파일을 읽거나 쓰는 함수
2) fgets / fputs : 라인 단위로 파일을 읽거나 쓰는 함수 (버퍼가 허용하는 한)
3)  fread / fwrite : 특정 크기만큼 파일을 읽고 쓰는 함수   


-> 버퍼 접근 횟수를 적게 할 수록 속도 측면에서 유리하다. (1 < 2 < 3)

###
