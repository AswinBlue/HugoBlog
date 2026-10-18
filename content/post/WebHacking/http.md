---
title: "HTTP 프로토콜 핵심 구조: 요청·응답 메시지, 메서드 및 상태 코드 총정리"
description: "웹 통신의 근간인 HTTP 프로토콜의 동작 메커니즘, Start Line과 Header 및 Body 메시지 구조, REST API 핵심 메서드(GET, POST, PUT, DELETE)의 멱등성, 응답 상태 코드 및 HTTPS 보안 전송 원리를 정리합니다."
slug: "http-protocol-structure-methods-status-codes"
date: 2025-03-06T20:17:24+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebHacking"]
tags: ["http", "https", "network", "web-standards", "rest-api"]
ShowToc: true
TocOpen: true
---

HTTP(HyperText Transfer Protocol)는 웹 브라우저(클라이언트)와 웹 서버 간에 하이퍼텍스트 및 멀티미디어 데이터를 주고받기 위한 OSI 7계층의 애플리케이션 계층(Application Layer) 표준 네트워크 프로토콜입니다.

현대의 모든 웹 서비스와 RESTful API는 HTTP 프로토콜을 기반으로 데이터를 교환하므로, HTTP의 메시지 구조, 메서드의 특성, 상태 코드의 의미를 정확히 이해하는 것은 웹 개발과 웹 보안의 필수 기본기입니다.

---

## 1. HTTP 프로토콜 개요 및 통신 메커니즘

HTTP는 클라이언트의 명시적인 요청(Request)에 대해 서버가 결과 데이터를 응답(Response)하는 단방향 클라이언트-서버 모델로 동작합니다.

### 1.1. 비연결성(Connectionless)과 무상태성(Stateless)
- **비연결성 (Connectionless)**: 클라이언트가 요청을 보내고 서버가 응답을 반환하면 즉시 TCP 연결을 종료합니다. 서버의 동시 연결 유지 비용을 아낄 수 있으나 매 요청마다 핸드셰이크(Handshake) 오버헤드가 발생할 수 있어, HTTP/1.1부터는 `Keep-Alive` 헤더를 통해 커넥션을 재사용합니다.
- **무상태성 (Stateless)**: 서버는 이전 통신의 상태(State)나 클라이언트 정보를 메모리에 유지하지 않습니다. 서버의 수평 확장성(Scale-Out)이 극대화되는 장점이 있는 반면, 상태 유지를 위해 쿠키(Cookie), 세션(Session), JWT 토큰과 같은 별도 메커니즘이 필요합니다.

### 1.2. Well-Known 포트와 전송 계층(TCP)
HTTP는 전송 계층(Transport Layer)에서 신뢰성 있는 전송 프로토콜인 TCP(Transmission Control Protocol)를 사용합니다.
- **HTTP 기본 포트**: `80` 포트 (보조/개발 포트: `8080`)
- **HTTPS 보안 포트**: `443` 포트 (보조 포트: `8443`)

---

## 2. HTTP 메시지 구조 (Request & Response)

HTTP 메시지는 사람이 읽을 수 있는 ASCII 텍스트 형식으로 구성되며, 줄바꿈은 `CRLF`(`\r\n`) 문자로 구분됩니다.

### 2.1. HTTP 요청 메시지(Request) 구조
```http
POST /api/v1/users HTTP/1.1
Host: api.example.com
User-Agent: Mozilla/5.0
Content-Type: application/json
Content-Length: 38

{"username": "johndoe", "age": 28}
```
1. **시작줄 (Start Line / Request Line)**:
   - **Method**: 수행할 동작 (`GET`, `POST`, `PUT`, `DELETE` 등)
   - **Request Target**: 접근하려는 리소스 URI 경로 (`/api/v1/users`)
   - **HTTP Version**: 프로토콜 버전 (`HTTP/1.1`, `HTTP/2`)
2. **헤더 (Headers)**: `필드명: 값` 형태로 요청 메타데이터(호스트, 브라우저 정보, 인증 토큰 등)를 전달합니다.
3. **빈 줄 (Empty Line)**: 헤더부의 끝을 알리는 필수 공백 라인(`\r\n`).
4. **본문 (Body / Payload)**: 서버로 전송할 실제 페이로드 데이터(JSON, 폼 데이터, 바이너리 등).

### 2.2. HTTP 응답 메시지(Response) 구조
```http
HTTP/1.1 200 OK
Date: Sun, 18 Oct 2026 09:00:00 GMT
Content-Type: application/json; charset=UTF-8
Content-Length: 42

{"status": "success", "userId": "1001"}
```
1. **상태줄 (Status Line)**: HTTP 버전, 숫자 상태 코드(Status Code), 상태 텍스트(Reason Phrase)로 구성됩니다.
2. **헤더 (Headers)**: 응답 일시, 콘텐츠 타입, 서버 정보, 쿠키 설정(`Set-Cookie`) 등.
3. **본문 (Body)**: 클라이언트가 요청한 HTML 마크업, JSON 데이터, 이미지 바이너리 등.

---

## 3. HTTP 메서드 종류와 멱등성(Idempotency)

HTTP 메서드는 리소스에 대해 수행할 작업의 성격을 규정합니다.

