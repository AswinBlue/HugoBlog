+++
title = "Linux commands"
date = 2021-08-12T10:41:00+09:00
lastmod = 2021-08-12T10:41:00+09:00
tags = [ "linux", "sed",]
categories = ["dev",]
imgs = []
cover = "" # image show on top
readingTime = true # show reading time after article date
toc = true
comments = false
justify = false # text-align: justify;
single = false # display as a single page, hide navigation on bottom, like as about page.
license = "" # CC License
draft = false
+++
# Linux Command
- 리눅스에서 사용되는 명령어들을 정리한다.
- 자주 사용되는 모듈의 명령어도 포함한다.
- 리눅스에서 명령어는 `/usr/bin/` 폴더에 저장되며, 내부에 저장된 파일들은 각 유저들에게 실행권한이 있다.
- 유저 개인의 명령어를 따로 설정 및 관리하려면 `~/.bashrc` 파일에서 특정 디리렉터리를 PATH에 추가하여 사용할 수 있다. 
  - 기본적으로 `~/bin/` 경로가 PATH에 추가되어 있다.
  - `export PATH=$PATH:추가할경로[:추가할경로2:추가할경로3:...]` 명령어를 `~/.bashrc` 에 추가하면 경로를 추가할 수 있다.
    - ex) 
      ```
      # in .bashrc file
      PATH=$PATH:/home/user/bashrc  # 기존의 PATH에 /home/user/.bashrc 추가
      # 현재 PATH는 .bashrc 포함
      PATH=$PATH:/home/user/dir1:/home/user/dir2  # 기존의 PATH에 dir1, dir2 추가
      # 현재 PATH는 .bashrc, dir1, dir2 포함

      export PATH  # PATH를 적용
      ```
    - 적용 후 `source ~/.bashrc` 명령어로 .bashrc를 재적용 해 주면 설정이 완료된다. 
  - 리눅스 쉘에서 위 쉘코드를 바로 입력해도 적용은 가능하지만, 이 경우 재부팅시 설정이 초기화된다.

## 리눅스 기본
### 리눅스 설정 관련
- `stty -a`: 시그널 단축키들의 값 확인
- `strace FILE_NAME`: 실행파일이 실행되는 상세 과정을 라인별로 보여준다.
- `getconf`  리눅스의 시스템 변수 값을 확인하는 명령어
  - `getconf -a`: 모든 시스템 변수를 반환한다.
  - `getconf LONG_BIT`: 시스템이 x64라면 64를, x86이라면 32를 반환한다.
- `ldd FILE_NAME` : FILE_NAME 을 실행하는데 필요한 라이브러리 의존성을 확인한다. 

### 파일 시스템 조작
- `mkdir` : 디렉터리를 생성하는 명령여
  - parent 디렉터리가 존재하지 않는다면 `mkdir -p` 명령어로 한 번에 생성 가능 (ex: `mkdir -R A/B/C/D`)

## 문자열 조작
### sed
- 기본적인 기능은 ed에서 따 왔으며, 이 기능들은 모두 sed에 적용이 된다.
- ed는 대화형 편집기이며, sed는 스트리밍 편집기
- \n 을 개행문자로 사용하는 스트리밍 에디터

`sed [-e script][-f script-file][file...]`
1. 찾기/출력
   - `sed -n '/abd/p' list.txt : list.txt` : 파일을 한줄씩 읽으면서(-n : 읽은 것을 출력하지 않음) abd 문자를 찾으면 그 줄을 출력(p)한다.

2. 치환
   - `sed 's/addrass/address/' list.txt` : list.txt파일에서 addrass를 address로 바꾼다. 단, 원본파일을 바꾸지 않고 출력을 바꿔서 한다.
   - `sed 's/□□*/□/' list.txt` : ( *표시: □ 는 공백 문자를 표시한다. ) 위의 구문은 한개이상의 공백문자열을 하나의 공백으로 바꾼다.

3. 삭제
   - `sed '/TD/d' list.txt` : TD 문자가 포함된 줄을 삭제하여 출력한다.
   - `sed '/Src/!d' list.txt` : Src 문자가 있는 줄만 지우지 않는다.
   - `sed '1,2d' list.txt` : 처음 1줄, 2줄을 지운다.
   - `sed '/^$/d list.txt` : 공백라인을 삭제하는 명령이다

### tr
- `tr -s STRING1 STRING2` : 특정 STRING1 의 문자를 STRING2 의 문자로 치환한다.
  - STRING1[0] 은 STRING[0] 으로, STRING1[1] 은 STRING[1] 로, ... 치환된다.
    - ex) `tr -s ' ;' '\n'` : 문자열에서 ' ;' 를 '\n' 문자로 치환한다. 
    - ex) `tr -s '123' 'abc'` : 문자열에서 1을 a로, 2를 b로, 3을 c로 치환한다.
  - 정규식도 사용 가능하다.
    - ex) `tr -s '1-3' 'a-c'` : 문자열에서 1을 a로, 2를 b로, 3을 c로 치환한다.
- `tr -c STRING1 STRING2` : STRING1에 포함된 문자를 제외하고 STRING2의 마지막 문자로 치환한다.
  - ex) `tr -c '123' 'abc'` : 1,2,3을 제외한(\n포함) 모든 문자를 c로 변환한다.
