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
- GNU Debugger의 약자
- 유닉스의 디버거는 오픈소스가 아니라 GNU에서 새로 개발한 디버거

## 컴파일
- gcc로 컴파일시 옵션에 `-g` 를 붙여야 소스를 보면서 디버깅이 가능

## gdb 옵션
- `gdb [파일이름]` : 해당 파일이름 디버깅 실행
- `--args [arg1] [arg2] [...]` : 파일 실행에 필요한 argument를 전달
## 기타 명령어
### coredumb 파일 생성
- 프로그램이 비정상적으로 종료될 때 메모리의 현재 상황을 블랙박스처럼 남기는 coredump 파일이 생성된다.다만, coredump 파일 생성에는 사전에 설정이 필요하다. 
- 리눅스 프롬프트에서 `ulimit -a` 명령을 입력 해 보면 각종 파일들의 크기 설정을 볼 수 있다. 이때 `core file size` 가 보통 0으로 설정되어 있다. 
- `ulimit -c unlimited` 로 설정하면 coredump 파일의 크기가 최대로 설정된다.
- 이후에는 프로그램 실행 중 비정상적으로 종료가 되면 `core` 라는 이름의 파일이 생성된다. 
- gdb에서 core파일을 사용하여 디버깅을 할 수 있다. 디버깅 심벌이 있는 실행파일과, core파일이 있다면, `gdb 실행파일 core` 라고 입력 해 주면 gdb는 프로그램이 죽기 직후 까지 동작을 수행하고 break 한다. 
  - 이때 `bt` 명령으로 stack을 확인할 수도 있다.
## 디버깅 중 명령어
### breakpoint
- `b <라인>` : 해당 라인에 breakpoint 설정 (break와 동일)
- `b <함수명>` : 해당 함수 시작점에 breakpoint 설정
- `b <파일명>:<라인>` : 특정 파일 해당 라인에 breakpoint (ex : `b test.cpp:10`)
- `b <라인> <조건문>` : 특정 조건일 때 해당 라인에 breakpoint 작동 (ex: `break 25 if x==0` x가 0일때만 25번 라인에서 break)
- `tb` : 임시 중단점 설정, 일회성
- `w <변수>` : 조사식에 해당 변수 추가하고, 실행 중 조사식에 담긴 변수들의 값이 변할 때 마다 자동으로 break (watch와 동일)
  - 로컬 변수는 해당 변수를 확인할 수 있는 scope에 들어가서 지정할 수 있다.
- `i b` : breakpoint 모두 확인 (info breakpoint 와 동일) 
- `d` : 모든 brekapoint 삭제 (delete와 동일)
- `d [index]` : 특정 breakpoint 삭제
- `cl [라인]` : 해당 라인의 brekapoint 삭제
- `cl [함수]` : 해당 함수의 breakpoint 삭제
- `cl` : 모든 breakpoint 삭제
- `enable [index]` : 해당 brekapoint 활성화
- `disable [index]` : 해당 breakpoint 비활성화
- `condition [index] [조건]` : 해당 breakpoint는 조건을 만족할 때에만 동작 (ex : `condition 2 var_a == 0`)

### 실행
- `file [파일이름]` : 해당 파일 이름 디버깅 실행
- `r [arg1] [arg2] [...]`: 지정된 파일을 argument와 함께 실행 (run과 동일)
- `c` : 다음 breakpoint로 진행 (continue 와 동일)
- `n [숫자]` : 해당 숫자만큼 다음 라인으로 진행. 숫자 생략가능 (next와 동일)
- `s [숫자]` : 다음 라인이 함수라면 함수 내부로 이동. 해당 숫자만큼 진행. 숫자 생략 가능 (step 과 동일)
- `k` : 실행중인 프로그램 종료
- `set <변수>=<값>` : 특정 변수에 강제로 값을 집어넣음
- `set {타입}<주소>=<값>` : 특정 타입의 값을 해당 주소에 집어넣음 (ex: `set {int} 0x123456 = 10` : 0x123456 주소에 10이라는 int값 주입)

### 확인
- `l` : main을 기점으로 소스 출력 (list와 동일)
- `l [라인]` : 해당 라인을 기점으로 소스 출력
- `l [함수]` : 해당 함수를 기점으로 소스 출력
- `info locals` : 지역변수들 확인
- `info variables` : 전역변수 확인
- `p [변수]` : 변수 값 확인
- `p *[배열]@[숫자]` : 해당 숫자만큼 배열의 값 출력
- `p [구조체]` : 구조체 주소 확인
- `p *[구조체]` : 구조체 전체 값 확인
- `p *[구조체].인자` : 구조체 인자 값 확인 (ex: `p *s1.name` : s1 구조체의 name필드 값 확인)
  - linked list 는 포인터를 계속 참조할 수 있음 (ex: `p s1.next->next->next->name`)
- `p <함수>` : 함수 실행 결과를 확인
 - `p/t var` : var 변수를 2진수로 출력
 - `p/o var` : var 변수를 8진수로 출력
 - `p/d var` : var 변수를 부호가 있는 10진수로 출력 (int)
 - `p/u var` : var 변수를 부호가 없는 10진수로 출력 (unsigned int)
 - `p/x var` : var 변수를 16진수로 출력
 - `p/c var` : var 변수를 최초 1바이트 값을 문자형으로 출력
 - `p/f var` : var 변수를 부동 소수점 값 형식으로 출력
 - `p/a addr` : addr주소와 가장 가까운 심볼의 오프셋을 출력
- `x <메모리주소>` : 메모리값 확인
  - `x $pc` : program counter (다음 실행할 명령어 번지) 확인
  - x 뒤에 '/' 를 입력하여 옵션을 추가 할 수 있다.
    - `/o` : 8진법으로 표시
    - `/x` : 16진법으로 표시
    - `/u` : 10진법으로 표시
    - `/t` : 2진법으로 표시
    - `/b` : 1 byte 단위로 표시(byte)
    - `/h` : 2 byte 단위로 표시(half word)
    - `/w`: 4 byte 단위로 표시(word) 
    - `/g` : 8 byte 단위로 표시(giant)
    - `/i` : 역어셈블된 기계여 표시
    - `/c` : ASCII 표의 바이트 표시
    - `/s` : 문자 데이터의 전체 문자열을 표시.
    - `x/4wx` : 주소값부터 다음 네 개의 주소를 4byte씩 16진수로 표시
- `i r` : 레지스트 값 모두 확인 (info registers 와 동일)
- `bt` : 프로그램 중단시 최종 스택 프레임을 출력 (backtrace와 동일)
- `display [변수명]`  : 변수 값을 매번 화면에 디스플레이
- `display/[출력형식] [변수명]` : 변수 값을 출력 형식으로 디스플레이
- `undisplay [디스플레이번호]` : 디스플레이 설정을 없앤다
- `disable display [디스플레이번호]` : 디스플레이를 일시 중단한다.
- `enable display [디스플레이번호]` : 디스플레이를 다시 활성화한다.
- `f [인덱스]` : stack frame에서 인덱스에 해당하는 함수로 포커스를 변경한다. 0번이 가장 최근에 호출된 함수이며, 인덱스를 생략하면 0번 함수가 선택된다. (frame 과 동일)`
  - 포커스를 변경한다는 말은, 해당 함수 stack 내부에 선언된 로컬 변수 등을 참조할 수 있다는 뜻이다. 

### 기타
- q : 종료
