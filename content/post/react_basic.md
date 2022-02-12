+++
title = "React basic"
date = 2021-08-23T18:46:22+09:00
lastmod = 2021-08-23T18:46:22+09:00
tags = ["react", "javascript", "web application"]
categories = ["dev", "basic",]
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

# React basic

## 개발환경 설치 및 실행
1. node.js 로 만들어진 create-react-app 툴을 이용하면 손쉽게 react 앱을 생성할 수 있다.
 - npm을 설치하고 아래 명령어를 수행하여 create-react-app을 설치한다.
 `npm install -g create-react-app`

2. 원하는 경로에 들어가 프로젝트를 생성한다.
 - `create-react-app <NAME>` : NAME 경로에 프로젝트 생성
 - 주의 : 프로젝트가 생성되는 폴더명은 대문자를 사용할 수 없다.

3. 실행
 - `npm run start` 를 수행하면 `localhost:3000`에서 웹페이지를 퍼블리싱한다.

## 기본 구조
1. /public/index.html 에서 기본 화면 구성
 - 'root' 이름으로 된 division이 있는데, 이 division에 대한 설정은 javascript로 정의되어있다.
2. src 경로에 javascript파일들 구성
 - 'index.js' 에 메인 화면에 사용된 객체가 정의되어 있다. 아래 내용은 id가 'root' 인 division에 'App'을 적용하겠다는 의미이다.
```
ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
```
 - 'index.js'에서 `<App/>` 라 되어있는 사용자 정의 태그를 생성했는데, `App`은 'App.js'에 정의되어 있고, 'index.js'에서 'App.js'를 참조한다.
 - 'App.js'에서 선언된 'App' 이라는 이름의 함수가 반환하는 값이 'App'태그에 치환된다고 보면 된다.
 - 'App'이 함수가 아니라 class로 정의되어 있다면 'App' class의 'render()' 함수의 리턴값이 'App'태그로 치환된다.
 - 리턴값은 무조건 특정 태그 안에 들어가 있어야 한다. <div>태그로 감싸주도록 한다.
3. src경로에 css파일 구성
 - index.css에서 css설정 구성
 -
## 배포
 - `npm run start`로 'create-react-app'으로 만든 앱을 실행시킬 수는 있지만, 이는 개발자용 실행 방식이다.
  - 웹 브라우저에서 페이지에 접속하고 다운로드받은 용량을 확인해보면 아무 기능이 없어도 MB단위가 다운받아짐을 확인할 수 있다.
  - 이러한 상태로 배포를 하면 효율 및 보안 관점에서 적합하지 않다.
 - `npm run build` 명령어를 수행하면 'build'라는 새로운 디렉터리와 데이터들이 생성된다.
  - 'build' 안에 있는 파일들은 공백 등을 제거하여 용량 및 보안에 최적화된 상태로 제공된다.
  - 배포시에는 'build'디렉터리 안의 내용을 사용하면 된다. 웹서버의 최상위 디렉터리를 'build'로 설정하면 된다.
 - `npm install serve` 명령어로 serve 툴을 설치한다. serve는 웹서버를 실행시키는 도구이다.
 - `serve -s build` 명령어로 'build' 디렉터리를 root 디렉터리로 웹서버를 실행한다.
 - 보통은 이렇게 일일이 작업을 수행하지 않고, `npm run deploy` 명령으로 package.json 파일에 기록된 설정대로 배포 작업을 자동화시킨다.

### github에 배포
 1. create-react-app으로 프로젝트 생성 : `create-react-app <NAME>`
 2. gh-pages 설치(이미 설치시 생략가능) : `npm install -g gh-pages`
 3. git hub에서 원하는 이름으로 repository 생성( 이후 {repo-name} 로 지칭)
  - 생성된 git repository와 react 폴더 연동한다.
  - `git init`
  - `git remote add origin {your-repository-url}`  
 4. package.json파일 수정 ({username}은 github 계정 이름)
  - "homepage" : "http://{username}.github.io/{repo-name}"
  - "scripts": {"predeploy": "npm run build", "deploy": "gh-pages -d build"}
 5. 배포를 실행한다. `npm run deploy`
  - gh-pages 라는 branch를 자동으로 생성하고, package.json에 설정한 'homepage' 주소에 react 페이지가 업로드된 것을 볼 수 있다.

