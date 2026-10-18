---
title: "웹 애플리케이션 아키텍처와 브라우저 렌더링 과정 및 네트워크 통신 기초"
description: "웹 애플리케이션의 동작 원리와 프론트엔드/백엔드 아키텍처, URL 구조와 DNS 조회, 브라우저의 중요 렌더링 경로(DOM/CSSOM 트리 생성, Layout, Paint) 및 CGI 연동 메커니즘을 상세히 분석합니다."
slug: "web-architecture-and-browser-rendering-process"
date: 2025-03-06T22:46:50+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebHacking"]
tags: ["web-architecture", "browser", "rendering", "dns", "http"]
ShowToc: true
TocOpen: true
---

웹(World Wide Web)은 인터넷이라는 물리적 네트워크 인프라 위에서 HTTP 프로토콜을 매개로 정보를 하이퍼텍스트 형태로 공유하고 상호작용하는 분산 시스템입니다. 초기에는 정적인 문서 열람 위주의 단순 플랫폼이었으나, 현대에는 고도화된 클라우드 인프라와 단일 페이지 애플리케이션(SPA) 기술이 융합된 복합 서비스 플랫폼으로 진화했습니다.

이 글에서는 웹의 기본 아키텍처 구성, 사용자가 URL을 입력했을 때 화면에 렌더링되기까지의 전 과정, 브라우저 렌더링 엔진의 동작 메커니즘, 그리고 백엔드 동적 처리를 가능하게 한 CGI의 개념을 정리합니다.

---

## 1. 웹 시스템의 구성 요소와 프론트엔드·백엔드 아키텍처

웹 애플리케이션은 사용자 인터페이스를 담당하는 프론트엔드와 비즈니스 로직 및 데이터를 처리하는 백엔드로 명확히 분리되어 협업합니다.

### 1.1. 클라이언트-서버 모델과 웹 리소스
- **웹 클라이언트 (Web Client)**: 주로 웹 브라우저나 모바일 앱을 지칭하며, 서버에 리소스를 요청(Request)하고 반환된 결과를 가공하여 사용자에게 시각적으로 표시합니다.
- **웹 서버 (Web Server)**: 80(HTTP) 또는 443(HTTPS) 포트에서 대기하며 클라이언트의 요청을 수신하여 정적 리소스를 반환하거나 백엔드 WAS(Web Application Server)로 전달합니다.
- **웹 리소스 (Web Resource)**: 웹에 존재하는 모든 자산으로 URI(Uniform Resource Identifier)를 통해 식별됩니다.

### 1.2. 프론트엔드 3대 리소스의 역할
1. **HTML (HyperText Markup Language)**: 웹 문서의 뼈대와 정보의 계층적 구조를 정의합니다.
2. **CSS (Cascading Style Sheets)**: 글꼴, 여백, 레이아웃 등 시각적 디자인과 반응형 스타일을 부여합니다.
3. **JavaScript**: DOM을 동적으로 조작하고 사용자의 비동기 인터랙션(AJAX/Fetch)을 실행합니다.

---

## 2. 브라우저 주소창 입력부터 화면 노출까지의 라이프사이클

사용자가 브라우저 주소창에 `https://www.example.com/search?q=security#top` 을 입력하고 엔터를 누르면 다음과 같은 단계가 순차적으로 실행됩니다.

### 2.1. URL 구조 분석
- **Scheme (`https`)**: 사용할 통신 프로토콜.
- **Host (`www.example.com`)**: 통신할 대상 도메인 주소.
- **Port (`:443`)**: 접속할 포트 번호 (기본 포트는 생략 가능).
- **Path (`/search`)**: 서버 내에서 처리할 리소스의 세부 경로.
- **Query String (`?q=security`)**: `?` 뒤에 키-값 쌍으로 전달되는 검색 인자.
- **Fragment (`#top`)**: `#` 뒤에 지정된 페이지 내부의 특정 북마크 위치 식별자 (서버로 전송되지 않음).

### 2.2. DNS(Domain Name System) 주소 해석
컴퓨터 간 통신에는 숫자 형태의 IP 주소가 필수적이므로, 사람이 읽기 쉬운 도메인을 IP로 변환해야 합니다.
1. 브라우저 캐시 및 OS 로컬 Hosts 파일 확인
2. 라우터 및 로컬 DNS 서버(ISP) 질의
3. 루트 DNS 서버 &rarr; TLD(.com) 서버 &rarr; Authoritative DNS 서버 순차 질의
4. 최종 매핑된 서버 IP 주소 반환 (`nslookup` 또는 `dig` 도구로 확인 가능)

