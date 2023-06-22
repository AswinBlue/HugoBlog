+++
title = "JavaScript"
date = 2020-06-23T20:38:45+09:00
lastmod = 2020-06-23T20:38:45+09:00
tags = [
    "javaScript",
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

# JavaScript
 - 기본적으로 HTML 위에서 돌아가는 코드
 1) body 태그 안에 <script> </script> 태그를 넣고 안에 작성
    - document를 호출하고, .으로 함수를 호출한다.
    - querySelector('')로 원하는 element 선택 가능, ''안의 내용은 css 선택자 문법과 같음
    - querySelectorAll('')로 원하는 속성의 element들을 nodeList(배열과 유사)형태로 선택 가능

       ex ) ``document.querySelector('body')``

       ex ) ``document.querySelector('#new')``

       ex ) ``document.write("hello world")``

 2) 태그 안에 javaScript를 사용하는 속성값으로 사용

    ex ) ``<input type="button" value="hello" onclick="alert('hello')">``

    - 특정 태그 안에서 자기자신을 호출할 때에는 querySelector를 호출하지 않고 this를 사용하면 된다.

       ex ) ``<input type="button" id="hello" onclick="document.querySelector('#hello').style.color='black';">``

       ex ) ``<input type="button" id="hello" onclick="this.style.color='black';">``

    - var 로 변수를 선언 가능하다. (var 이 없어도 된다)

 3) 별도의 파일로 분리한 후 파일의 링크를 지정한다.

    ex ) ``<script src="script.js"> </script>``


## 연산자
 - = : 대입 연산자
 - == : 비교 연산자, 좌항과 우항이 같으면 true
 - === : 비교 연산자, 좌항과 우항의 type 까지 비교

   ex ) ``null === undefined : false``

   ex ) ``null == undefined : true``

   ex ) ``123 == "123" : true``

   ex ) ``123 === "123" : false``

 - \+ : 덧셈 연산자, 문자열 병합에도 사용 가능

## 배열
 - var NAME = [] 형태로 선언
 - .length : 배열의 길이를 반환하는 메소드

## 함수 선언
 - function FUNCTION_NAME () {} 형태로 함수 선언, ()안에는 인자가, {}안에는 함수 body가 들어간다.
 - 인자로 self를 넣으면 python의 함수가 호출된 객체를 지칭하도록 사용할 수 있다.
 - return 예약어를 통해 함수 종료시 값을 반환 가능(return 필수 아님)
 - 동일한 이름의 함수가 다시 정의되면 이전의 함수는 삭제된다.

## 객체
 - var NAME = {}; 형태로 선언 가능

   ex ) ``var coworker = {"designer" : "A", "programmer" : "B", "data scientist" : "C"};``
 - 객체의 값은 . 이나 [] 로 참조 가능, property라고 칭한다.

   ex ) ``coworker.designer``

   ex ) ``coworker["data scientist"]``

 - 객체의 필드들은 ,로 구분해야 한다. 함수도 {} 다음에 ,를 찍어준다.

   ex ) ``var coworker = { "designer":"A", showAll:function( ){ }, "programmer":"B" }``

 - 이미 선언된 객체에 새로운 값 추가 혹은 기존 값 변경 가능

   ex ) ``coworker.new = "D"``

   ex ) ``coworker.programmer = "E"``

 - for ( .. in \~\~ ) {}  : 객체 내부 순회, ..는 내부 원소를 지칭할 변수를 선언하고, \~\~에는 객체를 넣어준다.

   ex ) ``for (var key : coworker) {}``
 - 객체 내부에 함수도 선언 가능, method라고 칭한다.

   ex ) ``var body = { setColor:function( ){ } }``

   ex ) ``coworker.setColor = function() {}``

 - 객체 내부의 메소드에서 객체를 칭할 때에는 this를 사용

   ex ) ``funciton () { for (var key in this) {} }``


## 데이터 타입
 - primitive
    * Boolean
    * Null
    * Undefined
    * Number
      - 연산으로 계산 가능
    * String
      - ' ' 나 " " 로 묶어서 사용
      - \+ 으로 concatenate 가능
    * Symbol
 - Object

### 문자열 (String)
 - `.startWith(STRING)` : 문자열이 STRING 으로 시작하면(prefix) true를 반환, 아니면 false를 반환 
 - `.slice(VALUE)` : 시작점으로 부터 VALUE만큼의 글자를 제거 (문자열 자르기)
 - `.substring(VALUE)` : 시작점으로 부터 VALUE만큼의 글자를 제거 ()
 - `.replace("/^AB", '')` : 정규식을 이용, AB로 시작하는 prefix 제거 (문자열 치환)
 
### Json
 - `.hasOwnProperty(KEY)` : json 데이터에 KEY 라는 key가 존재한다면 true를 반환, 아니면 false를 반환

## 이벤트
 - onclick : 클릭 이벤트가 일어났을 때
 - onchange : 텍스트 에디터의 내용이 변경되었을 경우
 - onkeydown : 키를 눌렀을 때

## 메소드
 - alert(' ') : 브라우저의 경고창에 '' 안의 내용을 띄움
 - .length : 문자열의 길이를 반환, 배열의 길이를 반환
 - .indexOf(' ') : 문자열 중 ''에 속하는 문자 혹은 문자열이 시작되는 index를 반환, 0부터 카운팅
 - .trim() : 문자열의 공백을 제거
 - .value : element의 값을 뜻하는 변수 호출


## 함수
 - `var repeat = setInterval(function, time)` : time 만큼 delay를 주고 function을 반복한다. 독립 thread로 동작한다.
 - `clearInterval(repeat)` : 인자로 받은 interval 반복함수를 정지한다.
 - `var result = setTimeout(function, time)` : time만큼 delay후 function을 실행한다. 실행후 result에는 'true'가 저장된다.

## Jquery
 - javascript상에서 document를 대체하여 사용성을 높인 라이브러리
 - ``$()`` 로 시작한다.

   ex ) ``$('a').css('color','red')``  : 모든 'a' 태그의 css 속성 중 color을 red로 변경

## 참조
 - document < DOM (Document Object Model) < window
 - ajax : 웹페이지를 변경하지 않고 내용 변경
 - cookie : 사용자에게 개별화된 서비스 제공
 - offline web application : 인터넷이 끊겨도 동작하는 어플리케이션
 - webRTC : 화상통신 웹
 - speech(로 시작하는 API) : 사용자 음성 처리
 - webGL : 3차원 그래픽
 - webVR : 가상현실
