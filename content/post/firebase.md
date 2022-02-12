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
- 온라인으로 콘솔에 접속하여 프로젝트를 생성 및 설정하고, firebase sdk를 로컬에 다운받아 코드에 적용한다.
- firebase는 다양한 운영체제에 설치 가능하며, 각각의 설치 방법을 따르면 된다.
  (웹에서는 설치하지 않고 url로 참조해 사용할 수도 있다.)
>> 버전이 올라감에 따라 참조방법, 인터페이스 등 사용법이 바뀌는 경우가 많으니 항상 docs를 잘 살펴보자
 - firebase link: https://firebase.google.com
 - firebase docs : https://firebase.google.com/docs

- firebase를 코드에 적용하려면 config 데이터를 작성해야 한다.
  - firebase 콘솔에서 앱을 생성하고, 내 소스를 firebase의 내 프로젝트와 연동에 필요한 config 정보들을 복사하여 소스에 적용한다.
  ex) AppFirebase.js
```
import firebase from "firebase/compat/app";
import "firebase/compat/auth";

const firebaseConfig = {
  apiKey: process.env.REACT_APP_API_KEY,
  authDomain: process.env.REACT_APP_AUTHDOMAIN,
  projectId: process.env.REACT_APP_PROJECTID,
  storageBucket: process.env.REACT_APP_STORAGEBUCKET,
  messagingSenderId: process.env.REACT_APP_MESSAGINGSENDERID,
  appId: process.env.REACT_APP_APPID
};

export default firebase.initializeApp(firebaseConfig);

export const authService = firebase.auth();

```

## 기능
- firebase 콘솔에 로그인 하고, 프로젝트를 생성한다. 생성된 프로젝트에 진입하여 원하는 기능을 사용할 수 있다.

### 인증 (Auth)
- 'Authentication' 탭을 선택하여 사용 가능하다.
- email, phone, google account, facebook account 등 다양한 인증 방법을 제공한다.
- 다만, 주의할 점은 firebase API를 이용해 인증 서비스를 이용하면, 이후 확보된 사용자층을 다른 플랫폼으로 옮길 수 없다는 점이다.
- 로그인에 사용된 계정들은 콘솔창에서 관리할 수 있으며, 비밀번호 재설정 등을 위한 메일도 커스텀할 수 있도록 환경이 제공된다.

#### React code
```
import { authService } from "../components/AppFirebase";

const data = await authService.createUserWithEmailAndPassword(email, password)  // email, passwd로 계정 생성
const data = await authService.signInWithEmailAndPassword(email, password)  // email, passwd로 로그인

```

#### email 인증
- Authentication 탭에서 signed-in method를 선택한다.
- 원하는 '로그인 제공업체' 를 선택하여 추가한다.

#####
