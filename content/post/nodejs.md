+++ 
title = "Nodejs"
date = 2020-07-20T20:40:05+09:00
lastmod = 2020-07-20T20:40:05+09:00
tags = [ "nodejs", "webServer", ] 
categories = ["dev",] 
imgs = []
cover = "" # image show on top
readingTime = true # show reading time after article date 
toc = true 
comments = false 
justify = false # text-align: justify; 
single = false # display as a single page, hide navigation on bottom, like as about page. 
license = "" # CC License 
draft = false 
+++

# Nodejs
- 패키지 생성

``npm init`` 

- 라이브러리 설치

``npm install``

- 실행(main.js)

``node main.js``

## main.js
- nodejs 실행시 실행할 메인 파일
### 모듈 사용

``var express = require('express');``

``var session = require('express-session');``

``var bodyParser = require('body-parser');``

``var app = express();``

### static 설정

``app.use('/static', express.static(__dirname + '/static'));``
- '/static' 이라는 경로로 '현재경로/static' 폴더를 연결시킴, 즉 '/static/file' 을 호출하면 '현재경로/static/file' 이 호출됨

### session 설정

``app.use(session({`` -> session 사용 설정

``    secret:"SECRET_CODE",`` -> 세션을 암호화 할 시드 설정

``    resave:false,`` 

``    saveUninitialized:true``

``}));``

### body parser

``app.use(bodyParser.urlencoded({extended: false}));``
- html의 body의 내용을 express의 js파일에서 불러와 사용할 수 있도록 하는 모듈

### routing

``r_edit = require('./route/edit.js');`` -> '/edit' 경로로 요청이 오면  './route/edit.js' 파일로 연결, 라우팅 처리함

``app.use('/edit', r_edit);``

``r_login = require('./route/login.js');``

``app.use('/login', r_login);``

``r_default = require('./route/default.js');``

``app.use('/', r_default);``


### ejs

``app.set('views', './views');`` -> './view' 경로를 view로 사용, view 폴더 안에는 html파일들을 넣으면 됨

``app.set('view engine', 'html');`` -> view 를 html로 구성함

``app.engine('.html', require('ejs').renderFile);``


### Server

``var server = app.listen(80, function() {`` -> 80번 포트로 서버 오픈

``    var host = server.address().address`` -> 호스팅한 서버의 주소

``    var port = server.address().port`` -> 호스팅한 서버의 포트

``    console.log("App listening at http://%s:%s", host, port)`` -> 로그

``});``


## edit.js
- main 파일에서 라우팅을 위해 r_edit 변수에 연결시켜 사용하는 파일, ./route 폴더에 정리되어 있다. 

``var express = require('express');`` -> express 모듈 사용

``var router = express.Router();`` -> express의 routing 모듈 사용

### 함수 사용

``function stringToInt(x, base) {`` -> js 파일 안에서도 함수 정의, 사용 가능

``  const parsed = parseInt(x, base);`` -> string을 int로 변환

``  if (isNaN(parsed)) { return 0; }`` -> string이 '' 인 경우, NAN을 반환하는데, NAN을 0으로 치환

``  return parsed;`` -> 치환한 결과를 반환

``}``


### routing 설정

