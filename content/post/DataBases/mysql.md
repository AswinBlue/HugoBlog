---
title: "MySQL 관계형 데이터베이스 기초: DDL, DML 쿼리 작성 및 계정 권한 관리"
description: "오픈소스 RDBMS인 MySQL의 기본 접속부터 데이터베이스 및 테이블 정의(DDL), CRUD 데이터 조작(DML), 조인(JOIN)과 서브쿼리, 스토리지 엔진(InnoDB vs MyISAM) 및 사용자 권한(GRANT) 관리를 총정리합니다."
slug: "mysql-rdbms-basics-sql-queries-permissions"
date: 2020-07-02T20:29:29+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DataBases"]
tags: ["mysql", "rdbms", "sql", "database", "backend"]
ShowToc: true
TocOpen: true
---

MySQL은 전 세계에서 가장 널리 사용되는 오픈소스 관계형 데이터베이스 관리 시스템(RDBMS)입니다. 구조화된 2차원 테이블(Table) 형태로 데이터를 관리하며, 표준 SQL(Structured Query Language)을 통해 ACID 트랜잭션과 엄격한 데이터 무결성을 보장합니다.

이 글에서는 MySQL의 콘솔 접속 및 데이터베이스 생성부터 DDL(테이블 정의), DML(데이터 조작/조인/서브쿼리), DCL(사용자 권한 관리), 그리고 스토리지 엔진별 특징을 체계적으로 정리합니다.

---

## 1. MySQL 접속 및 데이터베이스 기본 관리

MySQL은 기본적으로 3306 포트를 통해 통신하며, 대소문자를 구분하지 않는 표준 SQL 문법을 지원합니다. 주석은 `-- `(반드시 공백 포함) 또는 `#`을 사용합니다.

### 1.1. CLI 로그인 및 데이터베이스 생성/선택
```bash
# 특정 계정으로 비밀번호 프롬프트와 함께 로그인
mysql -u root -p

# 특정 데이터베이스를 바로 지정하여 접속
mysql -u app_user -p my_database
```

```sql
-- UTF-8(utf8mb4 권장) 인코딩으로 데이터베이스 생성 (이모지 지원)
CREATE DATABASE my_database DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 목록 조회 및 활성화
SHOW DATABASES;
USE my_database;
```

### 1.2. 스토리지 엔진 비교 (InnoDB vs MyISAM)
- **InnoDB (기본 권장)**:
  - 트랜잭션(ACID) 및 외래키(Foreign Key) 제약 조건을 지원합니다.
  - 행 레벨 락(Row-level Locking)을 사용하여 동시성 처리가 뛰어나며 대규모 웹 서비스에 표준으로 사용됩니다.
- **MyISAM**:
  - 트랜잭션을 지원하지 않고 테이블 레벨 락(Table-level Locking)을 사용합니다.
  - 쓰기 작업이 빈번한 환경에서는 성능이 저하되나, 단순 읽기(SELECT COUNT) 위주의 경량 통계 테이블에 과거 주로 쓰였습니다.

---

## 2. 데이터 정의 언어 (DDL: Data Definition Language)

DDL은 데이터베이스와 테이블 스키마의 구조를 생성, 변경, 삭제하는 명령어입니다.

### 2.1. 테이블 생성 (`CREATE TABLE`) 및 제약 조건
```sql
CREATE TABLE users (
  id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  registered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (id)
) ENGINE=InnoDB;
```
- `AUTO_INCREMENT`: 레코드 삽입 시 자동으로 1씩 증가하는 고유 ID 부여.
- `PRIMARY KEY`: 레코드를 유일하게 식별하는 기본키(중복 불가, NOT NULL).
- `DEFAULT`: 값이 명시되지 않았을 때 삽입될 기본값.

### 2.2. 테이블 스키마 수정 (`ALTER TABLE`) 및 삭제 (`DROP`)
```sql
-- 컬럼 추가
ALTER TABLE users ADD COLUMN phone VARCHAR(20) NULL;

-- 컬럼 타입 변경
ALTER TABLE users MODIFY COLUMN username VARCHAR(100) NOT NULL;

-- 컬럼 이름 변경
ALTER TABLE users CHANGE COLUMN phone mobile_phone VARCHAR(20) NULL;

-- 컬럼 삭제
ALTER TABLE users DROP COLUMN status;

-- 테이블 및 데이터베이스 영구 삭제
DROP TABLE IF EXISTS old_users;
DROP DATABASE IF EXISTS test_db;
```

---

## 3. 데이터 조작 언어 (DML: Data Manipulation Language)

DML은 테이블에 저장된 데이터를 삽입, 조회, 갱신, 삭제(CRUD)하는 명령어입니다.

