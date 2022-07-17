+++
title = "thymeleaf"
date = 2022-06-29T20:00:00+09:00
lastmod = 2022-06-29T20:00:00+09:00
tags = ['html', 'jsp',]
categories = ['dev',]
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = false
+++

# Thymeleaf
- 서버에서 view를 구성할 때 사용하는 라이브러리
- 태그 형식의 문법을 사용하며 vue와 유사하다.

## 기본 문법
- [thymeleaf 공식 튜토리얼](https://www.thymeleaf.org/doc/tutorials/2.1/usingthymeleaf.html) 에서 기본적인 문법을 확인할 수 있다.
- 태그 안에  `th:속성="값"` 형태의 속성을 추가하는 형태로 사용한다.

1. text
  - `<span th:text="${text}">default text</span>`: 서버에서 'text'라는 이름으로 정의한 태그가 있으면 text를 표시한다. text변수가 없으면 `<span>default text</span>`를 표시한다.  
1. utext
  - `<span th:utext="${utext}">default text</span>`: 'text' 이름으로 정의한 텍스트를 'span' 태그에 넣어 표시한다. 'text'변수가 없으면 'default text'를 표시한다.
1. fragment
  - `<div th:fragment="name">`: 'name' 이라는 이름으로 fragment를 생성한다. fragment는 `th:replace`, `th:copy` 를 사용해서 재활용 가능하다.
1. copy
  - `<div th:copy="this::name">`: 현재 파일의 'name' fragment를 'div'태그로 표현한다. 'this' 대신 파일 이름을 사용하면 다른 파일의 fragment를 사용 가능하다.
1. replace
  - `<div th:replace="this::name">`: 현재 파일의 'name' fragment로 대체한다.(태그도 바뀐다.) 'this' 대신 파일 이름을 사용하면 다른 파일의 fragment를 사용가능하다.