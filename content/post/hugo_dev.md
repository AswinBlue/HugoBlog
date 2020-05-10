+++
author = "AswinBlue"
title = "Hugo 환경세팅"
date = 2020-05-10T12:23:13+09:00
lastmod = 2020-05-10T12:23:13+09:00
tags = [
    "Hugo",
]
categories = [
    "dev",
]

cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
+++

Git과 markdown을 이용하여 git을 블로그처럼 이용하는 사람들이 있다는 것을 알았다. 

게다가 UI를 보기 좋게 꾸며줄 수 있는 툴들도 찾았는데, 그 중 Hugo를 사용해 보았다.

 
Hugo는 Go 언어로 짜여져 있어 apt-get으로도 설치가 가능하고, 소스 코드를 받아 빌드하여 쓸 수도 있다.

내 컴퓨터에는 Go가 이미 설치되 있던 터라 apt-get으로 hugo를 받아서 사용해 보았다. 

설치는 정상적으로 되었고, 처음에는 잘 동작하는 듯 했는데, theme을 적용하니 ERROR들이 뜨기 시작했다. 

인터넷 검색을 아무리 해 봐도 해결책이 보이지 않고, 해당 git에 issue를 날려보기도 했는데 응답이 없어서 혼자 이것저것 뒤져 보았다. 

알고보니 내 hugo의 버전이 너무 낮아서 발생한 현상이었고, 덩달아 Go의 버전도 낮다는 것을 알아냈다. 

Go언어는 apt-get 대신 인터넷에서 tar파일을 받아서 압축을 풀어 사용했고, Hugo는 소스코드를 받아 Go 언어로 빌드하여 사용하였다. 

(brew를 이용해 보라고도 해서 brew를 설치 해 보기도 했는데, 잘 동작 하지 않아서 그만뒀다.)

버전을 최신으로 맞추고 나니 모두 정상동작, git에 올려놓은 issue를 뻘쭘하게 혼자 close했다. 

-----

# 링크

1. hugo 환경설정 및 사용방법 가이드

	아래 주소의 글쓴이도 hugo로 블로그를 만들어 관리하고 있다. 이분의 글을 토대로 환경을 세팅했다. 

	https://github.com/Integerous/Integerous.github.io

2. Hugo git 사이트

	Hugo의 소스파일을 다운받을 수 있다. 

	https://github.com/gohugoio/hugo

3. 내가 사용한 theme의 git 주소

	설명대로 theme을 다운받고, config파일을 수정해 주어야 최종적으로 적용이 된다. 

	https://github.com/cntrump/hugo-notepadium

4. Go 언어 설치 가이드

	https://golang.org/doc/install

5. Hugo 설치 가이드

	https://gohugo.io/getting-started/installing/

-----

# 기본 동작

새로운 Hugo 사이트를 생성하는 명령어, <NAME> 폴더 안에 Hugo 구조에 맞게 폴더 및 파일이 자동 생성된다. 
```
hugo site <NAME>
```

생성된 <NAME> 폴더에서 새로운 post를 생성하는 명령어, content 폴더 안에 archtype에 맞게 내용을 적어 파일을 생성한다. 
```
hugo new <POST>
```

테마에 맞는 형식으로 content 폴더 안의 내용을 이용해 public 폴더 안에 내용을 생성한다. 
```
hugo -t <THEME>
```
본인은 hugo-notepadium 테마를 사용했다. 문서 최상단에 +++로 둘러쌓인 부분은 설정 부분이다. draft=false로 설정을 해야 화면에 표시된다. (이걸 몰라서 한참을 헤맸다.)

public 폴더에 생성한 내용을 push 하기 전 테스트 해 본다.
```
hugo server [--theme <THEME_PATH>]
```

Go와 Hugo의 설치만 잘 하면 사용 가이드는 인터넷에 잘 정리된 글들이 많다. 참조하면 활용에 문제는 없을 것이다. 




