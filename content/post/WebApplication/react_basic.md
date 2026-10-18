---
title: "React 기초 입문: 컴포넌트 생명주기, State/Props 및 Hooks 핵심 완벽 정리"
description: "React의 기본 구조와 JSX 문법부터 클래스/함수형 컴포넌트 비교, Props와 State 관리, 핵심 Hooks(useState, useEffect, useRef), React Router 활용까지 총정리합니다."
slug: "react-basics-components-state-props-hooks-guide"
date: 2021-08-23T18:46:22+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebApplication"]
tags: ["react", "javascript", "frontend", "hooks", "spa"]
ShowToc: true
TocOpen: true
---

React는 Facebook(현 Meta)에서 개발한 사용자 인터페이스(UI) 구축용 오픈소스 자바스크립트 라이브러리입니다. 가상 DOM(Virtual DOM)을 활용한 고성능 렌더링 엔진과 컴포넌트 기반 아키텍처를 바탕으로 모던 웹 애플리케이션 개발의 사실상 표준(De facto standard)으로 자리 잡았습니다.

이 글에서는 React의 개발 환경 구축부터 프로젝트 구조, ES6+ 핵심 문법, Props와 State 관리, 함수형 컴포넌트 및 Hooks API, 그리고 React Router 기반의 라우팅 기법까지 실무 기초 전반을 상세히 다룹니다.

---

## 1. React 개요 및 프로젝트 환경 구축

React 애플리케이션은 Node.js 및 npm 기반의 번들러 도구를 사용하여 손쉽게 스캐폴딩할 수 있습니다.

### 1.1. Create-React-App 및 Vite 프로젝트 생성
기존 표준 도구인 `create-react-app` 또는 초고속 번들러인 `vite`를 활용하여 프로젝트를 생성합니다.

```bash
# create-react-app을 활용한 프로젝트 생성 (프로젝트명은 소문자만 허용)
npx create-react-app my-react-app

# 개발 서버 실행 (기본 포트: 3000)
cd my-react-app
npm start
```

### 1.2. 기본 디렉터리 구조 및 렌더링 진입점
React 앱의 핵심 진입점은 `public/index.html`과 `src/index.js`입니다.

```text
my-react-app/
├── public/
│   └── index.html         # id="root" DOM 컨테이너를 포함하는 단일 HTML
├── src/
│   ├── App.css            # 컴포넌트 스타일시트
│   ├── App.js             # 최상위 루트 컴포넌트
│   ├── index.css          # 글로벌 스타일시트
│   └── index.js           # Virtual DOM을 실제 DOM root에 마운트하는 진입점
└── package.json
```

`src/index.js`는 `ReactDOM.createRoot`를 통해 루트 엘리먼트에 `<App />` 컴포넌트를 마운트합니다.

```javascript
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
```

---

## 2. 모던 자바스크립트(ES6+) 핵심 문법과 불변성

React 코드를 효과적으로 다루기 위해서는 모던 자바스크립트의 비구조화 할당과 불변성(Immutability) 패턴을 숙지해야 합니다.

### 2.1. 변수 선언 스코프 (const, let vs var)
과거의 `var`는 함수 스코프와 호이스팅으로 인해 예기치 않은 부작용을 일으킵니다. 블록 레벨 스코프를 지원하는 `const`와 `let`을 사용해야 합니다.
- **`const`**: 재할당이 필요 없는 기본 변수 및 컴포넌트 함수 선언 시 사용합니다.
- **`let`**: 카운터나 루프 인덱스 등 재할당이 필요한 경우에 한정하여 선언합니다.

### 2.2. 구조 분해 할당(Destructuring) 및 전개 연산자(...)
객체나 배열의 내부 요소를 손쉽게 추출하고 복제할 수 있습니다.

```javascript
// 객체 구조 분해 할당 및 기본값 설정
const user = { name: "철수", age: 25 };
const { name, age, role = "게스트" } = user;

// 전개 연산자(Spread Operator)를 이용한 객체/배열 불변 복사
const updatedUser = { ...user, age: 26 };
const numbers = [1, 2, 3];
const newNumbers = [...numbers, 4, 5];
```

### 2.3. 배열 순회 및 불변성 조작 (map, filter)
JSX 내부에서 동적 리스트를 렌더링할 때는 원본 배열을 변형하지 않고 새로운 배열을 반환하는 `map()` 메서드를 사용합니다. 이때 고유한 `key` prop을 반드시 지정해야 React의 가상 DOM 재조정(Reconciliation) 성능이 최적화됩니다.

```javascript
const items = [
  { id: 1, text: "React 학습" },
  { id: 2, text: "컴포넌트 분리" },
  { id: 3, text: "배포 실습" }
];

function ItemList() {
  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>{item.text}</li>
      ))}
    </ul>
  );
}
```

---

## 3. React 컴포넌트 아키텍처: Props와 State

### 3.1. 컴포넌트 선언 방식 (함수형 vs 클래스형)
과거에는 상태 관리를 위해 클래스형 컴포넌트를 사용했으나, React 16.8 Hooks 도입 이후 문법이 간결하고 메모리 효율이 뛰어난 **함수형 컴포넌트**가 표준으로 사용됩니다.

```javascript
// 모던 함수형 컴포넌트
function Header({ title }) {
  return (
    <header>
      <h1>{title}</h1>
    </header>
  );
}
```

