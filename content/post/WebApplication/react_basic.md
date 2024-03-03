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

### 기본 설정
1. 실행 포트
  - `package.json` 파일에서 `"proxy": "http://localhost:3000/"` 과 같이 입력하면 실행시 포트를 3000으로 설정할 수 있다. 

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

4. 디렉터리
 - src 하위에 디렉터리를 만들 수 있고, 각 디렉터리에는 index.jsx 파일을 넣을 수 있다.
 - index.js 파일은 아래와 같이 디렉터리 안의 파일들에서 export 된 내용들을 export한다.
   
     ```
     // src/component/index.js
     export { default as Navbar } from './Navbar'; // src/component/Navbar.jsx에서 Navbar을 default로 export한 경우
     export { Footer } from './Footer'; // src/component/Footer.jsx에서 Footer을 export한 경우
     ```
 - 이렇게 export 된 내용들을 다른 폴더에서는 디렉터리만 import 하고 해당 모듈을 사용할 수 있다.
     ```
     // src/App.js
     import { Navbar Footer } from component
     ```
 - ❗ 단, index.js에 의해 세팅이 되는 시점이 App.js가 랜더 되는 시점보다 느리다는점에 주의한다. 아래는 이 문제로 발생할 수 있는 오류.   
   ```
   // component/index.js
   export { default as Button } from './Button'
   
   // App.js
   import Navbar from './component/Navbar' // navbar을 import하는 라인이 먼저 호출됨
   
   // component/Navbar.js
   import { Button } from '.' // button을 import하기 전에 App.js에서 Navbar을 호출했기 때문에 오류 발생, App.js를 구성하지 못해 빈 화면이 보여짐
   ```
## 모듈 import / export
- 특정 모듈을 export하고, 이를 다른 파일에서 import하여 사용할 수 있다.
- export 방법으로는 default 방법과, 일반 방법이 있습니다.
  - default 방법
    ```
      // A.jsx
      export default A; // import A from './A'
      // 혹은 import B from './A'도 가능
    
      export {default as A}; // import {A} from './A'
    ```
  - 일반 방법
    ```
      // A.jsx
      export { A }; // inport { A } from './A'
    ```

  - 위 두가지 예시를 보면 알겠지만, default로 export를 하면 다른 파일에서 import를 할 때 중괄호 없이 import가 가능하며, 그 이름도 아무렇게나 정할 수 있다.
  - default 없이 export를 하면 중괄호 안에서 받아야 하며, 변수 명도 동일해야 한다.
- import나 export에는 wildcard * 을 사용할 수 있다.
    ```
    export * from './A' // 보통 index.jsx에서 사용
    import * as A from './A' // A.jsx에서 export한 것들을 모두 받아와 A로 사용.
    // 받아온 컴포넌트는 A.name, A.number 와 같이 사용하게 됨
    ```

## 배포
 - `npm run start`로 'create-react-app'으로 만든 앱을 실행시킬 수는 있지만, 이는 개발자용 실행 방식이다.
  - 웹 브라우저에서 페이지에 접속하고 다운로드받은 용량을 확인해보면 아무 기능이 없어도 MB단위가 다운받아짐을 확인할 수 있다.
  - 이러한 상태로 배포를 하면 효율 및 보안 관점에서 적합하지 않다.
 - `npm run build` 명령어를 수행하면 'build'라는 새로운 디렉터리와 데이터들이 생성된다.
  - 'build' 안에 있는 파일들은 공백 등을 제거하여 용량 및 보안에 최적화된 상태로 제공된다.
  - 배포시에는 'build'디렉터리 안의 내용을 사용하면 된다. 웹서버의 최상위 디렉터리를 'build'로 설정하면 된다.
 - `npm install serve` 명령어로 serve 툴을 설치한다. serve는 웹서버를 실행시키는 도구이다.
 - `serve -s build` 명령어로 'build' 디렉터리를 root 디렉터리로 웹서버를 실행한다.
   - 만약 vsCode 사용 중 "이 시스템에서 스크립트를 실행할 수 없으므로 ..." 문구가 발생한다면, 콘솔에서 설정을 변경해야 한다. 
   - 관리자코드로 vsCode를 실행시킨 후, 콘솔 창에 `Set-ExecutionPolicy RemoteSigned` 를 입력한다. 
   - 이후 `get-ExecutionPolicy` 를 입력하여 결과값이 `RemoteSigned` 가 나오는지 확인한다. 
   - 이후에는 정상적으로 `serve` 명령이 동작함을 확인 할 수 있다. 
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

