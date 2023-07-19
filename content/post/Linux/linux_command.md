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
## 리눅스 기본
- `stty -a`: 시그널 단축키들의 값 확인
- `strace FILE_NAME`: 실행파일이 실행되는 상세 과정을 라인별로 보여준다.


## sed
- 기본적인 기능은 ed에서 따 왔으며, 이 기능들은 모두 sed에 적용이 된다.
- ed는 대화형 편집기이며, sed는 스트리밍 편집기
- \n 을 개행문자로 사용하는 스트리밍 에디터

`sed [-e script][-f script-file][file...]`

### 찾기/출력
- `sed -n '/abd/p' list.txt : list.txt` : 파일을 한줄씩 읽으면서(-n : 읽은 것을 출력하지 않음) abd 문자를 찾으면 그 줄을 출력(p)한다.

### 치환
- `sed 's/addrass/address/' list.txt` : list.txt파일에서 addrass를 address로 바꾼다. 단, 원본파일을 바꾸지 않고 출력을 바꿔서 한다.
- `sed 's/□□*/□/' list.txt` : ( *표시: □ 는 공백 문자를 표시한다. ) 위의 구문은 한개이상의 공백문자열을 하나의 공백으로 바꾼다.

## 삭제
- `sed '/TD/d' list.txt` : TD 문자가 포함된 줄을 삭제하여 출력한다.
- `sed '/Src/!d' list.txt` : Src 문자가 있는 줄만 지우지 않는다.
- `sed '1,2d' list.txt` : 처음 1줄, 2줄을 지운다.
- `sed '/^$/d list.txt` : 공백라인을 삭제하는 명령이다

## 압축
압축과 해제는 `tar` 명령어로 수행 가능하다. 
 - `tar -xvf <FILE_NAME>` : 압축 해제
 - `tar -cvf <FILE_NAME>` : 압축


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
- `file FILE_NAME`: 파일이 어떤 종류의 내용을 담고 있는지(C language, text ...)를 확인할 수 있다.
- `readelf FILE_NAME`: ELF 파일의 meta data를 확인한다. 
  - ELF란 Executable and Linkable Format을 의미한다. (*.o 형태의 파일이다)
- `objdump -S FILE_NAME`: object file을 어셈블리 형태로 주소별로 출력 해주는 명령이다. 


### 리다이렉션
- `CMD1 > FILE_NAME` 표준 출력을 리다이렉션, 동작1의 결과를 FILE_NAME에 저장한다.
- `CMD1 2> FILE_NAME` 표준 에러를 리다이렉션, 동작1에서 발생한 에러를 FILE_NAME에 저장한다.
- `CMD1 >> FILE_NAME` 표준 출력을 리다이렉션, 동작1의 결과를 FILE_NAME에 저장하되, 기존 파일 뒤부터 이어서 쓴다.

## 참조
http://m.egloos.zum.com/slog2/v/3689816


