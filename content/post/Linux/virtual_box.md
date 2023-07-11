---
title: "Virtual_box"
date: 2023-07-02T20:03:24+09:00
lastmod: 2023-07-02T20:03:24+09:00
tags: ["linux"]
categories: ["dev",]
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

# VirtualBox

## 문제와 해결

### root 계정
- virtual box를 생성하면 기본 user의 이름은 vboxuser로 세팅되어 있다. 하지만 vboxuser는 sudo 권한이 없어 다른 설정을 수행 할 수가 없다.
- virtual box에서 root 계정 비밀번호를 변경하는 방법은 다음과 같다. 
1. virtualbox에서 원하는 ubuntu machine를 실행시킨다.
2. machine이 실행되는 도중 shift키를 클릭하고 있는다.
3. 부팅 모드 선택 화면이 뜨면 `Advanced options for Ubuntu` 를 선택하고, `(recovery mode)`표시가 되어있는 항목으로 부팅을 시도한다.
4. 로딩이 완료되면 `root` 라는 항목을 선택하여 root 계정의 비밀번호를 재설정 할 수 있다. 

