---
title: "Python CGI 스크립트를 활용한 레거시 웹 서버 데이터 처리와 보안 고려사항"
description: "공용 게이트웨이 인터페이스(CGI)의 동작 메커니즘과 파이썬 cgi 모듈을 통한 폼 데이터 파싱, 환경 변수 읽기 및 XSS/인젝션 방어법을 정리합니다."
slug: "python-cgi-web-server-and-security"
date: 2020-07-02T19:15:21+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebApplication"]
tags: ["python", "cgi", "web-server", "backend", "security"]
ShowToc: true
TocOpen: true
---

CGI(Common Gateway Interface)는 웹 서버(Apache, Nginx 등)가 클라이언트로부터 수신한 동적 요청을 외부 프로그램(Python, Perl, C 등)에 전달하고, 그 실행 결과를 웹 브라우저로 반환하기 위한 표준 통신 규약입니다. 현대에는 WSGI나 비동기 ASGI 기반 웹 프레임워크(Django, Flask, FastAPI)가 표준으로 자리 잡았으나, CGI의 동작 메커니즘을 이해하는 것은 웹 서버와 백엔드 간 통신 원리를 파악하는 데 매우 유익합니다.

이 글에서는 Apache 환경에서의 Python CGI 구동 방식, HTTP 헤더/본문 전송 규칙, 폼 데이터 처리 및 XSS 보안 대응 방안을 정리합니다.

---

## 1. CGI(Common Gateway Interface) 개념과 동작 원리

사용자가 웹 브라우저를 통해 동적 페이지를 요청하면, 웹 서버는 해당 요청을 처리할 수 있는 스크립트를 독립 프로세스로 실행하고 환경변수와 표준 입출력(Standard I/O)을 통해 데이터를 주고받습니다.

### 1.1. 웹 서버와 스크립트 간 통신 구조
1. 브라우저가 웹 서버에 URL 파라미터나 폼 데이터를 포함하여 HTTP 요청을 전송합니다.
2. 웹 서버(Apache 등)는 요청 정보를 파이썬 스크립트의 환경변수(`QUERY_STRING`, `REQUEST_METHOD` 등) 및 표준 입력(`stdin`)으로 주입합니다.
3. 파이썬 스크립트가 표준 출력(`stdout`)으로 생성한 HTTP 응답 문자열을 웹 서버가 받아 브라우저로 최종 전송합니다.

### 1.2. Apache 웹 서버 CGI 모듈 활성화
Ubuntu/Debian 환경의 Apache2 웹 서버에서 CGI를 구동하기 위한 기본 설정 절차는 다음과 같습니다.

```bash
# Apache CGI 모듈 활성화
sudo a2enmod cgi

# Apache 서비스 재시작
sudo systemctl restart apache2

# 에러 발생 시 로그 확인
tail -f /var/log/apache2/error.log
```

---

## 2. HTTP 헤더 응답과 파이썬 CGI 스크립트 작성

웹 브라우저가 응답 데이터를 정상적으로 파싱하기 위해서는 본문(Body) 출력 전에 반드시 적절한 HTTP 헤더(Header)를 출력하고 빈 줄(`\n\n`)로 헤더의 끝을 알려야 합니다.

### 2.1. Content-Type 헤더와 동적 HTML 출력
파이썬 스크립트 최상단에 실행 인터프리터 경로(Shebang)를 지정하고 실행 권한(`chmod +x`)을 부여해야 합니다.

```python
#!/usr/bin/env python3
import sys

# HTTP 응답 헤더 출력 (헤더와 본문 사이는 개행 문자 2개로 구분)
print("Content-Type: text/html; charset=UTF-8\n")

# 동적 HTML 본문 출력
page_title = "Python CGI 예제"
content = "안녕하세요, 파이썬 CGI로 생성된 동적 웹 페이지입니다."

html_template = f"""
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>{page_title}</title>
</head>
<body>
    <h1>{page_title}</h1>
    <p>{content}</p>
</body>
</html>
"""

print(html_template)
```

