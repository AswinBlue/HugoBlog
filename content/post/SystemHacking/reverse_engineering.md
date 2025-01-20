---
title: "Reverse Engineering"
date: 2024-05-12T14:42:07+09:00
lastmod: 2024-05-12T14:42:07+09:00
tags: ["C", "hacking",]
categories: ["dev", "hacking",]
imgs:  []
cover:  ""  # image show on top
readingTime:  true  # show reading time after article date
toc:  true
comments:  false
justify:  false  # text-align: justify;
single:  false  # display as a single page, hide navigation on bottom, like as about page.
license:  "BY-SA"  # CC License, https://creativecommons.org/licenses/?lang=ko
draft: false
---

# Reverse Engineering

- software 를 분석하여 소스코드를 역으로 생성 해 내는 기법

## software 분석 방법
### Static analysis
- 프로그램을 실행시키지 않고 수행하는 분석이다.
- 프로그램의 전체 구조를 파악하기 쉬우며, 환경적 제약 사항에 자유롭고, 악성 코드의 위협으로부터 안전하다.
- 난독화 적용시 분석이 어려워 진다는 단점이 있다.

- 정적분석에 사용되는 툴로는 `IDA` 가 있다.
  - `IDA` 는 프리웨어로 https://hex-rays.com/ida-free/ 에서 다운 가능하다.
### Dynamic analysis
- 프로그램을 실행시키며 수행하는 분석이다.
- 프로그램의 개략적인 동작을 빠르게 확인 할 수 있다.
- 정적 분석과 반대로 프로그램 실행에 필요한 환경 구성이 어려울 수 있다.
- 안티 디버깅 기법 적용된 프로그램은 디버깅이 불가능하다.


# IDA
- 리버스 엔지니어링 툴
 
## 단축어
1. shift + F12
   - 문자열 검색, String 탭으로 이동
2. `x`
   - 상호참조 확인, 변수 또는 함수가 사용되는 곳의 위치를 확인
3. F5
   - 어셈블리를 C 언어 형태로 변환
4. `g`
   - 특정 주소 혹은 라인으로 이동
   - 디컴파일 된 함수 이름 위에 커서를 놓고 g 를 누르면 어셈블리 상 함수 라인을 확인할 수 있다.
   - 함수 이름을 적어도 함수 위치로 이동된다.
5. ESC
   - 이전 커서 위치로 이동
6. Ctrl + Enter
   - 다음 커서 위치로 이동
7. `n`
   - 변수 이름 바꾸기
8. `Y`
   - 변수 타입 설정
   - 함수 매개변수 변경, 함수 매개변수 타입 변경
9. F2
   - 어셈블리 혹은 C 언어 라인에서는 break point(중단점) 설정
   - stack 또는 hex View 에서는 값 변경
10. F9
   - 실행 (run)
   - 프로그램을 실행시켜 동적 분석을 수행할 수 있다.
11. F8
   - 한 단계 실행 (next)
12. F7
   - 함수 내부로 진입 (step int)
13. Ctrl + F2 
   - 디버깅 중단
14. `r`
   - hex 데이터를 문자로 변환
15. Shift + E
   - 선택한 값을 원하는 형태로 변환하여 추출(export)
   - hex 데이터를 문자열로 추출할 때 유용하다.
## 화면
1. IDA View
   - 어셈블리 코드, 디컴파일 결과, Hex-View, 구조체 목록 등 필요에 따른 화면 표시
2. Stack of main
   - main 함수의 stack
3. String
   - 코드 내 검색되는 모든 문자열 표시 화면
   - 문자열 더블클릭 시 assembly code view로 이동
 
4. Functions
   - 코드 내 인식되는 함수들 표기
   - Ctrl + F 로 검색 가능
5. Graph overview
   - `IDA View` 가 그래프로 표시된 경우, 전체 그래프 중 `IDA View` 에 표시된 화면 표기

 