### 2.3. TCP 핸드셰이크 및 HTTP 전송
1. **3-Way Handshake (SYN &rarr; SYN-ACK &rarr; ACK)**: 클라이언트와 서버 간 신뢰성 있는 TCP 연결 수립.
2. **TLS 핸드셰이크**: HTTPS의 경우 보안 암호화 통신을 위한 대칭키 교환 및 인증서 검증 수행.
3. **HTTP Request/Response 전송**: 클라이언트의 GET 요청에 대해 서버가 200 OK 상태 코드와 함께 HTML 문서를 반환.

---

## 3. 웹 브라우저 렌더링 엔진과 중요 렌더링 경로(CRP)

서버로부터 수신한 바이트 스트림 데이터를 브라우저가 화면의 실제 픽셀로 변환하는 과정을 **중요 렌더링 경로(Critical Rendering Path)**라고 부릅니다.

### 3.1. DOM 및 CSSOM 트리 구축
- **DOM(Document Object Model) 트리**: 브라우저는 수신한 원시 바이트를 문자(UTF-8)로 변환하고, 토큰(Token)으로 분해한 뒤, 노드(Node) 객체로 파싱하여 부모-자식 트리 구조로 구축합니다.
- **CSSOM(CSS Object Model) 트리**: 외부 CSS 파일 및 `<style>` 블록을 파싱하여 스타일 규칙이 적용된 트리를 생성합니다.

### 3.2. 렌더 트리 결합, Layout(Reflow) 및 Paint(Repaint)
1. **Render Tree 구축**: DOM 트리와 CSSOM 트리를 결합하여 화면에 실제로 표시되는 가시 노드들(`display: none` 제외)만으로 구성된 렌더 트리를 만듭니다.
2. **Layout (Reflow)**: 뷰포트 내에서 각 노드의 정확한 위치와 크기를 픽셀 단위로 계산합니다.
3. **Paint (Repaint)**: 계산된 좌표에 색상, 배경, 그림자, 테두리 등 시각적 픽셀을 채워 화면에 최종 출력합니다.
4. **Composite (합성)**: 레이어 단위로 그려진 요소들을 GPU를 통해 합성하여 모니터에 표시합니다.

### 3.3. 주요 브라우저 엔진
- **Blink**: Google Chrome, Microsoft Edge, Opera
- **WebKit**: Apple Safari
- **Gecko**: Mozilla Firefox

---

## 4. 동적 웹 처리의 시초: CGI(Common Gateway Interface)

초기 웹 서버는 미리 작성된 정적 HTML 파일만을 내려줄 수 있었으나, 검색 결과나 게시판 등 실시간 데이터 처리를 위해 외부 프로그램과 통신하는 표준 규약인 CGI가 등장했습니다.

### 4.1. CGI 프로그램의 구동 흐름
1. 클라이언트가 폼 데이터를 입력하고 제출합니다.
2. 웹 서버가 요청 경로를 분석하여 CGI 스크립트(C, Perl, Python 등)를 별도 프로세스로 포크(Fork)합니다.
3. 웹 서버는 요청 정보와 파라미터를 스크립트의 환경변수(`QUERY_STRING`, `REQUEST_METHOD` 등) 및 `stdin`으로 전달합니다.
4. CGI 프로그램이 데이터베이스 조회 등 비즈니스 로직을 수행하고 결과 HTML을 `stdout`으로 출력합니다.
5. 웹 서버가 해당 출력을 받아 브라우저에 최종 HTTP 응답을 전송합니다.

### 4.2. CGI의 한계와 현대 애플리케이션 아키텍처
CGI는 요청이 들어올 때마다 매번 운영체제 프로세스를 새로 생성하고 종료하므로 서버 부하가 극심했습니다. 현대에는 프로세스 풀을 유지하며 스레드 기반으로 요청을 처리하는 FastCGI, Java의 서블릿 컨테이너(Tomcat), 파이썬의 WSGI(Gunicorn/Uvicorn), 그리고 Node.js의 싱글 스레드 이벤트 루프 아키텍처로 발전하였습니다.