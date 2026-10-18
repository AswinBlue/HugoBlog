---
title: "Angular 기본 개념 및 프로젝트 아키텍처와 템플릿 바인딩 가이드"
description: "Angular CLI를 활용한 개발 환경 구축부터 프로젝트 아키텍처, 컴포넌트 생명주기와 부모-자식 데이터 통신(@Input, @Output), 라우팅 파라미터 처리, 템플릿 바인딩 문법까지 핵심 개념을 체계적으로 정리합니다."
slug: "angular-basics-project-structure-template-syntax"
date: 2021-08-23T19:46:09+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebApplication"]
tags: ["angular", "typescript", "frontend", "spa", "javascript"]
ShowToc: true
TocOpen: true
---

Google에서 개발한 Angular는 엔터프라이즈급 대규모 단일 페이지 애플리케이션(SPA) 구축에 최적화된 컴포넌트 기반 프론트엔드 프레임워크입니다. 엄격한 타입 안정성을 제공하는 TypeScript를 기본 언어로 채택하고 있으며, 라우팅, 폼 관리, HTTP 통신 등 웹 개발에 필요한 필수 기능들을 프레임워크 차원에서 자체 내장하고 있습니다.

이 글에서는 Angular와 AngularJS의 차이점, CLI 환경 설정부터 프로젝트 구조, 컴포넌트 통신, 라우팅, 필수 템플릿 지시자 문법까지 실무 핵심 사항을 정리합니다.

---

## 1. Angular 프레임워크 개요 및 AngularJS와의 차이

- **AngularJS (1.x 버전)**: 자바스크립트 기반 프레임워크로 양방향 데이터 바인딩과 스코프(`$scope`) 모델을 채택했으나, 프로젝트 규모가 커질수록 성능 저하와 복잡도 증가 문제가 있었습니다.
- **Angular (2.x 이상)**: 이전 AngularJS와 코드 호환성을 완전히 분리하고 새롭게 재설계된 차세대 프레임워크입니다.
  - TypeScript를 기반으로 정적 타입 검사와 최신 객체지향 프로그래밍 패러다임을 지원합니다.
  - 컴포넌트 트리 기반 아키텍처를 도입하여 유지보수성과 렌더링 성능을 극대화했습니다.

---

## 2. Angular CLI 개발 환경 구축 및 프로젝트 생성

### 2.1. Node.js 및 Angular CLI 설치
Angular 개발을 위해서는 Node.js 런타임과 전역 패키지 관리 도구인 Angular CLI가 필수적입니다.

```bash
# Node.js 및 npm 설치 (Ubuntu/Debian 기준)
sudo apt update
sudo apt install -y nodejs npm

# Angular CLI 전역 설치
npm install -g @angular/cli
```