### 주석
- React 는 react code(typescript)와 JSX(xml) 코드가 있다.
- typescript에서는 '//' 혹은 '/* */' 로 주석을 사용한다.
- JSX에서는 '{/* */}' 로 주석을 사용한다.

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
- arrow 함수는 javascript를 반환할 수도 있고, html을 반환할 수도 있다. 방법은 아래와 같이 구분된다.    
    ```
    const js = () => { // 함수 내용 }
    const html = () => ( // html )
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

#### string
- 문자열을 담는 변수로, 아래와 같은 함수들을 지원한다.
- contains(str) : 문자열 내에 주어진 문자열(str)이 포함되었는지 확인, 결과를 반환

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
3) foreach
 - map과 유사하게 동작한다. 하지만 map은 callback함수에서 조작한 내용으로 새로운 배열을 구성하고, foreach는 단순 반복만 수행한다.
```
const lists = ['1', '2', '3']
return(
  // map
  {lists.map(element => {
    console.log('name', element);
    return <div> {element} </div>
  })}  // -> <div>1</div>, <div>2</div>, <div>3</div> 이 화면에 출력되고, 로그가 출력된다. 
  
  // foreach
  {lists.foreach(element => {
    console.log('name', element);
    return <div> {element} </div>
  })}  // -> 화면에는 아무것도 나오지 않고 로그만 출력된다.
)
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
 - 재구조화시 전개 연산자를 사용할 수 있지만, 전개연산자를 재정의 할 수는 없다. `{a:A, ...rest} = {a:10, b:20, c:30} // rest:B 는 불가능`

#### unpack
- 전개 연산자 `...` 을 사용하여 객체 내용을 나열할 있다.
ex)

  ```
  const obj = () => {
    var value = "value";
    var onChange = () => {console.log("onchange")}
    return {value, onChange};
  }
  
  ...
  
  // 아래 두 줄은 같은 효과를 가진다.
  <input placeholder="" {...obj}><input/>
  <input placeholder="" value = {obj.value} onchange={obj.onChange}><input/>
  ```

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
### 조건
- 특정 조건을 만족할 때에만 내용이 출력되도록 한다.   
  `{CONDITION && <div> ! </div>} // CONDITION 이 true일 때만 '!'를 표시한다.`  
- 3항 연산자 : C, java의 3항 연산자와 동일   
  `<span>{A ? "True" : "False"}</span>`  
- && : 앞의 내용이 참이면 뒤의 내용 수행  
  `<span>{A && "True"}</span>`  

### promise
- 비동기 처리시 사용하는 객체
- promise 객체는 async와 wait를 이용한다.
  - `async function f1() {}` : async 함수 선언, f1 함수는 비동기로 동작하고, 내부에 await 구문을 사용할 수 있다.
  - `const var = await f1()` : async 함수가 완료될 때 까지 대기하도록 await로 명시

## Component
- React는 js파일에서 정의한 컴포넌트를 html로 컴파일 한다.
ex)
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

1. state로 배열 사용

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

### render
- component 안의 `render()` 함수는 실제로 랜더링할 때 사용할 로직 및 html 형태를 반환한다.
- `render()` 함수 안에서 javascript로 로직 구현이 가능하다.   
  ex) 조건문   
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

