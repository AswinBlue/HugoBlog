---
title: "모던 자바스크립트(ES6+) 핵심 문법과 비동기 프로그래밍(Promise / async-await)"
description: "let/const 스코프, 화살표 함수, 구조 분해 할당, 이벤트 루프(Event Loop) 동작 원리 및 Promise와 async/await를 활용한 비동기 흐름 제어를 총정리합니다."
slug: "modern-javascript-es6-async-await-guide"
date: 2020-06-23T20:38:45+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebApplication"]
tags: ["javascript", "es6", "frontend", "async-await", "web-development"]
ShowToc: true
TocOpen: true
---

자바스크립트(JavaScript)는 정적인 HTML/CSS 웹 페이지에 동적인 인터랙션과 비즈니스 로직을 부여하는 표준 스크립트 프로그래밍 언어입니다. 브라우저 내장 자바스크립트 엔진(V8, JavaScriptCore 등)을 통해 실행되며, 브라우저 환경뿐만 아니라 Node.js를 통해 서버 사이드 런타임으로도 폭넓게 활용됩니다.

이 글에서는 HTML과의 연동 방식, ES6+ 변수 선언 및 데이터 타입, DOM 요소 탐색/조작, 객체와 메서드, 비동기 타이머 제어까지 핵심 기초 문법을 정리합니다.

---

## 1. 자바스크립트 개요 및 HTML 연동 방식

자바스크립트는 브라우저의 DOM(Document Object Model) 트리에 접근하여 HTML 요소를 동적으로 생성, 수정, 삭제할 수 있습니다.

### 1.1. 스크립트 작성 및 외부 파일 로드
- **내부 스크립트**: HTML 문서 내 `<script>` 태그를 선언하여 코드를 직접 작성합니다.
  ```html
  <script>
    console.log("Hello, JavaScript!");
  </script>
  ```
- **외부 스크립트 (권장)**: 별도의 `.js` 파일로 로직을 분리하고 `src` 속성으로 참조하여 재사용성과 캐싱 이점을 확보합니다.
  ```html
  <script src="main.js" defer></script>
  ```
- **인라인 이벤트 핸들러**: HTML 태그의 이벤트 속성에 자바스크립트 코드를 직접 바인딩합니다.
  ```html
  <button onclick="alert('버튼 클릭됨!')">확인</button>
  ```

### 1.2. DOM 요소 탐색과 내용 조작
CSS 선택자 문법을 사용하여 DOM 트리의 특정 엘리먼트를 손쉽게 획득할 수 있습니다.

```javascript
// 단일 요소 선택 (CSS 선택자와 동일)
const heading = document.querySelector('h1');
const submitBtn = document.querySelector('#btn-submit');

// 복수 요소 선택 (NodeList 컬렉션 반환)
const menuItems = document.querySelectorAll('.nav-item');

// 내용 및 스타일 동적 변경
submitBtn.textContent = "제출 완료";
submitBtn.style.backgroundColor = "#2b6cb0";
```

---

## 2. 데이터 타입과 변수 선언 (ES6+ 표준)

### 2.1. 변수 선언 키워드 (`const`, `let`)
과거의 `var` 키워드는 함수 레벨 스코프와 호이스팅 부작용으로 인해 유지보수에 위험이 따릅니다. 모던 자바스크립트에서는 블록 레벨 스코프를 지원하는 `const`와 `let`을 사용합니다.
- **`const`**: 재할당이 불가능한 상수를 선언할 때 기본으로 사용합니다.
- **`let`**: 값 재할당이 필요한 가변 변수에 한정하여 사용합니다.

```javascript
const maxLimit = 100;
let currentScore = 0;
currentScore += 10;
```

### 2.2. 원시 타입과 일치 연산자 (`===`)
자바스크립트의 기본 원시(Primitive) 타입에는 `String`, `Number`, `Boolean`, `Null`, `Undefined`, `Symbol`, `BigInt`가 있습니다.

연산자 사용 시 암묵적 타입 변환이 일어나는 동등 연산자(`==`) 대신, 값과 자료형을 모두 엄격하게 비교하는 **일치 연산자(`===`)**를 사용해야 버그를 방지할 수 있습니다.

```javascript
// 동등 연산자 (값만 비교, 암묵적 형변환 발생)
123 == "123";      // true
null == undefined;  // true

// 일치 연산자 (값과 타입 모두 비교 - 권장)
123 === "123";     // false
null === undefined; // false
```

---

## 3. 배열과 객체(Object) 다루기

### 3.1. 배열과 유용한 내장 메서드
배열은 순서가 있는 데이터의 집합이며 대괄호(`[]`)로 선언합니다.

```javascript
const fruits = ["사과", "바나나", "포도"];
console.log(fruits.length); // 3

// 요소 추가 및 순회
fruits.push("오렌지");
fruits.forEach((item, index) => {
  console.log(`${index}: ${item}`);
});
```

### 3.2. 객체(Object)와 메서드, `this`
객체는 키(Key)와 값(Value)의 쌍으로 구성되며 중괄호(`{}`)로 정의합니다. 객체 내부에 선언된 함수를 메서드(Method)라고 하며, 메서드 내부에서 `this`는 해당 함수를 호출한 객체 자신을 가리킵니다.

```javascript
const userProfile = {
  name: "홍길동",
  role: "프론트엔드 개발자",
  skills: ["JavaScript", "React"],
  introduce() {
    return `안녕하세요, ${this.name}(${this.role})입니다.`;
  }
};

// 속성 접근 (마침표 표기법 및 대괄호 표기법)
console.log(userProfile.name);
console.log(userProfile["role"]);
console.log(userProfile.introduce());

// 객체 키 순회 (for...in)
for (const key in userProfile) {
  if (Object.prototype.hasOwnProperty.call(userProfile, key)) {
    console.log(`${key}: ${userProfile[key]}`);
  }
}
```

---

## 4. 이벤트 핸들링과 비동기 타이머 함수

### 4.1. 이벤트 리스너 등록 (`addEventListener`)
HTML 인라인 속성 대신 자바스크립트 코드에서 `addEventListener`를 사용하는 것이 유지보수와 관심사 분리에 유리합니다.

```javascript
const actionBtn = document.querySelector('#action-btn');

actionBtn.addEventListener('click', (event) => {
  console.log("이벤트 발생 타깃:", event.target);
  alert("버튼이 정상적으로 클릭되었습니다.");
});
```

### 4.2. 비동기 타이머 메서드 (`setTimeout`, `setInterval`)
브라우저의 Web API를 활용하여 지정된 지연 시간 후 작업을 실행하거나 일정 주기로 작업을 반복합니다.

```javascript
// 3초(3000ms) 후 1회 실행
const timerId = setTimeout(() => {
  console.log("3초 후 실행되는 지연 작업");
}, 3000);

// 필요 시 예약 취소
clearTimeout(timerId);

// 1초마다 반복 실행
let counter = 0;
const intervalId = setInterval(() => {
  counter++;
  console.log(`경과 시간: ${counter}초`);
  if (counter >= 5) {
    clearInterval(intervalId); // 5초 후 반복 중지
  }
}, 1000);
```
