---
title: "Linux_env"
date: 2023-07-10T21:04:56+09:00
lastmod: 2023-07-10T21:04:56+09:00
tags: ["linux"]
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

# Dev in Linux
리눅스 개발환경 구축을 위한 가이드

## 사용자 맞춤 설정
### .bashrc
홈 디렉터리에 위치한 user별 설정 파일이다.  
- `source ~/.bashrc` 명령어로 언제든 새로고침 할 수 있다.  

- 리눅스 콘솔 프롬프트를 보기 쉽게 색칠하기 위한 설정할 수 있다.  
```
force_color_prompt=true
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_root)}\[\033[01;32m\]\u\[\033[01;36m\]@\[\033[01;35m\]\h\[\033[00m\]:\[\033[01;033m\]\w\$\[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
```

### vi
리눅스에서 활용할 수 있는 기본적인 에디터이다. 진입장벽은 높은 편이지만, 한번 익숙해지면 매우 편리하다.  
~/.vimrc 폴더에 기본 설정을 적용할 수 있다.  
기본적인 설정은 아래와 같이 세팅할 수 있다.  
```
# 탭을 spacebar 4개로 설정한다. 
set ts=4  
set sw=4  
set sts=4
# 자동으로 indent를 넣어주도록 설정한다. 
set smartindent
# 검색시 하이라이트를 넣어준다. 
set hlsearch
"   " indent for python"
set smartindent
"   cinwords=if,elif,else,for,while,try,except,finally,def,class
# 테마를 설정 해 준다. 테마는 '/usr/share/vim/vim[VER]/colors/' 경로에 *.vim 파일이 있어야 한다. 아래는 molokai.vim 파일을 설정하는 방식이다.
:colorscheme molokai
:highlight comment term=bold cterm=bold ctermfg=4

:set hlsearch
:set expandtab
:set smartindent
:set tabstop=4

:set autoindent
:set si
:set shiftwidth=4
:set cinoptions+=j1
```
### Ctag
vi와 함께 쓰이는 툴로, vi 환경에서 파일간 함수/변수 선언위치를 버튼 하나로 이동할 수 있도록 해주는 모듈이다.   
tags라는 파일을 생성하여 
기본적인 사용법은 다음과 같다. 
1. 설정 (리눅스 명령어로)
 - ctag를 사용할 가장 root 폴더로 이동한다.
 - `ctags -R *` 명령어로 하위 폴더의 모든 파일에 대해 태그를 생성한다. (* 대신 *.cpp *.java 등 원하는 파일만 설정할 수도 있다. )
 - make 모듈이 깔려있다면 `make tags` 명령으로 커널을 이용하여 더 빠르게 생성할 수도 있다.
 - `set tags+=PATH_TO_FILE` 형태로 ~/.vimrc 파일에서 tags 경로를 설정해주면, 어떤 위치에서도 ctag 검색이 가능하다. 
2. 사용 (vi 창에서)
 - `Ctrl + ]` : 커서 위치의 함수/변수의 선언부로 이동 (g + ] 로도 가능)
 - `Ctrl + T` : 이전 위치로 이동


## 시스템

## 네트워크


### 네트워크 상태확인
- `ifconfig -a` 명령을 사용하면 현재 기기의 랜카드와 그 정보를 확인할 수 있다.
- `netstat -nap` 명령으로 시스템에서 네트워킹을 사용하는 프로세스들의 정보 및 네트워크 소켓 상태를 확인 가능하다.
  - `netstat -rn` 게이트웨이 정보만 짧게 출력 가능하다.
- `route -n` 라우팅 테이블을 확인 할 수 있다. 게이트웨이 주소를 확인할 수 있음
- `nslookup SERVER_NAME` : DNS 서버가 제대로 동작하는지 있다.
  - SERVER_NAME 에 주소를 입력하면 입력한 서버의 정보가 확인된다.
  - ex) nslookup naver.com 입력 결과
    ```
    $ nslookup naver.com
    Server:         172.26.80.1
    Address:        172.26.80.1#53

    Non-authoritative answer:
    Name:   naver.com
    Address: 223.130.200.219
    Name:   naver.com
    Address: 223.130.192.248
    Name:   naver.com
    Address: 223.130.192.247
    Name:   naver.com
    Address: 223.130.200.236
    ```

