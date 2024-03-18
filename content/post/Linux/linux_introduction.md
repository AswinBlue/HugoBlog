---
title: "Linux_introduction"
date: 2023-07-10T21:31:47+09:00
lastmod: 2023-07-10T21:31:47+09:00
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

# Linux

## 생성 배경

### Unix
 - unix는 범용 다중 사용자 방식의 시분할 운영체제이다. 즉, multi-user를 목적으로 개발된 운영체제이다. 
 - Dennis Ritche, Ken Thompson, Douglas Mcllroy 등이 주축이 되어 개발
 - 이후 다양한 회사들에 의해 개발이 지속되어, 표준화의 필요성이 생겼고, IEEE에서 제안한 POSIX(Portable Operating System Interface) 라는 표준 인터페이스를 따르게 되었다.
 - 리눅스는 unix를 기반으로 개발된 os이다. 
  ---

### GNU 
 - Richard Stallman이 창시한 FSF(Free Software **Fo**undation) 의 프로젝트 GNU 
 - 리눅스도 GNU의 GPL(General Public License) 에 의해 배포된다.
   1) 무료로 사용 가능하며
   2) GPL 소스를 적용된 코드를 수정하여 재판매가 가능하지만, 해당 코드를 공개해야 하며,
   3) 개발자는 코드로 인해 발생하는 어떤 문제에 대해서도 법적 책임을 지지 않는다.
 - GNU 프로젝트에서 linux를 main os로 채택
  ---


### Linus Torvalds
 - 리눅스 커널을 최초로 개발하였으며, 현재도 리눅스 커널 최고 설계자로 위치
 - Git 개발에도 참여하였음
  ---

- 리눅스는 수많은 개발자들이 개발에 동참하기에 개발 속도가 빠르고 분량이 방대하다. 
- 1991년 0.01버전이 공개되고, 1994년 1.0버전이, 1999년 2.4가 발표되었다.
- 커널은 같지만, Redhat Ubuntu CentOs Fedora 등 다양한 배포 버전이 개발되었다. 

---
## Linux hierarchy
- 리눅스는 다음과 같은 구조로 구성되어 하드웨어를 제어한다. 
> Hardware ->  
> Linux Kernel ->  
> System Call Interface ->  
> System Utilities ->  
> Linux Shell

- 하드웨어에 가까울 수록 low level,  멀어질 수록 high level 로 동작이 캡슐화 된다.


---
## File System
- 리눅스의 파일 구조는 Tree 형태를 갖고 있다. 가장 최 상단의 경로는 `/` 이며, root directory라고 칭한다.
- 모든 주변장치(터미널, 프린터, 디스크) 를 파일로 간주한다.
- 리눅스는 multi user 를 위한 OS이기 때문에, 각 파일은 접근 권한이 부여된다.
- file system은 아래와 같이 partition의 연속으로 이루어진다.
```
file system 구조
---------------------------------
Partition | Partition | Partition 
---------------------------------
Partition 구조
------------------------------------------------------------------
Boot block | Super block | i-node List | Data block 
------------------------------------------------------------------
i-node list 구조
-------------------------------
i-node | i-node | i-node | ...
-------------------------------
```
### Boot block
- Boot block에는 bootstrap loader가 들어있다.
- 
### Super block
- Superblock에는 파일 시스템의 정보가 들어있다.
  1) 파일 시스템 크기
  2) 파일 시스템 내의 자유 블록 수
  3) 파일 시스템 내에서 사용 가능한 자유 블록의 리스트
  4) i-node 리스트의 크기
  5) 파일 시스템에서 사용 가능한 i-node의 수
  6) 파일 시스템에서 사용 가능한 i-node의 리스트 

### i-node (information node)
- 각 partition은 i-node list를 가지며, i-node list에는 information node(i-node) 들이 나열되어 있다.
- 모든 파일 하나에는 i-node 하나가 할당되며, i-node는 파일의 정보를 나타낸다.
  1) 소유자 ID
  2) 파일 유형
  3) 파일 접근 권한
  4) 파일 접근 시간
  5) 링크 수
  6) 파일 데이터의 주소
  7) 파일의 크기
- 파일의 이름은 inode 번호와 함께 디렉터리에 기록된다. 

- i-node는 부팅시 추가 정보가 포함되어 메모리에 복사된다. 복사된 이 정보를 i-node cache라 한다.
  - 추가정보에는
    1) 참조계수
    2) i-node번호 (`ls -li`로 확인 가능)
    3) 파일 시스템 장치 번호 (`ls -l` 명령시, 파일 size 대신 major/minor 번호가 표시됨) 

### Data block
- Data block은 4kB 크기이며, 하나의 파일이 여러 Data block을 가질 수 있다.

## 디렉터리 구조
- /bin : 유저가 사용할 수 있는 명령어나 실행 파일을 보관하는 디렉터리.
- /boot : 시스템 부팅에 필요한 파일들을 보관하는 디렉터리
- /dev : 리눅스에서는 컴퓨터에 연결된 장치들을 디바이스 드라이버라는 파일 형태로 접근하며, 그러한 장치들을 나타내는 파일들은 /dev 경로에 보관된다.
- /etc : 리눅스에서 동작하는 서비스의 설정 파일들을 보관하는 디렉터리
- /home : 각 유저의 홈 디렉토리가 들어가는 디렉터리.
- /lib : 시스템에 필요한 라이브러리 파일들이 보관되는 디렉터리. /bin 이나 /sbin 에 존재하는 프로그램이 필요로 하는 동적 라이브러리 파일이 /lib 디렉터리에 보관된다.
- /opt : 최초 설치에 포함되지 않고 유저가 추가로 설치한 프로그램들을 보관하는 디렉터리. (window의 C:\Program Files 와 유사하다고 보면 된다.)
- /proc : 리눅스 커널의 상태를 나타내는 파일들을 보관하는 디렉터리
- /root : root 유저의 홈 디렉터리
- /sbin : /bin 디렉터리와 같이 명령어나 프로그램이 저장되는 디렉터리지만, /sbin은 root 유저가 사용할 수 있는 명령어나 프로그램이 보관된다는 차이가 있다.
- /tmp : 유저나 프로그램이 파일을 임시로 생성할 떄 사용할 수 있는 디렉터리. 오래된 파일들은 시스템에 의해 자동으로 삭제되므로 주의
- /usr : 사용자 바이너리, 문서, 라이브러리, 헤더 파일 등을 담고 있는 디렉터리(윈도우의 C:\User 폴더와 유사)
- /var : 프로그램이나 시스템이 실행될 때 저장이 필요한 파일을 저장하는 디렉터리. (ex: /var/log)