---
title: "웹 스크래핑 핵심 가이드: XPath 문법, 정규표현식, User-Agent 차단 우회"
date: 2021-08-23T19:00:44+09:00
lastmod: 2021-08-23T19:00:44+09:00
description: "효율적인 웹 데이터 수집을 위한 XPath 경로 탐색 문법, 데이터 정제를 위한 정규표현식(Regex) 핵심 패턴, 그리고 봇 차단 방지를 위한 User-Agent 헤더 설정 팁을 정리합니다."
slug: "web-scraping-xpath-regex-user-agent-guide"
categories: ["DevelopTips"]
tags: ["web-scraping", "xpath", "regex", "python", "crawler", "development-tips"]
ShowToc: true
TocOpen: true
draft: false
---

# 웹 스크래핑 핵심 가이드

웹 페이지에서 필요한 정보를 수집하고 가공하기 위한 핵심 파싱 기법과 네트워크 헤더 설정 팁입니다.

## 1. XPath 기초 경로 문법
XPath(XML Path Language)는 HTML/XML 문서의 노드 트리를 탐색하기 위한 경로 표기 언어입니다:
- `/a/b/c`: 절대 경로를 따라 특정 부모-자식 구조의 노드를 탐색
- `//*[@id="abcd"]`:
  - `//`: 루트뿐 아니라 문서 전체의 모든 하위 경로에서 재귀적으로 탐색
  - `*`: 모든 태그 대상 (특정 태그만 탐색할 경우 `//div[@id="abcd"]`와 같이 태그명 명시)
  - `[@id="abcd"]`: 속성(attribute) 중 `id` 값이 "abcd"인 노드를 필터링
- 브라우저 개발자 도구(F12)에서 요소를 우클릭한 후 `Copy > Copy XPath`를 통해 손쉽게 경로를 획득할 수 있습니다.

## 2. 웹 데이터 추출을 위한 정규표현식 (Regex)
HTML 파싱 후 텍스트 문자열 내에서 특정 패턴을 추출하거나 정제할 때 정규표현식을 활용합니다:
- `.`: 임의의 단일 문자 1개
- `^`: 문자열의 시작 위치
- `$`: 문자열의 끝 위치
- `*`: 앞의 문자가 0회 이상 반복
- `+`: 앞의 문자가 1회 이상 반복
- `\d`: 임의의 숫자 1개 (`[0-9]`)
- `\s`: 공백 문자 (스페이스, 탭, 줄바꿈)
- `[a-zA-Z]`: 알파벳 문자 매칭

[Python Regex W3Schools 가이드](https://www.w3schools.com/python/python_regex.asp)를 참고하여 패턴을 조합할 수 있습니다.

## 3. 크롤링 차단 우회를 위한 User-Agent 설정
대부분의 웹 서버는 자동화된 봇(Bot)이나 스크래퍼의 접근을 차단하기 위해 HTTP Request Header의 `User-Agent` 값을 검증합니다:
- 기본 Python 라이브러리(`urllib`, `requests`)는 `python-requests/2.x`와 같은 식별자를 전달하므로 403 Forbidden 응답을 받을 수 있습니다.
- 실제 사용자가 사용하는 일반 웹 브라우저(Chrome, Edge 등)의 헤더 문자열을 수집하여 요청에 주입해야 합니다:
  ```python
  import requests

  headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  }
  response = requests.get('https://target-site.com', headers=headers)
  ```

## 4. 참고 자료
- [BeautifulSoup 공식 문서](https://beautiful-soup-4.readthedocs.io/en/latest/)
- [Python re 정규표현식 문서](https://docs.python.org/ko/3/library/re.html)
