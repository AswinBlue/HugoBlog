---
title: "Node.js 비동기 이벤트 루프 아키텍처와 Express 웹 서버 구축 가이드"
description: "V8 엔진 기반 Node.js의 논블로킹 I/O 동작 원리부터 npm 패키지 관리, Express 라우터와 미들웨어(세션, 정적 파일, 바디 파서), MySQL 데이터베이스 연동 및 EJS 템플릿 렌더링까지 총정리합니다."
slug: "nodejs-event-loop-and-express-server-guide"
date: 2020-07-20T20:40:05+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WebServer"]
tags: ["nodejs", "express", "backend", "javascript", "rest-api", "mysql"]
ShowToc: true
TocOpen: true
---

Node.js는 Chrome V8 자바스크립트 엔진으로 빌드된 비동기 이벤트 기반(Event-driven) 논블로킹 I/O 런타임 환경입니다. 브라우저 환경에 종속되어 있던 자바스크립트를 고성능 서버 사이드 애플리케이션 개발에 활용할 수 있도록 지원하며, 경량화된 구조와 높은 동시 처리 성능으로 마이크로서비스 및 실시간 API 서버 개발에 널리 사용됩니다.

이 글에서는 Node.js의 기본 명령어 및 `package.json` 설정, Express 웹 프레임워크의 미들웨어 파이프라인, 모듈형 라우터 분리, MySQL 데이터베이스 연동, 그리고 EJS 템플릿 엔진을 활용한 렌더링 구조를 체계적으로 정리합니다.

---

## 1. Node.js 런타임 개요 및 npm 패키지 관리

Node.js 생태계의 패키지 관리자인 npm(Node Package Manager)을 사용하여 프로젝트의 의존성을 선언하고 스크립트를 자동화합니다.

### 1.1. 필수 npm 명령어 모음
```bash
# 프로젝트 초기화 (package.json 자동 생성)
npm init -y

# 패키지 설치 옵션
npm install <package>          # 프로덕션 의존성 등록 (dependencies)
npm install -D <package>       # 개발 전용 의존성 등록 (devDependencies)
npm install -g <package>       # OS 전역 바이너리 설치
npx <package>                  # 로컬 설치 없이 1회성 도구 실행

# 의존성 보안 진단 및 캐시 관리
npm audit                      # 패키지 보안 취약점 점검
npm cache clean --force        # npm 로컬 캐시 초기화
```

### 1.2. `package.json` 파일의 핵심 구조
프로젝트 메타데이터, 의존성 라이브러리 목록, 실행 스크립트(`scripts`)를 JSON 형식으로 정의합니다.

```json
{
  "name": "express-web-server",
  "version": "1.0.0",
  "description": "Express 백엔드 웹 서버",
  "main": "main.js",
  "scripts": {
    "start": "node main.js",
    "dev": "nodemon main.js",
    "test": "cross-env NODE_ENV=test mocha"
  },
  "dependencies": {
    "express": "^4.19.0",
    "express-session": "^1.18.0",
    "mysql": "^2.18.1",
    "ejs": "^3.1.9"
  },
  "devDependencies": {
    "cross-env": "^7.0.3",
    "nodemon": "^3.1.0"
  }
}
```

---

## 2. Express 웹 프레임워크와 미들웨어 파이프라인

Express는 Node.js 환경에서 가장 표준적으로 사용되는 미니멀 웹 프레임워크로, 미들웨어 체인(Middleware Chain)을 통해 요청과 응답을 유연하게 제어합니다.

### 2.1. 메인 서버 진입점 (`main.js`)
정적 파일 제공, 세션 관리, 바디 파서 등록 및 라우터를 마운트합니다.

