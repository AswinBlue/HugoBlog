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

## SOP (Same Origin Policy)
- 악의적인 웹 페이지에서 javascript 를 통해 Client 가 다른 웹 페이지로 패킷을 보내게 한다면, Client 의 Session 과 Cookie 를 사용해 웹 페이지에 패킷을 보낼 수 있게 된다.
- Web Client 에서는 동일한 출처(origin) 로 판별된 사이트를 대상으로만 읽어들일 수 있는 제약을 만들었고, 이를 SOP 라 한다.
- 데이터 읽기는 막지만, 쓰기는 허용된다.

### 동일 출처 (same origin)
- 웹 사이트의 URL은 프로토콜, 포트, 호스트 세 가지로 구성된다.
- 예를들어 `https://google.com:443` URL은 아래와 같이 분석된다.
  - 프로토콜(scheme) : `https`
  - 호스트 : `google.com`
  - 포트 : `443`
- `https://google.com/menu:443` : same origin. path가 다른 것은 허용
- `http://google.com:443` : cross origin. 프로토콜(scheme)이 다름
- `https://naver.com:443` : cross origin. 호스트가 다름
- `https://google.com:123` : cross origin. 포트가 다름

### CORS (Cross-Origin Resource Sharing)
- SOP 제약사항에도 예외는 있다. 이미지나 자바스크립트, CSS 등의 리소스를 불러오는 \<img>, \<style>, \<script> 등의 태그는 SOP의 영향을 받지 않습니다.
- 또한, 필요에 의해 cross origin 간에도 데이터를 교환해야 할 상황이 있는데, 이 경우 CORS와 관련된 HTTP 헤더를 추가하여 데이터를 요청할 수 있다. 
  ```
  xhr = new XMLHttpRequest();
  xhr.withCredentials = true;
  ```
  - 이 경우, 수신측에 메시지 요청을 질의하는 용도로 `OPTIONS` 메소드 데이터가 전달된다. 
  - 이러한 패킷을 `CORS preflight` 라고 한다. 
  - 요청 패킷의 헤더에 `Access-Control-Request` 구문이 들어있고, 회신 패킷의 헤더에는 `Access-Control-Allow` 구문이 들어가 있다.
  - Server 의 회신에 적힌 CORS 정책을 보고, Client는 데이터를 요청할지 판단한다.

### JSONP (JSON with Padding)
- javascript 는 SOP 의 예외 취급을 받는 속성을 이용하여 \<script> 태그 형태로 cross origin 의 데이터를 받아오는 기법이다.
- Server 에 데이터를 요청할 때 callback 함수의 이름을 넘겨주면, 대상 서버는 전달된 callback 함수로 데이터를 감싸 응답합니다
  - ex) request: `<script src='http://theori.io/whoami?callback=myCallback'></script>`
  - ex) response: `myCallback({'id':'dreamhack'});`
- JSONP는 CROS 가 생성되기 전에 쓰이던 방법으로, 최근에는 사장되는 추세이다.
