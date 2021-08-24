+++
title = "Web_scrapping"
date = 2021-08-23T19:00:44+09:00
lastmod = 2021-08-23T19:00:44+09:00
tags = ["web", "scrapping", "regular expression",]
categories = ["dev",]
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

# Web Scrapping
## x-path
- ``/a/b/c/d/e/f/g/...`` 와 같이 특정 경로를 가진 개체를 가리키는 방법이다.
- ``//*[@id="abcd"]``
  - // 는 모든 경로에서 찾겠다는 의미
  - * 는 모든 태그에 대해 찾겠다는 의미. *대신 TAG를 넣으면 'TAG' 라는 이름의 태그를 가진 항목에서만 검색함
  - @id="abcd" 는 id라는 속성이 abcd 인 항목을 찾겠다는 의미
  - 브라우저에서 자동으로 해줒기 때문에 보통은 걱정할 필요가 없다.

## 정규식
- \. : 하나의 문자
- \^ : 문자열의 시작
- \$ : 문자열의 끝
- \* : 모든 문자
- \# : 하나의 숫자

[정규식 참조 link](https://www.w3schools.com/python/python_regex.asp)


## Useragent
- 특정 페이지에서는 request 헤더를 확인하여 매크로 접속을 막는 경우가 있다.
- 서버에서는 useragent 정보를 확인하여 접속하는 웹 브라우저, 기기 등의 정보를 확인할 수 있다.

## 참조
https://www.youtube.com/watch?v=yQ20jZwDjTE
https://www.w3schools.com/python/python_regex.asp
