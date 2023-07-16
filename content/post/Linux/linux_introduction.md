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
 - Richard Stallman이 창시한 FSF(Free Software Foundation) 의 프로젝트 GNU 
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


- i-node는 부팅시 추가 정보가 포함되어 메모리에 복사된다. 복사된 이 정보를 i-node cache라 한다.
  - 추가정보에는
    1) 참조계수
    2) i-node번호 (`ls -li`로 확인 가능)
    3) 파일 시스템 장치 번호 (`ls -l` 명령시, 파일 size 대신 major/minor 번호가 표시됨) 

### Data block
- Data block은 4kB 크기이며, 하나의 파일이 여러 Data block을 가질 수 있다.