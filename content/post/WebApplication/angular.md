+++
title = "Angular"
date = 2021-08-23T19:46:09+09:00
lastmod = 2021-08-23T19:46:09+09:00
tags = ["angular", "typescript",]
categories = ["dev",]
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
# Angular
- Angular JS와 Angular는 다르다. Angular JS는 초창기 Angular를 의미하고, 그냥 Angular는 Angular2 이상의 버전을 의미한다.
- javascript기반의 textscript를 사용한다. 확장자가 ts로 끝난다.

## 개발환경 세팅
1. nodejs 설치
- `$ sudo apt install npm` :nodejs와 npm 동시에 설치
2. angular client 설치
 - `$ npm install -g @angular/cli` 명령어를 이용하여 설치
3. workspace 생성
 - client 설치가 완료되었으면 workspace를 생성하고 application을 생성한다.
 - `$ ng new <application_name>` 명령어를 이용하여 설치한다.

 - nodejs 버전이 낮다고 한다.  github에서 받아서 빌드하여 써 보자.
 - 공식 사이트는 https://github.com/nodejs 이다.
 - 소스코드를 받아 빌드하는 내용은 없고, 바로 바이너리를 다운받기를 권장하는 듯 하다.
 - https://nodejs.org/en/download/ 로 가서 리눅스용 바이너리를 받아보자.
 - .xz 형태의 파일이다. ``$ tar -xvf <file_name>`` 로 압축을 푼다.
 - 압축을 푸니 안의 내용들이 /usr/lib/ 경로에 어울릴 것 같다. mv 명령으로 옮겨준다.
 - bin 폴더 안의 내용은 링크로 /usr/local/lib/ 에 넣어준다.   
 `ln -s /usr/lib/<file>/bin/<binary> /usr/local/lib/bin/<binary>`
 - 다시 돌아와서 명령어를 수행하여 application을 생성한다. stylesheet format을 선택하라고 하는데, 가장 위에있는 CSS로 선택해 본다.

4. application 실행
 - application을 생성하면 현재 경로에 <application_name>에 해당하는 폴더가 생성된다.
 - 테스트용으로 application을 실행해 보자.
 `$ng serve --open`
 - 4200 포트로 서버 접속이 가능함을 알 수 있다.

5. 방화벽 설정
 - 방화벽이 아직 열려있지 않은 것 같다. 방화벽을 열어보자.
 - iptables -I INPUT 1 -p tcp --dport 12345 -j ACCEPT
 - `$sudo ufw allow 4200/tcp`

## 프로젝트 구조
- WORKSPACE
  - src
    - app : 화면을 구성하는 요소들의 root component, WORKSPACE와 같은 이름
    - \<COMPONENT\> : root component의 일부를 구성하는 component, 원하는만큼 추가 가능, [css, html, ts] 항목들이 기본 세트로 생성됨
     - COMPONENT.component.css : 기본적으로 비어있다.
     - COMPONENT.component.html
     - COMPONENT.component.ts : type script로 짜여진 코드, class들이 정의되어 있다.
    - app.component.css
    - app.component.html
    - app.component.ts
    - app.module.ts


### component
- view라는 단위의 화면을 구성하는 모듈
- `ng generate component COMPONENT_NAME` 명령으로 workspace에 component 생성 가능
- component를 생성하면 css, html, ts파일을 기본적으로 갖는다.
- component는 다른 component를 가질 수 있다. 최상위 component를 root component라고 한다.

#### ts 파일
- angular에서 제공하는 모듈을 import할 수 있다.
- class를 선언하고, component에서 사용할 기능(함수)을 구현한 후 export한다.
- component가 생성될 때 상위 component로 부터 input을 받을 수 있다.
##### ts파일 문법
  - `Component` : Component를 사용하기 위한 기본 모듈
  - `OnInit` : Component 시작시 동작 정의, constructor 와 유사한 동작을 하지만 OnInit은 angular가 관할하고, constructor은 js가 관할하여 초기화하는 차이가 있다.
  - `Input` : Component 생성시 상위 Component로 부터 받을 변수를 선언, 상위 Component에서는 해당 변수로 값을 집어넣어 줄 수 있다.
  - `Output` : 상위 Component에서 사용할 수 있는 변수를 정의, Component에서 변수를 선언하면 상위 Component에서 해당 변수를 사용할 수 있다.
 - `@component` 로 다음 class가 컴퍼넌트임을 표시한다.
selector : 해당 component가 view에서 어떤 이름으로 표시될지 명명한다. (Tag 이름이 된다.)
 - `templateUrl` : html 파일의 이름을 지정한다
 - `styleUrls` : css파일의 리스트를 나열한다.

