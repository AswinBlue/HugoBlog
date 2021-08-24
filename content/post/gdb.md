+++
title = "GDB"
date = 2021-08-23T18:49:15+09:00
lastmod = 2021-08-23T18:49:15+09:00
tags = ["gdb", "c", "c++", "debug", ]
categories = ["dev"]
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
# GDB

## 컴파일
- 컴파일 옵션에 `-g` 를 붙여야 디버깅이 가능

## 시작
- `gdb [파일이름]`
- `gdb` 실행 후 `file [파일이름]`

## 디버깅 중 명령어

▷breakpoint
- b [라인] : 해당 라인에 breakpoint 설정
- b [함수명] : 해당 함수 시작점에 breakpoint 설정
- b [파일명]:[라인] : 특정 파일 해당 라인에 breakpoin (ex : `b test.cpp:10`)
- tb : 임시 중단점 설정, 일회성
- info b : breakpoint 확인
- delete : 모든 brekapoint 삭제
- delete [index] : 특정 breakpoint 삭제
- cl [라인] : 해당 라인의 brekapoint 삭제
- cl [함수] : 해당 함수의 breakpoint 삭제
- cl : 모든 breakpoint 삭제
- enable [index] : 해당 brekapoint 활성화
- disable [index] : 해당 breakpoint 비활성화
- condition [index] [조건] : 해당 breakpoint는 조건을 만족할 때에만 동작 (ex : `condition 2 var_a == 0`)

▷ 실행
- run 지정된 파일을 실행
- c : continue, 다음 breakpoint로 진행
- n [숫자]: next, 해당 숫자만큼 다음 라인으로 진행. 숫자 생략가능
- s [숫자]: step, 다음 라인이 함수라면 함수 내부로 이동. 해당 숫자만큼 진행. 숫자 생략 가능
- k : 실행중인 프로그램 종료

▷ 확인
- l : main을 기점으로 소스 출력
- l [라인] : 해당 라인을 기점으로 소스 출력
- l [함수] : 해당 함수를 기점으로 수스 출력
- info locals : 지역변수들 확인
- info variables : 전역변수 확인
- p [변수] : 변수 값 확인
- p *[배열]@[숫자] : 해당 숫자만큼 배열의 값 출력
- p [구조체] : 구조체 주소 확인
- p *[구조체] : 구조체 값 확인
 - p/t var : var 변수를 2진수로 출력
 - p/o var : var 변수를 8진수로 출력
 - p/d var : var 변수를 부호가 있는 10진수로 출력 (int)
 - p/u var : var 변수를 부호가 없는 10진수로 출력 (unsigned int)
 - p/x var : var 변수를 16진수로 출력
 - p/c var : var 변수를 최초 1바이트 값을 문자형으로 출력
 - p/f var : var 변수를 부동 소수점 값 형식으로 출력
 - p/a addr : addr주소와 가장 가까운 심볼의 오프셋을 출력
- info registers : 레지스트 값 모두 확인
- display [변수명]  : 변수 값을 매번 화면에 디스플레이
- display/[출력형식] [변수명] : 변수 값을 출력 형식으로 디스플레이
- undisplay [디스플레이번호] : 디스플레이 설정을 없앤다
- disable display [디스플레이번호] : 디스플레이를 일시 중단한다.
- enable display [디스플레이번호] : 디스플레이를 다시 활성화한다.

## 기타
- q : 종료
