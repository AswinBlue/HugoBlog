+++
title = "Mysql"
date = 2020-07-02T20:29:29+09:00
lastmod = 2020-07-02T20:29:29+09:00
tags = [
"DB",
"mysql",
]
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

# mysql

## 명령어 
- ``$ mysql -p DB_NAME -u USER_NAME``
사용자 이름과 USER_NAME으로 DB_NAME 데이터베이스 실행
USER_NAME이 비어있으면 현재 로그인한 계정과 동일한 이름으로 로그인 시도
-u DB_NAME 옵션은 로그인 후 ``$use DB_NAME`` 과 같은 효과

- DB 목록확인
 ``show databases``

- DB 선택
 ``use DB_NAME``

- 현재 사용자 정보 확인
 ``select user()``

- 현재 DB 정보 확인
``select databases()``
- TABLE_NAME 테이블의 스키마 확인
``desc TABLE_NAME``
- CSV파일 DB에 적용
``LOAD DATA LOCAL INFILE '``**FILE_NAME**``' INTO TABLE ``**TABLE_NAME**`` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';``
  - FILE_NAME 파일을 TABLE_NAME 테이블에 넣는다. 
필드는 ','로 구분되어 있고, 줄바꿈은 '\n'로 구분되어 있고, '"'로 싸인 내용은 한 덩어리로 인식한다. 

- 경고문 확인 
`` SHOW WARNINGS\G ``
  
- 테이블 생성 명령 
```
  CREATE  TABLE 테이블이름 ( 
    id  INT  NOT  NULL AUTO_INCREMENT, 
    항목1 VARCHAR(255) NOT  NULL, 
    항목2 DATE  NOT  NULL, 
    항목3 DECIMAL(10 , 2 ) NULL, 
    PRIMARY KEY (id) 
  );
  ```

