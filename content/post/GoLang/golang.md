---
title: "Go 언어 환경 설정 및 기본 포맷 출력 문법 정리"
date: 2022-01-14 21:52:14+09:00
lastmod: 2022-01-14 21:52:14+09:00
description: "Go(Golang) 개발 환경 구축을 위한 설치 과정과 기본 작업 공간(GOPATH 및 Go Modules) 구조를 살펴보고, fmt 패키지의 printf 서식 지정자(%v, %+v, %#v)를 활용한 변수 출력 문법을 상세히 정리합니다."
slug: "golang-environment-setup-and-fmt-printf"
categories:
  - "GoLang"
tags:
  - "golang"
  - "go"
  - "environment-setup"
  - "fmt"
  - "printf"
ShowToc: true
TocOpen: true
draft: false
---

## Go 설치 및 작업 디렉터리 구성

Go 언어는 구글에서 개발한 정적 타입 컴파일 언어로, 간단하고 명료한 문법과 뛰어난 동시성 처리 성능을 제공한다.

### 설치 및 환경변수 설정
1. 공식 웹사이트([golang.org](https://go.dev/))에서 운영체제에 맞는 설치 패키지를 다운로드하여 설치한다.
2. Go의 기본 루트 경로(`GOROOT`)와 작업 공간(`GOPATH`)을 설정한다.
   - Windows: `C:\Go`, `C:\Users\<사용자>\go`
   - Linux/macOS: `/usr/local/go/bin`, `~/go`
3. 초기 전통적인 Go 프로젝트 관리 방식에서는 `$GOPATH/src` 디렉터리 내에 도메인별(예: `github.com/username/project`)로 디렉터리를 구성하여 소스 코드와 패키지를 관리하였다.
   > [!NOTE]
   > 최신 Go(1.11 버전 이후)에서는 `go mod init <모듈명>` 명령을 통해 `$GOPATH` 외부의 임의 디렉터리에서도 Go 모듈(Go Modules) 기반으로 독립된 프로젝트와 의존성을 편리하게 관리할 수 있다.

## fmt 패키지 및 Printf 문법

Go 표준 라이브러리의 `fmt` 패키지는 C의 `printf`/`scanf`와 유사한 표준 입출력 포맷팅 기능을 제공한다.

```go
package main

import "fmt"

type User struct {
    Name string
    Age  int
}

func main() {
    u := User{Name: "Alice", Age: 30}
    fmt.Printf("%v\n", u)  // 기본 표현 형태: {Alice 30}
    fmt.Printf("%+v\n", u) // 필드명을 포함한 상세 형태: {Name:Alice Age:30}
    fmt.Printf("%#v\n", u) // Go 문법 구문 표현: main.User{Name:"Alice", Age:30}
    fmt.Printf("%T\n", u)  // 데이터 타입 출력: main.User
}
```

### 주요 서식 지정자 (Format Specifiers)
- `%v`: 값의 기본 출력 표현 (default format)
- `%+v`: 구조체 출력 시 각 필드의 이름과 값을 함께 출력하여 디버깅에 유용
- `%#v`: Go 언어 소스 코드 형태의 표현식으로 출력
- `%T`: 해당 변수의 Go 데이터 타입(Type)을 출력
- `%d`: 10진수 정수 출력
- `%s`: 문자열 또는 바이트 슬라이스 출력
- `%t`: 불리언(`true`/`false`) 출력
- `%p`: 포인터 메모리 주소(16진수) 출력