### 2.2. Location 헤더를 활용한 리다이렉션
작업 완료 후 사용자를 다른 URL로 이동시키고자 할 때는 `Location` 헤더를 출력합니다.

```python
#!/usr/bin/env python3
# 처리 완료 후 index.py로 리다이렉트
print("Status: 302 Found")
print("Location: index.py?status=success\n")
```

---

## 3. HTML Form 데이터 수신 및 파싱 (`cgi.FieldStorage`)

클라이언트가 전송한 GET 쿼리스트링 또는 POST 페이로드는 파이썬의 표준 `cgi` 모듈(또는 `urllib.parse`)을 통해 딕셔너리와 유사한 형태로 파싱할 수 있습니다.

### 3.1. 클라이언트 Form 마크업 구성
```html
<!-- create.html -->
<form action="/cgi-bin/create.py" method="POST">
  <p><input type="text" name="title" placeholder="글 제목 입력" required></p>
  <p><textarea name="description" rows="5" placeholder="내용 입력"></textarea></p>
  <!-- 사용자에게 노출하지 않는 식별자 전송 -->
  <input type="hidden" name="category_id" value="101">
  <p><input type="submit" value="저장하기"></p>
</form>
```

### 3.2. 백엔드 스크립트의 폼 데이터 추출
```python
#!/usr/bin/env python3
import cgi
import html

print("Content-Type: text/html; charset=UTF-8\n")

# 폼 데이터 파싱 객체 생성
form = cgi.FieldStorage()

# getvalue를 사용하여 안전하게 파라미터 값 추출 (키가 없으면 None 반환)
title = form.getvalue('title', '제목 없음')
description = form.getvalue('description', '내용 없음')
category_id = form.getvalue('category_id', '0')

print(f"<p>등록된 제목: {html.escape(title)}</p>")
print(f"<p>등록된 내용: {html.escape(description)}</p>")
```

---

## 4. 웹 보안 기초: XSS(Cross-Site Scripting) 방어

사용자가 입력한 악의적인 자바스크립트 코드(`<script>alert('해킹')</script>`)가 웹 브라우저에 그대로 출력되면 세션 쿠키 탈취 등의 위험이 발생합니다.

### 4.1. HTML 엔티티 이스케이프 처리
특수문자를 HTML 엔티티 코드로 치환하여 브라우저가 스크립트로 실행하지 않고 단순 텍스트로 안전하게 렌더링하도록 처리해야 합니다.
- `<` &rarr; `&lt;`
- `>` &rarr; `&gt;`
- `&` &rarr; `&amp;`
- `"` &rarr; `&quot;`

```python
import html

raw_user_input = "<script>stealCookies();</script>"
# 표준 html.escape 함수를 활용한 특수문자 무력화
safe_output = html.escape(raw_user_input)
# 결과: &lt;script&gt;stealCookies();&lt;/script&gt;
```

---

## 5. CGI의 한계와 모던 파이썬 웹 프레임워크 (WSGI/ASGI)

- **CGI의 한계점**: 클라이언트의 HTTP 요청마다 매번 새로운 파이썬 프로세스를 생성(Process Fork)하고 종료하므로, 동시 접속자가 증가하면 CPU 및 메모리 오버헤드가 급격히 증가하여 대규모 트래픽 처리가 불가능합니다.
- **FastCGI / WSGI (Web Server Gateway Interface)**: 데몬 형태로 프로세스 풀을 유지하면서 요청을 지속 처리하는 PEP 3333 표준 규약입니다. 이를 기반으로 **Flask**, **Django**와 같은 강력한 웹 프레임워크가 발전하였습니다.
- **ASGI (Asynchronous Server Gateway Interface)**: WebSocket 및 비동기 I/O를 지원하는 차세대 표준으로, **FastAPI**와 같은 고성능 비동기 API 서버의 기반이 됩니다.
