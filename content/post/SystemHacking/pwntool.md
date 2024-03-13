---
title: "Pwntool"
date: 2024-03-09T10:09:44+09:00
lastmod: 2024-03-09T10:09:44+09:00
tags: []
categories: []
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

# pwntool
- 시스템 해킹을 위해 제작된 파이썬 라이브러리
- 바이너리를 실행하고 특정 input을 집어넣어 해킹(exploit)을 할수 있게 한다.

## 설치
- 리눅스의 apt와 파이썬의 pip 명령으로 설치가 가능하다.
```
$ apt-get install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
$ python3 -m pip install --upgrade pip
$ python3 -m pip install --upgrade pwntools
```
- [공식 메뉴얼](https://docs.pwntools.com/en/latest/)

## 사용법
- `from pwn import *` 을 통해 모듈을 로딩한다.
1. process / remote
   - `target = process(파일경로)` 로 로컬 파일을 exploit 하기위한 대상으로 설정한다. 
   - 원격으로 접속한 목적지의 파일을 exploit 할 때는 remote를 사용한다.
  - `target = remote('목적지 ip', 목적지 port)` 를 호출하면 해당 ip:port 에 연결된 소켓을 exploit target으로 설정한다.
2. send
   - `process` 혹은 `remote` 로 설정한 target 에 입력을 전달하는 함수
   - send의 파생으로 sendline, sendafter, sendlineafter 등이 있다. 
     - `target.send(B)` : target에 B를 입력
     - `target.sendlineafter(A, B)` : 출력으로 A가 감지되면 target에 B를 입력
3. recv
   - target으로 부터 들어오는 출력 데이터를 수신하는 함수
   - 파생으로 recvn, recvline, recvuntil, recvall 이 있다.
     - `result = target.recv(len)`: len만큼 데이터를 수신, len보다 길이가 짧으면 오류 반환
     - `result = target.recvn(len)`: len만큼 데이터를 수신, 수신한 길이가 len보다 짧으면 무한 대기
     - `result = target.recvline()`: 개행문자를 만날 때 까지 데이터 수신
     - `result = target.recvuntil(A)`: A 문자를 만날 때 까지 데이터 수신
     - `result = target.recvall()`: 프로세스가 종료될 때 까지 데이터 수신
4. packing / unpacking
   - 리틀엔디안 / 빅엔디안 사이를 변환하는 함수
5. interactive
   - exploint 중 표준 입력/출력으로 프로세스에 직접 입력을 주입하고 출력을 확인하고 싶은 경우
   - `target.interactive()` 를 설정하면 'target' 에 직접 관여할 수 있다.
6. ELF
   - ELF 파일 헤더를 참조할 때 사용 가능
   - `elf = ELF(파일명)` 형태로 참조하면 dictionary 형태의 데이터를 반환 받을 수 있다.
   - `elf.symbols[함수명]` 으로 함수의 주소를 확인할 수 있다.
7. context
   - context.log_level
     - `context.log_level` 을 설정하여 디버깅을 위한 로그 레벨을 설정 할 수 있다.
   - context.arch
     - exploit 대상의 아키텍처에 대한 정보를 설정할 수 있다. 
     - `context.arch = "amd64"` 형태로 설정
     - i386, arm, mips 등을 설정 할 수 있다.
8. asm
   - `asm(CODE)` 형태로 CODE에 어셈블리 라인을 string 형태로 기입시 바이너리 코드를 반환한다.
   - ex) `asm('mov eax, SYS_execve')` => `b'\xb8\x0b\x00\x00\x00'`
9. disasm
   - `disasm(BIN)` 형태로 BIN에 바이너리 데이터를 입력시 어셈블리 명령어를 반환한다. 
   - ex) `disasm(b'\xb8\x0b\x00\x00\x00')` => `0:   b8 0b 00 00 00          mov    eax, 0xb'`