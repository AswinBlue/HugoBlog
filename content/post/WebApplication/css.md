+++
title = "Css"
date = 2020-06-23T20:38:05+09:00
lastmod = 2020-06-23T20:38:05+09:00
tags = [
    "css",
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

# CSS
 - 특정 개체에 효과를 부과한다. 이를 declaration 이라 칭한다. 
 - 중복의 제거 가능, 유지보수 수월, 가독성 증가
 - 위에서 부터 아래로 읽어가며 효과 적용, 중복 불가능한 효과에 대해서는 이전 효과가 사라짐
 - tag 선택자 < calss 선택자 < id 선택자 로 우선 순위가 높다. 

 1) html 문서 안에 ``<style>`` 태그 안에 작성 가능
             
       ex ) ``<style> a { color:black; } </style>``
       
   - 태그의 종류별로 속성 설정 가능
   - 여기서 태그 a 는 선택자(selector)라고 한다. 
   - 선택자는 ,로 구별하여 함께 사용 가능
  
      ex ) ``<style> a, h1 { color:black; } </style>``
      
   - 특정 태그의 자식태그 중 하나의 속성을 지정하고 싶다면 띄워쓰기로 구분한다. 
    ex ) <style> #grid ol { padding-left:3px; } </style>
   - 중괄호{} 안에 declaration을 작성한다. 
   - 하나의 declaration은 ;로 끝나서 다음 declaration과 구분된다. 
 2) 특정 태그 안에 style 속성을 넣어 작성 가능
  
      ex ) ``<a style="color:black"> </a>``
 3) 다른 파일로 만들어 사용 가능
  - 재사용이 가능해 가장 효율적인 방법
  - 웹페이지 안에 직접 css를 넣는 것이 트래픽적 관점에서는 더 효율적이지만, 재사용성과 캐싱 기법에 의해 본 기법이 더 효율적이다.
  
      ex ) ``<link rel="stylesheet" href="style.css"> ``

 - 특정 태그(element)를 지정해 효과 설정이 가능하다.

    ex ) ``<style> a { color:black; } </style>``
 - 특정 class를 지정해 효과 설정이 가능하다. class를 지칭할 때에는 이름 앞에 . 을 찍는다. 태그 선택자 보다 우선 순위가 높다. 

    ex ) ``<style> .saw{color:gray;} </style>``
 - 특정 id를 지정해 효과 설정이 가능하다. id를 지정할 때에는 이름 앞에 # 을 찍는다. class보다 우선 순위가 높다. 

    ex ) ``<style> #active{color:red;} </style>``

## 스타일
 - PROPERTY:PROPERTY_VALUE; 형태로 존재한다. 
 - color:red : 색깔 변경(빨강)
 - text-decoration:none : 꾸미기 없음
 - text-decoration:underline : 밑줄
 - font-size:45px : 글자 크기 설정
 - text-align:center : 글자 정렬 설정(가운데 정렬)
 - border-width:5px : 테두리 굵기 설정
 - border-color:red : 테두리 색상 설정
 - border-style:solid : 테두리 모양 설정(직선)
   - border 스타일 및 일부 스타일은 축약해서 사용 가능하다. 

     ex) ``<style> a{ border: 5px red solid;} </style>``
 - border-bottom: 1px solid gray : 아래쪽 테두리에만 설정 적용
 - display:inline : 태그의 레벨 속성(inline element - block element)을 변경
 - display:none : 화면에 표시 안함
 - display:grid : grid 형태로 표시
 - grid-template-colums: 150px 1fr : 그리드 형태를 열로 하고, 첫 열은 150, 둘째 열은 남은 공간을 사용하도록 설정
 - padding:20px : 테두리와 내용 사이의 버퍼 설정
 - margin:10px : 테두리 바깥과 다른 element 사이의 버퍼 설정
 - width:100px : element 폭 설정


## 단위
- px : 픽셀
- fr : 남은 자유공간으로 그 크기는 ((현재 fr 수치 / <총 사용된 fr>) * 남은 공간) 으로 계산된다. 

## 미디어 쿼리
- 반응형 웹(responsive web) 을 위한 내용
- @media() {} 와 같이 표현되며, () 안에는 조건문이 들어가고, {} 안에는 적용 할 내용이 들어간다. 
  
  ex ) ``<style> @media(min-width:800px) {div {display:none;}} </style>``

- http://caniuse.com : 특정 스타일을 사용했을 때 몇 %의 브라우저가 해당 스타일을 지원하는지 확인 가능한 사이트

