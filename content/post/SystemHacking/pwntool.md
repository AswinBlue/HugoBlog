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
- docker를 사용한 설치 방법
   ```
   FROM ubuntu:18.04

   ENV PATH="${PATH}:/usr/local/lib/python3.6/dist-packages/bin"
   ENV LC_CTYPE=C.UTF-8

   RUN apt update
   RUN apt install -y \
      gcc \
      git \
      python3 \
      python3-pip \
      ruby \
      sudo \
      tmux \
      vim \
      wget

   # install pwndbg
   WORKDIR /root
   RUN git clone https://github.com/pwndbg/pwndbg
   WORKDIR /root/pwndbg
   RUN git checkout 2023.03.19
   RUN ./setup.sh

   # install pwntools
   RUN pip3 install --upgrade pip
   RUN pip3 install pwntools

   # install one_gadget command
   RUN gem install one_gadget

   WORKDIR /root
   ```

## 사용법
- `from pwn import *` 을 통해 모듈을 로딩한다.
1. process / remote
   - `target = process(파일경로)`
     - 로컬 파일을 exploit 하기위한 대상으로 설정한다. 
     - `env` 인자로 실행시 환경변수를 설정 할 수 있다.
       - 다음은 libc 파일을 원하는 경로에서 링킹 하도록 설정하는 구문이다. :  `target = process('./a.out', env= {"LD_PRELOAD" : "./libc.so.6"})`
  - `target = remote('목적지 ip', 목적지 port)` 
    - ip:port 에 연결된 소켓을 exploit target으로 설정한다.
    - 원격으로 접속한 목적지의 파일을 exploit 할 때 사용한다.
2. send
   - `target.send(b'data_to_send')`
     - `process` 혹은 `remote` 로 설정한 target 에 표준입력을 주입하는 함수
     - `b''` 형태의 byte literal 을 전달해야 한다. `p64` 혹은 `p32` 로 변환하여 전달 할 수도 있다.
     - send의 파생으로 sendline, sendafter, sendlineafter 등이 있다. 
       - `target.sendline(b'data')` : 'data' 전달 후 '\n' 추가 입력
       - `target.sendlineafter(b'input:', b'data')` : 출력으로 'input:'가 감지되면 target에 'data'를 입력
3. recv
   - target으로 부터 들어오는 출력 데이터를 수신하는 함수. return 값은 byte literal 이므로 `u64` 혹은 `u32` 로 변환 후 사용한다.
   - `result = target.recv(len)`: len만큼 데이터를 수신, len보다 길이가 짧으면 오류 반환
   - 파생으로 recvn, recvline, recvuntil, recvall 이 있다.
     - `result = target.recvn(5)`: 5byte 데이터를 수신, 수신한 길이가 len보다 짧으면 무한 대기
     - `result = target.recvline()`: 개행문자를 만날 때 까지 데이터 수신
     - `result = target.recvuntil('name: ')`: "name: " 문자를 만날 때 까지 데이터 수신 (인자로 b'name', 'name' 모두 되는듯)
     - `result = target.recvall()`: 프로세스가 종료될 때 까지 데이터 수신
4. packing / unpacking
   - 데이터를 변환하는 함수
   - `p32(VALUE)` : 32bit little endian으로 변환
   - `p64(VALUE)` : 64bit little endian으로 변환
   - `u32(VALUE)` : 32bit big endian으로 변환
   - `u64(VALUE)` : 64bit big endian으로 변환

5. interactive
   - exploint 중 표준 입력/출력으로 프로세스에 직접 입력을 주입하고 출력을 확인하고 싶은 경우
   - `target.interactive()` 를 설정하면 'target' 에 직접 관여할 수 있다.
6. ELF
   - ELF 파일 헤더를 참조할 때 사용 가능
   - `elf = ELF(파일명)` 형태로 참조하면 dictionary 형태의 데이터를 반환 받을 수 있다.
   - `elf.symbols[함수명]`: 'elf' 가 라이브러리 파일일 때, 라이브러리 함수의 `offset` 을 확인할 수 있다.
     - `elf.symbols[변수명]`: 'elf' 가 실행프로그램일 때, 변수의 `주소`를 확인할 수 있다.
   - `elf.plt[함수명]`: 'elf' 가 실행프로그램일 때, plt 테이블에서 함수가 매핑된 `주소`를 확인할 수 있다.
   - `elf.got[함수명]` 'elf' 가 실행프로그램일 때, got 테이블에서 함수가 매핑된 `주소`를 확인할 수 있다.
   - `elf.search[문자열]` 으로 ELF 에 저장된 문자열의 주소를 확인한다. 
