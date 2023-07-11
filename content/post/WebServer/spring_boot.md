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
1. devtools 설정
  - 정적 파일들을 갱신했을 때, 서버 재실행 없이 explorer만 reload 해 주면 변경점이 반영될 수 있도록 한다.
  
  - 이 외에 DB, 포트, mvc, thymleaf 등 각종 설정이 포함된 yml 파일 예시는 다음과 같다.
      
        ```
        # web 서버 동작 설정
        server:
          # 포트 설정
          port: 8080
        # spring boot 설정
        spring:
           config:
             activate:
               on-profile: deploy
          # h2 database 설정
          h2:
            console:
              enabled: true
          # jpa 설정
          jpa:
            database: h2
            generate-ddl: off
          datasource:
            driver-class-name: org.h2.Driver
            url: jdbc:h2:mem:testdb;MODE=MySQL;
            username: SA
            password:
            initialization-mode: always
            schema: classpath:schema-h2.sql
            data: classpath:data-h2.sql
          # spring의 MVC 모델 설정
          mvc:
            # view로 사용할 static resources의 위치 및 파일 확장자 설정
            # thymeleaf가 view역할을 하기 때문에 본 프로젝트에서는 mvc 모듈 내용 활용 안됨
            view:
              prefix: /myApp/
              suffix: .jsp
      
          # thymeleaf 설정, MVC에서 view를 담당
          thymeleaef:
            cache: false
            mode: HTML
            encoding: UTF-8
            prefix: file:src/main/resources/templates/
          # web 서버 동작시 설정
          web:
            resources:
              # resource 위치, html파일에서 참조시 연결될 root 디렉터리
              static-locations: file:src/main/resources/static/
              cache:
                period: 0
      
          # devtools 설정, apply static resources instantly
          devtools:
            livereload:
              enabled: true
      
        # SLF4J 설정, 로그 시스템
        logging:
          file:
            name: ${user.dir}/log/test.log  # Log file path
            max-history: 7 # delete period
            max-size: 10MB  # max size of single log file
          level:  # set log level to each package
            com.aswinblue.RankServer : debug
          pattern:
            console: "%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"
            file: "%d %p %c{1.} [%t] %m%n"
        ```