### 3.1. CRUD 핵심 질의문
```sql
-- 1. 데이터 삽입 (INSERT)
INSERT INTO users (username, email) VALUES ('홍길동', 'hong@example.com');

-- 2. 조건부 데이터 조회 (SELECT)
SELECT id, username, email FROM users
WHERE email LIKE '%@example.com' AND status = 'ACTIVE'
ORDER BY id DESC LIMIT 10;

-- 3. 데이터 수정 (UPDATE - 반드시 WHERE 조건 명시)
UPDATE users SET username = '김철수' WHERE id = 1;

-- 4. 데이터 삭제 (DELETE - 반드시 WHERE 조건 명시)
DELETE FROM users WHERE id = 1;
```

### 3.2. 테이블 결합(JOIN)과 집합 연산자(UNION)
- **INNER JOIN**: 양쪽 테이블 모두에 조건이 일치하는 레코드만 결합하여 조회합니다.
  ```sql
  SELECT u.username, o.order_number, o.amount
  FROM users u
  INNER JOIN orders o ON u.id = o.user_id;
  ```
- **LEFT OUTER JOIN**: 좌측 테이블 전체를 유지하며, 우측 테이블에 매칭 데이터가 없으면 NULL로 채웁니다.
  ```sql
  SELECT u.username, o.order_number
  FROM users u
  LEFT JOIN orders o ON u.id = o.user_id;
  ```
- **UNION**: 두 `SELECT` 쿼리의 결과 집합을 하나로 병합합니다. (컬럼 개수와 타입이 일치해야 함)
  ```sql
  SELECT username, 'ADMIN' AS role FROM admin_users
  UNION
  SELECT username, 'STAFF' AS role FROM staff_users;
  ```

### 3.3. 서브쿼리(Subquery)와 인라인 뷰(Inline View)
쿼리 내부에 중첩된 또 다른 SELECT 쿼리를 활용하여 동적 필터링을 수행합니다.

```sql
-- WHERE 절 서브쿼리 (특정 사용자의 주문 목록)
SELECT * FROM orders WHERE user_id IN (SELECT id FROM users WHERE status = 'VIP');

-- FROM 절 인라인 뷰 (파생 테이블)
SELECT u.username, u.point
FROM (SELECT id, username, point FROM users WHERE point > 1000) AS u;
```

---

## 4. 데이터 제어 언어 (DCL) 및 사용자 권한 관리

데이터베이스에 대한 접근 권한을 관리하여 보안성을 유지합니다.

### 4.1. 사용자 계정 생성과 권한 부여 (`GRANT`)
```sql
-- 1. 로컬 및 외부 접속 사용자 생성
CREATE USER 'service_user'@'localhost' IDENTIFIED BY 'SecurePass123!';
CREATE USER 'service_user'@'%' IDENTIFIED BY 'SecurePass123!';

-- 2. 특정 데이터베이스에 대한 DML/DDL 권한 부여
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP ON my_database.* TO 'service_user'@'localhost';

-- 3. 권한 즉시 반영
FLUSH PRIVILEGES;

-- 4. 부여된 권한 확인
SHOW GRANTS FOR 'service_user'@'localhost';
```

### 4.2. 대용량 CSV 파일 고속 임포트 (`LOAD DATA INFILE`)
외부 CSV 대용량 데이터를 테이블로 초고속 적재할 때 사용합니다.

```sql
LOAD DATA LOCAL INFILE '/path/to/data.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- 헤더 컬럼 1줄 제외
```

---

## 5. MySQL 주요 데이터 타입 요약

| 분류 | 데이터 타입 | 스토리지 크기 | 설명 및 권장 용도 |
|---|---|---|---|
| **문자형** | `VARCHAR(n)` | 가변 (최대 65,535 바이트) | 실제 문자열 길이만큼만 저장되는 표준 텍스트 |
| **문자형** | `CHAR(n)` | 고정 (최대 255 바이트) | 우편번호, 주민번호 등 고정 길이 식별자 |
| **문자형** | `TEXT` / `LONGTEXT` | 최대 64KB / 4GB | 긴 게시글 본문 및 비정형 대용량 텍스트 |
| **정수형** | `INT` / `BIGINT` | 4 바이트 / 8 바이트 | 일반 수치 ID 및 대규모 식별자(PK) |
| **실수형** | `DECIMAL(M, D)` | 고정 소수점 | 통화, 금융 등 오차 없는 정확한 소수 계산 |
| **날짜형** | `DATETIME` | 8 바이트 | 시간대 무관 고정 일시 (`1000-01-01` ~ `9999-12-31`) |
| **날짜형** | `TIMESTAMP` | 4 바이트 | UTC 기준 자동 변환 일시 (생성/수정 타임스탬프) |