> Node.js 버전이 낮아 CLI 설치 오류가 발생할 경우, 공식 사이트(https://nodejs.org)에서 최신 LTS 바이너리를 다운로드하여 `/usr/local` 경로에 심볼릭 링크를 연결하거나 nvm(Node Version Manager)을 통해 최신 버전을 설치하는 것을 권장합니다.

### 2.2. 프로젝트 생성 및 로컬 개발 서버 구동
Angular CLI 명령어를 통해 표준 디렉터리 템플릿을 자동으로 스캐폴딩할 수 있습니다.

```bash
# 신규 애플리케이션 생성 (스타일시트 형식으로 CSS 선택)
ng new my-angular-app

# 생성된 프로젝트 폴더 진입 후 로컬 서버 실행 (기본 포트: 4200)
cd my-angular-app
ng serve --open
```

원격 서버나 가상 머신에서 작업하는 경우 방화벽(ufw 또는 iptables)에서 4200 포트를 개방해야 합니다.
```bash
sudo ufw allow 4200/tcp
```

---

## 3. Angular 프로젝트 아키텍처 및 컴포넌트 구조

### 3.1. 디렉터리 구성 및 역할
Angular 프로젝트의 기본 구조는 다음과 같이 루트 컴포넌트와 하위 모듈 단위로 계층화되어 있습니다.

```text
my-angular-app/
└── src/
    └── app/
        ├── app.component.html   # 루트 컴포넌트 템플릿
        ├── app.component.css    # 루트 컴포넌트 전용 스타일
        ├── app.component.ts     # 루트 컴포넌트 로직 클래스
        ├── app.component.spec.ts# 단위 테스트 스펙 파일
        ├── app.module.ts        # 의존성 및 컴포넌트 등록 모듈
        └── <COMPONENT_NAME>/    # 신규 추가된 하위 컴포넌트 폴더
```

컴포넌트 생성 명령어를 실행하면 CSS, HTML, TypeScript, Spec 파일이 세트로 자동 생성됩니다.
```bash
ng generate component product-alerts
# 축약형: ng g c product-alerts
```

### 3.2. TypeScript 컴포넌트 선언 및 데코레이터
컴포넌트는 화면의 특정 영역을 담당하는 독립적인 뷰(View) 단위입니다. `@Component` 데코레이터를 사용하여 HTML 템플릿 및 스타일을 클래스에 바인딩합니다.

```typescript
import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-product-alerts',          // HTML에서 호출할 태그 이름
  templateUrl: './product-alerts.component.html',
  styleUrls: ['./product-alerts.component.css']
})
export class ProductAlertsComponent implements OnInit {
  // 부모 컴포넌트로부터 전달받을 입력 프로퍼티
  @Input() product: any;

  // 부모 컴포넌트로 이벤트를 방출하기 위한 출력 프로퍼티
  @Output() notify = new EventEmitter<void>();

  constructor() {
    // 의존성 주입(DI) 및 순수 초기화 담당
  }

  ngOnInit(): void {
    // Angular 생명주기 훅: 컴포넌트가 DOM에 마운트된 후 초기 데이터 로딩
  }

  handleClick(): void {
    this.notify.emit();
  }
}
```

### 3.3. 부모-자식 컴포넌트 통신
상위 컴포넌트 템플릿에서는 대괄호(`[]`)를 이용해 하위 컴포넌트에 값을 주입하고, 소괄호(`()`)를 통해 하위 컴포넌트에서 발생한 이벤트를 핸들링합니다.

```html
<!-- 상위 컴포넌트의 HTML 템플릿 예시 -->
<app-product-alerts
  [product]="currentProduct"
  (notify)="onNotifyParent()">
</app-product-alerts>
```

---

## 4. Angular 라우터(Router)와 동적 파라미터 처리

### 4.1. 라우트 모듈(RouterModule) 등록
`app.module.ts`에서 URL 경로와 렌더링할 컴포넌트를 매핑합니다.

```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';

import { ProductListComponent } from './product-list/product-list.component';
import { ProductDetailsComponent } from './product-detail/product-detail.component';

@NgModule({
  imports: [
    BrowserModule,
    RouterModule.forRoot([
      { path: '', component: ProductListComponent },
      { path: 'products/:productId', component: ProductDetailsComponent },
    ])
  ],
})
export class AppModule { }
```

### 4.2. ActivatedRoute를 통한 URL 파라미터 수신
상세 페이지 컴포넌트에서는 `ActivatedRoute` 서비스를 주입받아 URL 경로의 동적 파라미터를 구독합니다.

```typescript
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-product-details',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.css']
})
export class ProductDetailsComponent implements OnInit {
  product: any;

  constructor(private route: ActivatedRoute) { }

  ngOnInit(): void {
    // URL 경로에서 productId 추출 (:productId)
    this.route.paramMap.subscribe(params => {
      const productId = Number(params.get('productId'));
      // 데이터 목록에서 일치하는 객체 조회 로직 수행
    });
  }
}
```

---

## 5. 핵심 템플릿 지시자 및 데이터 바인딩 문법

Angular 템플릿은 HTML 표준 문법을 확장하여 직관적인 반응형 UI 구성을 지원합니다.

### 5.1. 구조적 지시자 (*ngFor, *ngIf)
- **`*ngFor`**: 배열 컬렉션을 순회하며 요소를 반복 렌더링합니다.
- **`*ngIf`**: 참/거짓 조건에 따라 DOM 트리에 요소를 추가하거나 제거합니다.

```html
<!-- 목록 렌더링 및 라우터 링크 바인딩 -->
<div *ngFor="let product of products; index as productId">
  <a [title]="product.name + ' 상세정보'" [routerLink]="['/products', productId]">
    <h3>{{ product.name }}</h3>
  </a>

  <!-- 조건부 렌더링 -->
  <p *ngIf="product.description">
    설명: {{ product.description }}
  </p>
</div>
```

### 5.2. 바인딩 문법 요약
- **보간법 (Interpolation - `{{ }}`)**: 컴포넌트 클래스의 변수 및 표현식 결과를 문자열로 출력합니다.
- **프로퍼티 바인딩 (Property Binding - `[ ]`)**: HTML 속성 또는 컴포넌트 프로퍼티에 동적 데이터를 바인딩합니다.
- **이벤트 바인딩 (Event Binding - `( )`)**: 사용자 클릭, 입력 등의 DOM 이벤트를 감지하여 클래스 메서드를 실행합니다.
- **양방향 데이터 바인딩 (`[(ngModel)]`)**: 폼 컨트롤과 데이터를 양방향으로 실시간 동기화합니다.
