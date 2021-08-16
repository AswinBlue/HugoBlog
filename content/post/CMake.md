+++
title = "CMake"
date = 2021-08-12T10:41:00+09:00
lastmod = 2021-08-12T10:41:00+09:00
tags = [ "cmake", "make", "c++", ]
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

# CMake
- C,C++ 언어 컴파일시 make 툴을 이용할 때, 규모가 큰 프로젝트에서 컴파일 의존성 관리를 쉽게 하기 위한 도구
## 명령어
- `cmake CMakeList.txt` : CMakeList.txt파일 안의 내용을 수행한다.
- `cmake .` : 파일 경로를 입력하면 해당 경로에서 CMakeList.txt파일을 찾아서 수행.
- `make` : cmake를 이용해 생성한 파일들을 이용해 make로 컴파일

  - cmake 명령 후 make를 이용해 컴파일을 수행하면 부산물들이 많이 생성된다. 이를 방지하기 위해 보통 새로운 폴더를 만들어 넣어서 사용한다.
  ```
  1. mkdir build
  2. vi CMakeList.txt 후 내용 작성
  3. cd build
  4. cmake ..
  5. make
  ```
-

## 문법
- `ADD_EXECUTABLE(main.exe main.cpp function.cpp)` : 실행파일 생성
-

## 참조
https://nowonbun.tistory.com/712


# make

## 명령어
- `make install` : 해당 경로의 소스를 컴파일하여 /usr/local/lib, /usr/local/bin 폴더로 .so파일과 .bin파일 복사