### host 차단/허용
- `/etc/hosts.deny` 파일로 차단할 IP 를 설정할 수 있다. 
- `/etc/hosts.deny` 에서 차단한된 IP 중 일부를 `/etc/hosts.allow` 파일에서 허용할 수 있다.
- 파일에는 `SERVICE:IP:[PORT]` 형태로 내용을 작성하면 차단/허용을 설정할 수 있다.
  - ex) `sshd:10.162.36.10:22` : 10.162.36.10 주소에서 22번 포트로 sshd 서비스에 접근하는 경우를 설정
  - 모든 프로토콜, 혹은 모든 IP를 표현할 땐 `ALL` 을 사용한다.
  - ex) `ALL: 10.162.36.10`, `httpd:ALL`
  - 주소중 앞부분 일부가 일치하는 경우를 설정하고 싶다면 뒷자리를 비워두면 된다. 
    - ex) `ALL: 10.162.` : 10.162.*.* 형태의 주소에 대해 설정
- `service SERVICE restart` 명령을 실행하여 daemon을 재실행하면 설정한 내용이 적용된다.
  - ex) `service sshd restart`


## 네트워크 연결
- 리눅스 최초 설치 및 네트워크 설정 변경시 사용할 명령어를 기술한다. 본 내용은 ubuntu 를 base로 작성되었다. 
- 리눅스는 `/etc/network/interfaces` 에 네트워크 연결 설정이 세팅된다.
  - ex)
    ```
    auto eth0   
    iface eth0 inet static    
    address 192.168.0.20   
    netmask 255.255.255.0   
    netwrok 192.168.0.0    
    broadcast 192.168.0.255
    gateway 192.168.0.1
    dns-nameservers 168.126.63.1 168.126.63.2 8.8.8.8
    ```
  - 내용을 수정한 후에는 시스템을 재부팅 하거나 `ifdown eth0`, `ifup eth0` 명령으로 드라이버를 재구동 하면 된다.

- `/etc/netplan/*.yam` 파일로도 네트워크 설정을 할 수 있다.
  - ex)
    ```
    network:
        version: 2
        renderer: networkd
        ethernets:
            wlp5s0:
                dhcp4: no 
                addresses: 
            ## 설정할 IP 와 Netmask
            - 192.168.0.214/24
                ### deprecated
                # gateway4: 192.168.0.1
                routes:
                - to: default
                via: 192.168.10.1
                nameservers:
                addresses: [8.8.8.8,168.126.63.1]
                #  search: [lesstif.com]
    #            optional: true
    ```
  - `sudo netplan apply` 으로 설정을 적용한다.

- `/etc/resolv.conf` 에서 nameserver를 설정 할 수 있다. 

### net-tools 을 사용한 설정
- `net-tools` 이 설치되어 있다면 네트워크 설정이 간단하다.
- `ifconfig -a` 명령은 기기의 랜카드와 그 정보를 확인할 수 있다.
  - ex)   
    ```
        eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.162.82.17  netmask 255.255.255.0  broadcast 10.162.82.255
            inet6 0e10::313:5d6f:ae41:2ba8  prefixlen 64  scopeid 0x20<link>
            ether 00:25:3d:b1:14:9c  txqueuelen 1000  (Ethernet)
            RX packets 188  bytes 512005 (512.0 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 178  bytes 26044 (26.0 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    ```
    - `eh0` 은 랜카드의 이름이다.
    - `inet` 뒤의 10.162.82.177 은 IP주소이다. (IPv4)
    - `netmask`는 subnet mask 설정이다. 

### ip명령어로 동작
- `net-tools` 가 설치되지 않았을 때 사용해야 하는 방법이다. 
- `ip a` : 주소확인, ifconfig에 대응된다.
- `ip addr add 192.168.0.101/24 dev eth0` : 설정에 ip주소 추가
  - 192.168.0.101은 IP 주소이다.
  - / 다음 24는 subnet mask의 bit 수이다.
  - eth0 은 `ip a` 명령어로 확인한 랜카드의 이름이다.
- `ip route add default via 192.168.0.1` : 게이트웨이 192.168.0.1 로 설정
- `ip link set eth0 up` : 수정한 랜 설정 적용