---
title: "Git"
date: 2022-07-09T10:58:55+09:00
draft: true
lastmod: 2022-07-09T10:58:55+09:00
tags: ["git",]
categories: ["dev",]
---

# Git

## Cache
- Cache 확인: `git ls-files --stage FILE_PATH`
- Cache 삭제: `git rm -r --cached FILE_PATH`
  - `'PATH' already exists in the index` 오류가 발생했을 때, cache를 확인하고 삭제하면 해결 가능하다. 
## config
- `git config` 명령으로  git 관련 setting을 확인 및 설정할 수 있다. 
- `git config --list` : 설정된 내용 확인
- `git config --add` : 설정 추가
  - `--system` : 컴퓨터 환경에 적용
  - `--global` : 사용자 환경에 적용
  - `--local` : repository별로 설정 적용, default값
    - `git config --global user.name <USER_NAME>` : 사용자 이름 설정, 구역 인자를 붙이면 --add 는 생략가능
    - `git config --global user.email <EMAIL>` : 사용자 email 설정, 구역 인자를 붙이면 --add 는 생략가능
- `git config --unset` : 설정 제거

## Submodule
1. 생성
  - git repository 안에 다른 git repository를 관리할 때 사용한다. 
  - `git submodule add <REPOSITORY> [PATH]` 명령어로 추가 가능하다.
  - submodule 을 사용했던 repository를 clone 했을 때, submodule이 있던 폴더는 비어있다. 이때 `git submodule init [PATH]` 명령어로 submodule 안의 내용을 추가할 수 있다.  
  - 추가된 내용은 `.gitmodules` 파일에 저장된다.
  - submodule의 remote에 변경점이 생기면 `git fetch; git submodule update` 를 수행해서 변경점을 반영해 준다. 

  - 각 submodule에서 git 명령어 수행: `git submodule foreach [git명령어]`
  - .gitmodules 파일 업데이트 : `git submodule sync`
  - submodule의 내용 pull : `git submodule update`

1. 관리
  - submodule에서 commit을 작성하고, 부모 repository에서 commit을 작성하는 순으로 진행해야 모든 변경점이 정상적으로 반영될 수 있다. (child -> parent 순)
    - 부모 repository는 submodule의 변경점을 직접적으로 관리하지는 않지만, 최종 형태(commit)은 관리한다. 
  - remote에서 local로 변경점을 받아올 때는, parent를 먼저 pull 하고 submodule을 pull 한다. (parent -> child 순)
  - submodule을 push하지 않고 parent를 push할 경우, submodule의 현재 commit은 local에만 있고, remote에는 없는 상황이다. 이떄 `git clone --recursive` 명령어를 사용하여 전체 프로젝트를 받으려 하면, submodule을 clone할 때 remote에 없는 commit을 참조하려 하여 오류가 발생한다. 
## CRLF LF
- 윈도우 형태의 EOL(\n) 과 리눅스 형태의 EOL(\r\n) 차이 떄문에 git은 autocrlf 명령을 통해 자동으로 개행문자를 바꿔주는 기능을 지원한다. 
- `git config <--system> core.autocrlf <false>` 명령으로 이 기능을 조절할 수 있다.
  - `--system` : per-system solution
  - `--global` : per-user solution
  - `--local`  : per-project solution
  - `true`  : LF -> CRLF
  - `input` : LF -> LF
  - `false` : don't change
  
- 개행 문자 차이 때문에 윈도우에서 정상동작 하던 SHA-256이 리눅스 환경에서 비정상 동작을 할 수 있다. 
- 이때는 아래 명령을 순서대로 입력하여 git에서 발생한 개행문자 오류를 해결할 수 있다.   
  ```
  git config --global core.autocrlf input
  git rm --cached -r .
  # 이후 commit 수행하면 됨
  ```