7. context
   - context.log_level
     - `context.log_level` 을 설정하여 디버깅을 위한 로그 레벨을 설정 할 수 있다.
   - context.arch
     - exploit 대상의 아키텍처에 대한 정보를 설정할 수 있다. 
     - `context.arch = "amd64"` 형태로 설정
     - `i386`, `arm`, `mips` 등을 설정 할 수 있다.
8. asm
   - `asm(CODE)` 형태로 CODE에 어셈블리 라인을 string 형태로 기입시 바이너리 코드를 반환한다.
   - ex) `asm('mov eax, SYS_execve')` => `b'\xb8\x0b\x00\x00\x00'`
9. disasm
   - `disasm(BIN)` 형태로 BIN에 바이너리 데이터를 입력시 어셈블리 명령어를 반환한다. 
   - ex) `disasm(b'\xb8\x0b\x00\x00\x00')` => `0:   b8 0b 00 00 00          mov    eax, 0xb'`


### 예시
1. stack frame안의 버퍼와 canary를 획득한 경우, 버퍼에 shell 실행 코드를 주입하고 stack overflow로 return code를 버퍼의 주소로 변경한 후 canary를 복원시키면 쉘을 획득할 수 있다.

   ```
   from pwn import *
   target = process(TARGET_PROGRAM)
   # 'canary' 는 추출해온 스택 카나리 값이 littel endian형태로 담겨있다.
   shell_code = asm(shellcraft.sh())  # pwn tool로 쉘 실행코드 생성 및 바이너리로 변환
   payload = shell_code.ljust(buffer_to_canary, b'A') + canary + b'B' * 0x8 + p64(buffer_address) # 버퍼에 쉘 코드를 넣고, 남는 칸은 아무 문자로 메꾼다. 그 후 카나리를 잘 복원하고 SFP는 아무 숫자나 채워넣고 리턴 주소를 버퍼 주소로 덮어씀
   # gets() receives input until '\n' is received
   target.sendlineafter(b'Input:', payload) # 타겟 프로그램에서 Input을 받아 'buffer_address' 주소에 받도록 프로그램이 짜여져 있다.

   target.interactive() # 쉘을 획득하고 쉘을 유저가 활용할 수 있게 반환한다.
   ```

## 기타 도구
### checksec
- pwntool과 함께 설치되는 도구로, 바이너리에 적용되는 보호 기법(ex: RELRO, Canary, NX, PIE) 을 확인할 수 있다.
  - ASLR은 리눅스에서 기본적으로 적용되어있으므로, 특별한 언급이 없다면 default on이라 생각하면 된다.
- ex)
   ```
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
    RWX:      Has RWX segments
   ```


### shellcraft
- pwntool과 함께 설치되는 파이썬 모듈로 쉘 코드의 함수들을 반환한다.
- [시스템 콜 테이블 참조](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
  - shellcraft.sh() : 쉘 실행 코드
  - shellcraft.open() : 쉘 코드 open(인자 필요)
  - shellcraft.read() : 쉘 코드 read(인자 필요)
  - shellcraft.write() : 쉘 코드 write(인자 필요)
  - shellcraft.exit() : 쉘 코드 exit
- asm() 함수와 함께 조합하면 쉘코드를 바이너리로 만들어 프로그램에 주입할 수 있다.
  - ex) shellcraft.sh() : 
      ```
      /* execve(path='/bin///sh', argv=['sh'], envp=0) */
      /* push b'/bin///sh\x00' */
      push 0x68
      push 0x732f2f2f
      push 0x6e69622f
      mov ebx, esp
      /* push argument array ['sh\x00'] */
      /* push 'sh\x00\x00' */
      push 0x1010101
      xor dword ptr [esp], 0x1016972
      xor ecx, ecx
      push ecx /* null terminate */
      push 4
      pop ecx
      add ecx, esp
      push ecx /* 'sh\x00' */
      mov ecx, esp
      xor edx, edx
      /* call execve() */
      push SYS_execve /* 0xb */
      pop eax
      int 0x80
      ```
  - ex) asm(shellcraft.sh()) : `b'jhh///sh/bin\x89\xe3h\x01\x01\x01\x01\x814$ri\x01\x011\xc9Qj\x04Y\x01\xe1Q\x89\xe11\xd2j\x0bX\xcd\x80'`

