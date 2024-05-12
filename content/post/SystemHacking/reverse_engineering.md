---
title: "Reverse_engineering"
date: 2024-05-12T14:42:07+09:00
lastmod: 2024-05-12T14:42:07+09:00
tags: ["C", "hacking",]
categories: ["dev", "hacking",]
imgs:  []
cover:  ""  # image show on top
readingTime:  true  # show reading time after article date
toc:  true
comments:  false
justify:  false  # text-align: justify;
single:  false  # display as a single page, hide navigation on bottom, like as about page.
license:  "BY-SA"  # CC License, https://creativecommons.org/licenses/?lang=ko
draft: false
---

# Reverse Engineering

- software 를 분석하여 소스코드를 역으로 생성 해 내는 기법

## software 분석 방법
### Static analysis
- 프로그램을 실행시키지 않고 수행하는 분석이다.
- 프로그램의 전체 구조를 파악하기 쉬우며, 환경적 제약 사항에 자유롭고, 악성 코드의 위협으로부터 안전하다.
- 난독화 적용시 분석이 어려워 진다는 단점이 있다.

- 정적분석에 사용되는 툴로는 `IDA` 가 있다.
  - `IDA` 는 프리웨어로 https://hex-rays.com/ida-free/ 에서 다운 가능하다.
### Dynamic analysis
- 프로그램을 실행시키며 수행하는 분석이다.
- 프로그램의 개략적인 동작을 빠르게 확인 할 수 있다.
- 정적 분석과 반대로 프로그램 실행에 필요한 환경 구성이 어려울 수 있다.
- 안티 디버깅 기법 적용된 프로그램은 디버깅이 불가능하다.