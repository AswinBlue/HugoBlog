+++
title = "Firebase"
date = 2022-01-19T21:02:46+09:00
lastmod = 2022-01-19T21:02:46+09:00
tags = ["firebase","DB",]
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

# firebase
- firebase는 실시간 db로 유명하며, google에 인수되고 폭이 넓어졌다.
- Amazon의 Amplify가 firebase와 유사하다.
- 일정 사용량 까지는 무료로 사용 가능하며, 이후에는 요금이 부가된다.

## 설치 및 사용

- 다양한 운영체제에서 사용 가능하며, 각각의 설치 방법을 따르면 된다.
- 웹에서는 설치하지 않고 url로 참조해 사용할 수도 있다.
- 버전이 올라감에 따라 참조방법, 인터페이스 등 사용법이 바뀌는 경우가 많으니 항상 docs를 잘 살펴보자
 - firebase link: https://firebase.google.com
 - firebase docs : https://firebase.google.com/docs


## 기능

### 인증 (Auth)
- firebase로 인증을 수행할 수 있다.
- email, phone, google account, facebook account 등 다양한 인증 방법을 제공한다.
- 다만, 주의할 점은 firebase API를 이용해 인증 서비스를 이용하면, 이후 확보된 사용자층을 다른 플랫폼으로 옮길 수 없다는 점이다.
