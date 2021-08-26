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

## Component
1. js파일에서 컴포넌트를 생성하여 html에 적용
 - 'Subject'라는 이름의 component를 생성해 본다.
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
 - 'index.js'가 default라 가정하고, 'App.js'에서 App 객체 안에 `<Subject></Subject>` 와 같이 태그를 생성한다. (다른 파일에 선언했다면 해당 파일을 `App.js`에서 참조 필요)   
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

### state
- props는 부모 컴퍼넌트가 자식에게 설정해 주는 값이라면, state는 자식 컴퍼넌트가 자기 자신을 위해 사용하는 값이다.
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

##기타
- `debugger`라는 예약어는, chrome에서 실행할 때 break point역할을 한다. 개발시 코드로 break point를 설정할 수 있다.
- link는 페이지의 개념이고, button은 operation의 개념이다. 모두 event를 발생시킬 수 있지만 구분을 하는게 좋다.
