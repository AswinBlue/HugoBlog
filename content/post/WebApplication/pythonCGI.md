+++
title = "PythonCGI"
date = 2020-07-02T19:15:21+09:00
lastmod = 2020-07-02T19:15:21+09:00
tags = [
"python",
"CGI",
"webServer",]
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
# python CGI
- CGI는 Common Gateway Interface의 약자다. 
- web application을 만들 수 있는 언어는 ruby, java, php 등 다양하지만 모두 CGI 규약을 따라 web server와 통신한다. 
- web server는 사용자의 요청을 받으면 약속된 이름의 데이터를 환경변수로 web application에 전달하여 서로 교류한다.
- apache에서 python을 이용해 web application을 만들어 web server와 통신해 보자.
- ``$ a2enmod CGI`` 명령으로 apache의 CGI를 켜 주고, ``sudo service apache2 restart`` 로 설정 적용
- ``/var/log/apache2/error.log`` 안에 apache 실행시 발생한 에러 로그가 담겨있다. 
- 웹 브라우저가 웹 서버에 요청할 때 웹 서버는 응답으로 웹 페이지의 데이터 타입(헤더)와 함께 웹 페이지를 전송한다.
python CGI로는 ``print("content-type:text/html; charset=UTF-8\n")`` 와 같이 헤더를 표기낸다. 
- 헤더를 출력한 다음 부터는 body 부분이 출력된다. 
- 특정 주소로 Redirection을 할 때에는 ``print("location : index.py?id=title")``을 이용한다. ( ':' 이후 부터 '"' 까지는 원하는대로 작성)

## formatting
- string에서 특정 문자열을 다른 문자로 치환하는 기능
    ex) ``'{} {}'.format('one','tow')`` 
    ex) ``'{a} {b}'.format(a='hello', b='world')``
- python 파일에서 문자열과 format 함수를 이용하여 동적 html을 구현 가능하다.

## CGI 모듈
- ``import cgi`` 로 모듈을 로드해 사용한다.
- ``form = cgi.FieldStorage()`` form은 jQuery와 같은 역할을 한다. 
    ex) ``pageId = form['id'].value`` : page의 id를 가져온다. 

## HTML 연동
- input 태그의 name 속성 : input 태그를 특정 이름으로 CGI에 전달함
    ex) 
  ```
  <p> <input type="text" name="title" placeholder="title"> </p>
  <p> <textarea rows="4" name="description"></textarea></p>
  <p> <input type="submit"></p>
  ```
- form 태그 : 특정 파일로 form 태그 안의 태그들을 전송
  - action 속성 : form 안의 내용을 처리할 파일(목적지)를 설정한다. 
    ex) 
     ```
    <form action="create.py">
	    <p> <input type="text" name="title" placeholder="title"> </p>
	    <p> <textarea rows="4" name="description"></textarea></p>
	    <p> <input type="submit"></p>
    </form>
	```
  - url 쿼리 스트링 생성자 역할을 한다. 
  - url 쿼리 스트링은 form 안의 input 태그의 name 속성들과 목적지(처리할 파일)를 포함하고 있다. 
  - get 방식은 쿼리 스트링을 url에 넣어서 사용하는 것이 맞다. 하지만 post 방식은 url이 아닌 다른 곳에 내용을 담아 전송하게 된다. 
  - method 속성은 get과 post 방식을 설정할 수 있다. 
      ex)
    ```
    <form action="create.py" method="post">
	  <p> <input type="text" name="title" placeholder="title"> </p>
	  <p> <textarea rows="4" name="description"></textarea></p>
	  <p> <input type="submit"></p>
    </form>
      ```

  - action 속성으로 연결한 python 파일에서 form 안의 내용들을 사용하려면 ``cgi.FieldStorage()``을 사용한다. 
    ex) 
  ```
  import cgi
  form = cgi.FieldStorage()
  title = form["title"].value
  description = form["description"].value
  ```

  - form 안의 내용 중 사용자에게 노출이필요 없는 input 태그는 type="hidden" 속성을 주어 숨긴다. 
     ex) ``<input type="hidden" name="pageId" value={}>``

- 이벤트를 이용하여 form 안의 내용들을 특정 python 파일로 전송시키면 python 파일에서 내용을 처리하고 다른 html로 redirection 시키는 방식으로 웹 구성이 가능하다. 

## cross site scripting (xss)

- 웹 페이지의 script란을 임의로 작성하여 의도되지 않은 동작을 하도록 하는 행위
- 컴퓨터가 html 파일을 해석할 때, ``<script>``를 만나면 출력 대상이 아닌, javascript로 처리해야 할 태그로 인식한다. xml 문법에 사용되는 특수문자를 대체하여 이를 막을 수 있다. 
  - `` '<' : &lt; ``
  -  `` '>' : &gt; ``
  ex) `` ''.replace('<','&lt;') ``

- "python html sanitizer" 로 검색하면 관련 패키지 검색이 가능하다.


## 정리
- python package Index (PyPI): python 패키지들의 목록이 저장되어 있는 곳, 필요한 패키지를 활용하자.
- CGI는 느려서 최근에는 잘 쓰이지 않고, FastCGI, 파이썬 전용 WSGI 등이 쓰인다. 
- web framework : 웹에서 사용되는 공통적 작업들만 잘 추려서 만든 APIdjango, flask 가 이에 해당. 
- Database 연동
- Crawling: 웹페이지를 다운로드, 분석이 필요 (urllib, beautiful Soup 패키지 활용 가능)
- github의 trending 탭을 보면 현재 가장 인기 있는 패키지를 볼 수 있다.