### 3.2. Props (부모 &rarr; 자식 데이터 전달)
Props는 부모 컴포넌트가 자식 컴포넌트에 전달하는 읽기 전용(Read-Only) 데이터입니다. 자식 컴포넌트는 props를 직접 수정할 수 없으며 단방향 데이터 흐름(One-way Data Binding)을 유지합니다.

```javascript
function WelcomeCard(props) {
  return <h2>안녕하세요, {props.userName}님!</h2>;
}

// 부모 컴포넌트에서 호출
<WelcomeCard userName="홍길동" />
```

### 3.3. State (컴포넌트 자체 상태 관리)
State는 컴포넌트 내부에서 변경될 수 있는 동적 데이터입니다. 상태가 변경되면 React는 해당 컴포넌트와 하위 컴포넌트를 자동으로 리렌더링합니다. 상태는 반드시 상태 갱신 함수(`setState`)를 통해서만 변경해야 불변성이 유지됩니다.

### 3.4. 합성 컴포넌트와 `children` 속성
컴포넌트 태그 사이에 포함된 하위 엘리먼트는 `props.children`을 통해 컨테이너 형태로 재사용할 수 있습니다.

```javascript
function CardWrapper({ children }) {
  return <div className="card-box">{children}</div>;
}

// 사용 예시
<CardWrapper>
  <h3>공지사항</h3>
  <p>시스템 점검 안내입니다.</p>
</CardWrapper>
```

---

## 4. 컴포넌트 생명주기와 React Hooks

Hooks는 함수형 컴포넌트에서 상태와 라이프사이클 기능을 연동할 수 있도록 지원하는 특수 함수입니다. 반드시 컴포넌트 최상단에서만 호출해야 합니다.

### 4.1. `useState` (동적 상태 관리)
```javascript
import React, { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>현재 카운트: {count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>증가</button>
      <button onClick={() => setCount(0)}>초기화</button>
    </div>
  );
}
```

### 4.2. `useEffect` (부수 효과 및 생명주기 관리)
데이터 페칭, 이벤트 구독, 타이머 설정 등 컴포넌트의 렌더링 이후 발생하는 부수 효과(Side Effect)를 제어합니다.

```javascript
import React, { useState, useEffect } from 'react';

function UserProfile({ userId }) {
  const [user, setUser] = useState(null);

  useEffect(() => {
    // 마운트 및 userId 변경 시 실행
    console.log(`사용자 ID ${userId} 데이터 요청 시작`);

    return () => {
      // 클린업(Clean-up) 함수: 언마운트 또는 다음 effect 실행 직전 호출
      console.log(`이전 리소스 정리 (컴포넌트 소멸 또는 의존성 갱신)`);
    };
  }, [userId]); // 의존성 배열

  return <div>{user ? user.name : "로딩 중..."}</div>;
}
```

### 4.3. `useRef` (DOM 직접 참조 및 렌더링 독립 값 저장)
`useRef`는 렌더링을 유발하지 않는 가변 값을 유지하거나, 포커스 제어 등 실제 DOM 노드에 직접 접근할 때 사용합니다.

```javascript
import React, { useRef } from 'react';

function TextInputFocus() {
  const inputEl = useRef(null);

  const handleFocus = () => {
    inputEl.current.focus();
  };

  return (
    <div>
      <input ref={inputEl} type="text" placeholder="입력창" />
      <button onClick={handleFocus}>입력창으로 포커스 이동</button>
    </div>
  );
}
```

---

## 5. 이벤트 핸들링 및 싱글 페이지 라우팅 (React Router)

### 5.1. 합성 이벤트(SyntheticEvent)와 `e.preventDefault()`
React는 브라우저 간 크로스 브라우징을 지원하기 위해 W3C 표준 규격의 합성 이벤트를 제공합니다. 링크 클릭이나 폼 제출의 기본 동작을 막으려면 `e.preventDefault()`를 명시적으로 호출합니다.

```javascript
function FormSubmit() {
  const handleSubmit = (e) => {
    e.preventDefault(); // 페이지 새로고침 방지
    console.log("폼 데이터 비동기 전송 처리");
  };

  return (
    <form onSubmit={handleSubmit}>
      <button type="submit">제출</button>
    </form>
  );
}
```

### 5.2. React Router 기반 SPA 라우팅
페이지 전체를 새로고침하지 않고 브라우저 히스토리 API를 이용해 URL 경로별 컴포넌트를 전환합니다.

```bash
npm install react-router-dom
```

```javascript
import { BrowserRouter, Routes, Route, Link, Navigate } from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">홈</Link> | <Link to="/about">소개</Link>
      </nav>

      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        {/* 잘못된 경로는 홈으로 리다이렉션 */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
```

### 5.3. 프로덕션 빌드 및 환경변수(`.env`) 보호
- **빌드 최적화**: `npm run build` 명령어를 실행하면 코드 난독화, 공백 제거, 번들 파일 압축이 적용된 `build` 디렉터리가 생성됩니다.
- **클라이언트 환경변수 분리**: API 엔드포인트나 공개 키는 루트의 `.env` 파일에 `REACT_APP_` 접두사를 붙여 정의하며, Git 저장소 커밋에서 제외(`.gitignore`)하여 관리합니다. (단, 클라이언트 번들에 포함되므로 민감 비밀키는 백엔드에 보관해야 합니다.)
