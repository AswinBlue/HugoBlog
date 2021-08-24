+++
title = "Jython"
date = 2021-08-23T19:20:47+09:00
lastmod = 2021-08-23T19:20:47+09:00
tags = ["jython", "python", "java",]
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