- `tr -d STRING1 ` : STRING1에 포함된 문자를 제거한다.
  - ex) `tr -d '123'` 문자열에 포함된 1,2,3을 모두 제거한다.


## 압축
- `tar -xvf <FILE_NAME>` : tar 파일 압축 해제
- `tar -cvf <RESULT_FILE> <SOURCE_FILE>` : tar 파일 압축
- `tar -zxvf <FILE_NAME>` : tar.gz 파일 압축 해제
- `tar -zcvf <RESULT_FILE> <SOURCE_FILE>` : tar.gz 파일 압축
- `$ dpkg -x <SOURCE_PATH> <DESTINATION_PATH>` : .deb 파일 압축 해제


### 에러와 해결
1. tar (child): xz: Cannot exec: No such file or directory
 - `sudo apt-get install xz-utils` 명령으로 모듈을 설치 해 주어야 한다.
```
tar (child): xz: Cannot exec: No such file or directory
tar (child): Error is not recoverable: exiting now
tar: Child returned status 2
tar: Error is not recoverable: exiting now
```

이때 확장자가 gz로 되어있는 경우에는 옵션에 'z'를 추가해준다. (tar -zxvf, tar-zcvf)


## 파일 관리 / 접근
- `wc FILE_NAME` : 파일의 라인, 단어, 글자 수를 출력 (단어는 공백문자(줄바꿈, 공백, 탭) 으로 구분된 글자 집합)
- `wc -c FILE_NAME`: 파일 크기를 byte단위로 출력
- `xxd FILE_NAME`: binary파일의 hexdump 출력
- `file FILE_NAME`: 파일이 어떤 종류의 유형의 파일이며(C language, text, executable, ...), 어떤 속성을 갖고 있는지를 확인할 수 있다. 대상 파일의 유형을
  - ex) 
    ```
    $ file /bin/ls    
    /bin/ls: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=9567f9a28e66f4d7ec4baf31cfbf68d0410f0ae6, stripped

    $ file /etc/passwd
    /etc/passwd: ASCII text

    $  file /bin/python
    /bin/python: symbolic link to `python3'
    ```
- `readelf FILE_NAME`: ELF 파일의 meta data를 확인한다. 
  - ELF란 Executable and Linkable Format을 의미한다. (*.o 형태의 파일이다)
  - `readelf -h` ELF 파일의 헤더 확인
  - `readelf -s` ELF 파일 내부 symbol 정보들을 출력한다. 함수 주소, 이름 및 속성들을 확인할 수 있다.
  - `readelf -S` ELF 파일 내부 Section 정보들을 출력한다. 
    - `objdump -h` 명령과 동일한 결과를 출력한다.
- `objdump -S FILE_NAME`: object file을 어셈블리 형태로 주소별로 출력 해주는 명령이다. 
- `objdump -h FILE_NAME`: object file의 section 헤더정보를 확인하는 명령어이다. section의 크기, VMA(Virtual Memory Address), LMA(Load Memory Address), file offset 등의 정보를 확인할 수 있다.
  - `readelf -S` 명령과 동일한 결과를 출력한다.
- `objdump -d FILE_NAME`: object file 내용을 어셈블리어 형태로 출력한다.


### 리다이렉션
- 명령어 실행 시 발생하는 출력을 표준 출력/표준 에러가 아닌 다른 방향으로 전환하는 기법이다.
- `CMD1 > FILE_NAME`: 표준 출력을 리다이렉션, CMD1의 결과를 FILE_NAME에 저장한다.
  - `CMD1 1> FILE_NAME` 명령과 동일하다. 즉, `1>` 은 `>`로 대체 가능하다.
- `CMD1 2> FILE_NAME`: 표준 에러를 리다이렉션, CMD1에서 발생한 에러를 FILE_NAME에 저장한다.
- `CMD1 >> FILE_NAME`: 표준 출력을 리다이렉션, CMD1의 결과를 FILE_NAME에 저장하되, 기존 파일 뒤부터 이어서 쓴다.
- `CMD1 2> FILE_NAME_1 1> FILE_NAME_2`: CMD1의 표준에러와 표준출력을 FILE_NAME_1 과 FILE_NAME_2에 나누어 기록한다.
- `CMD1 > /dev/null`: 출력할 내용을 버린다. `dev/null` 로 리다이렉트 된 내용은 모두 버려진다.

## Metacharacter
- 리눅스 상에서 특정 역할을 수행하는 문자를 `Metacharacter`(메타문자) 라 한다.
- `$`: 쉘 환경변수 (`echo $PATH`: PATH 라는 환경변수를 화면에 출력)
- `&&`: 이전 명령 이후 다음 명령 수행(`mkdir A && cd A`: A 라는 디렉터리 생성 후 A 디렉터리로 이동)
- `;`: 명령어 구분자 (`mkdir A; cd A`: A 라는 디렉터리 생성, A 디렉터리로 이동)
- `|`: 명령어 파이프라이닝 (`find . -name hello | grep world`: 'hello' 라는 이름의 파일을 찾고, 출력된 항목들 중 'world' 가 포함된 라인만 다시 추출)
- `*`: 와일드카드 (`find . -name hello*`: 'hello*' 정규식에 일치하는 파일 찾기)
- 