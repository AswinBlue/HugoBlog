---
title: "Go 언어 핵심 기초 문법과 고루틴(Goroutine) 동시성 프로그래밍"
description: "Go 언어의 타입 시스템, 슬라이스, 맵, 구조체 및 고루틴과 채널을 활용한 경량 비동기 동시성 프로그래밍 기초를 체계적으로 정리합니다."
slug: "golang-core-syntax-and-concurrency"
date: 2022-01-14T21:52:14+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["GoLang"]
tags: ["golang", "go", "backend", "concurrency"]
ShowToc: true
TocOpen: true
---

# Go

## 설치 및 프로젝트 생성
1. 구글 검색을 통해 설치파일을 다운받는다.
 - root 디렉터리 설정이 필요하다.('C:\Go, '/usr/local/go/bin/')
 - 이후 생성할 프로젝트는 이 root 디렉터리 하위 경로에 생성된다. 외부 경로에는 프로젝트를 생성할 수 없다.
2.  root 디렉터리 안 src 디렉터리에 프로젝트를 생성한다.
 - Go는 npm, pip 와 같이 패키지 매니저가 없다. git 등에서 코드를 받아오면 src 디렉터리 안에 도메인별로 정리해서 관리하는게 정석이다.

## 문법
### printf
1. format specifier
- `%v`: used as a placeholder for the default format representation of a value
- `%+v`: a detailed representation of the value, including all the fields and their corresponding values for structs and maps.