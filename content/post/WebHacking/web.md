---
title: "Web"
date: 2025-03-06T22:46:50+09:00
lastmod: 2025-03-06T22:46:50+09:00
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
# Web
- HTTP를 이용하여 정보를 공유하는 인터넷 기반 서비스를 Web이라 한다.
- 정보 제공자를 Web Server, 정보 수신자를 Web Client라 칭한다.
- 현재의 웹은 단순 정보 제공을 떠나 서비스를 제공하는 형태로 발전하고 있으며, `Front end` 와 `Back end` 로 역할이 나뉘어지고 있다. 
  - Front end : `Web resource`로 구성된 사용자에게 직접 보여지는 부분
  - Back end : 사용자에게 직접 보여지지는 않지만 서비스 제공을 위해 구동되는 부분

## Web Resource
- 웹에 갖춰진 정보 자산을 의미하며, 사용자에게 제공되어 화면을 구성하는데 사용된다.
- 고유한 식별자인 Uniform Resource Identifier (URI)를 가진다.
- 대표적인 웹 리소스의 종류
  - Hyper Text Markup Language (HTML) : 태그와 속성을 통한 구조화된 문서 작성에 사용. [설명 참조](../WebApplication/html)
  - Cascading Style Sheets (CSS) : 웹 문서의 외형을 조절하는데 사용. [설명 참조](../WebApplication/css)
  - JavaScript (JS) : 이용자의 브라우저에서 실행되는 코드로 front end 의 동작을 결정. [설명 참조](../WebApplication/javaScript)
  - text
  - image
  - video
  - font

## Web browser
- Client 의 위치에서 Server 와 HTTP 통신을 수행해주고 그 결과를 가시화 해 주는 도구로, 사용자가 HTTP 통신을 직접 알지 못해도 Web을 사용할 수 있게 해 준다.
- 동작 순서
   1. URL 분석
   2. DNS 요청
   3. HTTP Request
   4. get HTTP Respond
   5. 리소스 다운로드 및 웹 랜더링

### Dev Tool 
- Web browser 에서 사용할 수 있는 개발자 도구
- `Ctrl + U` : 소스코드 보기 단축키
- `console.log` : 콘솔창에 로그 출력
- `document.cookie` : 콘솔창에서 쿠키 출력
- `location.href` : 전체 URL 을 반환하거나, URL을 업데이트

## URL(Uniform Resource Locator)
- 웹에 있는 리소스의 위치를 표현하는 문자열
- URL 의 구성 요소
  - Scheme: 웹 서버와 어떤 프로토콜로 통신할지 나타냅니다.
  - Host: Authority의 일부로, 접속할 웹 서버의 주소에 대한 정보를 가지고 있습니다.
  - Port: Authority의 일부로, 접속할 웹 서버의 포트에 대한 정보를 가지고 있습니다.
  - Path: 접근할 웹 서버의 리소스 경로로 '/'로 구분됩니다.
  - Query: 웹 서버에 전달하는 파라미터이며 URL에서 '?' 뒤에 위치합니다.
  - Fragment: 메인 리소스에 존재하는 서브 리소스를 접근할 때 이를 식별하기 위한 정보를 담고 있습니다. '#' 문자 뒤에 위치합니다.

## Domain name
- 숫자의 조합으로 이루어진 IP 주소를 사람이 읽기 쉬운 형태의 문자열로 대체한 형태
- Domain name 을 사용하기 위해서는 DNS가 필요하다.
- DNS(Domain Name Server) 에 Domain name 을 질의하면 DNS 는 매핑되는 IP 를 반환한다. 
> 콘솔의 nslookup  명령으로 domain name 정보를 확인할 수 있다.  
> ex) `nslookup google.com`

## Web rendering
- 서버로부터 받은 리소스 파일을 시각화하는 과정을 의미한다.
- 브라우저는 Web rendering 을 위한 엔진을 사용한다.
  - Webkit
  - Blink
  - Gecko

## CGI (Common Gateway Interface)
- 웹 서버와 외부 프로그램(예: 스크립트, 애플리케이션) 간의 데이터를 주고받는 표준 방식
- 웹 서버가 동적인 콘텐츠(예: 폼 입력 처리, 데이터베이스 조회 등)를 생성하기 위해 실행하는 프로그램의 인터페이스를 CGI 라 한다.
- CGI 동작 방식
  - 클라이언트 요청
    - 사용자가 웹 브라우저에서 특정 URL을 입력하거나, HTML 폼을 제출하면 요청이 웹 서버로 전달
  - 웹 서버가 CGI 프로그램 실행
    - 요청된 URL이 CGI 프로그램을 호출하는 경로라면, 웹 서버는 해당 CGI 스크립트를 실행
    - 보통 CGI 프로그램은 Perl, Python, C, PHP, Shell Script 등으로 작성
  - CGI 프로그램이 요청 처리
    - 폼 데이터 처리, 데이터베이스 조회, 파일 읽기 등 요청에 맞는 작업을 수행
  - 출력 결과를 웹 서버에 반환
    - CGI 프로그램은 HTML, JSON, 텍스트 등의 응답을 웹 서버에 출력
  - 웹 서버가 클라이언트에 응답 전송
    - 웹 서버는 CGI 프로그램이 반환한 결과를 클라이언트(웹 브라우저)에 전송
- 장점
  - 다양한 언어 지원 가능
  - 단순한 텍스트 기반 입출력 구조
- 단점
  - 속도가 느림
  - 확장성 부족
  - 보안 취약점 존재