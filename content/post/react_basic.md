+++
title = "React basic"
date = 2021-08-23T18:46:22+09:00
lastmod = 2021-08-23T18:46:22+09:00
tags = ["react", "javascript", "web application"]
categories = ["dev", "basic",]
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

# React basic

## 개발환경 설치 및 실행
1. node.js 로 만들어진 create-react-app 툴을 이용하면 손쉽게 react 앱을 생성할 수 있다.
 - npm을 설치하고 아래 명령어를 수행한다.
 `npm install -g create-react-app`

2. 원하는 경로에 들어가 프로젝트를 생성한다.
 - 주의 : 프로젝트가 생성되는 폴더명은 대문자를 사용할 수 없다.

3. 실행
 - `npm run start` 를 수행하면 `localhost:3000`에서 웹페이지를 퍼블리싱한다.

## 기본 구조
1. /public/index.html 에서 기본 화면 구성
 - 'root' 이름으로 된 division이 있는데, 이 division에 대한 설정은 javascript로 정의되어있다.
2. src 경로에 javascript파일들 구성
 - 'index.js' 에 메인 화면에 사용된 객체가 정의되어 있다. 아래 내용은 id가 'root' 인 division에 'App'을 적용하겠다는 의미이다.
```
ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
```
 - 'index.js'에서 `<App/>` 라 되어있는 사용자 정의 태그를 생성했는데, `App`은 'App.js'에 정의되어 있고, 'index.js'에서 'App.js'를 참조한다.
 - 'App.js'에서 선언된 'App' 이라는 이름의 함수가 반환하는 값이 'App'태그에 치환된다고 보면 된다.
 - 'App'이 함수가 아니라 class로 정의되어 있다면 'App' class의 'render()' 함수의 리턴값이 'App'태그로 치환된다.
 - 리턴값은 무조건 특정 태그 안에 들어가 있어야 한다. <div>태그로 감싸주도록 한다.
3. src경로에 css파일 구성
 - index.css에서 css설정 구성
 -
## 배포
 - `npm run start`로 'create-react-app'으로 만든 앱을 실행시킬 수는 있지만, 이는 개발자용 실행 방식이다.
  - 웹 브라우저에서 페이지에 접속하고 다운로드받은 용량을 확인해보면 아무 기능이 없어도 MB단위가 다운받아짐을 확인할 수 있다.
  - 이러한 상태로 배포를 하면 효율 및 보안 관점에서 적합하지 않다.
 - `npm run build` 명령어를 수행하면 'build'라는 새로운 디렉터리와 데이터들이 생성된다.
  - 'build' 안에 있는 파일들은 공백 등을 제거하여 용량 및 보안에 최적화된 상태로 제공된다.
  - 배포시에는 'build'디렉터리 안의 내용을 사용하면 된다. 웹서버의 최상위 디렉터리를 'build'로 설정하면 된다.

 - `npm install serve` 명령어로 serve 툴을 설치한다. serve는 웹서버를 실행시키는 도구이다.
 - `serve -s build` 명령어로 'build' 디렉터리를 root 디렉터리로 웹서버를 실행한다.

## 기타
1. 함수형, 클래스형
 - react는 함수형 방식과 클래스형 방식으로 작성할 수 있다. 최근에는 함수형 방식을 선호하는 추세이다.
2. 다른 파일 참조
 - react에서 다른 파일을 참조할 때에는 'import'를 사용하며, 확장자가 없으면 '.js'가 생략된 것으로 본다.   
 `import React, { Component } from "react"`는 기본으로 필요하다.
3. html에서 예약어로 사용하는 태그들은 'synamtic tag'라 한다.
 - 'h1', 'header', 'nav', 'article' 등이 있다.
4. `export` : 특정 객체를 다른 파일에서 import할 수 있도록 한다.   
ex) `export App`
