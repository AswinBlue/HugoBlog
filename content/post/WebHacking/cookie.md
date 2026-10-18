---
title: "웹 쿠키(Cookie)와 세션(Session) 동작 원리 및 보안 플래그(HttpOnly, Secure) 설정법"
description: "무상태 프로토콜인 HTTP에서 상태 유지를 위한 쿠키(Cookie)와 세션(Session)의 동작 메커니즘, 보안 플래그(HttpOnly, Secure, SameSite), SOP와 CORS 정책 및 보호 기법을 총정리합니다."
slug: "web-cookie-session-and-security-flags"
date: 2025-03-09T16:10:13+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebHacking"]
tags: ["cookie", "session", "web-security", "http", "cors"]
ShowToc: true
TocOpen: true
---

기본 HTTP 프로토콜은 연결을 유지하지 않는 비연결성(Connectionless)과 이전 요청의 상태를 기억하지 않는 무상태성(Stateless)을 기본 특징으로 갖습니다. 따라서 사용자가 로그인에 성공하더라도 다음 요청에서 웹 서버는 해당 클라이언트가 누구인지 식별할 수 없습니다.

이를 해결하기 위해 클라이언트와 서버는 쿠키(Cookie)와 세션(Session) 메커니즘을 사용합니다. 이 글에서는 쿠키와 세션의 동작 원리부터 세션 하이재킹 방어, 쿠키 보안 플래그, 동일 출처 정책(SOP) 및 CORS 설정까지 종합적으로 살펴봅니다.

---

## 1. HTTP 무상태성과 쿠키(Cookie)의 동작 원리

쿠키는 웹 서버가 클라이언트(웹 브라우저)에 전송하여 로컬에 저장하도록 하는 Key-Value 쌍 형태의 작은 텍스트 데이터 조각입니다.

### 1.1. 쿠키의 개념과 한계점
- **동작 방식**: 서버가 응답 헤더로 쿠키를 내려주면, 브라우저는 해당 도메인으로 요청을 보낼 때마다 `Cookie` 요청 헤더에 자동으로 쿠키를 동봉하여 전송합니다.
- **쿠키의 주요 한계점**:
  - 도메인당 최대 4KB 내외의 용량 제한이 있습니다.
  - 매 HTTP 요청마다 헤더에 포함되므로 불필요하게 대역폭을 낭비할 수 있습니다.
  - 클라이언트 브라우저 로컬 파일 시스템에 저장되므로 사용자가 쉽게 열람 및 임의 변조할 수 있습니다.
  - 암호화되지 않은 HTTP 환경에서는 패킷 스니핑을 통해 민감 데이터가 그대로 노출됩니다.

### 1.2. HTTP Set-Cookie 헤더와 브라우저 조작
서버는 응답 시 `Set-Cookie` 헤더를 통해 브라우저에 쿠키 생성을 지시합니다.

```http
HTTP/1.1 200 OK
Content-Type: text/html
Set-Cookie: sessionId=abc12345; Expires=Fri, 30 Sep 2026 14:00:00 GMT; Path=/; HttpOnly; Secure; SameSite=Strict
```

클라이언트 자바스크립트에서는 `document.cookie` 프로퍼티를 통해 쿠키를 조회하거나 설정할 수 있습니다. (단, `HttpOnly` 플래그가 없는 경우에만 접근 가능합니다.)

```javascript
document.cookie = "username=guest; max-age=3600; path=/";
```

---

## 2. 세션(Session) 기반 인증과 세션 하이재킹 방어

쿠키에 패스워드나 권한 정보를 직접 저장하면 보안상 치명적이므로, 민감 정보는 서버 측에 보관하고 클라이언트에게는 난수화된 식별자(Session ID)만 전달합니다.

### 2.1. 세션 발급 및 라이프사이클
1. 클라이언트가 로그인 자격 증명(ID/PW)을 서버에 전송합니다.
2. 서버는 자격 증명을 검증한 후 암호학적으로 안전한 무작위 문자열인 `Session ID`를 생성합니다.
3. 서버는 세션 저장소(Redis, RDBMS 또는 인메모리)에 `Session ID &rarr; 사용자 정보` 맵을 저장합니다.
4. 서버는 `Set-Cookie` 헤더에 `Session ID`를 담아 클라이언트에 반환합니다.
5. 이후 클라이언트는 매 요청마다 세션 쿠키를 동봉하며, 서버는 세션 ID를 키로 조회하여 사용자를 즉시 식별합니다.