#### return
- `render()` 함수의 return 값은 html 형태가 되어야 한다.
- 하지만 return 안에서도 `{}` 구문 안에서 간단한 문법은 사용 가능하다.
1. 조건문
  - 3항 연산자 : C, java의 3항 연산자와 동일   
    `<span>{A ? "True" : "False"}</span>`
  - && : 앞의 내용이 참이면 뒤의 내용 수행   
    `<span>{A && "True"}</span>`
  - {``} : 문자열 편집, 문자열 안에 연산을 추가할 수 있다.   
    ```<div className={`bg-white' ${flag ? 'flex' : 'flex-2'}\`}>```

### 이벤트   
- 버튼 클릭, 내용 변경 등 사건이 발생했을 때, 이벤트 함수가 호출된다.

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

- 이벤트 함수 안에서 `this.state.mode='write'`와 같이 state를 변경하면 react가 변경 여부를 확인하지 못해 render()함수를 다시 호출하지 않아 화면이 갱신되지 않는다.   
`this.setState({mode:'write'});`와 같이 state를 수정하도록 하자.

  2) onChange
    - 'input' 등 항목에서 내용이 변경되었을 경우
    - 아래와 같이 사용 가능

      ```
      const onChange = (event) => {
        // console.log(event.target.name);
        const {target: {name, value}} = event;  // get some values from 'event'
        ...
      ```


\+) bind
   - 이벤트 함수는 기본적으로 'this'를 가지지 않는다. 이때 강제로 this를 주입시키는 함수가 bind이다.  
   - 이벤트 함수 안에서는 기본적으로 'this'를 호출해도 아무것도 bind되어있지 않다.
   - `onClick={function(e) { ... }.bind(this)}` 와 같이 this를 bind해주면 this를 사용할 수 있게된다.

      ```
      var obj = {name:'obj'};
      functiotn bindTest() {
        console.log(this.name);
      }
      bindTest(); // 아무 반응이 없다.
      bindTest.bind(obj); // obj가 bindTest의 this가 된다.
      ```

 \+) custom event
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

---


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

6.Reference hook
- `useRef()` 함수가 속한다.
- `import { useRef } from 'react'` 구문으로 참조 가능
- 랜더링과 독립적으로 변하지 않는 데이터를 저장한다.
- useRef는 변경될 시 페이지를 재 랜더링 하지 않는다. 
- ref = useRef(null) 형태로 선언하며, reference object를 생성한다. 
  - null대신 저장하고싶은 데이터를 넣어도 된다.
  - ref.current 로 저장한 데이터를 참조한다. ex) `if (ref.current == null)`
  - useContext와 함께 사용하여 다른 component들에서 이 값을 참조하도록 할 수 있다. 
  - 객체 생성 후 값을 대입하려면 `ref.current = data` 형태로도 가능하다. 
  - `<textarea ref={textareaRef}/>` 형태로도 대입이 가능하다. textarea 객체 자체를 reference 하는 형태가 된다.
    - 'ref' 는 변수 명이 아니고 고정 속성값임에 주의
---

## 각종 모듈
- package.json에 dependency를 기록해놓은 경우, `npm install --legacy-peer-deps` 명령으로 모든 dependency를 한번에 다운받을 수 있다. package.json에 기록되지 않는 모듈은 지워버리니 주의.

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

### typeof
- react에서 기본적으로 제공하는 함수이다.
ex)

  ```
  var x = 1;
  if (typeof(x) === 'number') {
    ...
  }
  ```

- 반환하는 결과값은 다음과 같다.
> undefined, object, number, boolean, bigint, string, symbol, function

[정의되는 값 참조](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/typeof)

---

## DOM
- JSX에서 DOM을 조작하는 내용을 살펴보자

### script 참조
- javascript에서 아래와 같이 script를 추가할 수 있다.   
`<script async defer src="https://apis.google.com/js/api.js" onload="gapiLoaded()"></script>`   

