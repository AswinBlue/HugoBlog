---
title: "React 프로젝트에 Firebase SDK 연동 및 실시간 데이터 바인딩 실전 가이드"
description: "React 웹 애플리케이션에 최신 Firebase 모듈러 SDK를 연동하여 사용자 인증 상태 감지(onAuthStateChanged), Google 소셜 팝업 로그인, 에러 예외 처리 및 실시간 데이터 바인딩 구현법을 정리합니다."
slug: "react-firebase-sdk-realtime-database-integration"
date: 2022-02-12T19:32:34+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DataBases"]
tags: ["react", "firebase", "authentication", "frontend", "baas"]
ShowToc: true
TocOpen: true
---

단일 페이지 애플리케이션(SPA)의 표준인 React와 서버리스 BaaS의 대표 주자인 Firebase를 결합하면 별도의 백엔드 API 서버를 구축하지 않고도 사용자 인증과 실시간 데이터 동기화가 지원되는 웹 서비스를 고속으로 제작할 수 있습니다.

이 글에서는 React 프로젝트에서 Firebase 모듈러 SDK를 설정하는 방법, React 상태(State)와 `onAuthStateChanged` 관찰자(Observer)의 연동, 이메일 및 Google 소셜 로그인 구현, 그리고 실무 예외 처리 기법을 정리합니다.

---

## 1. React 환경에서 Firebase SDK 설정 및 환경변수 분리

Firebase SDK를 설치하고 브라우저 번들에 API 키가 안전하게 주입될 수 있도록 `.env` 환경변수를 구성합니다.

```bash
# Firebase 최신 SDK 설치
npm install firebase
```

### 1.1. 환경변수 파일 (`.env`) 구성
Git 저장소에 민감 키가 노출되지 않도록 프로젝트 루트의 `.env`에 정의하고 `.gitignore`에 등록합니다. Create-React-App 기준 접두사 `REACT_APP_`을 사용합니다.

```env
REACT_APP_FIREBASE_API_KEY=AIzaSyA1234567890abcdef
REACT_APP_FIREBASE_AUTH_DOMAIN=my-react-app.firebaseapp.com
REACT_APP_FIREBASE_PROJECT_ID=my-react-app
REACT_APP_FIREBASE_STORAGE_BUCKET=my-react-app.appspot.com
REACT_APP_FIREBASE_MESSAGING_SENDER_ID=123456789012
REACT_APP_FIREBASE_APP_ID=1:123456789012:web:abcdef123456
```

### 1.2. Firebase 모듈러 초기화 (`src/firebase.js`)
트리 셰이킹(Tree-shaking)을 지원하는 v9+ 모듈러 SDK 문법을 적용하여 필요한 기능만 선택적으로 임포트합니다.

```javascript
import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";

const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID
};

const app = initializeApp(firebaseConfig);
export const authService = getAuth(app);
export const googleProvider = new GoogleAuthProvider();
export default app;
```

---

## 2. 사용자 인증(Auth) 로직 및 React State 연동

로그인 직후 `authService.currentUser` 값은 비동기로 초기화되기 때문에 즉시 참조하면 `null`이 반환될 수 있습니다. 반드시 `onAuthStateChanged` 리스너를 활용해야 합니다.

### 2.1. 인증 상태 관찰자(Observer) 기반 루트 컴포넌트
`App.js`에서 앱 실행 시점에 로그인 세션을 확인하고 로딩 처리를 수행합니다.

```javascript
import React, { useState, useEffect } from "react";
import { onAuthStateChanged } from "firebase/auth";
import { authService } from "./firebase";
import AppRouter from "./Router";

function App() {
  const [init, setInit] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userObj, setUserObj] = useState(null);

  useEffect(() => {
    // 세션 인증 상태 변화 실시간 감지
    const unsubscribe = onAuthStateChanged(authService, (user) => {
      if (user) {
        setIsLoggedIn(true);
        setUserObj(user);
      } else {
        setIsLoggedIn(false);
        setUserObj(null);
      }
      setInit(true); // Firebase 초기화 완료
    });

    return () => unsubscribe();
  }, []);

  return (
    <>
      {init ? (
        <AppRouter isLoggedIn={isLoggedIn} userObj={userObj} />
      ) : (
        <div>애플리케이션 초기화 중...</div>
      )}
    </>
  );
}

export default App;
```

---

## 3. 이메일/비밀번호 가입 및 로그인 컴포넌트

사용자 입력 폼을 통해 가입 또는 로그인을 수행하며, 발생 가능한 Firebase 오류 코드를 잡아 사용자에게 알림을 제공합니다.

```javascript
import React, { useState } from "react";
import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword
} from "firebase/auth";
import { authService } from "./firebase";

function AuthForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [newAccount, setNewAccount] = useState(true);
  const [errorMessage, setErrorMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrorMessage("");

    try {
      if (newAccount) {
        // 신규 회원가입
        await createUserWithEmailAndPassword(authService, email, password);
      } else {
        // 기존 회원 로그인
        await signInWithEmailAndPassword(authService, email, password);
      }
    } catch (error) {
      // Firebase 에러 코드 핸들링
      switch (error.code) {
        case "auth/email-already-in-use":
          setErrorMessage("이미 사용 중인 이메일 주소입니다.");
          break;
        case "auth/weak-password":
          setErrorMessage("비밀번호는 최소 6자 이상이어야 합니다.");
          break;
        case "auth/user-not-found":
        case "auth/wrong-password":
          setErrorMessage("이메일 또는 비밀번호가 올바르지 않습니다.");
          break;
        default:
          setErrorMessage(error.message);
      }
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        placeholder="이메일 입력"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="비밀번호 입력"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <button type="submit">{newAccount ? "계정 만들기" : "로그인"}</button>
      <span onClick={() => setNewAccount((prev) => !prev)}>
        {newAccount ? "기존 계정으로 로그인" : "신규 계정 생성"}
      </span>
      {errorMessage && <p className="error-text">{errorMessage}</p>}
    </form>
  );
}
```

---

## 4. Google 소셜 팝업 로그인 및 세션 관리

별도의 복잡한 OAuth 백엔드 통신 없이 `signInWithPopup` 메서드만으로 소셜 인증 플로우를 완성할 수 있습니다.

### 4.1. 소셜 로그인 버튼 구현
```javascript
import React from "react";
import { signInWithPopup } from "firebase/auth";
import { authService, googleProvider } from "./firebase";

function SocialLogin() {
  const onGoogleSignIn = async () => {
    try {
      const result = await signInWithPopup(authService, googleProvider);
      console.log("Google 로그인 성공 사용자:", result.user.displayName);
    } catch (error) {
      console.error("소셜 로그인 중 오류 발생:", error.message);
    }
  };

  return (
    <div>
      <button onClick={onGoogleSignIn}>Google 계정으로 계속하기</button>
    </div>
  );
}
```

### 4.2. 로그아웃 처리
`signOut(authService)`를 호출하면 브라우저의 로컬 스토리지 및 IndexedDB에 저장된 세션 토큰이 즉시 초기화되며 `onAuthStateChanged`가 호출되어 UI가 로그인 이전 상태로 복구됩니다.