## 문법

### 함수  
1. 일반 함수
 - javascript와 동일하게 선언 가능하다.

```
function Subject() {
    return (
	    <div>
        <a href="/" onClick={ function(e) {
          e.preventDefault();
          this.props.onChangePage();  // 상위 컴퍼넌트로 부터 받은 함수 실행
        }
		</div>
	);
```

2. arrow 함수
 - `FUNCTION_NAME = (VARIABLES) => { BODY }` 형태로 이루어져 있다.
 - VARIABLES는 ','로 나누어져 두개 이상의 인자를 선언할 수 있고, BODY에서 사용될 수 있다.
 - 위 함수를 호출하려면 `FUNCTION_NAME(VARIABLES)` 형태로 호출 가능하다.
```
highlightSquares = i => {
  if (this.props.winningSquares.length > 0) {
    if (this.props.winningSquares.indexOf(i) > -1) {
      return "square winningSquares";
    } else {
      return "square";
    }
  } else {
    return "square";
  }
};
```

### 변수
 - hoisting : javascript에서는 변수를 scope(함수 혹은 블록)의 가장 위로 끌어올려서, 먼저 선언된것처럼 인식하는 기능이 있다.

 1. var
  - var는 function-scoped 변수이다. 함수가 끝나기까지 해당 변수는 유지된다. (hoisting)
  - var를 block-scoped로 낮추기 위해서는 IIFE, 'use strict' 등의 방법을 사용할 수도 있지만 let으로 선언하는게 빠르다.

```
function TEST() {
  for (var i = 0; i < 10; i++) {
    console.log('i: ', i); // 정상출력
  }
  console.log('i: ', i); // 정상출력
}
console.log('i: ', i); // 오류
```

- 동일한 이름의 변수를 재선언할 수 있고, hoisting에 의해 나중에 선언한 변수를 먼저 사용할수도 있다. (오류를 일으키기 좋은 허용이다)

```
var A = 1
var A = 2 // 가능

str='abcd' // 가능
var str
```

 2. let
  - es2015에서 추가된 문법
  - 재선언 불가능
  - hoisting 동작 안함

```
let A = 1
let A = 2 // 불가능
A = 3 // 가능

str='abcd' // 불가능
let str
```

 3. const
  - es2015에서 추가
  - 선언과 동시에 값 할당 필요, 재정의 불가능
  - hoisting 동작 안함

```
const A = 1
const A = 2 // 불가능
A = 3 // 불가능

str='abcd' // 불가능
const str // 불가능
```

 4. 선언없이 정의
  - 아무 타입을 붙이지 않고 선언하면 전역변수로 선언된다.

```
str='12345'
A=5
```

### 배열
 - 배열은 `arr=[1, 2, 3]` 과 같은 형태로 선언한다. `arr=[,,,]`과 같이 크기3(쉼표개수)의 배열 선언도 가능하지만, 배열의 요소는 undefined로 정의된다. `arr = new Array(1,2,3)`로 선언도 가능하다.
 - 배열의 길이는 `arr.length` 로 추출 가능하다.
 - 좌항에 배열 형태를 두어 배열의 요소를 각각 정의할 수 있다. ` [a, b, c] = [1, 2, 3]` 이때, 일부 값을 무시할 수 있다. `[a, , c] = [1, 2, 3]`
 - 전개 연산자('...')을 이용하여 나머지 개체들을 통틀어 지정할 수 있다. `[a, b, ...c] = [1, 2, 3, 4, 5] // a = 1, b = 2, c = [3, 4, 5]`
 - 전개 연산자 이후 다른 변수가 오면 오류가 난다. `[a, b, ...c, d] = [1,2,3,4,5] // 오류`
 - 선언된 변수를 전개연산자로 다른 변수에 넣을수도 있다.
 - `ARRAY.indexOf(ITEM)` : ARRAY 배열안의 ITEM의 index를 반환한다.
