---
title: "Spring Boot 실전 프로젝트: Gradle 빌드, REST API 구축 및 배포 가이드"
description: "스프링 부트(Spring Boot)의 자동 구성(Auto-Configuration) 원리와 application.yml 설정, Gradle 멀티태스크 빌드, Spring Data JPA와 H2 연동, RESTful 컨트롤러 및 스케줄러 구현을 총정리합니다."
slug: "spring-boot-gradle-rest-api-production-guide"
date: 2022-05-30T19:20:23+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebServer"]
tags: ["spring-boot", "java", "gradle", "jpa", "rest-api", "h2-database"]
ShowToc: true
TocOpen: true
---

Spring Boot는 기존 Spring 프레임워크의 복잡한 XML 및 수동 빈(Bean) 설정을 획기적으로 단순화한 차세대 자바 백엔드 프레임워크입니다. 의존성 관리의 표준화(Starters), 자동 구성(Auto-Configuration), 그리고 내장 톰캣(Embedded Tomcat) 서버를 통해 `java -jar` 명령어 하나로 단독 실행 가능한 상용 수준의 웹 서비스를 빠르게 제작할 수 있습니다.

이 글에서는 Spring Boot 개발 환경 구축부터 `application.yml` 프로파일 설정, Gradle 빌드 파이프라인, Spring Data JPA를 통한 영속성 계층 구현, 그리고 빈 등록 및 배치 스케줄러 구현까지 실무 핵심 전반을 다룹니다.

---

## 1. Spring Boot 개요 및 개발 환경 구축

