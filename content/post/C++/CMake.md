---
title: "CMake 기본 문법과 크로스 플랫폼 빌드 스크립트 작성 가이드"
description: "CMakeLists.txt를 활용하여 C/C++ 프로젝트를 플랫폼 독립적으로 빌드하고 외부 라이브러리 종속성을 연결하는 핵심 작성법을 설명합니다."
slug: "cmake-basics-and-cross-platform-build"
date: 2021-08-12T10:41:00+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["C++"]
tags: ["cmake", "c++", "build-system", "cross-platform"]
ShowToc: true
TocOpen: true
---

## CMake 개요 및 빌드 절차

CMake는 C/C++ 프로젝트의 규모가 커짐에 따라 복잡해지는 컴파일 의존성 관리를 자동화하고, 크로스 플랫폼 빌드 파일(Makefile, Visual Studio 프로젝트 등)을 생성해 주는 메타 빌드 시스템이다.

### 기본 빌드 흐름
CMake를 실행하면 빌드 관련 중간 파일 및 캐시가 대량으로 생성되므로, 소스 코드 오염을 방지하기 위해 관례적으로 별도의 `build` 디렉터리를 생성하여 분리 빌드를 수행한다.

```bash
# 1. 빌드 디렉터리 생성 및 진입
mkdir build
cd build

# 2. 상위 디렉터리의 CMakeLists.txt를 참조하여 빌드 환경 구성
cmake ..

# 3. 생성된 Makefile을 기반으로 실제 컴파일 수행
make
```

- `cmake .`: 현재 경로에서 `CMakeLists.txt` 파일을 탐색하여 빌드 파일을 생성한다.
- `cmake <경로>`: 지정된 디렉터리의 `CMakeLists.txt`를 기반으로 환경을 설정한다.
- `make`: CMake가 생성한 Makefile을 사용하여 타깃 실행 파일 및 라이브러리를 빌드한다.

## CMakeLists.txt 핵심 문법

`CMakeLists.txt` 파일은 대소문자를 구분하지 않는 고유의 스크립트 문법을 따르며, 변수와 함수를 조합하여 빌드 파이프라인을 정의한다.

### 실행 파일 및 라이브러리 타깃 정의

- `add_executable(<target> <sources...>)`: 소스 파일들을 컴파일하여 실행 파일을 생성한다.
  ```cmake
  add_executable(main.exe main.cpp function.cpp)
  ```
  헤더 파일은 소스 파일의 인클루드 경로에 따라 자동으로 반영된다.

- `target`: 빌드의 최종 산출물(실행 파일 또는 라이브러리)을 의미한다. `add_executable()`, `add_library()`, `add_custom_target()` 함수로 타깃을 생성하고 속성을 제어한다.

- `add_subdirectory(<source_dir>)`: 하위 디렉터리를 빌드 트리에 추가한다. 해당 하위 디렉터리 내에도 독립된 `CMakeLists.txt`가 존재해야 한다.
  > `add_subdirectory`를 통해 서브모듈을 직접 포함한 경우에는 외부 패키지를 탐색하는 `find_package`를 사용할 필요가 없다.

- `add_dependencies(<target> <dependencies...>)`: 타깃 간의 빌드 선후 의존 관계를 정의한다. 디렉터리명이 아닌 `add_library` 또는 `add_executable`로 생성된 타깃 이름을 인자로 사용해야 한다.
  ```cmake
  add_dependencies(my_app my_shared_lib my_module)
  ```

### 메시지 출력 (message)

`message()` 함수를 사용하여 터미널에 상태 및 디버그 정보를 출력한다.

```cmake
message([MODE] "출력할 내용")
```

- 지원하는 로그 레벨(MODE):
  - `FATAL_ERROR`: 심각한 오류 발생 시 출력 후 CMake 실행 즉시 중단
  - `SEND_ERROR`: 오류 출력 후 처리는 계속하되 코드 생성 단계 생략
  - `WARNING`: 일반 경고 출력
  - `AUTHOR_WARNING`: 프로젝트 작성자용 경고 출력
  - `DEPRECATION`: 폐기 예정 기능 경고
  - `STATUS`: 사용자가 인지할 일반적인 진행 정보 출력 (출력 앞부분에 `--` 표시)
  - `VERBOSE`, `DEBUG`, `TRACE`: 상세 디버깅 메시지

- 변수 값 출력:
  `${VARIABLE}` 구문으로 변수를 참조하여 문자열과 결합한다.
  ```cmake
  message(STATUS "Build directory: ${PROJECT_BINARY_DIR}")
  ```

### 전처리기 매크로 정의 (add_definitions)

컴파일 시 전달할 전처리기 매크로 플래그를 등록한다.

```cmake
add_definitions(-DFOO -DBAR)
add_definitions(-DYOUR_DEFINITION=1 -DMY_DEFINITION="MY")
```
위 설정은 소스 코드 내에서 `#define YOUR_DEFINITION 1`, `#define MY_DEFINITION "MY"`를 선언한 것과 동일한 효과를 낸다.

## 참고 자료
- 공식 CMake 문서: https://cmake.org/documentation/
- Nowonbun 기술 블로그 CMake 가이드: https://nowonbun.tistory.com/712