```
var A = [1, 2, 3, 4, 5]
var B = [...A] // B = [1, 2, 3, 4, 5]
```

#### 반복(순회)
- 배열 내용을 순회하는 방법은 다음과 같다.   
1) map 함수
```
var A = [1,2,3]
A.map((a) => {
  // 원하는 동작을 입력하면 된다.
})
A.map(Math.sqrt) // lambda함수 외 일반함수를 넣어도 된다.
```
2) for-of
```
var A = [1,2,3]
for (var a of A) {
  // java의 for( : ) 와 같다
}
```
- 객체의 배열도 동일한 방법으로 순회가 가능하다. 다만 비구조화(destructing)가 포함된다.
```
var B = [{a:1, b:2, c:3}, {a:4, b:5, c:6}]
B.map({a,b,c} => {
  // 원하는 동작 수행
})
for (var {a:aa, b:bb, c:cc} of B) {
  // key가 마음에들지 않으면 재정의도 가능하다.
}
```

#### 비교
- filter 함수를 이용하여 조건에 맞는 요소만 선택 가능하다.
```
var a = [1,2,3,4,5,6,7]
var b = a.filter(i => i < 4); // b = [1,2,3]
```

### 객체
 - Json형태로 이루어져 있다. `var obj = {'a':10, b:20}` key값은 ''를 붙여도 되고 안붙여도 된다.
 - value를 변수로 추출할때는 다음과 같이 수행한다. 이를 비구조화라 한다. `var {a,b,c} = {a:1, b:2, c:3} // a==1, b==2, c==3`
 - 비구조화시 기본값을 설정할 수도 있다. `var {a=1,b=2} = {a:10} // a==10, b==2. b=2를 설정하지 않으면 b==undefined`
 - 다른 key를 사용하고싶다면 다음과 같이 수행한다. `var {a:one, b:two} = {a:10, b:20, c:30} // one==10, two==20, c==30`
 - key값으로 사용불가능한 값이 올 경우 다음과 같이 비구조화 한다. `var {'a-b-c':a_b_c, [key]:A_B_C} = {'a-b-c':10, 'A B C':20} // a_b_c = 10, A_B_C = 20`
 - 재구조화시 전개 연산자를 사용할 수 있지만, 전개연산자는 재정의할 수 없다. `{a:A, ...rest} = {a:10, b:20, c:30} // rest:B 는 불가능`

### 복사
- 배열
```
var a = [1,2,3]
var b = [...a] // 깊은복사
var [...c] = a // 깊은복사
var d = a // 얕은복사
```
- 객체
```
var A = {one:1, two:2, three:3}
var B = {...A} // 깊은복사 : one==1, two==2, three==3
var C = {...A, three:30} // 깊은복사+값 할당 : one==1, two==2, three==30
```

### promise
- 비동기 처리시 사용하는 객체
- promise 객체는 async와 wait를 이용한다.
  - `async function f1() {}` : async 함수 선언, f1 함수는 비동기로 동작하고, 내부에 await 구문을 사용할 수 있다. 
  - `const var = await f1()` : async 함수가 완료될 때 까지 대기하도록 await로 명시

## Component
1. js파일에서 컴포넌트를 생성하여 html에 적용
 - 'Subject'라는 이름의 component를 생성해 본다.
 - 생성된 'Subject'는 custom tag가 된다. HTML에서 tag를 호출하듯 사용 가능하다.

 1) class형태로 만들기
```
class Subject extends Component {
   render() {
	   return (
		   <header>
         <h1>Hello</h1>
       </header>
     );
   }
}
```
 2) 함수 형태로 만들기
```
function Subject() {
    return (
	    <div>
		    <h1>Hello</h1>
		  </div>
	  );
}
```
 -> 함수형은 자원을 덜 사용하고, 선언하기 쉬운 장점이 있다.
 - 'index.js'가 default라 가정하고, 'App.js'에서 App 객체 안에 `<Subject></Subject>` 와 같이 태그를 생성한다. (다른 파일에 선언했다면 해당 파일을 'App.js'에서 참조 필요)   
 ※  _'App.js' 파일은 확장자가 js이지만 코드 문법은 javascript가 아니다._

