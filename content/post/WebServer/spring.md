+++
title = "Spring basic"
date = 2021-08-23T19:21:55+09:00
lastmod = 2021-08-23T19:21:55+09:00
tags = ["spring", "java"]
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
# Spring basic

## 설치
 - spring CLI를 설치한다. 직접 다운받아서 원하는 곳에 압축을 푼 후 PATH설정을 해 주는게 빠르다.   
 [참조](https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started-installing-the-cli)

## 프로젝트 생성
 - CLI로 프로젝트를 생성해 보자.
``spring init --build=gradle -d=web -a=myApp -g=com.aswin.blue [location]``
 - ``--build=gradle`` 기본으로 maven을 사용하지만 gradle로 설정 가능하다.
 - ``-d=web`` dependency를 web으로 설정
 - ``-a=myApp`` artifactId, 즉 project명을 설정한다.
 - ``-g=com.aswin.blue`` 그룹 명을 설정한다.
 - ``[location]`` 생성할 폴더를 지정한다. 없으면 새로 생성한다. 지정하지 않으면 zip 형태로 압축해서 생성한다.


## 설정
- maven으로 프로젝트를 생성하면 pom.xml을 설정해야 한다.
- 각종 라이브러리를 플러그인 형태로 사용하려면 dependency와 repository 설정을해 줘야 한다.
- "https://mvnrepository.com/" 주소처럼 maven repository를 정리해 놓은 사이트에서 원하는 repository를 찾아서 dependency를 작성한다.
- repository 추가시 compile dependency를 확인하고 추가로 pom.xml을 작성한다.
- maven 사이트보다는 github의 readme를 더 신용하자, maven 사이트 업데이트가 안돼서 잘 동작하지 않는 것도 있다.


## 실행
- maven 프로젝트의 실행에도 maven이 사용된다.
- ``mvn -X clean install exec:java -Dexec.args=""`` 로 실행이 가능하다.

``-X`` 는 디버깅 로그 출력을 의미한다.
``-Dexec.args=`` 는 main 함수의 argv를 설정한다.

- spring 프로젝트는 ``mvn spring-boot:run`` 으로 실행시킬 수 있다.
