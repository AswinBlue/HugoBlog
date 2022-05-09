+++
title = "React_adv"
date = 2021-08-24T19:50:51+09:00
lastmod = 2021-08-24T19:50:51+09:00
tags = ["react", "javascript", "web application"]
categories = ["dev", "advanced",]
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = true
+++

# React Advanced

## 라이프사이클
- 컴퍼넌트는 '마운트 -> 업데이트 -> 언마운트' 생명주기를 갖는다.

### 마운트
- 마운트 단계 메서드로는 다음이 존재한다.
  - `constructor` :  생성시 호출되는 메서드 (생성자)
  - `getDerivedStateFromProps` : props 값을 state에 넣는 메서드
  - `render` : UI를 렌더링 하는 메서드(화면 재구성)
  - `componentDidMount` : 컴퍼넌트 랜더링 완료 후 호출되는 메서드

### 업데이트
- 컴퍼넌트가 업데이트 되는 경우는 아래의 경우들이 속한다.
  1) setProps를 이용한 props변경시
  2) setState를 이용한 state변경시
  3) 부모 컴퍼넌트가 리렌더링 될 시  
  4) this.forceUpdate로 강제 렌더링시

- 업데이트 단계의 메서드로는 다음이 존재한다.
  - `getDerivedStateFromProps` : props의 값을 state에 입력
  - `shouldComponentUpdate` : 컴퍼넌트의 변화를 인지하고, 랜더링 필요 여부를 판단. true: 랜더링 필요, false: 랜더링 불필요.
  - `render` : 컴퍼넌트 리렌더링  
  - `getSnapshotBeforeUpdate` : 컴퍼넌트 변화를 DOM에 반영하기 바로 직전에 호출되 메서드
  - `componentDidUpdate` : 컴퍼넌트 업데이트 작업이 끝난 후 호출되 메서드

### 언마운트
- 언마운트 단계의 메서드로는 다음이 존재한다.
  - `componentWillUnmount` : 컴퍼넌트가 브라우저상에서 사라지기 직전 호출되는 메서드

---

## this
 - javascript 문법의 this와 동일하게 동작한다.
 - class 안에서는 this를 호출하면 class(컴퍼넌트)에 소속된 요소들에 접근할 수 있다.
 - 일반 function 안에서 this를 호출하면 자신이 종속된 객체에 접근한다.
 - arrow function 안에서 this를 호출하면 자신이 종속된 인스턴스(컴퍼넌트)에 접근한다.
 ```
   function func1() {
     this.name = "func1"
     return {
         name : "return"
         arrow : () => {
           console.log(this.name) // 'func1' 출력
         }
         normal : function() {
           console.log(this.name) // 'return' 출력
         }
     }
   }
 ```

---

## hook
- class component에는 this.state가 있지만 function component 에서는 this.state가 없다. 대신 hook을 사용하여 동일한 기능을 수행한다.
- React에서는 built-in hook을 지원하고, 사용자가 직접 정의해서 사용할 수도 있다.

### hook의 조건
 1. hook은 React 함수에서만 호출해야 한다. 일반 javascript 함수에서 호출하면 안된다.
 2. hook은 반복문, 조건문, nested function에서 호출되면 안된다.
 >위 두 조건을 이해하려면 hook의 동작 원리를 이해해야한다.  
  React는 컴퍼넌트를 처리할때 hook 함수들을 호출된 순서대로 관리한다.  
  만약 컴퍼넌트를 업데이트할 때 hook 함수들의 순서가 변경된다면 React는 이를 정상적으로 처리하지 못한다.  
  이때문에 hook은 항상 컴퍼넌트의 최상단에서 호출되어야 한다.

### hook의 종류
1. State Hooks
 - `import { useState } from 'react'` 로 참조한다.
 - `[state, updateState] = useState( VALUE )`: 컴퍼넌트에 VALUE값을 저장하고, 배열을 반환한다. 'state' 는 VALUE 와 동일한 값이며, 'updateState' 는 state값을 업데이트할 수 있는 함수 페어를 반환한다. 'updateState' 는 `this.setState`와 유사한 효과를 가진다.
  - VALUE값으로는 숫자, 문자열, 객체 모두 수용 가능하다.