### props
- props를 활용하여 js파일에서 컴포넌트 태그 생성시 속성을 설정 가능하다.   
`<Subject title="TITLE", content="CONTENT">` : title 값으로 "TITLE", content 값으로 "CONTENT" 설정
- Subject 객체 생성시 `{this.prop.title}`, `{this.prop.content}`와 같이 참조하여 사용한다.
```
function Subject() {
    return (
	    <div>
		    <h1>{this.prop.title}</h1>
        <h2>{this.prop.content}</h2>
		</div>
	);
}
```

- 응용하여 아래와 같은 활용도 가능하다.
```
function Subject() {
    {title, content} = {this.prop}
    return (
	    <div>
		    <h1>{title}</h1>
        <h2>{content}</h2>
		</div>
	);
}
```

### state
- props는 부모 컴퍼넌트가 자식에게 설정해 주는 값이라면, state는 컴퍼넌트가 자기 자신을 위해 사용하는 값이다.
- state는 함수형에서는 사용 불가능하고 클래스형에서 사용 가능하다. 대신 함수형에서는 '훅' 이라는 기능을 이용해 state와 유사한 효과를 낼 수 있다.
1. state 세팅
 - constructor : 컴퍼넌트가 생성되었을 때 최초로 실행되는 함수. 초기화를 담당한다.
```
class App extends Component {
  constructor(props) {
    super(props);       // constructor 함수 기본
    this.state : {    // state 초기화
      subject:{title:"TITLE", content: "CONTENT"}
    }
  }
  render() {
    return (
      <div ClassName = "APP">
        <Subject title={this.state.subject.title} content={this.state.subject.content}></Subject>     // html형태의 return값 안에서 javascript문법을 사용하려면 '{}'로 묶어준다.
      </div>
    );
  }
}
```
-> App 컴퍼넌트가 생성되면 초기 설정된 state 값으로 Subject 컴퍼넌트를 생성한다.
- index.js -> App.js -> Subject.js 순으로 호출이 이루어지는데, index.js에서는 App.js의 상태값을 알지 못한다. 즉, 부모에게 자신의 정보를 노출하지 않고 은닉한다.

2. state로 배열 사용
```
  class App extends Component {
    constructor(props) {
      super(props);       // constructor 함수 기본
      this.state = {    // state 초기화
        subject:{title:"TITLE", content: "CONTENT"},
        contents:[
          {id:1, title:'title1', desc:'desc1'},
          {id:2, title:'title2', desc:'desc2'},
          {id:3, title:'title3', desc:'desc3'},
        ]
      }
    }
    render() {
      return (
        <div ClassName = "APP">
          <TOC data={this.state.contents}></TOC>
        </div>
      );
    }
  }

  class TOC extends Component {
    render() {
      var lists = [];
      var data = this.props.data;
      var i = 0;
      while (i < data.length) {
        lists.push(<li key={i}><a href={"/content/" + data[i].id}>{data[i].title}</a></li>)
        /*
         * 반복문을 통해 여러 객체를 만들 때, react에서는 'key'라는 유니크한 속성을 요구한다.
         *
         */
        i = i + 1;
      }
      return (
        <nav>
          <ul>
            {lists} // lists에 <li>태그들을 넣어놓은 것들이 그대로 출력된다.
          </ul>
        </nav>
      );
    }
  }
```

※ react에서는 props나 state가 바뀌면, 이를 사용하는 하위 컴퍼넌트들의 `render()` 함수가 모두 다시 호출된다. 즉, 화면이 재구성된다.

3. 조건문
- `render()` 함수 안에서 javascript로 조건문 설정 가능
```
  class App extends Component {
    constructor(props) {
      super(props);       // constructor 함수 기본
      this.state = {    // state 초기화
        mode: 'read'
    }
    render() {
      var _mode = state.mode;
      if (_mode == 'read') {    // 조건문

      } else if (_mode == 'write') {

      }
      return (
        <div ClassName = "APP">
          <TOC data={this.state.contents}></TOC>
        </div>
      );
    }
  }
```

