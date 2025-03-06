---
title: "HTTP"
date: 2025-03-06T20:17:24+09:00
lastmod: 2025-03-06T20:17:24+09:00
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

# HTTP(Hyper Text Transfer Protocol)
- 서버와 클라이언트의 데이터 교환을 요청(Request)과 응답(Response) 형식으로 정의한 프로토콜로, 웹 서비스의 근간이 되는 텍스트 교환 프로토콜이다. 
- 주로 클라이언트가 요청을 하면 서버가 응답을 해 주는 방식이며, 서버는 클라이언트의 요청을 받기 위해 socket 통신으로 80번 (혹은 8080번) 포트를 상시 열어놓고 대기한다. 
- HTTP 프로토콜은 ISO 7계층 중 Application layer에 해당하며, transport layer 에 TCP 프로토콜을 사용할 떄 80번 포트를 HTTP 프로토콜 용으로 할당받는다. 
  - 0 ~ 1023 번 까지 port는 well-known 포트로, 시스템 혹은 네트워크에서 공공연히 사용되는 프로토콜들의 포트들이 할당되어 있고, HTTP 프로토콜도 그 중 하나이다.
  - 80번 포트에 HTTP가, 443 포트에 HTTPS가 할당되어 있다.

## 프로토콜 상세
### 패킷 구조
1. headers
    - headers는 `CRLF`(Carriage Return Line Feed) 로 한 줄을 구분하며, 첫 줄은 `Start line`, 이후 나머지 줄들은 모두 `header` 라 부른다. 
    - headers 의 끝은 빈 줄로 나타낸다.
    - headers 는 `field` 와 `value` 로 구성되어 HTTP 메시지의 속성 또는 body 의 속성을 나타낸다.
    - HTTP 메시지에는 0개 이상의 headers 가 존재할 수 있다.
2. body
    - headers 의 마지막 `CRLF` 다음 모든 줄을 body라 칭한다.
    - 상대방에게 전하려는 실제 데이터가 들어있다.

### 패킷 종류
- [HTTP 패킷 참조](https://www.rfc-editor.org/rfc/rfc2616.html#section-5)
1. Request
   - 시작줄에 Method, Request target, HTTP version 가 작성되며, 띄어쓰기로 구분된다.
   - Method
     - GET:  특정 리소스의 표시를 요청합니다. GET을 사용하는 요청은 오직 데이터를 받기만 합니다.
     - HEAD: GET 메서드의 요청과 동일한 응답을 요구하지만, 응답 본문을 포함하지 않습니다.
     - POST: 특정 리소스에 엔티티를 제출할 때 쓰입니다. 이는 종종 서버의 상태의 변화나 부작용을 일으킵니다.
     - PUT: 목적 리소스 모든 현재 표시를 요청 payload로 바꿉니다.
     - DELETE: 특정 리소스를 삭제합니다.
     - CONNECT: 목적 리소스로 식별되는 서버로의 터널을 맺습니다.
     - OPTIONS: 목적 리소스의 통신을 설정하는 데 쓰입니다.
     - TRACE: 목적 리소스의 경로를 따라 메시지 loop-back 테스트를 합니다.
     - PATCH: 리소스의 부분만을 수정하는 데 쓰입니다.
   - Request Target
     - URI라고도 불리며, 서비스 내에서 메소드를 처리할 하위 대상을 지정하는 용도이다. 
   - HTTP version
     - 프로토콜의 버전을 나타낸다.
2. Response
   - 요청에 대한 회신을 담아내는 패킷으로, 요청 결과를 숫자로 표현한 상태 코드를 담고 있다.
   - 상태 코드는 첫 숫자에 따라 아래와 같은 의미를 지닌다.
     - 1xx: 요청을 제대로 받았고, 처리가 진행 중임
     - 2xx: 요청이 제대로 처리됨
       - 200(OK): 성공
     - 3xx: 요청을 처리하려면, 클라이언트가 추가 동작을 취해야 함.
       - 302(Found): 다른 URL로 갈 것
     - 4xx: 클라이언트가 잘못된 요청을 보내어 처리에 실패
       - 400(Bad Request): 요청이 문법에 맞지 않음
       - 401(Unauthorized): 클라이언트가 요청한 리소스에 대한 인증이 실패함
       - 403(Forbidden): 클라이언트가 리소스에 요청할 권한이 없음
       - 404(Not Found): 리소스가 없음
     - 5xx: 클라이언트의 요청은 유효하지만, 서버에 에러가 발생하여 처리에 실패
       - 500(Internal Server Error): 서버가 요청을 처리하다가 에러가 발생함
       - 503(Service Unavailable): 서버가 과부하로 인해 요청을 처리할 수 없음
     - [상태코드 참조](https://www.rfc-editor.org/rfc/rfc2616.html#section-6)

# HTTPS(HTTP over Secure socket layer)
- HTTP는 평문으로 전달하기 때문에, 패킷이 유출되면 중요 정보가 노출될 수 있다.
- 보안 위협을 방지하기 위해 TLS(Transport Layer Security) 프로토콜을 도입한 HTTP의 변형 프로토콜이 HTTPS 이다.
- 평문 대신 암호화된 구문을 전송하며 복호화를 위한 키가 있어야 내용을 읽을 수 있다.
