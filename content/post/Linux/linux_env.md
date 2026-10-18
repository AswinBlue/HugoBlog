---
title: "리눅스 개발 환경 설정 및 네트워크 구성 가이드: .bashrc, Vim, Ctags부터 Netplan까지"
description: "리눅스(Ubuntu) 개발 환경 구축을 위한 .bashrc 프롬프트 커스텀, Vim 및 Ctags 소스 탐색 설정부터 ifconfig, netstat 네트워크 상태 진단, /etc/hosts 접근 제어 및 Netplan 정적 IP 설정법을 상세히 다룹니다."
slug: "linux-development-environment-setup-and-network"
date: 2023-07-10T21:04:56+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["linux", "ubuntu", "vim", "networking", "bash"]
ShowToc: true
TocOpen: true
---

# 리눅스 개발 환경 및 네트워크 설정 가이드

## 사용자 쉘 및 에디터 환경 구축

### .bashrc 프롬프트 커스터마이징
홈 디렉터리에 위치한 `~/.bashrc`는 사용자별 쉘 시작 설정 파일입니다. 변경 사항은 `source ~/.bashrc` 명령어로 즉시 적용할 수 있습니다.
터미널 프롬프트에 가독성 높은 색상을 적용하기 위해 다음과 같이 `PS1` 환경 변수를 설정할 수 있습니다.

```bash
force_color_prompt=true
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;36m\]@\[\033[01;35m\]\h\[\033[00m\]:\[\033[01;33m\]\w\$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
```

### Vim 편집기 환경 설정 (~/.vimrc)
리눅스 CLI 환경에서 필수적인 Vim 편집기의 들여쓰기, 검색 하이라이트 및 컬러 스킴을 `~/.vimrc` 파일에 구성합니다.

```vim
" 들여쓰기 탭 간격 4칸 설정
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set autoindent

" 검색 결과 하이라이트 설정
set hlsearch

" 테마 설정 (molokai.vim이 /usr/share/vim/vim*/colors/ 등에 위치해야 함)
syntax on
colorscheme molokai
highlight Comment term=bold cterm=bold ctermfg=4
```

### Ctags 코드 탐색 환경 구축
Ctags는 소스코드 내 함수, 구조체, 변수 선언부를 인덱싱하여 `tags` 데이터베이스 파일을 생성하는 도구입니다. 대규모 C/C++ 프로젝트를 Vim에서 탐색할 때 유용합니다.

1. **태그 파일 생성**
   - 프로젝트 루트 디렉터리로 이동 후 다음 명령을 실행합니다.
   ```bash
   ctags -R *
   ```
   - 또는 리눅스 커널 소스 트리 등에서는 `make tags` 명령으로 빠르게 인덱싱할 수 있습니다.
   - `~/.vimrc`에 `set tags+=./tags,tags;` 구문을 추가하면 하위 디렉터리에서도 상위 `tags` 파일을 자동 탐색합니다.
2. **Vim 내 탐색 단축키**
   - `Ctrl + ]` (또는 `g + ]`): 커서가 위치한 함수/변수의 정의부로 즉시 이동
   - `Ctrl + T`: 이전 코드 위치로 스택 복귀

## 네트워크 상태 진단 및 점검

### 네트워크 상태 확인 명령어
- `ifconfig -a` (또는 `ip a`): 시스템에 인식된 모든 네트워크 인터페이스와 IP, MAC 주소, 서브넷 마스크 현황을 확인합니다.
- `netstat -nap` (또는 `ss -tulnp`): 네트워크 소켓을 점검하여 리스닝 중인 포트 및 통신 중인 프로세스 ID(PID)를 조회합니다.
- `route -n` (또는 `ip route`): 라우팅 테이블 및 기본 게이트웨이 주소를 확인합니다.
- `nslookup <도메인>` (또는 `dig <도메인>`): DNS 서버 질의를 통해 도메인 네임의 IP 주소 매핑 상태를 검증합니다.
  ```bash
  $ nslookup naver.com
  Server:         127.0.0.53
  Address:        127.0.0.53#53

  Non-authoritative answer:
  Name:   naver.com
  Address: 223.130.192.248
  ```

### TCP Wrapper 접근 제어 (/etc/hosts)
TCP Wrapper를 지원하는 네트워크 데몬(`sshd` 등)에 대해 IP 단위 접근 차단 및 허용 목록을 정의할 수 있습니다.

- `/etc/hosts.deny`: 차단할 대상 호스트 설정
  ```text
  # 모든 호스트의 SSH 접근 기본 차단
  sshd: ALL
  ```
- `/etc/hosts.allow`: 차단 목록 중 특정 신뢰 IP 대역 예외 허용
  ```text
  # 특정 서브넷 대역만 SSH 접속 허용
  sshd: 10.162.36. 192.168.0.
  ```
- 변경 사항 적용: 데몬 프로세스를 재시작합니다 (`sudo systemctl restart ssh` 또는 `service sshd restart`).

## 네트워크 인터페이스 및 IP 구성

### Netplan 기반 네트워크 설정 (/etc/netplan)
Ubuntu 18.04 LTS 이후 버전에서는 YAML 기반의 Netplan이 기본 네트워크 설정 관리자로 동작합니다.
- 설정 파일 경로: `/etc/netplan/*.yaml`
- 정적 IP 할당 예시:
  ```yaml
  network:
    version: 2
    renderer: networkd
    ethernets:
      eth0:
        dhcp4: no
        addresses:
          - 192.168.0.100/24
        routes:
          - to: default
            via: 192.168.0.1
        nameservers:
          addresses: [8.8.8.8, 1.1.1.1]
  ```
- 설정 유효성 검사 및 적용:
  ```bash
  sudo netplan apply
  ```

### 레거시 interfaces 설정 (/etc/network/interfaces)
데비안 및 구형 우분투 시스템에서는 `/etc/network/interfaces` 파일로 고정 IP를 설정합니다.
```text
auto eth0
iface eth0 inet static
address 192.168.0.20
netmask 255.255.255.0
gateway 192.168.0.1
dns-nameservers 8.8.8.8 168.126.63.1
```
- 네트워크 재시작: `sudo ifdown eth0 && sudo ifup eth0`

### ip 명령어를 이용한 런타임 수동 설정
재부팅 없이 일시적으로 IP 주소나 기본 게이트웨이를 갱신할 때 `iproute2` 명령어를 사용합니다.
- IP 주소 할당: `sudo ip addr add 192.168.0.101/24 dev eth0`
- 기본 게이트웨이 추가: `sudo ip route add default via 192.168.0.1 dev eth0`
- 인터페이스 활성화: `sudo ip link set eth0 up`