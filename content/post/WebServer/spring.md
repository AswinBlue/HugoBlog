---
title: "Spring 프레임워크 핵심 개념: IoC 제어의 역전, DI 의존성 주입 및 CLI 환경 구축"
description: "자바 엔터프라이즈 개발의 표준인 Spring 프레임워크의 IoC(제어의 역전)와 DI(의존성 주입), ApplicationContext 빈 관리, Spring CLI 프로젝트 생성 및 Maven/Gradle 빌드 설정을 체계적으로 정리합니다."
slug: "spring-framework-ioc-di-and-cli-setup-guide"
date: 2021-08-23T19:21:55+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebServer"]
tags: ["spring", "java", "backend", "ioc-di", "maven", "gradle"]
ShowToc: true
TocOpen: true
---

Spring 프레임워크는 엔터프라이즈급 Java 애플리케이션 개발을 위한 오픈소스 경량 애플리케이션 프레임워크입니다. 복잡한 EJB(Enterprise JavaBeans)를 대체하여 POJO(Plain Old Java Object) 기반의 개발을 지향하며, 제어의 역전(IoC)과 의존성 주입(DI), 관점 지향 프로그래밍(AOP)을 바탕으로 모듈 간의 결합도를 획기적으로 낮추어 줍니다.

이 글에서는 Spring 프레임워크의 3대 핵심 철학부터 Spring CLI를 활용한 프로젝트 스캐폴딩, Maven/Gradle 빌드 도구 설정 및 실행 라이프사이클을 정리합니다.

---

## 1. Spring 프레임워크 핵심 아키텍처 (IoC / DI)

스프링 프레임워크가 제공하는 핵심 가치는 애플리케이션의 제어 흐름과 객체 생명주기를 개발자가 아닌 스프링 컨테이너가 주도하도록 위임하는 데 있습니다.

### 1.1. 제어의 역전 (IoC, Inversion of Control)
전통적인 프로그래밍에서는 개발자가 객체를 직접 생성(`new Class()`)하고 제어 흐름을 관리했습니다. 반면 스프링 환경에서는 객체의 생성, 초기화, 소멸 등 전 생명주기를 **스프링 IoC 컨테이너(`ApplicationContext`)**가 도맡아 관리합니다.

### 1.2. 의존성 주입 (DI, Dependency Injection)
스프링 컨테이너가 관리하는 객체를 **빈(Bean)**이라고 부르며, 컴포넌트가 필요로 하는 의존 객체를 외부(컨테이너)에서 주입해 주는 메커니즘을 DI라고 합니다.
- **생성자 주입 (Constructor Injection - 권장)**: 불변 객체 생성 보장 및 순환 참조 방지.
- **필드 주입 (`@Autowired`)**: 간결하지만 단위 테스트 및 변경에 취약함.

```java
@Service
public class OrderService {
    private final MemberRepository memberRepository;

    // 생성자 주입을 통한 의존성 결합도 완화
    public OrderService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }
}
```

---

## 2. Spring CLI 환경 구축 및 신규 프로젝트 생성

Spring CLI 도구를 활용하면 명령줄 인터페이스에서 간편하게 스프링 부트 프로젝트를 스캐폴딩하고 프로토타이핑할 수 있습니다.

### 2.1. Spring CLI 설치 및 환경변수 등록
공식 스프링 저장소에서 CLI 바이너리를 내려받아 압축을 해제한 후, 실행 경로를 `PATH` 환경변수에 등록합니다.

```bash
# 설치 검증
spring --version
```

### 2.2. 프로젝트 생성 명령어 옵션 (`spring init`)
CLI 명령어 한 줄로 Maven 또는 Gradle 기반의 웹 애플리케이션 뼈대를 생성할 수 있습니다.

```bash
spring init --build=gradle \
  --dependencies=web,data-jpa \
  --artifactId=myApp \
  --groupId=com.example.demo \
  --package-name=com.example.demo \
  my-spring-app
```
- `--build=gradle`: 빌드 도구 지정 (`gradle` 또는 `maven`, 기본값: maven)
- `-d=web,data-jpa`: 추가할 스프링 스타터 의존성 (Web MVC, JPA 등)
- `-a=myApp`: 프로젝트 Artifact ID 설정
- `-g=com.example.demo`: 프로젝트 Group ID 설정
- `my-spring-app`: 소스코드를 생성할 대상 디렉터리 경로

---

## 3. 빌드 시스템 구성: Maven(pom.xml)과 Gradle(build.gradle)

자바 프로젝트의 외부 의존 라이브러리는 빌드 스크립트를 통해 자동으로 다운로드되고 컴파일 클래스패스에 바인딩됩니다.

### 3.1. Maven 설정 (`pom.xml`)
[Maven Central Repository](https://mvnrepository.com)에서 라이브러리의 `groupId`, `artifactId`, `version` 좌표를 확인하여 `pom.xml`에 등록합니다.

```xml
<dependencies>
    <!-- Spring Boot Starter Web 의존성 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

### 3.2. Gradle 설정 (`build.gradle`)
모던 스프링 생태계에서는 간결한 DSL 문법과 증분 빌드(Incremental Build) 성능이 뛰어난 Gradle이 표준으로 선호됩니다.

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}
```

---

## 4. 프로젝트 빌드 및 실행 명령어

### 4.1. Maven 기반 실행
```bash
# 빌드 및 단위 테스트 수행 후 패키징
mvn clean package

# 로컬 개발 서버 즉시 실행 (Spring Boot 플러그인)
mvn spring-boot:run

# 디버깅 모드 실행 (-X 옵션)
mvn -X spring-boot:run
```

### 4.2. Gradle 기반 실행
Gradle Wrapper(`gradlew`)를 사용하여 로컬 환경에 별도 Gradle 설치 없이도 일관된 빌드를 수행합니다.

```bash
# 로컬 개발 서버 실행
./gradlew bootRun

# 실행 가능한 JAR 바이너리 빌드 (build/libs/*.jar)
./gradlew clean build

# 생성된 JAR 단독 실행
java -jar build/libs/myApp-0.0.1-SNAPSHOT.jar
```
내장된 톰캣(Embedded Tomcat)이 8080 포트에서 자동으로 기동되므로 추가적인 WAS 설치 없이 독립적으로 서비스가 구동됩니다.