- react에서는 위 방식 대신, hook과 document 인자를 사용하여 아래와 같이 작성한다.   

  ```
  const [calendarApiLoaded, setCalendarApiLoaded] = useState(false);
  useEffect( ()=> {
    // check api is loaded
    const existingCheck = document.getElementById('gapi');
    // if not loaded, load
    if (!existingCheck) {
      const gapiScript = document.createElement('script');
      gapiScript.src = "https://apis.google.com/js/api.js"
      const gisScrpit = document.createElement('script');
      gisScrpit.src = "https://accounts.google.com/gsi/client"
  
      // merge two scripts
      gapiScript.append(gisScrpit);
      gapiScript.id = 'gapi';
  
      // append to body
      document.body.appendChild(gapiScript);
  
      // change state
      setCalendarApiLoaded(true);
    }
  });
  ```
### window 변수
- window는 전역번수를 attach된 모든 script에서 접근할 수 있는 변수이며, react에서도 마찬가지로 `window.value` 혹은 `window['value']` 형태로 접근이 가능하다.

## 기타
1. 함수형, 클래스형
  - react는 함수형 방식과 클래스형 방식으로 작성할 수 있다. 최근에는 함수형 방식을 선호하는 추세이다.
  - 함수형이 클래스형보다 메모리를 덜 사용한다.
1. 다른 파일 참조
 - react에서 다른 파일을 참조할 때에는 'import'를 사용하며, 확장자가 없으면 '.js'가 생략된 것으로 본다.   
   `import React, { Component } from "react"`는 기본으로 필요하다.
1. html에서 예약어로 사용하는 태그들은 'synamtic tag'라 한다.
  - 'h1', 'header', 'nav', 'article' 등이 있다.
1. `export` : 특정 객체를 다른 파일에서 import할 수 있도록 한다.   
  ex) `export App`
1. `debugger`라는 예약어는, chrome에서 실행할 때 break point역할을 한다. 개발시 코드로 break point를 설정할 수 있다.


---

## 추가 활용

### 이미지 첨부
- 이미지는 /resources 파일에 첨부하고, import로 가져와 사용할 수 있다.
- 확장자가 없으면 js파일로 취급하니 확장자도 꼭 적어주도록 한다.   

  ```
  import screen_img from '../resources/screen_img.webp'
  
  ...
  
      // INFO: React JSX에서 style 설정
      var _style = {
          'top': 0 //- scrollPos
      }
      var _style_img = {
          'background-image': "url(" + screen_img + ")",
          'top': -694 - scrollPos * 4/5
      };
  ```

### key 숨기기
- API key 등 사용자에게 드러내지 않고싶은 정보들을 react가 아닌 다른 곳에 저장해야 한다. **react app에 저장하게 되면 개발 도구를 사용해 Client에서 어떻게든 내용을 확인할 수 있다.**
- 다만, .env 파일에 따로 저장하게 되면 git에서는 나타나지 않게 설정할 수 있다.
### .env 파일 사용법
- root 경로에 .env파일을 생성한다.
- .gitignore에 .env파일을 예외처리 한다.
- 정의하고 싶은 내용을 `REACT_APP_` 뒤에 이어붙여 정의한다. (ex: REACT_APP_API_KEY)
- 정의한 내용은 react JSX에서 `process.env.REACT_APP_API_KEY` 형태로 사용 가능하다.

### Custom Tag
- Custom tag 'CAT' 를 새로 만든다고 할때, `<CAT name={name}/>` 과 같이 생성하였다.
- Custom tag 안에 다른 내용을 집어넣고 싶으면, `<CAT name={name}> {props.children} </CAT>` 형태로 사용하면 된다.
- Custom tag를 정의할 때, tag 사이에 든 child를 포함하여 아래와 같이 구조를 정의할 수 있다.
    ```
    const CAT ({child}) => {
      <div>start</div>
        {child}
      <div>end</div>
    };
    ```

## 참조
[자바스크립트 문법](https://yuddomack.tistory.com/entry/%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8-%EB%AC%B8%EB%B2%95-%EB%B9%84%EA%B5%AC%EC%A1%B0%ED%99%94-%ED%95%A0%EB%8B%B9)
[문법 Document](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment#array_destructuring)
[React LifeCycle](https://devowen.com/307?category=778540)
[What & Why Hook](https://reactjs.org/docs/hooks-intro.html#motivation)