### 2.2. 세션 하이재킹(Session Hijacking) 위협
공격자가 스니핑이나 XSS 공격을 통해 희생자의 세션 ID 쿠키를 탈취하면, 아이디와 비밀번호를 알지 못하더라도 서버로부터 정상 사용자로 인가받을 수 있습니다. 이를 세션 하이재킹이라 하며, 이를 차단하기 위해 엄격한 쿠키 보안 플래그 설정이 필수적입니다.

---

## 3. 웹 보안을 위한 쿠키 핵심 플래그 설정

프로덕션 환경에서는 쿠키를 발급할 때 다음 3대 보안 플래그를 반드시 활성화해야 합니다.

### 3.1. `HttpOnly` (XSS 공격 방어)
`HttpOnly` 속성을 지정하면 브라우저의 자바스크립트(`document.cookie`)를 통한 쿠키 접근이 완전히 차단됩니다. 악성 스크립트가 주입되는 XSS(Cross-Site Scripting) 취약점이 발생하더라도 공격자가 사용자의 인증 쿠키를 탈취할 수 없습니다.

### 3.2. `Secure` (HTTPS 암호화 강제)
`Secure` 속성을 추가하면 암호화된 HTTPS 통신을 통해서만 쿠키가 서버로 전송됩니다. 평문 HTTP 통신 구간에서 일어날 수 있는 중간자 공격(MITM) 및 패킷 스니핑을 원천 차단합니다.

### 3.3. `SameSite` (CSRF 공격 방어)
교차 출처(Cross-Site) 요청 시 쿠키가 전송되는 정책을 제어하여 사용자의 의도치 않은 요청 실행(CSRF)을 방어합니다.
- **`SameSite=Strict`**: 어떠한 타사 사이트 링크나 요청에서도 쿠키를 일체 전송하지 않는 가장 엄격한 모드.
- **`SameSite=Lax` (기본값)**: 사용자가 링크를 클릭하여 이동하는 최상위 탐색(Top-level GET navigation)을 제외한 서드파티 이미지, iframe, POST 요청에서는 쿠키 전송을 차단.
- **`SameSite=None`**: 모든 교차 사이트 요청에 쿠키를 전송 (반드시 `Secure` 플래그와 함께 사용해야 함).

---

## 4. 동일 출처 정책(SOP)과 교차 출처 리소스 공유(CORS)

### 4.1. 동일 출처 정책(SOP - Same-Origin Policy)
웹 브라우저는 보안을 위해 한 출처(Origin)에서 로드된 문서나 스크립트가 다른 출처의 리소스와 상호작용하는 것을 기본적으로 제한합니다. 출처는 **프로토콜(Scheme), 호스트(Host), 포트(Port)** 3가지 요소의 조합으로 판별됩니다.

- `https://example.com:443/api/user` (기준 출처)
- `https://example.com:443/board` &rarr; **Same Origin** (경로만 다름)
- `http://example.com:443/` &rarr; **Cross Origin** (프로토콜 불일치)
- `https://api.example.com:443/` &rarr; **Cross Origin** (서브도메인 호스트 불일치)
- `https://example.com:8080/` &rarr; **Cross Origin** (포트 번호 불일치)

### 4.2. CORS (Cross-Origin Resource Sharing)와 Preflight
SOP 제약 하에서도 프론트엔드와 백엔드 서버가 다른 도메인으로 분리된 경우 안전하게 데이터를 교환할 수 있도록 HTTP 헤더를 통해 권한을 위임하는 메커니즘입니다.

- 브라우저는 `PUT`, `DELETE` 요청이나 커스텀 헤더가 포함된 복합 요청 시 본 요청 전에 `OPTIONS` 메서드로 **프리플라이트(Preflight)** 질의를 서버로 전송합니다.
- 서버가 응답 헤더에 허용 정책을 명시해야 실제 요청이 수행됩니다.
  ```http
  Access-Control-Allow-Origin: https://frontend.example.com
  Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
  Access-Control-Allow-Headers: Authorization, Content-Type
  Access-Control-Allow-Credentials: true
  ```

### 4.3. 레거시 우회 기법인 JSONP의 한계
과거 CORS 표준이 정립되기 전에는 `<script>` 태그가 SOP의 제약을 받지 않는다는 점을 악용하여 콜백 함수로 JSON 데이터를 감싸서 수신하는 JSONP(JSON with Padding) 기법을 사용했습니다. 그러나 JSONP는 오직 GET 요청만 가능하고 임의 스크립트 실행으로 인한 XSS 보안 위협이 높아 현재는 완전히 사장되었습니다.