---
문법 참조 : [http://tcpschool.com/mysql/mysql_basic_syntax](http://tcpschool.com/mysql/mysql_basic_syntax)

- SELECT
``SELECT 필드 [,필드2 ...] FROM 테이블 [WHERE 조건]``
  - 필드를 ','로 다중 선택
  - 
- DELETE
``DELETE FROM 테이블 [WHERE 조건]``
  - 조건을 생략하면 테이블의 모든 데이터 삭제

- DROP 
`` DROP DATABASE 데이터베이스``
`` DROP TABLE 테이블``
- INSERT
`` INSERT INTO 테이블(필드1, 필드2, ... ) VALUES (데이터1, 데이터2, ... )``
`` INSERT INTO 테이블 VALUES (데이터1, 데이터2, ... )``

- JOIN
  1. 내부Join
     - ``SELECT 테이블1.*, 테이블2.* FROM 테이블1, 테이블2 WHERE 조건``
     - ``SELECT 테이블1.*, 테이블2.* FROM 테이블1 INNER JOIN 테이블2 ON 조건``

  2. 외부Join
      - LEFT Join
         - ``SELECT * FROM 테이블1 LEFT JOIN 테이블2 ON 조건``
         - 조건이 맞지 않으면 테이블2의 필드 값이 모두 null 상태로 표시된다. 
      - RIGHT Join
         - ``SELECT * FROM 테이블1 LEFT JOIN 테이블2 ON 조건``
         - 조건이 맞지 않으면 테이블1의 필드값이 모두 null 상태로 표시된다. 

## 데이터 타입

1. 문자형 데이터타입

데이터 타입 | 설명
---|---
CHAR(n) | 고정 길이 데이터 타입(최대 255byte)- 지정된 길이보다 짦은 데이터 입력될 시 나머지 공간 공백으로 채워진다.
VARCHAR(n) | 가변 길이 데이터 타입(최대 65535byte)- 지정된 길이보다 짦은 데이터 입력될 시 나머지 공간은 채우지 않는다.
TINYTEXT(n) | 문자열 데이터 타입(최대 255byte)
TEXT(n) | 문자열 데이터 타입(최대 65535byte)
MEDIUMTEXT(n) | 문자열 데이터 타입(최대 16777215byte)
LONGTEXT(n) | 문자열 데이터 타입(최대 4294967295byte)
 ---
 
   2. 숫자형 데이터 타입


데이터 타입 | 설명
---|---
TINYINT(n) | 정수형 데이터 타입(1byte) -128 ~ +127 또는 0 ~ 255수 표현 가능하다.
SMALLINT(n) | 정수형 데이터 타입(2byte) -32768 ~ 32767 또는 0 ~ 65536수 표현 가능하다.
MEDIUMINT(n) | 정수형 데이터 타입(3byte) -8388608 ~ +8388607 또는 0 ~ 16777215수 표현 가능하다.
INT(n) | 정수형 데이터 타입(4byte) -2147483648 ~ +2147483647 또는 0 ~ 4294967295수 표현 가능하다.
BIGINT(n) | 정수형 데이터 타입(8byte) - 무제한 수 표현 가능하다.
FLOAT(길이,소수) | 부동 소수형 데이터 타입(4byte) -고정 소수점을 사용 형태이다.
DECIMAL(길이,소수) | 고정 소수형 데이터 타입고정(길이+1byte) -소수점을 사용 형태이다.
DOUBLE(길이,소수) | 부동 소수형 데이터 타입(8byte) -DOUBLE을 문자열로 저장한다.
---

3. 날짜형 데이터 타입

데이터 타입 | 설명
---|---
DATE | 날짜(년도, 월, 일) 형태의 기간 표현 데이터 타입(3byte)
TIME | 시간(시, 분, 초) 형태의 기간 표현 데이터 타입(3byte)
DATETIME | 날짜와 시간 형태의 기간 표현 데이터 타입(8byte)
TIMESTAMP | 날짜와 시간 형태의 기간 표현 데이터 타입(4byte) -시스템 변경 시 자동으로 그 날짜와 시간이 저장된다.
YEAR | 년도 표현 데이터 타입(1byte)
---

4. 이진 데이터 타입

데이터 타입 | 설명
---|---
BINARY(n) & BYTE(n) | CHAR의 형태의 이진 데이터 타입 (최대 255byte)
VARBINARY(n) | VARCHAR의 형태의 이진 데이터 타입 (최대 65535byte)
TINYBLOB(n) | 이진 데이터 타입 (최대 255byte)
BLOB(n) | 이진 데이터 타입 (최대 65535byte)
MEDIUMBLOB(n) | 이진 데이터 타입 (최대 16777215byte)
LONGBLOB(n) | 이진 데이터 타입 (최대 4294967295byte)
---


## 참조
[데이터베이스 정규화 1NF, 2NF, 3NF, BCNF :: Deep Play](https://3months.tistory.com/193)

[[MySQL] csv 파일을 직접 MySQL 테이블로 Import 하는 방법 (대용량 파일 import 팁) 주경야근](https://moonlighting.tistory.com/140)

[Import CSV File Into MySQL Table](https://www.mysqltutorial.org/import-csv-file-mysql-table/)

[DB - 데이터 타입/MYSQL](http://www.incodom.kr/DB_-_%EB%8D%B0%EC%9D%B4%ED%84%B0_%ED%83%80%EC%9E%85/MYSQL)

[[MySQL] Warnings 발생 했을 때 경고 내용 보기 - Blog Goooood.net](http://blog.devez.net/277)

[How to import CSV into mysql if values contains comma - Stack Overflow](https://stackoverflow.com/questions/31599622/how-to-import-csv-into-mysql-if-values-contains-comma)

[[SQL] 테이블 합치기 (JOIN / UNION) : 네이버 블로그](https://blog.naver.com/PostView.nhn?blogId=horajjan&logNo=220465143567&parentCategoryNo=&categoryNo=10&viewDate=&isShowPopularPosts=true&from=search)

[MySQL 계정 생성 관리 및 권한설정 :: 비실이의 개발공간](https://2dubbing.tistory.com/13)

[[MySQL] ERROR 1044 (42000.. : 네이버블로그](https://blog.naver.com/maestrois/220486269515)

[php - How can I make a key pair primary? - Stack Overflow](https://stackoverflow.com/questions/8376420/how-can-i-make-a-key-pair-primary)

[MySQL 계정 변경 및 간단한 사용법 : 네이버 블로그](https://m.blog.naver.com/PostView.nhn?blogId=athena1028&logNo=20060725715&proxyReferer=https:%2F%2Fwww.google.com%2F)

[MySQL 소개 및 기본 사용법 - 생활코딩](https://opentutorials.org/course/2136/12020)

[MySQL ALTER TABLE 테이블 변경하기](https://nexthops.tistory.com/2)


