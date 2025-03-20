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