1. 빌드 설정
    - gradle 프로젝트는 `./gradlew build` 명령으로 프로젝트를 빌드한다.
    - 이때 `build.gralde` 파일 설정으로 하위 프로젝트의 빌드까지 함께 정의할 수 있다.
    - gradle 파일이 수정되면 `./gradlew build` 명령을 새로 돌려서 업데이트 해 준다.
    - 아래는 React 프로젝트의 빌드 세팅이다.   
  
      ```
      /*********************
       * 기본 설정 및 dependency
       *********************/
      plugins {
      	id 'org.springframework.boot' version '2.7.1'
      	id 'io.spring.dependency-management' version '1.0.11.RELEASE'
      	id 'java'
      }
      
      group = 'com.aswinblue'
      version = '0.0.1-SNAPSHOT'
      sourceCompatibility = '18'
      
      repositories {
      	mavenCentral()
      }
      
      dependencies {
      	implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
      	implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
      	implementation 'org.springframework.boot:spring-boot-starter-web'
        implementation 'com.h2database:h2'
      	testImplementation 'org.springframework.boot:spring-boot-starter-test'
        implementation 'org.springframework.boot:spring-boot-devtools' //devtools
      }
      
      tasks.named('test') {
      	useJUnitPlatform()
      }
      
      /*********************
       * React 설정
       *********************/
      def reactDir = "$projectDir/src/main/webapp"; // react 프로젝트 경로 설정
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
    - 각종 설정을 해주는 batch 파일 예시이다.
      ```
      gradle wrapper
      gradlew build
      @REM package.json에 script 작성 필요
      npm run build:postcss
      ```

1. 폴더 설정
  - `resources` : html, css 등 화면 구성을 위한 파일들의 root 디렉터리
    - `resources/static` : html파일에서 href로 참조하면 아래 디렉터리를 root로 경로 설정 가능
    - `resources/template` : mustache 파일에서 root 디렉터리로 사용

## 웹 서비스 개발
1. tomcat
    - spring boot에서 web 패키지를 설치하면 tomcat을 사용하여 web server를 동작시킨다.
    - localhost:8080으로 default 주소가 처리되어 있고, `application.yml` 파일에서 아래와 같이 수정 가능하다.   
      ```
      server:
        port : 8081
      ```

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
  
    - model(.mustache .html 등)은 `resources/templates` 파일 경로 하위에 배치하고, 확장자를 `.mustache`로 지정한다.  
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

#### Controller
- Controller는 request를 받아 어떤 화면을 보여줄지 결정하는 routing 로직을 담당하게 된다. 
- controller class는 `@Controller` annotation을 붙여서 선언하며 routing 함수로는 `@GetMapping`, `@RequestMapping` annotation을 사용하여 정의한다.

1. 에러 화면
    - 에러 화면도 controller에 의해 유도되며 BasicErrorController가 이를 담당한다.
    - `application.yml` 파일에서 따로 설정을 하지 않았다면 `server.error.path=/error` 가 기본이다.
  
#### JPA
- spring은 mysql, postgress, M2 등 여러 DB를 적용할 수 있다.
- controller는 Java로 구현되고, DB는 sql로 동작하기 때문에 java로 sql을 조작하기 위한 JPA라는 라이브러리가 필요하다.
- `Entity` : java 객체를 DB가 이해할 수 있게 재구성한 데이터
  - `@Entity` : 해당 class를 entity 로 선언
  - `@Table(name="")` : 특정 table과 객체를 연동. 기본적으로는 calss 이름에 해당하는 DB의 table과 매핑 된다.
  - `@Column` : 지정한 변수를 DB의 컬럼으로 선언
- `Repository` : entity를 DB에 저장하는 역할을 수행하는 객체
  - `save(ENTITY)` : 저장, DB의 insert / update 에 해당
  - `delete(ENTITY)` : 특정 Entity 삭제, DB의 delete에 해당

   - 상세 내용은 링크를 참조한다.
     <details><summary>JPA Usage Links</summary>
       
     - [JPA Repository Query function](https://docs.spring.io/spring-data/jpa/docs/1.10.1.RELEASE/reference/html/#jpa.query-methods.query-creation)
     - [JPA Repository Query annotation](https://docs.spring.io/spring-data/jpa/docs/1.10.1.RELEASE/reference/html/#repositories.query-streaming)
     -  [JPA Repository get Top x result](https://docs.spring.io/spring-data/jpa/docs/1.10.1.RELEASE/reference/html/#repositories.limit-query-result)
     -  [JPA update data from DTO](https://www.baeldung.com/spring-data-partial-update#1-mapping-strategy)
     </details>
     
1. DTO 정의
   - 서버의 Controller에서 이를 처리 가능하며, 사용자 입력을 Java Class로 대응시킨 형태를 DTO라 칭한다.
   - DTO를 다음과 같이 정의하였다고 하자  

    ```
    class DtoSample {
      private String name;
      public DtoSample(String name) {
          this.name = name;
      }
    }
    ```

1. Entity 정의
   - DTO에 해당하는 entity를 정의해야하며, 그 형태는 다음과 같다.   
     - entity는 `@Entity` annotation을 붙여야 한다.
     - Entity는 primary key를 가져야 하며, 이는 `@Id` annotation으로 지정한다.
     - DB의 column에 해당하는 값들은 `@Column` annotation을 붙여준다.
     - `@GeneratedValue`는 자동으로 생성된 값이 들어가도록 한다.
     - '실제 DB table' ⊃ 'DTO에 정의된 column들' 이 성립해야 한다.
     
    ```
    @Entity
    public class sampleEntity {
        @Id // 대표값
        @GeneratedValue // 자동생성
        private Long id;
        @Column
        private String name;
  
        public sampleEntity(Long id, String name) {
            this.id = id;
            this.name = name;
        }
  
    }
    ```

1. Repository 구현
   - Entity를 DB에 저장하기 위한 Repository도 생성한다.
   - repository는 entity로 DB에 접근하는 방법을 정의하기 위한 객체이다.
   - spring에서 기본으로 제공하는 형태를 상속받아 사용도 가능하다.   

    ```
    // CrudRepository<관리대상, 대표값의 type>
    public interface searchNameRepository extends CrudRepository<sampleEntity, Long> {
        // CrudRepository 의 기본값을 사용
    }
    ```
   - 직접 구상한 쿼리를 사용하고 싶다면 camelcase로 구성된 함수 이름으로 쿼리를 추가할 수 있다.
       <details> <summary> Tips </summary>
         
         [no property ~ found for type ~ 오류 해결법](https://stackoverflow.com/questions/19733464/order-by-date-asc-with-spring-data)
       </details>
     
     
     ```
     public interface searchNameRepository extends CrudRepository<SampleEntity, Long> {
         // select * from SampleEntity where name = ?1     
         @Query("Select s From SampleEntity")
         List<sampleEntity> findByName(String name);

         // select * from SampleEntity where name = ?1 and id = 1
         @Query("Select s From SampleEntity where s.id = 1")
         List<sampleEntity> findByName(String name);
      }

     ```
   
1. 기타 추가작업
   - 이전에 만들었던 controller 에 내용을 추가한다. DTO로 받은 내용을 Entity로 변환시켜 repository를 통해 처리한다.   

    ```
    @Autowired // String boot가 알아서 new 해서 사용하는 annotation
    searchNameRepository snr;
    
    @PostMapping("/data/part1")
    public String handleForm(DtoSample dto) {
      sampleEntity name = dto.toEntity(); // toEntity 구현 필요
      name = snr.save(name); // 'save'는 저장 및 저장된 데이터를 반환함
      return "returnView";
    }
    ```

   - contorller에서 받은 DTO 데이터를 entity로 변환시킬 때 사용한 `toEntity()` 함수를 구현해야 한다.
   - DTO 파일을 추가로 수정한다.  

    ```  
    class DtoSample {
      private String name;
      public DtoSample(String name) {
          this.name = name;
      }
      public sampleEntity toEntity() {
          return new sampleEntity(null, this.name); // id에 null을 넣는다. @GeneratedValue에 의해 자동으로 생성된다.
      }
    }
    ```


#### 데이터 교환
- view에서 사용자 입력을 받아 처리하는 과정을 다룬다.
- 앞서 JPA를 통해 구현한 DB 시스템에 데이터를 넣을 수 있다. 

1. view 구현
    - view쪽에서는 `form` 태그를 사용하여 controller에 데이터를 전송할 수 있다.
    - `form` 태그의 인자로 `action`, `method`를 적용 가능하다.
      - `action` : 데이터를 보낼 url을 설정. ex) action="/data/part1"
      - `method` : 전송 방법을 설정한다. post 혹은 get 적용 가능
    - `form` 태그 안의 `input`태그를 두고, 인자로 `name`을 설정한다.
      ```
      <form action="/data/userRank" method="post">
        <label>type your character name</label>
        <input type="text" name="userName">
        <br/>
        <button>see table</button>
        <br/>
      </form>
      ```
1. controller 구현
    - DTO로 사용할 class를 선언한다. (ex: DtoSample)
    - controller 를 구현한 java 파일에서 `@PostMapping` annotation을 달고, 인자로 위에서 선언한 DTO를 받는다.   
    - return 값으로 지정한 이름의 view로 redirect 한다. (ex: returnView)
        ```
        @PostMapping("/data/part1")
        public String handleForm(DtoSample dto) {
          return "returnView";
        }
      ```
     - parameter를 꼭 DTO 형태로 받지 않을 수도 있다.
       - `@RequestBody`, `@RequestParam` annotation을 이용하여 데이터를 받을 수 있다.
           ```
             public String handleUserNameForm(@RequestBody String userName, Model model) {}
             // userName = "userName=TESTNAME" 과 같이 데이터가 받아진다.
           ```
           ```
             public String handleUserNameForm(@RequestParam String userName, Model model) {}
             // userName = "TESTNAME" 과 같이 데이터를 받을 수 있다.
           ```


### Bean
- Spring boot를 실행하면 container가 동작하는데, 이 container가 관리하는 객체를 bean이라고 한다.
1. 선언
   1. Component 사용
      - `@Component` annotation을 class에 붙여주면, 해당 class가 bean으로 등록된다.
      - 직접 구현한 객체를 bean으로 적용할 떄 사용할 수 있다.
      - `@AutoWired` annotation을 이용해 의존성을 정의할 수 있다.
        ```
        @Component
        class C {
          // C가 bean으로 등록
          public C() {
            System.out.println("use C as bean");
          }
        
          @AutoWired
          private D d; // D 라는 class에 대한 dependency 정의
        }
        ```
   1. Bean 사용
      - `@Configuration` annotation을 class에 붙여주고, 해당 class에 선언된 함수에 `@Bean` annotation을 붙여준다.
      - `@Bean` 이 붙은 함수에서 반환되는 값들은 모두 Bean으로 관리된다.
      - 3rd party에서 구현된 객체를 bean으로 적용할 때 사용할 수 있다.
      - bean으로 반환할 객체 생성자에 인자를 넣어 의존성을 정의할 수 있다. 
        ```
        class Foo {
          public Foo() {
            System.out.println("use Foo as bean");
          }
        }
        class Bar {
          public Bar() {
            System.out.println("Bar as dependency");
          }
        }

        @Configuration
        class configure {
          @Bean
          public Bar bar() {
            return new Bar(); // Bar을 bean으로 선언
          }
          @Bean
          public Foo foo() {
            return new Foo(new Bar()); // Foo가 Bar의 의존성을 가짐을 표현
          }
        }
        ```
   
   - spring은 `@ComponentScan` annotation이 붙은 class에서 component(bean)을 찾아가기 시작한다.
     - spring 프로젝트를 생성하면 main 함수가 있는 class가 있는데, 이 clalss에 붙은 `@SpringBootApplication` annotation이 `@ComponentScan` annotation을 포함하고 있다.
     - `@Configuration` annotation 도 `@Component` annotation을 포함하고 있어 scan 대상이 된다.
     - `@Controller` 로 선언된 class들도 bean으로 관리되는데, 이는 `@Controller`가 `@Component` annotation을 포함하고 있기 때문이다.


## Annotation 및 기능
### Value
- `@Value` annotation을 변수에 선언하면 프로젝트 설정파일(application.yml) 에서 변수를 가져올 수 있다.
    ```
    @Value(${server.port})
    private int port;
    ```
### Scheduled
- spring boot로 특정 주기마다 반복 동작을 수행하는 기능을 구현할 수 있다.
1. main 함수가 선언된 class에 `@EnableScheduling` 을 선언한다.
2. schedule을 관리할 class(Scheduler)를 선언하고, `@Component` annotation을 붙인다. 
3. 에서 생성한 Scheduler class에 함수를 선언하고, `@Scheduled` annotation을 붙인다.
   - `@Scheduled(cron = "1 2 3 4 5 ?")` : 매 5월4일3시2분1초 에 동작
     - 숫자대신 *을 하면 모든 값에 동작하도록 설정 가능
     - 앞에서부터 초,분,시,일,월,요일이며 요일은 0이 일요일 6이 토요일, 7또한 일요일이다. 
     - [상세 내용은 공식 document 참조](https://spring.io/blog/2020/11/10/new-in-spring-5-3-improved-cron-expressions)
   - `fixedDelay=1000` : 매 1초마다 동작(함수 종료 시점부터 1초)
   - `fixedRate=1000` : 매 1초마다 동작(함수 시작 시점부터 1초)

### SLF4J
- 로그를 쉽게 설정하기 위한 툴

## 참조한 사이트
1. https://allonsyit.tistory.com/43
1. https://galid1.tistory.com/494
1. https://atoz-develop.tistory.com/entry/Spring-%EC%8A%A4%ED%94%84%EB%A7%81-%EB%B9%88Bean%EC%9D%98-%EA%B0%9C%EB%85%90%EA%B3%BC-%EC%83%9D%EC%84%B1-%EC%9B%90%EB%A6%AC
1. https://goateedev.tistory.com/128
1. https://itworldyo.tistory.com/40
1. https://docs.spring.io/spring-data/jpa/docs/current/reference/html/