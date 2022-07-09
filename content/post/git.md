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

## Submodule
1. 생성
  - git repository 안에 다른 git repository를 관리할 때 사용한다. 
  - `git submodule add <REPOSITORY> [PATH]` 명령어로 추가 가능하다.
  - submodule 을 사용했던 repository를 clone 했을 때, submodule이 있던 폴더는 비어있다. 이때 `git submodule init [PATH]` 명령어로 submodule 안의 내용을 추가할 수 있다. 

1. 관리
  - submodule에서 commit을 작성하고, 부모 repository에서 commit을 작성하는 순으로 진행해야 모든 변경점이 정상적으로 반영될 수 있다. (child -> parent 순)
  - remote에서 local로 변경점을 받아올 때는, parent를 먼저 pull 하고 submodule을 pull 한다. (parent -> child 순)