2. Effect Hooks
 - `import React, { useEffect } from 'react';`로 참조한다.
 - componentDidMount, componentWillUnmount 혹은 componentDidUpdate 와 유사한 효과를 발생시키며, 한 함수에서 여러번 선언 가능하다.
 - useEffect의 첫번째 인자로 함수가 들어가는데, 이 함수는 componentDidMount와 같은 시점에 동작된다.
 - useEffect의 첫번째 인자로 들어간 함수는 return값으로 함수를 반환하는데, 이 반환된 함수는 componentWillUnmount와 같은 시점에 동작된다.
 - useEffect의 두번째 인자로는 배열이 들어가고, 빈 배열을 넣을수도 있고, 값을 넣을수도 있다.
   - 이 배열 요소의 값이 바뀔경우 useEffect의 첫번째 인자로 들어간 함수를 실행시킨다. (componentDidUpdate와 유사하게 특정 변수가 변할때 rerendering을 할 수 있다.)
   - 또한, 이 배열 요소의 값이 바뀌기 직전, 첫번째 인자로 들어간 함수의 return 값이 실행된다.
 ```
     // return 없는 함수만 오는 경우
     useEffect( () => {
       console.log("componentDidUpdate");
     }
     // return 이 포함된 함수가 오는 경우
     useEffect( () => {
       console.log("componentDidMount");
       return (
         () => { console.log("componentWillUnmount") }
       )
     })
     // 두번쨰 인자가 들어간 경우
     useEffect( () => {
       console.log("'value' changed");
       return (
         () => { console.log("value will be change")}
       )
     }, [value])

 ```
 - class 의 componentdidMount와 같은 함수에 비해 간단하고 직관적으로 사용할 수 있다.

3. Context Hooks
 - `useContext`
4. Reducer Hooks
 - `useReducer`
5. Custom Hooks
 - hook을 담고 있는 사용자 정의 함수를 custom hook이라 칭한다. 반복되는 hook 호출 + 일련의 처리 과정을 하나의 함수로 묶어서 사용할 수 있다.
 - 통념적으로 'use'로 시작하는 이름을 붙여준다.
 - 호출된 custom hook도 일반 hook과 마찬가지로 중복해서 사용이 가능하며 각 hook들 끼리는 독립적이다.

---

## 각종 모듈
### Router
- SPA (Single Page Application) 에서 사용하지 않는 리소스를 로딩하느라 시간이 오래걸리는 것을 방지하기 위해, 소스를 분할처리하여 사용시에만 받을수 있게 하는 모듈
- 설치 : `npm install react-router-dom`
- 사용 :
```
import { HashRouter, Route, Routes, BrowserRouter} from "react-router-dom";
const sample = () => {
    return (
        <HashRouter>
          /* can add any components you want */
          <Routes>
          /* can only put 'Route' components in 'Routes' */
          <Route path="/" element={<Home/>} />  // '/' 주소 호출시 Home component를 호출
          <Route path="/about/*" element={<About/>} />  // 'about' 및 'about/...' 형태의 주소 호출시 About component 호출
          /* add as you wish */
          </Routes>
        </HashRouter>
    );
};
```
- Route는 위에서부터 순차적으로 적용된다. if-else if 구문으로 생각하면 편하다.
- 정규식 wild card `*`을 사용할 수 있다. (v5에서 exact 옵션 삭제되고 '*'로대체)
- route 하는 대상에 props을 전달하고 싶다면,

### Link
- 특정 페이지로 경로를 전환해 주는 기능을 한다.
- react-router-dom 모듈 안에 포함되어있다.
- `<a>` 태그와 동일한 역할을 하지만, React에서는 `<a>`를 사용하면 페이지를 새로 호출하여 React가 지니고 있던 상태들이 모두 초기화되기 때문에 `<a>` 태그 대신 link를 사용하는것이 맞다.
- link는 페이지의 개념이고, button은 operation의 개념이다. 모두 event를 발생시킬 수 있지만 구분을 하는게 좋다.
- 설치 : `npm install react-router-dom`
- 사용 :
```
import { Link } from "react-router-dom";
...
<Link to="/">Root</Link> // 클릭하면 '/' 경로로 redirect 되는 Link 생성
```
### Redirect
- react-router-dom에서 redirect를 지원하는 방법은 여러가지가 있다.
1. Navigate 모듈
- 사용 :
```
import { HashRouter, Routes, Route, Navigate } from "react-router-dom";
...
<HashRouter>
  <Routes>
    <Route path="/" element={<Home/>}
    <Route path="/about" element={<About/>}
    /* add as you wish */
    <Route path="/index" element={<Navigate replace to="/" />} />  // 'index' 페이지를 '/' 경로로 redirect
    <Route path="*" element={<Navigate to="/" />} />  // 위에서 설정되지 않은 경로에 대해서는 모두 '/'로 redirect
  </Routes>
</HashRouter>
```
1. useHistory
- 사용 :
```
const history = useHistory();
history.push("/");  // '/' 경로로 redirect
```
1. useNavigation
- 사용 :
```
const navigation = useNavigation()
navigation("/");  // '/' 경로로 redirect
```

### cross-env
- 운영체제마다 환경변수 제공 방식이 달라 절대경로 표시가 어려웠던 점을 해결해주는 모듈
- 설치 : `npm install cross-env --dev`


---

## 기타
- `debugger`라는 예약어는, chrome에서 실행할 때 break point역할을 한다. 개발시 코드로 break point를 설정할 수 있다.


## 참조
[React LifeCycle](https://devowen.com/307?category=778540)
[What & Why Hook](https://reactjs.org/docs/hooks-intro.html#motivation)
