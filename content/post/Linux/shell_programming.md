---
title: "Shell Programming"
date: 2023-07-13T18:29:44+09:00
lastmod: 2023-07-13T18:29:44+09:00
tags: ["linux", "shell_programming"]
categories: ["dev"]
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

# Shell Programming
- 리눅스 쉘 프로그래밍에 대해 기술한다.
- 쉘 프로그래밍은 bash, sh 등의 명령어를 활용한 로직을 칭하며, 리눅스 환경에서 text 파일 안에 명령어를 작성해 놓고, 실행하는 방식으로 사용한다.
- 명령어가 든 파일의 확장자는 보통 .sh 로 세팅한다. (윈도우 OS의 .batch 와 유사)

## .sh 파일 작성
- 새로 생성된 text 파일은 확장자가 .sh 라도 실행 권한이 없기 떄문에 `chmod` 명령어로 권한을 수정해야 한다. 
  - ex) `chmod a+x <파일이름>` 명령으로 모든 사용자에 대해 실행 권한을 부여할 수 있다.
- .sh 파일 안에는 shell 명령어들을 사용할 수 있다. 그 외 추가적으로 작성할 수 있는 구문들은 다음과 같다. 

- `#!/bin/bash` : /bin/bash 경로의 shell 로 아래 명령어들을 실행하겠다고 세팅
  - 쉘 파일을 실행할 때 어떤 shell로 실행될지 설정 하는 구문으로, .sh 파일의 최상단부에 기입한다.
- `set` :
  - `set -e` : 오류나 에러가 발생하면 즉시 스크립트를 종료
  - `set -x` : 스크립트 내 실행되는 명령어의 결과를 화면에 출력
- `echo` : 화면에 문자열을 출력하는 구문 (C언어의 printf, python의 print 와 유사한 역할)
  - `echo -e` : `\` 문자를 escape 문자로 취급해 `\n` 과 같은 특수 문자를 사용할 수 있게 하는 옵션
- `$#` 파라미터 개수를 나타내는 변수
  - ex) `$ ./myscript.sh param1 param2` 명령어로 쉘 스크립트를 실행시켰다면, `$#` 은 2이다.
- `$1`: 첫 번째 파라미터
- `$2`: 두 번째 파라미터
- `$@`: 모든 파라미터
  - ex) `$ ./myscript.sh param1 param2` 명령어로 쉘 스크립트를 실행시켰다면, `$@` 은 `param1 param2` 이다.