### ROPgadget
- 바이너리에서 gadget 값들을 확인할 수 있는 툴이다.
- gadget들의 주소를 확인하여 exploit에 활용할 수 있다.
- `ROPgadget --binary FILE_NAME` 을 입력하면 FILE_NAME 에서 gadget들을 찾아 출력 해 준다.
  - ex) ROPgadget --binary /bin/bash 의 일부이다.
   ```
   0x000000000008b4fb : xor r9d, r9d ; jmp 0x8b46b
   0x00000000000c0e30 : xor r9d, r9d ; jmp 0xc0c50
   0x00000000000c7caa : xor r9d, r9d ; jmp 0xc7cb3
   0x00000000000cc0ed : xor r9d, r9d ; jmp 0xcb089
   0x000000000007f2a5 : xor r9d, r9d ; lea eax, [rdx + 1] ; jmp 0x7ef68
   0x000000000006dc63 : xor r9d, r9d ; mov dword ptr [rbx], eax ; jmp 0x6cfd8
   0x00000000000618ec : xor r9d, r9d ; movsxd rax, r14d ; jmp 0x61792
   0x000000000006d9b4 : xor r9d, r9d ; xor r13d, r13d ; mov dword ptr [rbx], eax ; jmp 0x6cfd8
   0x00000000000757b3 : xor rax, qword ptr [r8] ; add byte ptr [rdi + 2], bh ; jmp 0x78b80
   0x00000000000558c2 : xor rax, rax ; test r13, r13 ; jne 0x558e4 ; jmp 0x558f1
   ```
- `--re REGULAR_EXPRESSION` 옵션을 넣어 정규 표현식으로 결과를 필터링 할 수 있다. (|grep 한 것과 유사한 효과)
  - ex) ROPgadget --binary /bin/bash --re "pop rdi" 의 결과 일부
      ```
      0x00000000000c5ac8 : pop rdi ; jmp rax
      0x00000000000b9c04 : pop rdi ; jne 0xb9c42 ; jmp 0xb9ce1
      0x00000000000bfc3a : pop rdi ; jne 0xbf8c3 ; jmp 0xbf8cb
      0x000000000005ca25 : pop rdi ; jns 0x5ca34 ; add al, ch ; jb 0x5c9f0 ; add dword ptr [rax], eax ; jmp 0x5c77f
      0x000000000005cadd : pop rdi ; or al, 0 ; mov rdx, qword ptr [rax + rcx] ; jmp 0x5c6c0
      0x000000000005cffc : pop rdi ; or al, 0 ; xor ebx, ebx ; xor ebp, ebp ; jmp 0x5d014
      0x000000000007542d : pop rdi ; out dx, eax ; or al, byte ptr [rax] ; add byte ptr [rax], al ; add byte ptr [rax], al ; jmp 0x752f8
      0x00000000000a69fc : pop rdi ; pop r8 ; jmp 0xa5ca0
      0x00000000000665ca : pop rdi ; pop rbp ; ret
      0x0000000000030934 : pop rdi ; ret
      0x00000000000aca60 : pop rdi ; sete dl ; or eax, edx ; movzx ebp, al ; jmp 0xac482
      0x00000000000ba113 : pop rdi ; sete sil ; or edx, esi ; jmp 0xb9eda
      0x00000000000b5690 : pop rdi ; xor ecx, ecx ; jmp 0xb56be
      0x00000000000493b2 : pop rsi ; pop rdi ; jmp 0x48b7d
      0x00000000000a6ca9 : pop rsi ; pop rdi ; jmp 0xa5ca0
      0x0000000000070836 : push rsi ; pop rdi ; add al, 0 ; jmp 0x705f1
      0x0000000000073205 : shr al, 5 ; pop rdi ; add dword ptr [rax], eax ; mov r13, rax ; jmp 0x72db8
      0x00000000000707e1 : stosd dword ptr [rdi], eax ; pop rdi ; add al, 0 ; jmp 0x7043d
      ```

### One_gadget
- exploit 에 필요한 `gadget` 들을 일일이 찾거나, `objdump`, `readelf` 등으로 매번 함수들을 찾지 않고 명령어 한 번으로 libc 라이브러리에서 execve("/bin/sh") 를 실행 시킬 수 있도록 하는 gadget 을 알려주는 툴이다.
- 다음 명령어로 설치가 가능하다.
   ```
   sudo apt-get install ruby
   sudo gem install one_gadget
   ```