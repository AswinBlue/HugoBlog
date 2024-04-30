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
### Format String
- format string 에서 변수에 매핑되는 문자
  - `%d` : 부호 있는 정수
  - `%ld` : 부호 있는 long 형 정수
  - `%lld` : 부호 있는 long long 형 정수
  - `%u` : 부호 없는 정수
  - `%lu` : 부호 없는 long 형 정수
  - `%llu` : 부호 없는 long long 형 정수
  - `%f` : 실수, 출력시 기본 소숫점 아래 6자리까지 처리
  - `%e` : 실수, 출력시 지수 표기법으로 표시('e' 소문자)
  - `%E` : 실수, 출력시 지수 표기법으로 표시('E' 대문자)
  - `%n` : 배열에서 사용된 인자 개수 저장
    - `printf("%s%n", "ABC", &num)` : "ABC" 출력, num 에 3 저장
  - `%s` : 문자열 출력
  - `%p` : 포인터 (void*)
- 문자 정렬에 사용되는 방식(예시)
  - `%-4d` : 4자리 이하는 공백으로 채우며, 좌측정렬
  - `%4d` : 4자리 이하는 공백으로 채우며, 우측정렬
  - `%04d` : 4자리 이하는 '0'으로 채우며, 우측정렬
  - `%.4f` : 소수점 이하 4자리 초과는 소수점 5번째 자리에서 반올림
  - `%010.4f` : '.' 포함 10자리 이하는 '0'으로 채우며, 소수점 이하 4자리 초과는 소수점 5번째 자리에서 반올림
  - `%-10s` : 문자열 출력시 10자리 이하는 공백으로 채우며, 좌측정렬
  - `%*d` : 정수형 변수 하나를 추가로 입력받아, 해당 변수의 값 만큼 자리 보장
    - `printf("%*d", num, 10);` : 10자리 이하는 공백으로 표시, 우측정렬
- 변수를 index로 지정
  - index로 변수를 지정하게 되면, 그 string format 안의 모든 변수들은 index로 참조되어야 하며, 같은 변수를 두번 이상 참조 할 수 있으며, 사용되지 않는 index 가 있다면 컴파일 타임에 에러가 난다. 
  - `%1$d`: 첫번째 index의 변수 참조
  - `%2$d`: 두번째 index의 변수 참조
  - `printf("%2$d, %1$d, %2$d", 1, 2);` : "2, 1, 2" 출력
  - `printf("%2$d, %2$d, %2$d", 1, 2);` : 컴파일 에러
  - `printf("%1$d", 1, 2);` : 컴파일 에러
  - `printf("%1$d, %d", 1, 2);` : 컴파일 에러

### printf
- `printf("%*d", width, value)` : value를 width글자 수만큼 앞에 공백을 두고 출력
- `printf("%0*d", width, value)` : value를 width글자 수만큼 앞에 0을 두고 출력
- printf의 버퍼가 출력되는 조건  
  1) 프로그램이 종료될 때
  2) 버퍼가 가득찬 경우
  3) 강제로 버퍼를 비우도록 명령받은 경우(ex: fflush)
  4) 버퍼에 개행문자가 들어온 경우

### sscanf
- `sscanf(base_buffer, "%64[^\n]", target_buffer)` : base_buffer에서 '\n'이 아닌 문자열 64개를 읽어와 target_buffer에 담는다. (정규식 사용)

### scanf
- `scanf("%s", buf)` 는 입력의 길이를 제한하지 않고 띄어쓰기, 탭, 개행문자가 올 때 까지 입력을 받는다. 
- `scanf("%[n]s", buf)` 를 사용하여 입력 갯수를 n개로 제한할 수 있다.