### 1.1. Spring Initializr 및 JDK 환경 구성
- **JDK 설치**: Java 17 또는 21 LTS 버전을 권장합니다.
- **프로젝트 생성**: [Spring Initializr](https://start.spring.io)에서 Project(Gradle), Language(Java), Spring Boot 최신 안정 버전을 선택하고 필요한 스타터(Spring Web, Spring Data JPA, H2 Database, Lombok, DevTools)를 추가하여 다운로드합니다.

### 1.2. Gradle 래퍼(gradlew)와 프론트엔드 연동 빌드
Gradle Wrapper(`gradlew`)를 사용하면 협업자 간에 빌드 도구 버전 차이로 인한 오류를 방지할 수 있습니다. `build.gradle`에 태스크를 정의하여 React 정적 빌드 산출물을 스프링의 `resources/static`으로 자동 복사하도록 파이프라인을 구성할 수 있습니다.

```groovy
plugins {
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
    id 'java'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-thymeleaf'
    runtimeOnly 'com.h2database:h2'
    developmentOnly 'org.springframework.boot:spring-boot-devtools'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

// React 프론트엔드 빌드 결과물을 스프링 리소스 경로로 복사하는 커스텀 태스크 예시
def reactDir = "$projectDir/src/main/webapp"

task buildReact(type: Exec) {
    workingDir "$reactDir"
    if (System.getProperty('os.name').toLowerCase().contains('windows')) {
        commandLine "npm.cmd", "run", "build"
    } else {
        commandLine "npm", "run", "build"
    }
}

task copyReactBuildFiles(type: Copy) {
    dependsOn "buildReact"
    from "$reactDir/build"
    into "$projectDir/src/main/resources/static"
}

processResources {
    dependsOn "copyReactBuildFiles"
}
```

---

## 2. 애플리케이션 환경 설정 (`application.yml`)

Spring Boot는 `application.properties` 또는 계층 구조 표현이 편리한 `application.yml`을 통해 포트, 데이터베이스, 로깅 수준을 통합 관리합니다.

```yaml
server:
  port: 8080

spring:
  # H2 인메모리 데이터베이스 및 웹 콘솔 활성화
  h2:
    console:
      enabled: true
      path: /h2-console
  datasource:
    url: jdbc:h2:mem:testdb;MODE=MySQL
    driver-class-name: org.h2.Driver
    username: sa
    password:
  # JPA 및 하이버네이트 설정
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        format_sql: true

# 로깅 프레임워크 (SLF4J / Logback) 설정
logging:
  level:
    root: INFO
    com.example.demo: DEBUG
  file:
    name: logs/application.log
    max-history: 7
    max-size: 10MB
```

---

## 3. 웹 MVC 컨트롤러와 RESTful API 개발

Spring MVC에서 클라이언트의 HTTP 요청을 매핑하고 JSON 응답이나 뷰를 반환하는 컨트롤러 계층을 구성합니다.

### 3.1. `@Controller`와 `@RestController`
- **`@Controller`**: 주로 Thymeleaf나 Mustache 템플릿 파일의 이름을 문자열로 반환하여 HTML 화면을 서버 사이드 렌더링(SSR)할 때 사용합니다.
- **`@RestController`**: `@Controller`에 `@ResponseBody`가 결합된 형태로, 자바 객체를 직렬화하여 순수 JSON/XML 페이로드를 반환하는 RESTful API 전용 컨트롤러입니다.

### 3.2. 요청 데이터 바인딩 (`@RequestBody`, `@RequestParam`)
```java
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // 쿼리 파라미터 수신: /api/v1/users?name=홍길동
    @GetMapping
    public ResponseEntity<UserResponseDto> getUserByName(@RequestParam String name) {
        return ResponseEntity.ok(userService.findByName(name));
    }

    // JSON 본문 페이로드 수신
    @PostMapping
    public ResponseEntity<Long> createUser(@RequestBody UserCreateRequestDto requestDto) {
        Long createdId = userService.save(requestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdId);
    }
}
```

---

## 4. Spring Data JPA를 활용한 데이터베이스 영속성 계층

Spring Data JPA를 도입하면 SQL 쿼리를 직접 작성하지 않고 인터페이스 메서드 선언만으로 CRUD 및 페이징을 처리할 수 있습니다.

### 4.1. `@Entity` 도메인 클래스 매핑
```java
@Entity
@Table(name = "members")
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    protected Member() { } // JPA 기본 생성자 필수

    public Member(String name, String email) {
        this.name = name;
        this.email = email;
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
}
```

### 4.2. 리포지토리 인터페이스 정의 (`JpaRepository`)
`JpaRepository<엔티티, ID타입>`을 상속받으면 기본적인 `save()`, `findById()`, `findAll()`, `delete()`가 자동 제공됩니다.

```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {

    // 쿼리 메서드: 메서드 이름 규칙에 따라 JPQL이 자동 생성됨
    Optional<Member> findByEmail(String email);

    // 커스텀 JPQL 쿼리
    @Query("SELECT m FROM Member m WHERE m.name LIKE %:keyword%")
    List<Member> searchByName(@Param("keyword") String keyword);
}
```

---

## 5. 스프링 빈(Bean) 관리와 유용한 컴포넌트 기능

### 5.1. 빈 등록 방식 (@Component vs @Configuration + @Bean)
- **`@Component` 계열 (`@Service`, `@Repository`, `@Controller`)**: 클래스 단위로 선언하며 `@ComponentScan`에 의해 자동 감지되어 싱글톤 빈으로 등록됩니다.
- **`@Configuration` + `@Bean`**: 외부 라이브러리 객체나 환경 설정 객체를 수동으로 생성하고 커스터마이징하여 컨테이너에 등록할 때 사용합니다.

### 5.2. `@Scheduled` 주기적 배치 스케줄러 구현
애플리케이션 메인 클래스에 `@EnableScheduling`을 선언하고 스케줄러 컴포넌트를 정의합니다.

```java
@Component
public class CacheWarmupScheduler {

    // 6자리 Cron 표현식: 초 분 시 일 월 요일 (매일 자정에 실행)
    @Scheduled(cron = "0 0 0 * * *")
    public void runMidnightTask() {
        System.out.println("자정 정기 캐시 갱신 작업을 수행합니다.");
    }

    // 이전 작업 종료 후 10초(10000ms) 지연 뒤 반복 실행
    @Scheduled(fixedDelay = 10000)
    public void runPeriodicTask() {
        // 주기적 헬스체크 로직 수행
    }
}
```
Spring Boot는 복잡한 인프라 설정 없이 어노테이션 기반으로 엔터프라이즈 기능들을 간결하게 조립할 수 있는 강력한 생산성을 제공합니다.