```javascript
const express = require('express');
const session = require('express-session');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 80;

// 1. 바디 파서 미들웨어 (URL-encoded 폼 데이터 및 JSON 페이로드 처리)
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

// 2. 정적 파일 디렉터리 매핑
app.use('/static', express.static(path.join(__dirname, 'static')));

// 3. 세션 미들웨어 설정
app.use(session({
  secret: 'my-super-secret-key', // 암호화 서명 시드
  resave: false,                 // 세션 데이터 변경 시에만 재저장
  saveUninitialized: false,      // 초기화되지 않은 빈 세션 저장 방지
  cookie: { secure: false, httpOnly: true, maxAge: 3600000 } // 1시간 유지
}));

// 4. 템플릿 엔진 설정 (EJS)
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// 5. 모듈형 라우터 등록
const editRouter = require('./route/edit');
app.use('/edit', editRouter);

// 6. HTTP 서버 구동
app.listen(PORT, () => {
  console.log(`Express 서버가 포트 ${PORT}에서 정상 구동 중입니다.`);
});
```

---

## 3. 모듈형 라우팅과 파라미터 제어 (`route/edit.js`)

대규모 애플리케이션에서는 URL 엔드포인트별로 라우터를 파일 단위로 분리(`express.Router()`)하여 유지보수성을 극대화합니다.

```javascript
const express = require('express');
const router = express.Router();
const mysql = require('mysql');
const dbConfig = require('../config/db_config.json');

// MySQL 커넥션 풀 또는 단일 커넥션 생성
const connection = mysql.createConnection(dbConfig);
connection.connect();

// 동적 경로 파라미터 (Path Parameter: /edit/:category/:product)
router.post('/:category/:product', (req, res) => {
  const { category, product } = req.params;
  const { name, description, price } = req.body;

  // 세션 권한 검증
  if (!req.session.user) {
    return res.status(401).json({ error: "로그인이 필요한 서비스입니다." });
  }

  // SQL Injection을 방어하기 위한 파라미터화된 쿼리(? 바인딩)
  const sql = 'UPDATE products SET name = ?, description = ?, price = ? WHERE category = ? AND id = ?';
  const values = [name, description, price, category, product];

  connection.query(sql, values, (err, results) => {
    if (err) {
      console.error("데이터베이스 쿼리 오류:", err);
      return res.status(500).json({ error: "DB 업데이트 실패" });
    }
    // 성공 시 상세 조회 페이지로 리다이렉트
    res.redirect(`/edit/${category}`);
  });
});

module.exports = router;
```

---

## 4. 데이터베이스 연동 보안과 SQL Injection 방어

데이터베이스 연결 설정은 소스코드에 하드코딩하지 않고 별도의 JSON 파일이나 환경변수(`.env`)로 분리해야 합니다.

### 4.1. `config/db_config.json` 설정
```json
{
  "host": "localhost",
  "user": "app_user",
  "password": "StrongPassword123!",
  "database": "production_db",
  "port": 3306
}
```

### 4.2. 파라미터 바인딩 원칙
SQL 인젝션 공격을 차단하기 위해 사용자 입력값을 직접 문자열 결합(`+`)하지 않고, 드라이버가 제공하는 플레이스홀더(`?`)를 사용하여 파라미터를 자동 이스케이프해야 합니다.

---

## 5. EJS 템플릿 엔진을 활용한 동적 화면 렌더링

EJS(Embedded JavaScript)는 HTML 마크업 내에서 자바스크립트 제어문과 변수를 바인딩할 수 있는 템플릿 엔진입니다.

```html
<!-- views/index.ejs -->
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상품 관리 대시보드</title>
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
  <h1>등록 상품 목록</h1>
  <table>
    <thead>
      <tr>
        <th>상품번호</th>
        <th>상품명</th>
        <th>설명</th>
      </tr>
    </thead>
    <tbody>
      <!-- 서버 라우터에서 전달받은 dataList 배열 순회 -->
      <% dataList.forEach(item => { %>
        <tr>
          <!-- <%= %> 구문은 특수문자를 안전하게 HTML 이스케이프하여 출력함 -->
          <td><a href="/edit/<%= item.number %>"><%= item.number %></a></td>
          <td><%= item.name %></td>
          <td><%= item.description %></td>
        </tr>
      <% }); %>
    </tbody>
  </table>
</body>
</html>
```
라우터에서 `res.render('index', { dataList: rows })` 형태로 데이터를 전달하면 EJS 엔진이 서버 사이드에서 HTML을 조합하여 클라이언트로 완성된 문서를 응답합니다.
