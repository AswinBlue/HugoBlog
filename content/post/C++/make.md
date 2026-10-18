---
title: "GNU Make 기본 사용법과 Makefile 문법 및 내장 매크로 정리"
date: 2023-07-13 18:35:05+09:00
lastmod: 2023-07-13 18:35:05+09:00
description: "C/C++ 대규모 프로젝트의 분할 컴파일과 빌드 자동화를 지원하는 GNU Make의 기본 동작 원리와 Makefile 타깃·의존성 구조, 변수 치환, 내장 자동 매크로($<, $@, $^) 및 실행 옵션을 상세히 정리합니다."
slug: "gnu-make-makefile-syntax-and-macros"
categories:
  - "C++"
tags:
  - "c++"
  - "c"
  - "make"
  - "makefile"
  - "build-system"
ShowToc: true
TocOpen: true
draft: false
---

## GNU Make 개요 및 동작 원리

GNU Make는 여러 소스 파일로 구성된 C/C++ 프로젝트의 분할 컴파일(Separate Compilation)을 자동화하고 빌드 효율을 극대화해 주는 빌드 도구이다.

- **증분 빌드(Incremental Build)**:
  소스 파일이 수정되었을 때 전체를 다시 컴파일하지 않고, 수정된 파일 및 이에 의존하는 파일들만 선별적으로 재컴파일한다.
- **수정 시간(Timestamp) 비교**:
  타깃 파일(Target)의 최종 생성 시간과 의존 파일(Dependencies)의 최종 수정 시간을 비교하여, 의존 파일의 시간이 더 최신일 때만 갱신 명령(Commands)을 실행하는 방식으로 동작한다.

## Makefile 기본 구조

Make는 실행 시 현재 디렉터리의 `Makefile`이라는 이름의 설정 파일을 기본적으로 탐색한다.

```makefile
TARGET: DEPENDENCIES
	COMMANDS
```

- **주의사항**: `COMMANDS` 라인의 앞머리는 반드시 **Tab 문자**여야 하며 일반 공백(Space)을 사용하면 문법 오류가 발생한다.
- `TARGET`: 명령어를 통해 최종적으로 생성할 목적물(실행 파일, 오브젝트 파일 등) 또는 가상 타깃이다.
- `DEPENDENCIES`: 타깃을 생성하기 위해 필요한 소스 파일이나 오브젝트 파일들의 목록이다.
- `COMMANDS`: 타깃을 생성하기 위해 쉘에서 실행할 명령어이다.
- `@COMMANDS`: 명령어 앞에 `@`를 붙이면 쉘이 명령문 원문을 터미널에 에코하지 않고 실행 결과만 출력한다.
- `#`: 주석 기호로 라인 단위 주석을 작성한다.

```makefile
# clean 가상 타깃 예시
clean:
	rm -f $(OBJ) $(TARGET)
```

### 변수 정의 및 문자열 치환

- `VARIABLE = VALUE`: 재귀적 확장 변수 (호출되는 시점의 최종 값으로 치환)
- `VARIABLE := VALUE`: 단순 확장 변수 (선언되는 즉시 값이 평가되어 확정)
- `VARIABLE += VALUE`: 기존 변수 값 뒤에 공백과 함께 추가 문자열 연결
- `$(VARIABLE)` 또는 `${VARIABLE}`: 변수 값 참조

```makefile
# 컴파일러 및 플래그를 변수화하여 유지보수성 확보
CC = gcc
CFLAGS = -Wall -O2 -I./include
LDFLAGS = -L./lib -lmylib
PROJECT_NAME = myProject

# 문자열 치환: ${VARIABLE:ASIS=TOBE}
SRCS = main.c func.c
OBJS = $(SRCS:.c=.o) # main.o func.o 로 치환됨
```

### 내장 매크로 및 패턴 규칙

반복적인 컴파일 룰을 단순화하기 위해 Make에서 제공하는 자동 내장 매크로(Automatic Variables)를 활용한다.

- `$<`: 현재 룰의 의존성 파일(Dependencies) 목록 중 첫 번째 파일
- `$^`: 현재 룰의 모든 의존성 파일 목록 (공백으로 구분)
- `$@`: 현재 타깃(Target)의 이름
- `$*`: 접미사(확장자)가 제외된 타깃의 이름
- `$?`: 타깃보다 최신으로 갱신된 의존 파일 목록

### 패턴 규칙(Pattern Rule) 예시
`.c` 소스 파일들로부터 동명의 `.o` 오브젝트 파일을 생성하는 빌드 룰을 일반화할 수 있다.

```makefile
CC = gcc
CFLAGS = -Wall -c
TARGET = a.out
OBJ = main.o func1.o

# 타깃 빌드: $^ 는 main.o func1.o, $@ 는 a.out
$(TARGET): $(OBJ)
	$(CC) $^ -o $@

# 패턴 룰: 모든 .o 파일은 동명의 .c 파일을 컴파일하여 생성
%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
```

## Make 명령어 실행 옵션

- `make`: 현재 디렉터리의 Makefile에서 첫 번째 타깃을 기본으로 빌드 실행
- `make <타깃명>`: 특정 타깃만 명시적으로 실행 (예: `make clean`, `make install`)
- `make -f <파일명>`: 기본 `Makefile` 대신 지정한 파일을 빌드 설정 파일로 사용
- `make -j <N>`: N개의 작업을 병렬로 동시 수행하여 멀티코어 컴파일 가속
- `make -p`: Make에 내장된 기본 규칙 및 정의된 모든 매크로 데이터베이스 출력
