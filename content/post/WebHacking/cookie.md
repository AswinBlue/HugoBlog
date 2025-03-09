---
title: "Cookie"
date: 2025-03-09T16:10:13+09:00
lastmod: 2025-03-09T16:10:13+09:00
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

# Cookie
- HTTP의 특징(Connectionless, Stateless) 때문에 Web Server 는 HTTP로 요청된 패킷들이 어떤 Web Client에서 전달된 것인지 구분할 수 없다. 
  - IP 주소와 User-Agent 등의 정보는 매번 변경될 수 있다.
- Client의 정보와 요청의 내용을 구체화하기 위해, Server는 Client 마다 고유한 Cookie를 발급하고, Client는 Server에 요청을 보낼 때마다 Cookie를 같이 전송한다.
- Server는 Request 패킷에 들어있는 Cookie 를 통해 Client의 정보와 상태를 기록한다.
- Cookie 는 key-value 로 구성된 파일이며, Client 에 저장된다.

## Cookie의 단점
- 4KB의 크기 제한
- 쿠키로 인해 웹의 반응성이 느려질 수 있음
- 도메인 내의 모든 페이지가 같은 쿠키를 전달 받음
- HTTP 프로토콜로 Cookie 요청시 암호화 되지 않아 보안이 취약함
- 쿠키는 사용자의 로컬에 텍스트로 저장 되어있어 쉽게 내용 확인이 가능함
- 악의적인 Client 가 Cookie 를 변조할 수 있음

## Modern Storage APIs
- Cookie 의 단점을 해결하기 위해 사용되는 방법이다.
- Local storage, Session storage 등이 있다.

## Session
- Session 은 Server 에서 생성한 랜덤한 문자열이고, Server 가 Client 마다 고유한 값을 발급한다.
- Client 가 변조하면 안되는 정보들을 서버에 저장하기 위해 Server 와 Client는 Session 이라는 정보를 추가로 주고 받는다.
  - Client 가 본인을 인증하기 위해 Cookie 에 자신의 인증 정보를 담아서 Server 로 전달하면, Server는 새로운 Session ID를 생성한다.
  - Server는 생성한 Session ID를 Client에게 반환한다. 
  - Server는 Client로 부터 수신한 인증 정보와 본인이 생성한 Session ID를 묶어서 자신의 DB에 저장한다. 
  - 이후 Server는 Client 로 부터 인증 정보를 받지 않고 Session ID 만으로 Client를 구분할 수 있다.

- 만약 공격자가 이용자의 쿠키를 훔칠 수 있으면 이용자의 인증 상태를 훔칠 수 있는데, 이를 `Sessions Hijacking` 이라고 한다.

## Cookie in HTTP
- HTTP 통신에서 Server가 브라우저에게 Cookie를 생성하려면 response 패킷에 아래와 같이 `Set-Cookie` 구문을 넣으면 된다.
    ```
    Set-Cookie: name=test;
    Set-Cookie: age=30; Expires=Fri, 30 Sep 2022 14:54:50 GMT;
    ```
- Client 에서 Cookie 를 조작하려면 Javascript 를 활용한다.
    ```
    document.cookie = "name=test;"
    document.cookie = "age=30; Expires=Fri, 30 Sep 2022 14:54:50 GMT;"
    ```
