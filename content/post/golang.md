+++
title = "Golang"
date = 2022-01-14T21:52:14+09:00
lastmod = 2022-01-14T21:52:14+09:00
tags = ["go",]
categories = ["dev"]
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = false
+++

# Go

## 설치 및 프로젝트 생성
1. 구글 검색을 통해 설치파일을 다운받는다.
 - root 디렉터리 설정이 필요하다.('C:\Go, '/usr/local/go/bin/')
 - 이후 생성할 프로젝트는 이 root 디렉터리 하위 경로에 생성된다. 외부 경로에는 프로젝트를 생성할 수 없다.
2.  root 디렉터리 안 src 디렉터리에 프로젝트를 생성한다.
 - Go는 npm, pip 와 같이 패키지 매니저가 없다. git 등에서 코드를 받아오면 src 디렉터리 안에 도메인별로 정리해서 관리하는게 정석이다.