```
 @Input() product;                        // product라는 변수로 input을 받겠다는 선언
 @Output() notify = new EventEmitter();   // notify 라는 변수를 상위 Component에서 사용 가능하게 하겠다고 선언
 // 한 component에서 다른 component를 호출할 때에는 ts 파일에서 정의한 이름을 태그로 생성한다.
 <app-product-alerts                      // 태그 이름이 곧 component 이름(selector에 정의한)이다.
   [product]="product"                    // product라는 변수에 "product"라는 내용을 을 넣을 때 사용한다.
 (notify)="onNotify()">                   // notify라는 변수에서 이벤트가 들어오면 onNotify() 함수를 실행, (onNotify() 함수는 class 안에 정의되어 있어야 함)
 </app-product-alerts>
```
### Routing
- app.modules.ts(main component의 ts파일) 파일에서 routing 설정이 가능하다.

```
import { RouterModule } from '@angular/router';                                     // Routing을 위해 필요한 모듈
import { ProductListComponent } from './product-list/product-list.component';`      // ProductListComponent라는 변수에 './product-list/product-list.component파일을 대응
import { ProudctDetailsComponent } from './product-detail/product-detail.component';

@NgModule({
  imports: [
    BrowserModule,
    ReactiveFormsModule,
    RouterModule.forRoot([                            // Router 모듈로 Routing 세팅
      { path: '', component: ProductListComponent },  // root 경로 '/' 에 위에서 ProductListComponent 변수에 대응시킨 파일을 매칭
      { path: 'products/:productId', component: ProductDetailsComponent },          // 마찬가지로 '/products/{productId}' 에 ProudctDetailsComponent를 매칭
    ])
  ],
```
- ./product-detail/product-detail.component.ts 에서 아래와 같은 설정을 추가로 해주어야 한다.

```
import { ActivatedRoute } from '@angular/router';           // routing을 당하는 곳에서 필요한 모듈
export class ProductDetailsComponent implements OnInit {    // component 를 정의할 class 선언
  product; -> product 변수 선언
constructor(private route: ActivatedRoute,)                 //  라우팅 관련 정보를 route라는 변수에 받았다.
  { } -> constructor 뒤에 붙여주는 형식, 비어있는 채로 둔다.
}

ngOnInit() {                                                // view 생성시 동작을 정의
  this.route.paramMap.subscribe(params => {                 // constructor에서 정의한 route를 참조하여
    this.product = products[+params.get('productId')];      // this.product는 products[index] 값을 가진다. 이때 index는 app.modules.ts에서 설정한 값이다. (url 경로에서 'products/' 다음에 들어간 숫자값)
  });
}
```
- ./product-detail/product-detail.component.html 에서 아래와 같이 설정한다.

```
<h2>Product Details</h2>
<div *ngIf="product">                 // product에 값이 들어가 있다면 아래 수행. 즉, ts파일에서 대입시킨 products[idx] 값이 존재하면 아래 동작 수행
<h3>{{ product.name }}</h3>           // json 형태의 값을 참조해 대입한다.
<h4>{{ product.price | currency }}</h4>
  <p>{{ product.description }}</p>
</div>
```

## 문법
- 반복, 출력, 링크

```
<div *ngFor="let product of products; index as productId">
/*
 *ngFor 은 반복을 뜻하는 예약어다. products 안의 원소를 하나씩 꺼내서 product 라 칭한다. 마치 java나 python의 ``for item in array`` 와 같다.
 ';' 로 구문을 구분할 수 있다.
 productId 변수에 index를 대입한다.
*/
　　<a [title]="product.name + ' details'" [routerLink]="['/products', productId]">
/*
 [title] 은 마우스를 올릴 때 나오는 텍스트를 뜻한다.
 routerLink는 클릭시 넘어갈 링크이다. 링크를 []로 설정하면 []안의 내용을 appepnd 한 값을 의미한다. 즉 "/product/:productId" 의 주소를 나타낸다.
 ""안의 내용은 ts문법이고, 단순 텍스트는 '' 사이에 집어넣으면 된다.
*/
　　　　<h3>
　　　　　　{{ product.name }}       // product 객체의 name 필드를 출력한다.
　　　　</h3>
　　</a>
</div>
```
- 조건

```
<p *ngIf="product.description">         // *ngIf는 조건문을 뜻하는 예약어다. product 객체에 description 필드가 존재하면 아래를 실행한다.
  Description: {{ product.description }}
</p>
```

- 버튼

`<button (click)="share()">` (click)은 클릭 event 발생시 실행할 내용을 적는다. share()라는 함수를 실행하도록 연결한다.

-> 요점
*ngFor
*ngIf
Interpolation {{ }}
Property binding [ ]
Event binding ( )