## 함수 분석
- `_stdio_common_vfprintf()` : printf 함수 출력시 호출되는 함수이다. 
- `_stdio_common_vfscanf()` : scanf 함수  출력시 호출되는 함수이다.
- `__ROL1__(TARGET, NUM)` : TARGET (숫자)을 좌측으로 NUM 번 shift 시키고, 8bit 비트 위로 밀려난 좌측 인자들을 오른쪽 빈자리에 다시 집어넣는 함수
  - reversing code
    ```
	def rol1(v, s):
        v = (v << s) | (v >> (8 - s))  # bit shift & push back
	    return v & 0xff  # 8bit 영역만 사용
    ```
- `__popcnt(NUM)` : NUM 을 2진수로 변경했을 때 1의 갯수를 반환
  - reversing code
    ```
	def popcnt(v):
        return bin(v).count('1')
	```
- `__ROR1__(TARGET, NUM)` : TARGET (숫자)을 우측으로 NUM 번 shift 시키고, 8bit 비트 위로 밀려난 우측 인자들을 왼쪽 빈자리에 다시 집어넣는 함수
  - reversing code
    ```
    def ror(value, count) :
        tmp1 = value >> count
        tmp2 = value << (8 - count)
        return((tmp1 + tmp2) % 2**8)
    ```
- `MEMORY[]` : 메모리 주소에 담긴 값을 나타냄
  - `MEMORY[0xDEADBEEF000]` 은 0xDEADBEEF000 번지 주소의 값을 반환함