### 3.1. 주요 CRUD 메서드
- **`GET`**: 서버로부터 지정된 리소스를 조회합니다. 요청 파라미터는 URL 쿼리스트링에 노출되며 본문(Body)을 포함하지 않습니다. (안전 및 멱등)
- **`POST`**: 서버에 데이터를 제출하여 새로운 하위 리소스를 생성하거나 상태를 변경합니다. (멱등하지 않음)
- **`PUT`**: 대상 리소스를 요청 페이로드 내용으로 완전히 교체(전체 수정)하거나 없을 경우 생성합니다. (멱등)
- **`PATCH`**: 대상 리소스의 특정 필드만을 부분적으로 수정합니다. (원칙적으로 비멱등)
- **`DELETE`**: 지정된 리소스를 서버에서 완전히 삭제합니다. (멱등)

> **멱등성(Idempotency)**: 동일한 요청을 한 번 실행하든 연속해서 여러 번 실행하든 서버의 최종 리소스 상태가 변하지 않는 성질을 뜻합니다. `GET`, `PUT`, `DELETE`는 멱등하지만, `POST`는 반복 실행 시 데이터가 계속 중복 생성되므로 멱등하지 않습니다.

### 3.2. 보조 메서드
- **`HEAD`**: `GET`과 동일하지만 응답 본문(Body) 없이 헤더 정보만 수신합니다. 리소스 크기나 수정 여부 확인에 쓰입니다.
- **`OPTIONS`**: 대상 서버가 지원하는 HTTP 메서드 목록을 조회하거나 CORS 프리플라이트 요청에 사용됩니다.
- **`CONNECT`**: 프록시 서버를 통해 대상 호스트와 터널링(SSL/TLS 통신)을 수립합니다.
- **`TRACE`**: 요청 경로를 따라 메시지 루프백 루프 진단 테스트를 수행합니다. (보안상 비활성화 권장)

---

## 4. HTTP 응답 상태 코드(Status Code) 분류

서버는 클라이언트의 요청 처리 결과를 3자리 숫자의 상태 코드로 전달합니다.

### 4.1. 성공 및 안내 코드
- **1xx (Informational - 조건부/정보 응답)**:
  - `101 Switching Protocols`: WebSocket 등 다른 프로토콜로 전환
- **2xx (Success - 성공)**:
  - `200 OK`: 요청이 성공적으로 처리됨
  - `201 Created`: 새로운 리소스가 성공적으로 생성됨 (POST 응답)
  - `204 No Content`: 요청이 성공했으나 반환할 본문 데이터가 없음 (DELETE 응답 등)
- **3xx (Redirection - 리다이렉션)**:
  - `301 Moved Permanently`: 요청한 리소스가 영구적으로 새로운 URL로 이동함
  - `302 Found`: 임시로 다른 URL로 리다이렉션됨
  - `304 Not Modified`: 캐시된 리소스가 유효하여 서버에서 데이터를 재전송하지 않음

### 4.2. 오류 코드
- **4xx (Client Error - 클라이언트 오류)**:
  - `400 Bad Request`: 문법 오류나 잘못된 인자 전달로 서버가 요청을 해석할 수 없음
  - `401 Unauthorized`: 인증 자격 증명이 누락되었거나 유효하지 않음
  - `403 Forbidden`: 인증은 되었으나 해당 리소스에 접근할 권한이 없음
  - `404 Not Found`: 요청한 URL에 매칭되는 리소스를 찾을 수 없음
  - `405 Method Not Allowed`: 해당 URL에서 지원하지 않는 HTTP 메서드로 요청함
- **5xx (Server Error - 서버 오류)**:
  - `500 Internal Server Error`: 서버 내부 로직 처리 중 예외 및 오류 발생
  - `502 Bad Gateway`: 게이트웨이 또는 프록시 서버가 상위 서버로부터 잘못된 응답 수신
  - `503 Service Unavailable`: 일시적인 과부하 또는 유지보수로 인해 서비스를 처리할 수 없음
  - `504 Gateway Timeout`: 게이트웨이가 업스트림 서버로부터 제한 시간 내에 응답을 받지 못함

---

## 5. HTTPS(HTTP over TLS/SSL) 보안 전송 원리

기본 HTTP는 데이터가 암호화되지 않은 일반 텍스트(Plaintext)로 전송되므로, 와이파이나 네트워크 중간 노드에서 패킷 스니핑을 통해 비밀번호나 세션 쿠키가 그대로 도청될 수 있습니다.

- **HTTPS(HTTP Secure)**: 전송 계층과 응답 사이에 **TLS(Transport Layer Security)** 암호화 계층을 추가하여 모든 통신 패킷을 암호화합니다.
- **주요 보안 효과**:
  1. **기밀성 (Confidentiality)**: 제3자가 패킷을 가로채더라도 암호화되어 있어 내용을 열람할 수 없습니다.
  2. **무결성 (Integrity)**: 데이터가 전송 도중 위·변조되지 않았음을 디지털 서명으로 보증합니다.
  3. **인증 (Authentication)**: 신뢰할 수 있는 인증기관(CA)에서 발급한 인증서를 통해 접속 대상 서버가 위장 사이트(피싱)가 아님을 입증합니다.
