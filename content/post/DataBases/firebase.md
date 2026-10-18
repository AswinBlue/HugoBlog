---
title: "Firebase Authentication 및 Firestore 실전 연동과 보안 규칙(Rules) 가이드"
description: "구글의 대표적인 BaaS 플랫폼인 Firebase의 프로젝트 설정부터 Authentication 사용자 인증, Cloud Firestore NoSQL 연동, 환경변수 보안 관리 및 보안 규칙(Security Rules) 작성법을 체계적으로 정리합니다."
slug: "firebase-authentication-and-firestore-security-rules"
date: 2022-01-19T21:02:46+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DataBases"]
tags: ["firebase", "firestore", "nosql", "authentication", "baas"]
ShowToc: true
TocOpen: true
---

Firebase는 Google에서 제공하는 모바일 및 웹 애플리케이션 개발을 위한 대표적인 BaaS(Backend-as-a-Service) 플랫폼입니다. 서버 인프라를 직접 구축하고 유지보수할 필요 없이 사용자 인증, 실시간 NoSQL 데이터베이스, 클라우드 스토리지, 서버리스 함수(Cloud Functions) 등의 백엔드 핵심 기능을 API 호출만으로 손쉽게 구현할 수 있습니다.

이 글에서는 Firebase 프로젝트 초기화부터 Authentication 사용자 인증, Cloud Firestore 실시간 데이터베이스 연동, 그리고 보안 규칙(Security Rules) 작성 원칙까지 실무 적용 방법을 정리합니다.

---

## 1. Firebase 플랫폼 개요 및 BaaS(Backend-as-a-Service) 특징

### 1.1. Firebase의 주요 장점과 고려사항
- **신속한 프로토타이핑**: 복잡한 백엔드 서버 개발 없이 클라이언트(웹/모바일) 로직에만 집중하여 MVP(최소 기능 제품)를 빠르게 출시할 수 있습니다.
- **실시간 데이터 동기화**: 웹소켓 기반의 실시간 리스너를 제공하여 채팅, 알림, 대시보드 기능을 손쉽게 구현합니다.
- **플랫폼 종속성(Vendor Lock-in) 주의**: 사용자 인증 데이터나 데이터베이스 스키마가 Firebase 고유 체계에 종속되므로, 서비스 규모가 매우 커질 경우 타 플랫폼으로의 마이그레이션 비용을 사전에 검토해야 합니다.

### 1.2. 프로젝트 콘솔 생성 및 SDK 초기화 설정
[Firebase Console](https://firebase.google.com)에서 신규 프로젝트를 생성하고 웹 앱을 추가한 후 발급받은 구성 키(Config)를 프로젝트에 등록합니다.

```javascript
// src/services/firebase.js
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

// 민감 설정값은 .env 파일로 분리하여 관리
const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID
};

// Firebase 앱 인스턴스 초기화
const app = initializeApp(firebaseConfig);

// 인증 및 데이터베이스 서비스 모듈 내보내기
export const auth = getAuth(app);
export const db = getFirestore(app);
export default app;
```

---

## 2. Firebase Authentication 사용자 인증 구현

Firebase Auth는 이메일/비밀번호 인증뿐만 아니라 Google, GitHub, Apple 등 다양한 OAuth 소셜 로그인을 통합 지원합니다.

### 2.1. 이메일/비밀번호 회원가입 및 로그인
```javascript
import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut
} from "firebase/auth";
import { auth } from "./firebase";

// 신규 회원가입
export const registerUser = async (email, password) => {
  try {
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    console.log("가입 성공:", userCredential.user.uid);
    return userCredential.user;
  } catch (error) {
    console.error("회원가입 실패:", error.code, error.message);
    throw error;
  }
};

// 기존 회원 로그인
export const loginUser = async (email, password) => {
  try {
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    return userCredential.user;
  } catch (error) {
    console.error("로그인 실패:", error.code);
    throw error;
  }
};

// 로그아웃
export const logoutUser = () => signOut(auth);
```

### 2.2. 인증 상태 변화 감지 (`onAuthStateChanged`)
애플리케이션 최상단에서 세션 상태를 실시간 구독하여 로그인 여부에 따른 UI를 반응형으로 갱신합니다.

```javascript
import { useEffect, useState } from "react";
import { onAuthStateChanged } from "firebase/auth";
import { auth } from "./firebase";

export function useAuth() {
  const [currentUser, setCurrentUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setCurrentUser(user);
      setLoading(false);
    });
    return unsubscribe; // 클린업 함수
  }, []);

  return { currentUser, loading };
}
```

---

## 3. Cloud Firestore NoSQL 데이터베이스 연동

Cloud Firestore는 유연한 계층형 문서 지향(Document-oriented) NoSQL 데이터베이스입니다. 데이터는 컬렉션(Collection) 내부의 개별 문서(Document) 형태로 저장됩니다.

### 3.1. 기본 CRUD 작업
```javascript
import { collection, addDoc, getDocs, doc, updateDoc, deleteDoc } from "firebase/firestore";
import { db } from "./firebase";

// 1. 문서 추가 (Create)
export const createPost = async (title, content, userId) => {
  return await addDoc(collection(db, "posts"), {
    title,
    content,
    userId,
    createdAt: new Date()
  });
};

// 2. 전체 목록 조회 (Read)
export const fetchPosts = async () => {
  const querySnapshot = await getDocs(collection(db, "posts"));
  return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

// 3. 문서 수정 및 삭제 (Update & Delete)
export const updatePost = async (postId, newTitle) => {
  const postRef = doc(db, "posts", postId);
  await updateDoc(postRef, { title: newTitle });
};

export const deletePost = async (postId) => {
  await deleteDoc(doc(db, "posts", postId));
};
```

---

## 4. Firebase 보안 규칙(Security Rules) 및 환경변수 보호

BaaS 환경에서는 클라이언트가 데이터베이스에 직접 질의하므로, 서버 사이드 보안 검증 역할을 하는 **보안 규칙(Rules)**을 반드시 엄격하게 설정해야 합니다.

### 4.1. Firestore 보안 규칙 예시
테스트 모드의 `allow read, write: if true;` 규칙은 누구나 데이터베이스를 삭제할 수 있는 치명적 보안 결함입니다. 인증된 작성자 본인만 쓰기 권한을 갖도록 제어해야 합니다.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // posts 컬렉션 보안 규칙
    match /posts/{postId} {
      // 읽기는 누구나 허용
      allow read: if true;

      // 생성은 로그인된 사용자만 허용
      allow create: if request.auth != null;

      // 수정 및 삭제는 작성자 본인(userId 일치)만 허용
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

### 4.2. 클라이언트 API 키 보안 관리
Firebase config의 `apiKey`는 클라이언트 번들에 포함되므로, Google Cloud Console의 **사용자 인증 정보** 메뉴에서 해당 API 키가 지정된 도메인(예: `https://my-app.com`)에서만 요청을 전송할 수 있도록 **HTTP 리퍼러(Referrer) 제한**을 설정하는 것이 필수적입니다.
