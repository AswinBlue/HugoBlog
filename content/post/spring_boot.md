+++
title = "Spring_boot"
date = 2022-05-30T19:20:23+09:00
lastmod = 2022-05-30T19:20:23+09:00
tags = ['spring_boot', 'java', 'server']
categories = ['dev']
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

# Spring Boot
  - Spring boot는 서버 생성을 위한 도구로, spring 프레임워크에 편의성을 향상시킨 프레임워크이다.  
  - Java, Kitlin, Groovy 등의 언어로 구현이 가능하다.

## 개발환경
1. java 기반으로 동작하기에 jdk 설치가 필요하다.
  - (22년 기준) 11버전 이상을 다운받는것을 추천한다.
1. IDE
  - vs code를 사용한다면 확장패키지로 'Java Extension Pack' 과 'Spring Boot Extension Pack' 을 설치한다.   
  - java 개발을 위한 eclips나 intelliJ를 사용해도 된다.  
1. spring 프로젝트 생성
  - `start.spring.io` 페이지에 들어가면 프로젝트를 생성할 수 있는 UI가 구성되어 있다. 원하는대로 설정 후 다운로드를 받아서 사용하면 된다.
1. gradle 설치
  - `https://gradle.org/releases/` 주소에서 gradle 파일을 다운받는다.
  - 이후 path 설정을 마친 후, 프로젝트 root directory에서 `gradle wrapper` 명령을 수행해 gradlew파일을 생성한다.

### 기본 설정
1. 포트 설정
  - `application.properties` (혹은 yml)파일을 열고, `server.port = 8080` 와 같이 기입하면 동작 포트를 8080으로 설정할 수 있다.

1. 빌드 설정
  - gradle 프로젝트는 `./gradlew build` 명령으로 프로젝트를 빌드한다.
  - 이때 `build.gralde` 파일 설정으로 하위 프로젝트의 빌드까지 함께 정의할 수 있다.
  - gradle 파일이 수정되면 `./gradlew build` 명령을 새로 돌려서 업데이트 해 준다.
  - 아래는 React 프로젝트의 빌드 세팅이다.

  ```
  def reactDir = "$projectDir/src/main/webapp/js"; // react 프로젝트 경로 설정
  sourceSets{
  	main{
  		resources{
  			srcDirs = ["$projectDir/src/main/resources"]
  		}
  	}
  }

  // 최초로 수행할 task 지정
  processResources{
  	dependsOn "copyReactBuildFiles"
  }

  // $reactDir 위치에서 `npm audit fix` 명령 실행
  task installReact(type:Exec){
  	workingDir "$reactDir"
  	inputs.dir "$reactDir"
  	group = BasePlugin.BUILD_GROUP

  	if(System.getProperty('os.name').toLowerCase(Locale.ROOT).contains('windows')){
  		commandLine "npm.cmd", "audit", "fix"
  		commandLine 'npm.cmd', 'install'
  	}else{
  		commandLine "npm", "audit", "fix"
  		commandLine 'npm', 'install'
  	}
  }

  // installReact task를 호출
  // $reactDir 위치에서 `npm run-script build` 실행
  // react 프로젝트의 `package.json` 파일에 적힌 build 스크립트가 실행됨.
  task buildReact(type:Exec){
  	dependsOn "installReact"
  	workingDir "$reactDir"
  	inputs.dir "$reactDir"
  	group = BasePlugin.BUILD_GROUP

  	if(System.getProperty('os.name').toLowerCase(Locale.ROOT).contains('windows')){
  		commandLine "npm.cmd", "run-script", "build"
  	}else{
  		commandLine "npm", "run-script", "build"
  	}
  }

  // buildReact task를 호출
  // 앞서 지정한 $reactDir 경로의 /build 위치에서 생성된 데이터를 $projectDir/src/main/resources/static 로 복사
  task copyReactBuildFiles(type:Copy) {
  	dependsOn "buildReact"
  	from "$reactDir/build"
  	into "$projectDir/src/main/resources/static"
  }
  ```

## 웹 서비스 개발
1. tomcat
  - spring boot에서 web 패키지를 설치하면 tomcat을 사용하여 web server를 동작시킨다.
  - localhost:8080으로 default 주소가 처리되어 있고,

### MVC 모델
- model, view, control 을 나누어 개발하는 형태를 MVC 모델이라고 한다.

#### View template
- view template 은 controller와 model을 합친 개념으로, 화면을 구성하는 역할을 한다.  
- mustache 패키지를 설치하여 view template를 만들 수 있다.  

1. jsp 활용
  - Spring boot에는 jsp가 잘 어울리지 않는다고 한다. 대신 Thymleaf, mustache 등을 사용하는걸 권장한다?  
  - jsp를 사용하여 model을 구성할 수도 있다.
  - jsp는 사용하기 전 `application.properties`(혹은 yml) 파일의 수정이 필요하다. 아래 내용을 추가한다.   

  ```
  spring.mvc.view.prefix=/myApp/
  spring.mvc.view.suffix=.jsp
  ```

  - 위 내용을 적용하면 `src/main/webapp/myApp/` 경로 내부에서 jsp파일을 찾게 된다. 'webapp' 폴더는 default로 필요하다.

1. mustache 활용
  - 앞서 말헀듯 mustache는 view template용 패키지로 controller와 model을 관장한다.
  - controller는 기본 패키지 경로 하위에 배치한다.
  - controller는 다음과 같이 구성한다.

  ```
  package com.example.firstproject.controller;
  import org.springframework.stereotype.Controller;
  import org.springframework.web.bind.annotation.GetMapping;
  import org.springframework.ui.Model;

  @Controller  // controller를 정의하는 annotation
  public class FirstController {
      @GetMapping("/index")  // 연결될 url을 지정하는 annotation, /index 로 연결하면
      public String mainPage(Model model)  // model 을 통해 가변 인자 control
      {
          model.addAttribute("title", "hello world"); // title 이름으로 hello world 라는 문자열을 설정
          return "mainPage";  // mainPage.mustache 파일과 연동
      }
  }
  ```

  - model(.mustache파일)은 `resources/templates` 파일 경로 하위에 배치하고, 확장자를 `.mustache`로 지정한다.  
  - html 파일은 사실 view에 가깝지만, mustache 파일은 view에 변수를 적용하여 model에 해당한다.
  - model은 다음과 같이 구성한다.

  ```
  <body>
    <h1>{{title}}</h1>  <!-- controller에서 정의한 title이 {{title}}에 치환됨 -->
  </body>
  ```

  1. Layout
    - model을 만들 때는 layout에 따라 화면에 보여지는 형태를 구성할 수 있다.
    - layout을 template화 하여 사용 가능하다. 재사용 되는 부분을 모듈화 하여 파일로 분리하고, 이를 다른 파일에서 불러올 수 있다.
    - `{{>FILE_NAME}}` 형태로 다른 파일을 호출해 올 수 있다.
