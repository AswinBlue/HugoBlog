---
title: "Database"
date: 2025-03-20T22:03:29+09:00
lastmod: 2025-03-20T22:03:29+09:00
tags: []
categories: []
imgs:  []
cover:  ""  # image show on top
readingTime:  true  # show reading time after article date
toc:  true
comments:  false
justify:  false  # text-align: justify;
single:  false  # display as a single page, hide navigation on bottom, like as about page.
license:  "BY-SA"  # CC License, https://creativecommons.org/licenses/?lang=ko
draft: false
---

# Database
- 데이터를 효율적으로 저장하여 관리하는 시스템을 Database라고 한다.
- Database 를 체계적으로 조작하기 위해서 DBMS(DataBase Management System) 을 사용한다. 
- Database는 형태에 따라 크게 Relational Database (관계형 DB), Non-Relational Database(비관계형 DB) 로 분류된다.
  - Relational Database : 테이블 형태로 데이터를 관리
  - Non-Relational Database : key-value 세트로 구성된 형태로 데이터를 관리(ex: json format)

## RDBMS (Relational Database Management System)
- Relational Database 조작을 위한 시스템을 의미한다.
- Codds 에서 정의한 12가지 정의에 따르도록 설계된다. (보통은 선두의 2가지 규칙만 필수로 따른다.)
- SQL (Structured Query Language) 이라는 쿼리 언어를 사용하여 Database를 조작한다.

## SQL (Structured Query Language)
- RDBMS의 데이터를 정의하고 질의, 수정 등을 하기 위해 고안된 언어로, 다음 세가지 종류의 언어를 포함한다.
  - DDL (Data Definition Language) : 데이터를 정의하기 위한 언어
  - DML (Data Manipulation Language) : 데이터를 조작하기 위한 언어
  - DCL(Data Control Language) : 접근 권한을 설정하기 위한 언어

## NoSQL 
- `Non-Relational Database` 를 위한 언어로, `Non-Relational DBMS` 라고도 불린다.
- SQL를 사용하지 않고 복잡하지 않은 데이터를 저장해 단순 검색 및 추가 검색 작업을 위해 매우 최적화되었고, 저장공간이 크다는 것이 특징이다.
- key-value 조합으로 데이터에 접근하기에 문법이 따로 없다는 것도 장점이다.
- MongoDB, Redis, CouchDB 등이 해당된다.
  - MongoDB : Json 형태로 테이블 관리
  - Redis : 메모리 기반 DBMS로 속도가 빨라 임시데이터 캐싱 용도로 주로 사용
  - CouchDB : 이는 웹 기반의 DBMS로, REST API 형식으로 요청을 처리

### 문법

- MongoDB 데이터 삽입
  ```
  $ mongosh
  > db.user.insertOne({uid: 'admin', upw: 'secretpassword'})
  { acknowledged: true, insertedId: ObjectId("5e71d395b050a2511caa827d")}
  > db.user.find({uid: 'admin'})
  [{ "_id" : ObjectId("5e71d395b050a2511caa827d"), "uid" : "admin", "upw" : "secretpassword" }]
  ```
- MongoDB 데이터 검색
  ```
  db.inventory.find(
    { $and: [
      { status: "A" },
      { qty: { $lt: 30 } }
    ]}
  )
  ```
  - 검색 연산자
    - [MongoDB 공식 문서 참조](https://www.mongodb.com/ko-kr/docs/manual/reference/operator/query/)
    > `$eq`: 지정된 값과 같은 값 반환  
    >   ex) `db.users.find({ "age": { "$eq": 25 } })`
    > `$in`: 배열 안의 값들과 일치하는 값 반환  
    > `$ne`: 지정된 값과 같지 않은 값 반환  
    >   ex) `db.users.find({ "status": { "$ne": "inactive" } })`   
    > `$nin`: 배열 안의 값들과 일치하지 않는 값 반환  
    > `$and`: 논리적 AND  
    > ex) 
    > ```
    >  db.users.find({
    >    "$and": [
    >      { "age": { "$gte": 18 } },
    >      { "age": { "$lte": 30 } }
    >    ]
    >  })
    > ```
    > \+ and는 생략할 수도 있다.   
    > ex) `db.users.find({ "age": { "$gte": 18 }, "age": { "$lte": 30 } })`   
    > `$not`: 쿼리 식의 효과를 반전  
    > ex) `db.users.find({ "age": { "$not": { "$gte": 18 } } })`   
    > `$nor`: 논리적 NOR  
    > `$or`: 논리적 OR  
    > `$exists`: 지정된 필드가 있는 값 반환  
    > `$type`: 지정된 필드가 지정된 유형인 문서를 반환  
    > `$expr`: 쿼리 조건자 내에 표현식을 사용 가능하도록 함
    > `$regex`: 지정된 정규식과 일치하는 값 반환
    > `$text`: 문자열 검색
  - MongoDB 함수
    - `db.테이블.find(조건, 필드)` : 조건을 만족하는 레코드에서 선택한 필드를 반환
      - ex) `db.account.find()` : 모든 레코드 선택
      - ex) `db.account.find( { user_id: "admin" }, { user_idx:1, _id:0 })`
    - `db.테이블.insertOne(레코드)` : 레코드를 테이블에 삽입
      - ex) `db.account.insertOne({ user_id: "guest",user_pw: "guest" })`
    - `db.테이블.remove(조건)` : 레코드를 테이블에서 삭제
      - ex) `db.account.remove()` : 전체 레코드 삭제
      - ex) `db.account.remove({user_id: "guest"})`
    - `db.account.updateOne(변경할 값, 조건)` : 조건에 맞는 레코드의 값을 변경
      - db.account.updateOne( { user_idx: 2 }, { $set: { user_id: "guest2" } })`

- [Redis 문법 참조](https://redis.io/commands)












