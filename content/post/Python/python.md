+++
title = "Python"
date = 2021-09-01T18:49:18+09:00
lastmod = 2021-09-01T18:49:18+09:00
tags = ['python',]
categories = ['dev',]
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = false
+++

# Python

## 기본 내장 함수

### 입력
한줄 받기 : `a = input()`
 - 받은 값은 string 형태이다.  
받은 단어 끊어서 해석 : `a, b = input().split()`
 - split() 함수 안의 인자에 따라 구분자 설정 가능. 빈칸이면 공백을 기준으로 끊어줌  
받은 단어 끊고 숫자로 변환 : `a, b = map(int, input().split())`
 - int 외 다른 형태도 사용 가능  

### 출력
print()

### 함수
함수 인자로 배열 형태를 표현할 때 *를 붙인다.
```
def func1(*arg)
    print(*arg)

func1(1, 2, 3) # 출력: [1, 2, 3]
```

### 숫자
읽기쉬운 숫자 표기: `x = 10000` vs `x = 10_000`
 - 숫자 정의할 때 `_`를 중간에 넣어도 python은 숫자만 골라서 해석한다.  

### 배열
오름차순 정렬: `list.sort()`  
튜플 두번째 인자 기준 오름차순 정렬: `list.sort(key=lambda x:x[1])`  
내림차순 정렬 : `list.sort(reverse=True)`

## 라이브러리
### numpy
기본 구문
- `where(조건, 값1, 값2)`: 조건문이 참이면 값1, 거짓이면 값2를 반환. 3항연산자와 동일  

### bisect 
오름차순으로 정렬된 배열에서 lower-bound, upper-bound 를 찾는 함수
`bisect_left(list, x, key)` : lower bound (x보다 같거나 큰 수들 중 최좌측 값의 위치)  
`bisect_right(list, x, key)` : upper bound (x보다 같거나 작은 수들 중 최우측 값의 위치)  
 - 또는 lower bound (lower bound 를 찾았는데 동일 값이 존재할 경우 최우측 값의 위치)  
`bisect(list, x, key)` : bisect_right와 동일

tueple 적용 방법 : 
`bisect(list_of_tuples, (3, None))` 형태로 사용하면 된다. 두 번째 인자에 튜플 형태를 넣어주면 됨.
https://stackoverflow.com/questions/20908047/using-bisect-in-a-list-of-tuples