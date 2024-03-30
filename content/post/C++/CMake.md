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
- Cmake란 : C,C++ 언어 컴파일시 make 툴을 이용할 때, 규모가 큰 프로젝트에서 컴파일 의존성 관리를 쉽게 하기 위한 도구

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
  - CmakeLists.txt 작성은 쉘 프로그래밍과 유사하다. cmake 문법을 사용하여 작성해 주면 된다. 미리 지정된 변수들도 있는데, 해당 변수들에 주의하며 작성한다.

## 문법

### 빌드 설정
- `ADD_EXECUTABLE` : 실행파일 생성
ex) ``ADD_EXECUTABLE(main.exe main.cpp function.cpp)`` : main.cpp와 function.cpp를 사용해 main.exe를 생성한다. 헤더 파일은 자동으로 적용된다.

- `TARGET` : 목표 생성물, 생성할 실행 파일을 의미한다. `add_executable()`, `add_library()`, `add_custom_target()` 등의 함수로 수정 가능하다.

- `add_subdirectory` : 하위 디렉터리를 빌드 환경에 추가한다.
 - `add_subdirectory`를 사용한 경우 find_package를 사용하지 않는다.

- `add_dependencies` : subdirectory 이름을 사용하지 않고, add_library 혹은 add_executable로 생성한 이름을 첫번째 인자로 사용해야 한다.   
ex) ``add_dependencies(<생성한 객체이름> <모듈1> <모듈2> ...)``   

### 출력
- `message(MODE MESSAGE)` : 로그레벨 `MODE` 로 MESSAGE를 출력한다. 
  - MODE는 아래 값을 가질 수 있다.
    - FATAL_ERROR
    - SEND_ERROR
    - WARNING
    - AUTHOR_WARNING
    - DEPRECATION
    - STATUS
    - VERBOSE
    - DEBUG
    - TRACE
  - MESSAGE에 변수를 출력할 땐 `${VARIABLE}` 형태를 대입한다.
    - ex) `message(STATUS ${directories})`
    - 여러 문자열과 변수를 합하여서 사용도 가능하다.
      - ex) `message(STATUS "your directory : ${directories}")`

### Define
- `add_definitions(-DFOO -DBAR ...)` 형태로 
  - ex) `add_definitions(-DYOUR_DEFINITION=1 -DMY_DEFINITION="MY")` : `#define YOUR_DEFINITION 1`, `#define MY_DEFINITION "MY"` 두 라인을 수행한 것과 같은 효과를 가진다.
## 참조
https://nowonbun.tistory.com/712
