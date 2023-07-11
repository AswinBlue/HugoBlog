+++
title = "Firebase_react"
date = 2022-02-12T19:32:34+09:00
lastmod = 2022-02-12T19:32:34+09:00
tags = ['react', 'firebase',]
categories = ['dev',]
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

# Firebase with React
- react에서 firebase를 활용하는 방법
- firebase SDK를 설치하거나 웹상에서 설치없이 사용하는 방법은 firebase 기본을 참조

## 인증 (Auth)
- firebase 로 계정 생성 및 로그인

1. firebase API를 import하여 사용
- <AppFirebase.js>
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

1. AppFirebase.js 를 활용하여 business logic에 필요한 로그인 / 회원가입 기능을 구현
<Auth.js>
```
import { authService } from "../components/AppFirebase";

const data = await authService.createUserWithEmailAndPassword(email, password)  // email, passwd로 계정 생성
const data = await authService.signInWithEmailAndPassword(email, password)  // email, passwd로 로그인
```
- createUserWithEmailAndPassword / signInWithEmailAndPassword 실행 이후 authService.currentUser를 참조하면 user 정보를 받아올 수 있다.
- 하지만, authService.currentUser 정보를 갱신하는데는 시간이 걸린다. firebase API에서는 observer를 등록하여 currentUser의 변경 시점을 확인할 수 있다.

1. currentUser 변경시점에 특정함수 동작
- user 정보가 갱신된 시점에 특정 동작을 원한다면, 아래와 같이 onAuthStateChanged 함수를 사용하면 된다.
```
authService.onAuthStateChanged((user) => { /* something to do */ }});
```
1. 로그아웃
- `authService.signOut()` 함수를 호출하여 로그아웃이 가능하다.
- 참고로 크롬 웹 디버깅 화면에서 'Application'탭에 들어가서 IndexedDB -> firebaseLocalDb 안의 내용을 🚫버튼으로 삭제해 주면 로그인 정보가 사라진다.

1. 에러
- `authService`의 함수(`createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, ...) 사용시 에러가 발생할 수 있으므로, try, catch문으로 묶어서 사용한다.
```
try {
  let data
  data = await authService.createUserWithEmailAndPassword(email, password)
} catch(error) {
  console.log(error.code) // 에러의 원인이 코드 형태로 출력된다.
  console.log(error.message) // 에러의 원인이 메시지 형태로 출력된다.
}
```
  ref) 오류발생 원인
  - 6자리 이하로 비밀번호 생성시
  - 동일한 e-mail로 계정 생성시

1. Google 계정으로 로그인
- firebase에서는 google, facebook 등 계정으로 로그인 할 수 있도록 기능을 제공한다.
- 팝업으로 로그인을 유도하는 방식과, redirect로 로그인하는 방식이 있다.
```
import { authService, firebaseModule } from "../components/AppFirebase";

const onSocialClick = async (event) => {
  try {
    let provider;
    provider = new firebaseModule.auth.GoogleAuthProvider();  //
  } catch (error) {
    console.log(error);
  }
  await authService.signInWithPopup(provider); // 팝업으로 로그인
}
```
