---
title: "Java 환경에서 Python을 실행하는 Jython 연동 가이드"
date: 2021-08-23 19:20:47+09:00
lastmod: 2021-08-23 19:20:47+09:00
description: "Java 가상 머신(JVM) 상에서 Python 코드를 원활하게 실행할 수 있는 Jython 라이브러리의 Maven 의존성(pom.xml) 설정 방법과 PythonInterpreter를 활용한 스크립트 실행 절차를 상세히 정리합니다."
slug: "java-jython-integration-guide"
categories:
  - "Java"
tags:
  - "java"
  - "jython"
  - "python"
  - "jvm"
  - "maven"
ShowToc: true
TocOpen: true
draft: false
---

## Jython 개요 및 특징

Jython은 Python 프로그래밍 언어를 Java 가상 머신(JVM) 상에서 구동할 수 있도록 바이트코드로 컴파일해 주는 오픈소스 구현체이다.
- Java 애플리케이션 내에서 Python 스크립트 파일을 동적으로 로드하여 실행할 수 있다.
- 반대로 Python 코드 안에서 Java의 표준 라이브러리 및 사용자 정의 클래스를 직접 임포트하여 객체를 생성하고 메서드를 호출할 수도 있다.
- Spring Framework 등의 Java 백엔드 환경에서 비즈니스 로직을 유연한 스크립트로 분리할 때 유용하게 활용된다.

## Maven 의존성 설정 (pom.xml)

Spring 또는 Maven 기반 Java 프로젝트에서 Jython을 사용하려면 `pom.xml`에 의존성을 추가한다.

```xml
<!-- https://mvnrepository.com/artifact/org.python/jython-standalone -->
<dependency>
    <groupId>org.python</groupId>
    <artifactId>jython-standalone</artifactId>
    <version>2.7.3</version>
</dependency>
```

> [!NOTE]
> `jython` 기본 아티팩트보다 표준 Python 라이브러리가 포함된 `jython-standalone`을 사용하면 별도의 로컬 Python 설치 없이도 대부분의 기본 내장 모듈을 안전하게 구동할 수 있다. 단, C 확장을 사용하는 외부 모듈(NumPy, Pandas 등)은 호환되지 않으므로 순수 파이썬 모듈 위주로 구성해야 한다.

## PythonInterpreter를 활용한 스크립트 실행

Java 코드에서 `PythonInterpreter` 인스턴스를 생성하여 인라인 파이썬 구문 또는 외부 `.py` 파일을 실행한다.

```java
import org.python.util.PythonInterpreter;
import org.python.core.PyObject;

public class JythonExample {
    public static void main(String[] args) {
        // Python 인터프리터 생성
        try (PythonInterpreter pyInterp = new PythonInterpreter()) {
            // 1. 단일 파이썬 코드 문자열 직접 실행
            pyInterp.exec("print('Hello from Jython!')");
            pyInterp.exec("result = 10 + 20");
            
            // 2. 파이썬 변수 값을 Java 객체로 추출
            PyObject result = pyInterp.get("result");
            System.out.println("Result: " + result.asInt());

            // 3. 외부 파이썬 스크립트 파일 실행
            pyInterp.execfile("script.py");
        }
    }
}
```

### 함수 정의 및 상호 호출
- `execfile` 또는 `exec`를 통해 특정 파이썬 함수를 정의해 두면, 이후 동일한 인터프리터 세션 내에서 해당 함수를 재사용하여 호출할 수 있다.
- Java 객체를 파이썬 인터프리터의 변수로 전달(`pyInterp.set("key", javaObj)`)하여 파이썬 스크립트 내부에서 Java 메서드를 직접 수행하도록 연동할 수도 있다.