### WinAPI 관련 함수
- API 관련 문서는 [MSDN 링크](https://learn.microsoft.com/en-us/windows/win32/api/) 에서 찾아볼 수 있다.
- `__stdcall WinMain` : GUI 실행시 가장 먼저 호출되는 함수
- `RegisterClassExW(v11)` : 윈도우 클래스 등록하는 함수
  - 인자로 들어가는 "v11" 변수는 윈도우 클래스이다.
  - `lpfnWndProc` : 윈도우의 메시지 콜백 함수로, 개발자가 의도한 윈도우의 business logic은 주로 이 함수 안에서 정의되어 있다.
 
## 함수 수정
- assembly 코드 화면에서 메뉴 -> edit -> patch program -> assemble 메뉴를 클릭하면 해당 라인의 어셈블리를 변경할 수 있다.
- 변경 이후에는 다시 메뉴 -> edit -> -> patch program -> apply patch to input file 을 선택하면 패치가 적용된다.
 
---
 
# Ghidra
- NASA에서 사용하는 리버스 엔지니어링 툴로, 오픈소스로 공개되어 있다.
- jdk를 사용하고 [github](https://github.com/NationalSecurityAgency/ghidra/releases?page=2) 에서 다운로드 가능하다.
- 다양한 도구들을 내장하고 있으며, GUI도 지원이 가능하다.
 
## 구성요소
1. Code Browser
   - Ghidra 에 내장된 도구로, 다음 기능이 가능하다. 
     - 디스어셈블: 분석 대상 프로그램의 기계어를 역으로 어셈블하여 어셈블리 언어 형태의 코드로 보여줍니다.
     - 디컴파일: 디스어셈블 결과를 C언어 형태로 디컴파일하여 사람이 이해하기 쉬운 코드로 변환하여 보여줍니다.
     - 코드 자동 분석: 프로그램 내에 존재하는 함수들을 자동으로 식별하고, 변수의 타입을 추론합니다.
     - 코드 시각화: 제어 흐름 그래프(Control Flow Graph)로 코드의 흐름을 시각적으로 표현하여 코드의 복잡한 구조를 비교적 쉽게 파악할 수 있습니다.
     - 스크립팅: 사용자가 자신의 요구에 맞게 분석 프로세스를 스크립트로 작성하고 실행할 수 있습니다.
     - 심볼 정보 수정
     - 주석 기능
     - 프로그램 흐름 시각화(Graph View)
   - [단축키 참조](https://ghidra-sre.org/CheatSheet.html)
   
   1. 디컴파일 창(Decompile)
      - C언어 형태로 디컴파일된 코드를 볼 수 있습니다. 디스어셈블 리스팅(2번 윈도우)에서 어셈블리 명령어를 클릭하면 해당 부분을 디컴파일하여 디컴파일 윈도우에서 보여줍니다.
      - 함수를 자동으로 추정하여 아래 정보를 추출 해 냄 (추정한 정보이기 때문에 부정확할 수 있음, pointer 타입이 long 타입으로 지정될 수 있다)
	    - 함수 호출 규약
		- 반환 타입
		- 함수 이름
		- 파라미터 타입과 이름
      - 함수 이름에 마우스 우클릭 -> `Edit Function Signature` 을 선택하여 함수 정보를 수정할 수 있음
	  - 변수에 우클릭 -> `Rename Variable` 선택하여 변수 이름 수정 가능
	  - 변수에 오클릭 -> `Retype Variable` 선택하여 변수 타입 수정 가능
	  - 공간에 우클릭 -> Comments -> `Set Pre Comment` 로 주석 작성 가능
	  - 공간에 우클릭 -> `Bookmark`로 북마크 설정 가능
	    - 메뉴 -> Windows -> Bookmark 로 새로운 창 띄워서 설정한 bookmark list 확인 가능
   2. 디스어셈블 리스팅(Listing)
      - 디스어셈블된 코드를 볼 수 있습니다. 디컴파일 창(1번 윈도우)에서 원하는 부분을 클릭하면 해당 부분을 디스어셈블 리스팅에서 보여줍니다.
   3. 심볼 트리(Symbol Tree)
      - 프로그램에 존재하는 심볼들(함수 이름)을 볼 수 있습니다. 원하는 심볼을 더블클릭하면 디스어셈블 리스팅이 해당 위치로 이동합니다.
   4. 프로그램 트리(Program Trees)
      - 프로그램을 계층 구조로 쪼개어 보여줍니다. 예를 들어서 리눅스 실행 파일 포맷인 ELF 프로그램의 경우, 내부적으로 .text, .data, .rodata와 같은 섹션으로 나누어져 있습니다. 프로그램 트리에서 특정 섹션을 클릭하면, 디스어셈블 리스팅이 해당하는 섹션의 위치로 이동합니다.
   5. 데이터 타입 매니저(Data Type Manager)
      - 데이터 타입을 관리할 수 있는 창입니다. 라이브러리에 정의된 타입을 불러오거나 분석을 통해 알아낸 구조체를 관리할 수 있습니다. 
      - 복잡한 프로그램을 분석하는 과정에서 구조체를 수동으로 식별하여 관리하는 작업에 사용
      - 구조체 추가
        - 프로그램 이름이 적힌 폴더에 우클릭 -> New -> Structure 선택
   6. 콘솔(Console)
      - Ghidra 스크립트의 실행 결과가 출력.
	  - 스크립팅 기능으로 자동화 가능
   7. Byte viewer 
     - 메뉴 -> Window -> bytes:~~~ 선택하여 바이너리를 byte 로 읽은 내용 확인
   8. 함수 호출관계 그래프
     - 메뉴 -> Window -> `Function Call Graph` 선택하여 함수간 링킹 관계 표시 (정적 링킹은 동적링킹에 비해 복잡하게 표시될 수 있음)
   9. 함수 그래프
     - 메뉴 -> Window -> `Function Graph` 로 어셈블리 코드상 함수 호출 구조를 확인
## 사용법
1. 문자열 검색 : 메뉴 -> search -> For String
2. 주소 역참조 : disassem 화면에서 주소에 마우스 우클릭 -> references -> show reference to address


# Ghidra
- 오픈소스 리버싱 툴

## Script
- 스크립트를 활용하여 반복적인 작업을 자동화 할 수 있다.
- `Script Manager` 를 활용하여 