``router.post('/:category/:product', function(req, res, next) {`` 
- post 명령으로 / ... / ... 주소로 명령이 내려올 경우 function을 수행한다. 
- main.js에서 r_edit을 'SERVER_ADDRESS/edit' 주소로 왔을 때 실행하도록 매핑해 놓았으므로, 'SERVER_ADDRESS/edit/AAA/BBB' 주소로 명령이 내려오면 해당 함수가 동작한다. 
- AAA 자리에 들어가는 값은 req.params.category 로 참조 가능하며, BBB는 req.params.product로 참조 가능하다. 


``router.get('/:TLV', function(req, res, next) {`` -> get 명령은 router.get으로 설정 가능하다.


``module.exports = router;`` -> 마지막에 router를 exports 해야 적용이 된다.


### session 설정
``    if (req.session.user) {`` 

- main.js에서 session을 사용하였으므로 req.session으로 session에 담긴 변수들을 참조 가능하다. 
- req.session.user 값이 있으면 아래 내용을 수행한다는 코드이다. 
- 값을 집어넣을 때에도 ``req.session.val = 1`` 과 같이 사용 가능하다. 

### DB 사용

``       var mysql = require('mysql');`` -> mysql 모듈을 사용한다. 

``        var db_config = require('../config/db_config.json');`` -> config 폴더 안에 db 접속에 필요한 내용을 저장해 놓았다. js 파일과 해당 내용을 분리하여 보안을 강화시킬 수 있다. db_config.json파일은 json 데이터를 담고 있다. 

``        var connection = mysql.createConnection({`` -> mysql 연결 설정

``            host : db_config.host,`` -> db_config_json 파일의 key를 참조하여 value를 대입한다. 

``            user : db_config.user,``

``            password : db_config.password,``

``            database : db_config.database`` -> 사용할 DB 이름

``        connection.connect();`` -> 연결을 수행한다. 

``        });``

``            connection.query('UPDATE mytable SET name = ?, description = ?, price = ? where number = ?',[inputs.name, inputs.description, inputs.price, req.params.category], function (error, results, fields) {`` -> 연결된 DB에 query를 날린다.  error는 오류정보, results는 DB 결과(row)를 array형태로 반환한다. 
- query 안에 query를 넣으면 오류가 난다. 완료 후 다음 query를 진행하도록 하자.

``                console.log(this.sql);`` -> 함수 안에서 this.sql을 호출하면 query 내용을 참조할 수 있다. 

``                if (error) {`` -> 에러가 발생한 경우

``                    console.log(error);``

``                    res.status(500).json({"Error": "DB Error"});`` -> 결과 response에 status 500을 주고, json 메시지를 함께 던진다.(화면에는 Json 메시지가 출력 됨)

``                }``

``            });``

``        connection.end();``-> DB 사용을 끝내고 연결을 해제한다.


``    connection.query("SELECT * FROM user WHERE User=? AND authentication_string=PASSWORD(?)", [id, pswd], function (error, results, fields) {``
- PASSWORD() 함수는 mysql의 user DB에서 사용자의 비밀번호를 인코딩하여 authentication_string 컬럼에 해당하는 값으로 만드는 함수이다. 비밀번호를 넣으면 authentication_string값을 반환한다. 


### html 페이지 연결
- routing 함수에서 받은 요청에 대해 redirect를 할 수도 있고, render로 파일을 열 수도 있다. 

``res.redirect('/edit/' + req.params.TLV);`` -> 설정한 주소로 페이지를 리다이렉트 한다. 

``res.render('login.html', {url: target});`` -> url이란 키로 target 이라는 변수에 담긴 data를 login.html에 전달한다. html 파일에서는 url 이란 변수로 target값을 사용 가능하다. 

### html 페이지 연동
- html 페이지에서 form에 넣어서 보낸 내용은 bodyParser 모듈로 파싱하면 'req.body.변수이름' 으로 참조 가능하다. 

``           var inputs = {`` -> 내용을 받아 json 형태로 저장

``                "relation": req.body.relation,`` -> html파일의 form 태그의 input 태그중 name="relation"인 태그의 value 값을 참조 

``                "number": req.body.name}``


## index.html
- ejs모듈을 사용하여 설정한 대로 view 폴더 내에 생성한다. 
- static 설정을 마쳤기 때문에 js 파일이나 css 파일들은 미리 설정해둔 '/static' 폴더 내에서 참조 가능하다. 

``       <script type="text/javascript" src="/static/edit_func.js"></script>`` -> static 파일 호출 방법

- html 안에서 nodejs 문법을 사용하려면 <% %> 안에서 사용하면 된다. 변수 값을 바로 반환하려면 <%= %> 를 사용한다. 

``            <% var ptr = 10 %>``  -> 변수 ptr 선언

``            <% dataList.forEach(function(item, index) { %>``-> dataList의 항목들에 대해 수행, dataList는 routing function(route/index.js 안의 routing 함수)에서 ``res.render('index.html', {dataList: data});`` 로 전해준 데이터이다. 

``                <% if (dataList[ptr].number != item.number) { %>`` -> if 함수 사용 가능, if문이 false라면 아래 내용은 출력되지 않음

``                <tr id="lineTr">``

``                    <td><a href="edit/<%=item.number%>"><%= item.number %></a></td>``

``                    <td><%= item.name %></td>``

``                    <td><%= item.description %></td>``

``                    <td><%= item.superSet %></td>``

``                <% ptr = index %>``

``                <% } else { %>``

``                <tr>``

``                    <td></td>``

``                    <td></td>``

``                    <td></td>``

``                    <td></td>``

``                <% } %>``

``                    <td><%= item.relation %></td>`` -> item.relation의 값을 반환, 즉 해당 값의 내용이 <td></td> 안에 출력된다. 

``                    <td><%= item.etc %></td>``

``                    <td><%= item.bit %></td>``

``                    <td><%= item.byte %></td>``

``                    <td><%= item.value %></td>``

``                    <td><%= item.meaning %></td>``

``                    <td><%= item.history %></td>``

``                </tr>``

``            <% }); %>``



