+++
title = "Mysql"
date = 2020-07-02T20:29:29+09:00
lastmod = 2021-08-16T14:15:00+09:00
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
문법 참조 : [http://tcpschool.com/mysql/mysql_basic_syntax](http://tcpschool.com/mysql/mysql_basic_syntax)

- 명령어에서 대소문자는 상관없다.
- mysql에서 주석은 '#'을 사용한다.

### 실행 및 로그인
1. ``mysql``
  - mysql 실행, 기본으로 설정된 user로 로그인됨
2. ``mysql -u 아이디 -p``
  - `-u`: 특정 아이디로 로그인
  - `-p`: 로그인시 비밀번호 입력하도록

### 데이터베이스 관리
1. DB 생성
   - UTF8 로 문자열 저장하기
   ``CREATE DATABASE 데이터베이스_이름 default CHARACTER SET UTF8``
1. DB 목록확인
  ``show databases``
1. DB 선택
  ``use DB_NAME``  
1. 종료
  ``EXIT``
1. 로그인 & 데이터베이스 선택
 ``$ mysql -p DB_NAME -u USER_NAME``
    - 사용자 이름과 USER_NAME으로 DB_NAME 데이터베이스 실행
    - USER_NAME이 비어있으면 현재 로그인한 계정과 동일한 이름으로 로그인 시도
    - -u DB_NAME 옵션은 로그인 후 ``$use DB_NAME`` 과 같은 효과


### 테이블 생성 및 관리
1. TABLE_NAME 테이블의 스키마 확인
``desc TABLE_NAME``

1. CREATE : 테이블 생성
```
  CREATE  TABLE 테이블이름 (
    id  INT  NOT  NULL AUTO_INCREMENT,
    항목1 VARCHAR(255) NOT  NULL DEFAULT 'FOO',
    항목2 DATE  NOT  NULL,
    항목3 DECIMAL(10 , 2 ) NULL,
    PRIMARY KEY (id)
  ) ENGINE-;
```
  - `NOT NULL`: 필수항목
  - `AUTO_INCREMENT`: 수동으로 설정 가능하지만, 따로 설정하지 않으면 테이블 내 해당 컬럼에서 가장 큰 값에 1을 증가하여 자동으로 설정됨.
  - `VARCHAR(#)`: 캐릭터형 #bit
  - `DEFAULT` : 기본값, 따로 설정안할시 기본값은 NULL이 됨.
  - `ENGINE`: 데이터 저장 구조
    - MyISAM
      - row level locking이 아닌 table level locking을 사용하기에, 한 테이블에 많은 접근이 이루어지면 속도가 느려짐
      - select count(*) from TABLE 속도가 빠름
    - InnoDB
      - 풀 텍스트 인덱스를 지원하지 않고 속도가 약간 느림
      - 트랜잭션을 지원함
    [참조](https://chiccoder.tistory.com/24)

1. DESC: 테이블 구조 확인
``DESC 테이블``
``DESCRIBE 테이블``

1. SELECT : 테이블 검색
``SELECT 필드 [,필드2 ...] FROM 테이블 [WHERE 조건] [ORDER BY 필드]``
    - 필드를 ','로 다중 선택
    - `WHERE` 문으로 특정 조건에 해당하는 레코드만 추출
      - `LIKE` : 뒤에 와일드 카드 사용
      - `_` : 와일드카드로, '한 자리의 어떤 문자'를 의미한다.
      - `%` : 와일드카드로, 정규식의 *과 같은 의미이다.
      - `NOT` : 부정의 의미, !과 동일
      - `<>` : !=와 같은 의미
    - `ORDER BY` 문으로 검색 결과를 필드에 맞게 정렬

1. DELETE : 데이터 삭제
``DELETE FROM 테이블 [WHERE 조건]``
  - 조건을 생략하면 테이블의 모든 데이터 삭제

1. ALTER: 테이블 변경
[참조](https://nexthops.tistory.com/2)
- 컬럼 추가
`` ALTER TABLE 테이블이름 ADD COLUMN 컬럼이름 데이터형``
- 컬럼 타입 변경
`` ALTER TABLE 테이블이름 MODIFY COLUMN 컬럼이름 데이터형``
- 컬럼 이름 변경
`` ALTER TABLE 테이블이름 CHANGE COLUMN 기존이름 새이름 데이터형``
- 컬럼 삭제
`` ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름``
- Primary Key 설정
`` ALTER TABLE 테이블이름 ADD PRIMARY KEY (설정할컬럼1, 설정할컬럼2, ...)``
- Primary key 삭제
`` ALTER TABLE 테이블이름 DROP PRIMARY KEY``
- 테이블명 변경
`` ALTER TABLE 테이블이름 RENAME 새테이블이름``
- DB구조 변경
`` ALTER TABLE 테이블 engine=InnoDB;``

1. DROP : 테이블 삭제
`` DROP DATABASE 데이터베이스``
`` DROP TABLE 테이블``

1. INSERT : 행 추가
- 원하는 필드만 설정, 설정 안한부분은 default값이 들어감
`` INSERT INTO 테이블(필드1, 필드2, ... ) VALUES (데이터1, 데이터2, ... )``
- 모든 필드를 설정할땐 컬럼 이름을 생략 가능
`` INSERT INTO 테이블 VALUES (데이터1, 데이터2, ... )``

1. JOIN : 테이블 융합
    - 내부Join
       - ``SELECT 테이블1.*, 테이블2.* FROM 테이블1, 테이블2 WHERE 조건``
       - ``SELECT 테이블1.*, 테이블2.* FROM 테이블1 INNER JOIN 테이블2 ON 조건``

    - 외부Join
        - LEFT Join
           - ``SELECT * FROM 테이블1 LEFT JOIN 테이블2 ON 조건``
           - 조건이 맞지 않으면 테이블2의 필드 값이 모두 null 상태로 표시된다.
        - RIGHT Join
           - ``SELECT * FROM 테이블1 LEFT JOIN 테이블2 ON 조건``
           - 조건이 맞지 않으면 테이블1의 필드값이 모두 null 상태로 표시된다.

### 유저 관리
 1. GRANT : 데이터베이스에 권한 부여
    - `` GRANT ALL PRIVILEGES ON my_db.* TO new_user@localhost IDENTIFIED BY 'pswd'; ``
       - `ALL PRIVILEGES` : 모든 권한
       - `my_db.*` : my_db의 모든 테이블
       - `new_user` : 사용권한을 받을 유저(없을시 자동생성),
       - `@localhost` : 로컬환경에서만 접속 가능
       - `IDENTIFIED BY 'pswd'` : new_user의 비밀번호를 pswd로 설정
    - `flush privileges` 권한 즉시 적용

### 기타 명령어
   1. 현재 사용자 정보 확인
   ``select user()``
   1. 현재 DB 정보 확인
   ``select databases()``
   1. CSV파일 DB에 적용
   ``LOAD DATA LOCAL INFILE '``**FILE_NAME**``' INTO TABLE ``**TABLE_NAME**`` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';``
     - FILE_NAME 파일을 TABLE_NAME 테이블에 넣는다.
   필드는 ','로 구분되어 있고, 줄바꿈은 '\n'로 구분되어 있고, '"'로 싸인 내용은 한 덩어리로 인식한다.

   1. 경고문 확인
   `` SHOW WARNINGS\G ``

-----

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

## C++연동 SDK
- mysql cpp connector 라 불리는, C++ 코드로 mysql을 사용할 수 있는 SDK가 제공된다.
- mysql과 mysqlx가 있는데, 전자는 RDB, 후자는 NoSQL이다.
- 표준 docmument
https://dev.mysql.com/doc/connector-cpp/8.0/en/connector-cpp-installation-source-distribution.html
- guthub
https://github.com/mysql/mysql-connector-cpp


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

[(MySQL) 1장 시작하기. (DB 생성, 테이블 생성, SELECT) - 미래학자](https://futurists.tistory.com/11)
