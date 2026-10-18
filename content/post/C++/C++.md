---
title: "C++ 핵심 문법과 객체 지향 프로그래밍(OOP) 기초 가이드"
description: "C++ 언어의 기본 문법부터 클래스 설계, 생성자와 소멸자, 상속과 다형성, 가상 함수 테이블(vtable)까지 객체 지향 프로그래밍의 핵심 개념을 정리합니다."
slug: "cpp-syntax-and-oop-fundamentals"
date: 2021-08-12T10:41:00+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["C++"]
tags: ["c++", "oop", "cpp-basics", "programming"]
ShowToc: true
TocOpen: true
---

## 전처리기 매크로 문법

### 매크로 상수 및 해제
- `#define MACRO 1`: `MACRO`의 값으로 1을 지정한다.
- `#undef MACRO`: 지정된 `MACRO`의 정의를 해제한다.

### 여러 줄 매크로 작성
역슬래시(`\`)를 사용하여 여러 줄로 정의할 수 있다.

```cpp
#define PRINT(X) printf("%d", X);\
  printf("%d", (X) + 1);\
  printf("%d", (X) + 2);
```

### 매크로 합성 (Token Concatenation)
`##` 연산자를 사용하여 두 토큰을 합성할 수 있다.

```cpp
#define A 1
#define B 1
#define C A##B // A##B -> 12로 합성
```

### 함수 형태 매크로 작성
일반 함수 호출문과의 일관성을 유지하고 제어문 내에서 의도치 않은 동작을 방지하기 위해 `do-while(0)` 패턴을 활용한다.

```cpp
// do-while(0) 구문을 사용하여 블록을 묶으면 세미콜론(;)을 붙여도 안전하게 동작한다.
#define FUNC(a, b) do { \
    a = b * 2;\
} while (0)
```

### 연산자 우선순위 주의사항
매크로 함수는 단순 텍스트 치환을 먼저 수행하므로 연산자 우선순위 문제를 방지하기 위해 인자와 식 전체를 괄호로 묶어야 한다.

```cpp
#define ADD1(a,b) a+b
#define ADD2(a,b) (a+b)
#define MULT(a,b) a*b
#define MULT2(a,b) (a)*(b)

printf("%d", ADD1(3,4) * 2); // 3 + 4 * 2 로 치환되어 11 출력 (예상값: (3 + 4) * 2 = 14)
// ADD2처럼 계산 결과를 괄호로 묶어야 안전하다.

printf("%d", MULT(2+2, 3+3)); // 2 + 2 * 3 + 3 로 치환되어 11 출력 (예상값: 4 * 6 = 24)
// MULT2처럼 각 인자를 괄호로 묶어야 안전하다.

// 결론: 인자와 결과식 전체를 모두 괄호로 감싸서 정의한다.
#define ADD3(a,b) ((a) + (b))
#define MULT3(a,b) ((a) * (b))
```

### 조건부 컴파일
`#if`, `#elif`, `#else`, `#endif`, `#ifdef`, `#ifndef` 등을 활용하며 논리 연산자(`!`, `&&`, `||`) 사용이 가능하다.

```cpp
#define MACRO
#define DEBUG 1

#ifdef MACRO // MACRO가 정의되어 있으면 컴파일 수행
#endif

#if DEBUG // DEBUG 평가식이 참이면 컴파일 수행
#endif
```

### 헤더 파일 중복 참조 방지
표준 라이브러리는 `<...>`, 현재 디렉터리 기준 파일은 `"..."`로 포함한다.

```cpp
#include <iostream> // 표준 라이브러리 참조
#include "my_header.h" // 현재 작업 경로 기준 파일 참조
```

1. **`#ifndef` 인클루드 가드 활용**:
```cpp
#ifndef __FILE_NAME_H__
#define __FILE_NAME_H__
// 헤더 파일 내용
#endif
```

2. **`#pragma once` 지시자 활용**:
```cpp
#pragma once // 컴파일러 레벨에서 단일 포함 보장
```

## 입출력 리다이렉션 (Redirection)

표준 입출력 스트림을 파일로 전환할 때 `freopen` 함수를 사용한다.

```cpp
// "in.txt" 파일을 표준 입력(stdin)으로 재설정
freopen("in.txt", "r", stdin);
```

## cin/cout 성능 최적화

`std::cin`과 `std::cout`은 기본적으로 C 표준 스트림(`stdio`)과의 동기화 및 flush 처리가 걸려 있어 `printf`/`scanf`에 비해 상대적으로 느리다. 아래 설정을 적용하여 입출력 속도를 대폭 향상시킬 수 있다.

```cpp
ios_base::sync_with_stdio(false);
cin.tie(NULL);
cout.tie(NULL);
```

> [!NOTE]
> `sync_with_stdio(false)` 적용 후에는 C 표준 입출력 함수(`printf`, `scanf`)와 C++ 스트림(`cin`, `cout`)을 혼용하면 출력 순서가 섞이므로 C++ 스트림만 단독으로 사용해야 한다.

## 표준 라이브러리 입출력 포맷팅

### 포맷 스트링 (Format String) 서식 지정자
- 변수 매핑 지정자:
  - `%d`: 부호 있는 32비트 정수
  - `%ld`: 부호 있는 `long`형 정수
  - `%lld`: 부호 있는 `long long`형 정수
  - `%u`: 부호 없는 정수 (`unsigned int`)
  - `%lu`: 부호 없는 `unsigned long`형 정수
  - `%llu`: 부호 없는 `unsigned long long`형 정수
  - `%f`: 부동소수점 실수 (기본 소수점 이하 6자리 출력)
  - `%e`, `%E`: 지수 표기법 실수 (`e` 소문자 / `E` 대문자)
  - `%n`: 현재까지 출력/파싱된 문자 수를 포인터 변수에 기록
    - `printf("%s%n", "ABC", &num);` -> `"ABC"` 출력 후 `num` 변수에 3 저장
  - `%s`: 널 종료 문자열
  - `%p`: 포인터 주소 (`void*`)

- 자릿수 정렬 및 패딩:
  - `%-4d`: 4자리 확보, 좌측 정렬, 빈 공간 공백 채움
  - `%4d`: 4자리 확보, 우측 정렬, 빈 공간 공백 채움
  - `%04d`: 4자리 확보, 우측 정렬, 빈 공간 `0` 채움
  - `%.4f`: 소수점 이하 4자리까지 출력 (5번째 자리에서 반올림)
  - `%010.4f`: 소수점 포함 전체 10자리 확보, 앞자리는 `0`으로 채우고 소수점 이하는 4자리 출력
  - `%-10s`: 10자리 확보, 좌측 정렬 문자열 출력
  - `%*d`: 인자로 폭(width)을 전달받아 동적으로 자릿수 지정
    - `printf("%*d", 10, num);` -> 10자리 폭 확보 후 우측 정렬 출력

- 인덱스 기반 인자 참조:
  - POSIX 표준에서는 `%[index]$d` 형태로 인자 순서를 명시적으로 지정할 수 있다.
  - `%1$d`: 첫 번째 인자 참조
  - `%2$d`: 두 번째 인자 참조
  - `printf("%2$d, %1$d, %2$d", 1, 2);` -> `"2, 1, 2"` 출력
  - 인덱스 서식을 사용할 때는 동일 포맷 스트링 내의 모든 인자가 인덱스 방식으로 참조되어야 하며 사용되지 않는 인덱스가 있으면 컴파일 경고 또는 에러가 발생한다.

### printf 버퍼 플러시 동작 원리
`printf`의 내부 버퍼가 실제로 화면이나 파일로 비워지는(flush) 조건은 다음과 같다.
1. 프로그램이 정상적으로 종료될 때
2. 내부 출력 버퍼가 가득 찬 경우
3. `fflush(stdout)` 등으로 강제 비우기를 호출한 경우
4. 줄바꿈 문자(`\n`)가 입력 스트림에 도달한 경우 (라인 버퍼링 환경)

### sscanf 활용
정규 표현식 유사 패턴을 사용하여 버퍼 문자열을 파싱할 수 있다.

```cpp
// base_buffer에서 개행('\n')이 아닌 문자열 최대 64글자를 읽어 target_buffer에 복사
sscanf(base_buffer, "%64[^\n]", target_buffer);
```

### scanf 입력 제어
- `scanf("%s", buf)`: 공백, 탭, 개행 문자를 만날 때까지 길이에 제한 없이 입력받으므로 버퍼 오버플로우 위험이 존재한다.
- `scanf("%64s", buf)`: 입력 글자 수를 최대 64자로 제한하여 버퍼 오버플로우를 방지한다.
- `scanf("%[^\n]", buf)`: 줄바꿈 문자(`\n`) 직전까지 공백을 포함하여 전체 라인을 읽는다.
- `scanf("%[^\n]%*c", buf)`: 줄바꿈 문자 직전까지 읽어 `buf`에 저장하고, 버퍼에 남은 줄바꿈 문자(`\n`)는 `%*c`를 통해 버퍼에서 읽어 폐기한다.
