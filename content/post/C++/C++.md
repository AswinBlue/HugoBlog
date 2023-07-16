+++
title = "C++ basic"
date = 2021-08-12T10:41:00+09:00
lastmod = 2021-08-12T10:41:00+09:00
tags = ["c++", "basic",]
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

# C++ basics
## 매크로
- `#define MACRO 1` : MACRO 값으로 1을 지정
- `#undef MACRO` : MACRO값에 지정된 내용 해제
- 여러줄의 매크로 값 지정 :
```
#define PRINT(X) printf("%d", X);\
  printf("%d", (X) + 1);\
  printf("%d", (X) + 2);
```
- 매크로 합성 :
```
#define A 1
#define B 1
#define C A##B // A##B = 12
```
- 함수형태 매크로 작성 :
```
// 일반함수에는 ';' 를 붙이지만 매크로 함수에는 ';'를 붙일 필요가 없다.
// 일관성을 갖기 위해 do-while문 안에 작성하면 매크로 함수에도 ';'를 붙이도록 할 수 있다.
#define FUNC(a, b) do { \
    a = b * 2;\
} while (0)
```
- 연산자 우선순 :
```
// 매크로 함수는 계산 전 치환을 먼저 수행한다. 연산자 우선순위에 주의한다.
#define ADD1(a,b) a+b
#define ADD2(a,b) (a+b)
#define MULT(a,b) a*b
#define MULT2(a,b) (a)*(b)
...
printf("%d",ADD1(3,4) * 2) // 예상값 (3 + 4) * 2 = 14
// 3 + 4 * 2 로 치환하여 계산되어 실제 결과는 11
// ADD2 처럼 계산 결과를 괄호로 묶어야 안전하다.

printf("%d",MULT(2+2,3+3)) // 예상값 (4 * 6) * 2 = 26
// (2 + 2 * 3 + 3) 로 치환하여 계산되어 실제 결과는 11
// MULT2 처럼 각 변수를 괄호로 묶어야 안전하다.

// ADD1, MULT2 경우를 종합하여 아래와 같이 사용하자
#define ADD3(a,b) ((a) + (b))
#define MULT3(a,b) ((a) * (b))
```

- 조건부 컴파일
  - if-elif-else 사용 가능
  - 조건에 !, && || 논리연산 가능
```
#define MACRO
#define DEBUG 1

#ifdef MACRO // 정의가 되어있으면 수행
#endif

#if DEBUG // DEBUG가 나타내는 값 또는 식이 참이면 수행
#endif
```

- 파일 포함
```
#include <FILE_NAME> // 표준라이브러리에서 파일 참조
#include "FILE_NAME" // 현재 경로 기준 파일 참조
```
→ [_활용_]: 헤더파일 중복 참조 방지법
1) #ifndef 사용
```
#ifndef __FILE_NAME_H__
#define __FILE_NAME_H__
// 헤더파일 내용
#endif
```
2) pragma once 사용
```
#pragma once // 일부 컴파일러에서만 지원
```

## 입출력 redirection
1. 입력 재설정
  - `freopen("in.txt", "r", stdin);` : 'in.txt' 파일을 표준입력 대신 사용

## cin cout
1. 속도 향상
  - cin, cout을 사용하면 printf, scanf보다 속도가 느리다.
  - 아래 코드로 세팅을 해 주면 출력 속도가 빨라진다. 하지만 printf, scanf와 함께 사용하면 순서가 섞이게 되니 설정 후에는 cin, cout만 사용하여야 한다.

  ```
  ios_base :: sync_with_stdio(false);
  cin.tie(NULL);
  cout.tie(NULL);
  ```

## std library
### printf
- `printf("%*d", width, value)` : value를 width글자 수만큼 앞에 공백을 두고 출력
- `printf("%0*d", width, value)` : value를 width글자 수만큼 앞에 0을 두고 출력