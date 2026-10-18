---
title: "Jython을 활용한 Java 런타임 위 Python 코드 상호 운용 가이드"
description: "JVM 위에서 동작하는 Python 구현체인 Jython의 환경 세팅과 Java 클래스를 Python에서 호출하거나 반대로 임베딩하는 연동법을 정리합니다."
slug: "jython-java-python-interoperability"
date: 2021-08-23T19:20:47+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Java"]
tags: ["java", "python", "jython", "interoperability", "jvm"]
ShowToc: true
TocOpen: true
---
# Jython
- Java 환경에서 python을 실행하게 하는 방법 중 하나
- 역으로 Jython 환경에서 java를 실행 가능하기도 하다.
- spring에서 jython을 사용하는 방법에 대해 묘사하겠다.

## 설치
- pom.xml에 의존성을 작성한다.
- pom을 사용하면 jython을 설치하지 않고 일부 동작이 실행되게 할 수 있지만, 외부 모듈 사용에는 제한적인 부분이 있기에 설치가 필요하면 설치를 해야한다.

```
<!-- https://mvnrepository.com/artifact/org.python/jython -->
<dependency>
    <groupId>org.python</groupId>
    <artifactId>jython</artifactId>
    <version>2.7.0</version>
</dependency>
```

## 실행

- PythonInterpreter 을 선언한다.
- 이후 execfile, exec 함수를 이용하여 python 문법을 사용 가능하다.

```
PythonInterpreter jython;
jython.execfile(PYTHON);
jython.exec("print(1+1)");
```

- execfile로 특정 함수를 정의하였다면 그 아래에 있는 exec함수에서 함수를 호출할 수도 있다.
