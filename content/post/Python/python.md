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

- `print()` 와 `sys.stdout.write()` 로 화면에 출력할 수 있다. 
  - `sys.stdout.write` 안에는 string 형태만 적용할 수 있다.
  - `print` 안에는 수식 등으로 string 및 byte를 표현 가능하다.
- `sys.stdout.buffer.write()` 를 사용하면 문자열을 수식을 통해 조합하고 ascii 코드 형태로 출력 가능하다.
  - print() 를 사용하면 prefix가 붙어서 원하는 형태를 표현하기 어렵다. 이럴 때 sys.stdout.buffer.write()를 사용한다.
  - ex)
      ```
        sys.stdout.write(b'A'*0x10 + b'B'*0x20 + b'\xaa\
        xbb\xcc\xdd\x00\x00\x00\x00')
        # 결과: AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB����
        sys.stdout.write(b'A'*0x10 + b'B'*0x20 + b'\xaa\
xbb\xcc\xdd\x00\x00\x00\x00')
        # 결과: b'AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\xaa\xbb\xcc\xdd\x00\x00\x00\x00'
      ```


#### Flush
  - print() 함수는 효율을 위해 버퍼에 내용을 채워놓고 있다가 버퍼가 일정량 채워지면 화면에 버퍼의 내용을 출력한다. 
  - print() 함수에는 bool 형태의 인자 `flush` 를 받을 수 있는데, flush를 True로 설정하면 버퍼가 찰 때 까지 대기하지 않고 바로 출력할 수 있다. 
    - ex) `print("print this immediately", flush=True)`
  - sys 모듈의 `sys.stdout.flush()` 함수를 사용하여 동일한 효과를 낼 수 있다.
  - python을 실행할 때, `-u` 옵션을 넣어서 실행하면 내부적으로 표준 출력이 모두 버퍼링 없이 즉시 flushing 된다. 


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

### 문자열
- 문자열 뒤에 `format()` 함수를 호출해서 문자열 안에 `{}` 를 변수로 치환할 수 있다. 
  - ex) `"sample text {} {}".format("var1", "var2")` 은 `sample text var1 var2` 으로 출력된다.

- `문자열.ljust(num, f)` : 문자열의 길이가 'num'이 될 때 까지 우측에 f 문자를 집어넣음
  - ex) "HELLO".ljust(10,'#') => HELLO#####
- `문자열.rjust(num, f)` : 문자열의 길이가 'num'이 될 때 까지 좌측에 f 문자를 집어넣음
  - ex) "HELLO".rjust(10,'#') => #####HELLO
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