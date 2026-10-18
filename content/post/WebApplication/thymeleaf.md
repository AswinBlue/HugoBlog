---
title: "Spring Boot 환경에서 Thymeleaf 템플릿 엔진을 활용한 서버 사이드 렌더링(SSR)"
description: "스프링 부트(Spring Boot) 환경에서 Thymeleaf 템플릿 엔진의 th:text, th:each, th:if 문법, Model 객체 데이터 바인딩, 프래그먼트 레이아웃 모듈화 기법을 체계적으로 정리합니다."
slug: "spring-boot-thymeleaf-ssr-template-guide"
date: 2022-06-29T20:00:00+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebApplication"]
tags: ["thymeleaf", "spring-boot", "java", "ssr", "web-development"]
ShowToc: true
TocOpen: true
---

Thymeleaf는 Java Spring Boot 생태계에서 가장 널리 사용되는 최신 서버 사이드 템플릿 엔진(Server-side Template Engine)입니다. 웹 브라우저에서 파일을 직접 열어도 정상적인 정적 디자인이 유지되는 **내추럴 템플릿(Natural Template)** 특성을 지니며, 스프링 MVC의 `Model` 객체와 유연하게 통합되어 동적 웹 페이지를 생성합니다.

이 글에서는 Thymeleaf의 기본 구동 원리부터 표준 표현식, 제어문(`th:if`, `th:each`), XSS 방어 텍스트 바인딩, 그리고 프래그먼트를 활용한 레이아웃 모듈화 기법을 정리합니다.

---

## 1. Thymeleaf 템플릿 엔진 개요 및 특징

기존 JSP와 달리 Thymeleaf는 순수 HTML 파일의 속성(Attribute) 형태로 문법을 작성하므로 디자이너와 백엔드 개발자 간의 협업에 최적화되어 있습니다.

- **내추럴 템플릿 지원**: 서버 구동 없이도 로컬 브라우저에서 퍼블리싱 화면을 그대로 미리보기할 수 있습니다.
- **Spring EL 완벽 연동**: 스프링 프레임워크의 Expression Language 및 폼 유효성 검증(Validation)과 긴밀하게 결합됩니다.

스프링 부트의 `build.gradle`에 스타터 의존성을 추가하여 즉시 활성화할 수 있습니다.

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
    implementation 'org.springframework.boot:spring-boot-starter-web'
}
```

---

## 2. Thymeleaf 핵심 표현식 문법

Thymeleaf는 용도에 따라 서로 다른 기호의 표현식(Expression) 체계를 제공합니다.

- **변수 표현식 (`${...}`)**: 컨트롤러의 `Model`에 담긴 객체 프로퍼티를 조회합니다.
  ```html
  <p th:text="${user.name}">홍길동</p>
  ```
- **선택 변수 표현식 (`*{...}`)**: `th:object`로 지정된 객체의 하위 필드를 축약 참조합니다.
  ```html
  <div th:object="${user}">
    <span th:text="*{email}">test@example.com</span>
  </div>
  ```
- **링크 URL 표현식 (`@{...}`)**: 애플리케이션의 컨텍스트 패스 및 쿼리 파라미터를 자동으로 처리하는 링크를 생성합니다.
  ```html
  <a th:href="@{/board/detail(id=${post.id}, page=1)}">게시글 보기</a>
  ```
- **메시지 표현식 (`#{...}`)**: 다국어 프로퍼티 파일(`messages.properties`)의 메시지 키를 매핑합니다.

---

## 3. 데이터 바인딩 및 제어 지시자

### 3.1. 텍스트 바인딩 (`th:text` vs `th:utext`)
- **`th:text`**: 특수문자(`<`, `>`, `&`)를 자동으로 HTML 엔티티로 이스케이프하여 출력하므로 **XSS 공격을 원천 방어**합니다.
  ```html
  <!-- Model에 담긴 <b>강조</b>가 문자열 그대로 &lt;b&gt;강조&lt;/b&gt; 로 안전하게 렌더링됨 -->
  <span th:text="${content}">기본 텍스트</span>
  ```
- **`th:utext`** (Unescaped Text): HTML 태그를 그대로 반영하여 브라우저에 렌더링합니다. 신뢰할 수 없는 사용자 입력값에 적용 시 보안 취약점이 발생하므로 주의해야 합니다.

### 3.2. 조건부 렌더링 (`th:if`, `th:unless`)
`th:if`는 조건이 참일 때, `th:unless`는 조건이 거짓일 때 해당 태그를 DOM에 렌더링합니다.

```html
<!-- 관리자 권한이 있는 경우 노출 -->
<button th:if="${user.role == 'ADMIN'}">관리자 대시보드</button>

<!-- 비로그인 상태일 때 노출 -->
<a th:unless="${user != null}" th:href="@{/login}">로그인</a>
```

### 3.3. 반복 렌더링 (`th:each`)
컬렉션이나 배열을 순회하며 반복 태그를 동적으로 생성합니다.

```html
<table>
  <thead>
    <tr>
      <th>순번</th>
      <th>제목</th>
      <th>작성자</th>
    </tr>
  </thead>
  <tbody>
    <tr th:each="post, iterStat : ${postList}">
      <td th:text="${iterStat.count}">1</td>
      <td th:text="${post.title}">제목</td>
      <td th:text="${post.author}">작성자</td>
    </tr>
  </tbody>
</table>
```
`iterStat` 상태 변수를 통해 `index`(0부터 시작), `count`(1부터 시작), `size`, `first`, `last` 등의 유용한 메타 정보를 조회할 수 있습니다.

---

## 4. 프래그먼트(Fragment)를 활용한 공통 레이아웃 모듈화

헤더, 푸터, 네비게이션 바 등 웹 페이지 전반에 반복되는 컴포넌트는 프래그먼트로 선언하여 재사용성을 극대화합니다.

### 4.1. 프래그먼트 정의 (`th:fragment`)
공통 레이아웃 파일(예: `templates/fragments/header.html`)을 생성하고 프래그먼트 이름을 부여합니다.

```html
<!-- templates/fragments/header.html -->
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
  <meta charset="UTF-8">
</head>
<body>
  <header th:fragment="mainHeader">
    <div class="logo">웹 서비스 로고</div>
    <nav>
      <a th:href="@{/}">홈</a>
      <a th:href="@{/board}">게시판</a>
    </nav>
  </header>
</body>
</html>
```

### 4.2. 프래그먼트 삽입 및 교체 (`th:replace`, `th:insert`)
- **`th:replace`**: 현재 선언된 태그 자체를 대상 프래그먼트 태그로 완전히 대체합니다.
- **`th:insert`**: 현재 선언된 태그의 자식 요소(Inner HTML)로 대상 프래그먼트를 삽입합니다.

```html
<!-- templates/index.html -->
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
  <title>메인 페이지</title>
</head>
<body>
  <!-- fragments/header.html의 mainHeader 조각으로 교체 -->
  <div th:replace="~{fragments/header :: mainHeader}"></div>

  <main>
    <h1>환영합니다!</h1>
  </main>
</body>
</html>
```
이러한 프래그먼트 분리를 통해 헤더나 푸터 디자인이 변경되더라도 개별 페이지를 수정할 필요 없이 공통 템플릿 한 곳만 수정하면 전체 페이지에 즉시 반영됩니다.