4. 이벤트   

 1) onClick
  - html에서 onclick은 'C'가 소문자이지만, react에서는 대문자이다.
  - onClick은 인자로 함수를 받는다.
    - 인자로 들어가는 함수는 'event' 객체를 인자로 받는다.
    - 이 함수를 이벤트 함수라 한다.
```
      class App extends Component {
        constructor(props) {
          super(props);  
          this.state = {}
        }
        render() {
          return (
            <div>
              <a href="/" onClick={function(e) {
                console.log(e);       // 로그 찍는 방법
                e.preventDefault();   // 해당 태그의 기본 클릭동작을 수행하지 않도록 한다.
                // 'a' 태그의 경우 링크로 접속하는 동작을 막는다.
                }
              }>Click_here</a>        
            </div>
          );
        }
      }
```
- 이벤트 함수 안에서는 기본적으로 'this'를 호출해도 아무것도 bind되어있지 않다.
- `onClick={function(e) { ... }.bind(this)}` 와 같이 this를 bind해주면 this를 사용할 수 있게된다.
- 이벤트 함수 안에서 `this.state.mode='write'`와 같이 state를 변경하면 react가 변경 여부를 확인하지 못해 render()함수를 다시 호출하지 않아 화면이 갱신되지 않는다.   
`this.setState({mode:'write'});`와 같이 state를 수정하도록 하자.

\+) bind
 - 이벤트 함수는 기본적으로 'this'를 가지지 않는다.
 - 이때 강제로 this를 주입시키는 함수가 bind이다.    
```
  var obj = {name:'obj'};
  functiotn bindTest() {
    console.log(this.name);
  }
  bindTest(); // 아무 반응이 없다.
  bindTest.bind(obj); // obj가 bindTest의 this가 된다.
```

 2) custom event
 - 함수를 하위 컴퍼넌트에 전달해 준다.
```
  class App extends Component {
    render() {
      return (
        <div ClassName = "APP">
          <Subject
            title={this.state.subject.title}
            content={this.state.subject.content}
            onChangePage={
              function(){
                alert("page chaged"); // 경고창 출력
              }.bind(this);
            }
          >
          </Subject>
        </div>
      );
    }
  }
  function Subject() {
      return (
  	    <div>
          <a href="/" onClick={ function(e) {
            e.preventDefault();
            this.props.onChangePage();  // 상위 컴퍼넌트로 부터 받은 함수 실행
          }
  		</div>
  	);
  }
```

 - 하위 컴퍼넌트를 수정하지 않고 하위 컴퍼넌트의 태그 클릭시 수행할 작업을 변경할 수 있다.
 - 하위 컴퍼넌트에서 상위 컴퍼넌트의 state를 변경할 수 있게 된다.

## 기타
1. 함수형, 클래스형
 - react는 함수형 방식과 클래스형 방식으로 작성할 수 있다. 최근에는 함수형 방식을 선호하는 추세이다.
 - 함수형이 클래스형보다 메모리를 덜 사용한다.
2. 다른 파일 참조
 - react에서 다른 파일을 참조할 때에는 'import'를 사용하며, 확장자가 없으면 '.js'가 생략된 것으로 본다.   
 `import React, { Component } from "react"`는 기본으로 필요하다.
3. html에서 예약어로 사용하는 태그들은 'synamtic tag'라 한다.
 - 'h1', 'header', 'nav', 'article' 등이 있다.
4. `export` : 특정 객체를 다른 파일에서 import할 수 있도록 한다.   
ex) `export App`


## 참조
[자바스크립트 문법](https://yuddomack.tistory.com/entry/%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8-%EB%AC%B8%EB%B2%95-%EB%B9%84%EA%B5%AC%EC%A1%B0%ED%99%94-%ED%95%A0%EB%8B%B9)
[문법 Document](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#array_destructuring)
