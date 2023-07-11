+++
title = "Linux_apt"
date = 2020-05-25T18:30:15+09:00
lastmod = 2020-05-25T18:30:15+09:00
tags = ["linux",]
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

Linux 서버에 개발 환경을 세팅하는데 뭔가 제대로 되지 않아 이미 환경설정을 해 본 다른 사람에게 원격으로 도움을 요청했다. 

하지만 그 사람이 리눅스에 익숙하지 않았는지, 우리 서버를 잘못 만져 apt가 먹통이 되는 현상이 발생했다. 

본 해프닝에 대해 서술하자면 아래와 같다. 

## 원인

/bin 디렉터리 안의 python bin파일을 강제로 삭제한 것이 원인으로 추정된다. 

환경 설정을 하는데 제대로 되지 않으니 sudo apt-get upgrade 명령도 남용하기도 했다. 


## 현상

apt를 이용해 install, remove를 하려 하면 py3compile, py3clean 등에서 오류가 발생하였다. 

apt 명령을 수행하면 
```
/usr/bin/dpkg return an errorcode(1) 
```

오류가 발생하며 정상 동작하지 않는다. 

install -f 명령도 먹히지 않았다. 


## 해결

python bin파일이 없어졌고, python이 없다는 내용이 떴으므로 python을 다시 설치해 봤다. 

apt가 제대로 동작하지 않았으므로 git에서 python을 받아 빌드하여 설치했다. 


dpkg return an errorcode(1) 을 검색해보니 dpkg에 문제가 있을 수 있다는 내용이 많았다. 

dpkg를 재설정 해보라는 글들이 많아 내용대로 따라가 보았다. 

``/var/lib/dpkg/info`` 에는 설치된 프로그램의 목록들이 저장되어 있는듯 하다. 

apt 명령을 수행할 때 오류가 발생하는 프로그램들을 찾아 rm 명령으로 해당 프로그램의 내용을 삭제한다. 

삭제 후 ``dpkg --configure -a`` 명령을 사용하여 dpkg를 재설정 해준다. 

그 후 apt 명령을 사용하여 설치, 삭제를 해 보니 dpkg를 리셋한 내용들은 오류에 뜨지 않았다. 

오류가 나지 않을 때 까지 dpkg를 계속 재설정 해주니 정상 동작하게 되었다. 


## 결론

``/bin`` 안의 파일들을 강제로 삭제하면 apt가 충돌이 일어나 동작하지 않을 수 있으므로 주의한다. 

``/var/lib/dpkg/info`` 에서 설치된 패키지의 내용들을 확인 가능하다. 

``dpkg --configure -a`` 명령으로 dpkg를 리셋할 수 있다. 

