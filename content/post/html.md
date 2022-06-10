+++
title = "Html"
date = 2020-06-23T19:13:17+09:00
lastmod = 2020-06-23T19:13:17+09:00
tags = [
    "html",
    "webServer",
]
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
# HTML
- W3C에서 HTML 규칙을 규정, 웹 브라우저 제작사들이 이를 참조하여 브라우저를 만든다.

## 태그

- element라고 칭하기도 한다.
- 부모 자식 관계가 존재
- ``<TAG_NAME>`` 로 시작하고 ``</TAG_NAME>``로 끝냄
- 태그별로 검색 엔진에서 노출되는 중요도가 다르다.
- 태그의 종류에 따라 줄 전체를 사용하거나(block level element), 내용의 크기 만큼의 공간만 사용하는 태그(lnline element)들이 있다.
- html : body와 head를 통틀어 묶은 최 고위 태그
- 관용적으로 <!doctype html> 을 붙여 쓴다.
- body : 본문을 묶는 태그
- head : 본문을 설명하는 태그

### body 태그

- strong : 굵은 글씨
- u : 밑줄
- h1 : 제목 1
- h2 : 제목 2
- h6 : 제목 6
- p : 단락 설정
- br : 줄바꿈
- img : 이미지
- ``<img src="">`` : src에 경로 지정
- li : 리스트
  - ul태그를 부모로 가짐
- ul : 리스트 그루핑을 위한 태그
  - li 태그를 자식으로 가짐
  - unordered-list
- ol : 넘버링 되는 리스트를 위한 태그
  - ordered-list
- a : 링크
  - Anchor의 약자
  - href 속겅 필요 (hypertext reference)
  - target : 창을 여는 방법, "_blank" : 새창
  - title : 마우스 오버레이시 툴팁 표시
- input :
  - type="checkbox" : 체크박스
  - type="button" : 버튼
    - onclick="" : "" 사이에는 javascript가 들어간다. 버튼 클릭 시 동작할 내용
 ``<input>`` 으로 끝난다. ``<input/>`` 이나 ``<input> </input>`` 으로 사용하지 않는다.

- font :
  - css가 등장하기 이전에 문자의 스타일을 설정하게 하기 위함
  - 어껀 정보도 없는 태그, 기자인만을 위함
- class : 태그들을 특정 그룹으로 묶기 위함
  - 하나의 태그에 두 개 이상의 class 지정 가능
- id : 특정 태그에 명칭을 붙이기 위함
  - class 보다 높은 우선순위
  - 단 한 번만 사용하도록 권장, 중복하여 사용하지 않도록 한다.
- div : 아무 의미 없이 디자인의 용도로만 사용하는 태그, block element
- span : div와 같지만 inline element
- form : 폼 데이터 전송을 위한 태그, 하위
  - action : 데이터를 어디로 전송할지 나타내는 속성
  - method : 데이터를 어떻게 전송할지 나타내는 속성. post/get을 사용 가능하다.


### head 태그

- title : 제목
- meta :
  - <meta charset="utf-8">
  - 현재는 사용되자 않음
- style : CSS 코드 삽입부


## 속성(attribute)
<TAG_NAME ATTRIBUTE> 와 같은 형태로 태그 이름 뒤에 붙음
