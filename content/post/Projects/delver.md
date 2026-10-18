---
title: "Python 웹 스크래퍼 Delver: AWS Lambda와 GitHub Actions 자동 배포기"
date: 2024-01-30T21:21:43+09:00
lastmod: 2024-01-30T21:21:43+09:00
description: "BeautifulSoup 기반 Python 웹 스크래퍼 Delver를 Docker 이미지로 빌드하고, AWS ECR/Lambda와 GitHub Actions를 통해 매일 자동 실행되도록 구현한 서버리스 구축기입니다."
slug: "python-web-scraper-delver-aws-lambda"
categories: ["Projects"]
tags: ["python", "beautifulsoup", "aws-lambda", "docker", "github-actions", "portfolio"]
series: ["프로젝트 개발기"]
ShowToc: true
TocOpen: true
draft: false
---

# Delver: Python 웹 스크래퍼 및 Slack 알림 봇 개발 문서

- 개발 기간: 2023년 3월 18일 ~ 2023년 3월 28일  

## 프로젝트 개요

### 목표

Python 기반 웹 스크래핑을 수행하고 결과를 Slack 채널로 자동 전송하는 Slack Bot 제작

### 요구사항

1. AWS Lambda 기반의 서버리스 환경에서 구동
2. 매 시간/매일 정해진 주기마다 자동 동작

## Web Scrapper 구현

### 1. 웹 스크래퍼 구현 내용

1. BeautifulSoup를 사용한 대상 웹사이트 스크래핑
   - 여러 사이트에 유연하게 호환되도록 사이트별 파싱 설정을 JSON 형태로 분리
   - 사이트별 속성을 JSON 형식으로 저장하여 코드 변경 없이 대상 사이트 추가가 가능한 아키텍처 설계
    
    ![사이트별 속성을 json 형태로 기록](/IMAGE_DELVER_WEB_SCRAPPER/Untitled.png)
    
    ![json 형태를 읽어 코드 변경 없이 사이트 추가할 수 있는 구조로 작성](/IMAGE_DELVER_WEB_SCRAPPER/Untitled1.png)

### 2. 스크래핑 문제와 해결

1. BeautifulSoup를 사용하여 특정 문자열 검색 시 태그 누락 이슈
   - `find()` 혹은 `find_all()`에 string 인자를 넣어 검색하면 반환값으로 HTML Tag 객체 대신 단순 문자열(string) 배열이 반환됨
   - 검색 결과에서 하위 요소를 추가 탐색해야 할 경우, 태그를 먼저 추출한 후 내부 텍스트에 대해 검사를 수행하도록 로직 개선
    
    ![item 안에 특정 문자열이 있는지 확인하는 구문](/IMAGE_DELVER_WEB_SCRAPPER/Untitled2.png)
    
    ![find_all 구문에 string 파라미터를 넣었을 때의 결과](/IMAGE_DELVER_WEB_SCRAPPER/Untitled3.png)

## AWS Lambda 배포 및 자동화

### 1. 작업 개요

- 작성한 스크래퍼 코드를 서버리스 인프라에 배포하여 정기 구동
- GitHub Actions를 연동하여 `push` 시 Docker 이미지 빌드 및 AWS Lambda 배포가 자동으로 수행되는 CI/CD 파이프라인 구축

### 2. 배포 파이프라인 구현

Delver는 상시 서버 구동이 불필요하므로 비용 절감을 위해 AWS Lambda를 채택했습니다. 커스텀 라이브러리(BeautifulSoup, Slack SDK) 구동을 위해 Docker 컨테이너 기반 Lambda 함수로 설계했습니다.

- **Docker 모듈화**:
  - `pip freeze > requirements.txt`로 의존성을 정의하고 Dockerfile 작성
  - AWS Lambda 베이스 이미지를 기반으로 컨테이너화 수행
  ![requirements](/IMAGE_DELVER_DEPLOY/Untitled.png)
  ![Dockerfile](/IMAGE_DELVER_DEPLOY/Untitled%201.png)

- **AWS 연동 (IAM, ECR, Lambda, EventBridge)**:
  1. IAM 사용자 생성 및 ECR/Lambda 권한 액세스 키 발급
  2. Amazon ECR(Elastic Container Registry) 프라이빗 리포지토리 생성
     ![리포지터리 생성 화면](/IMAGE_DELVER_DEPLOY/Untitled%203.png)
  3. 컨테이너 이미지 기반 AWS Lambda 함수 생성
     ![컨테이너 이미지 동작 설정](/IMAGE_DELVER_DEPLOY/Untitled%204.png)
  4. Amazon EventBridge (CloudWatch Events) 기반 스케줄러 등록
     - 한국 시간 기준 매일 지정 시각에 트리거되도록 cron 표현식 설정: `cron(0 3 * * ? *)` (UTC 기준 03:00 = KST 12:00)
     ![EventBridge 설정 내용](/IMAGE_DELVER_DEPLOY/Untitled%206.png)
  5. Lambda 타임아웃 및 재시도 설정: 스크래핑 네트워크 지연을 고려해 적절한 Timeout 설정 부여

- **GitHub Actions CI/CD 연동**:
  1. AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY 등 민감 정보를 GitHub Repository Secrets에 안전하게 등록
     ![GitHub Secrets](/IMAGE_DELVER_DEPLOY/Untitled%209.png)
  2. `.github/workflows/uploadECR.yml` 워크플로우 구성
     - 코드 푸시 시 Docker 이미지를 빌드하여 ECR에 푸시하고, Lambda 함수의 코드를 최신 ECR 이미지로 갱신하는 단계 정의
     ![Action 설정](/IMAGE_DELVER_DEPLOY/image%201.png)

### 3. 배포 문제와 트러블슈팅

1. AWS Lambda 기본 런타임의 외부 라이브러리 제약
   - Slack 및 BeautifulSoup와 같은 서드파티 라이브러리를 지원하기 위해 ECR 컨테이너 이미지 배포 방식으로 전환하여 해결

2. ECR 푸시 과정에서 EOF 에러 발생
   - 원인: `docker/build-push-action` 사용 시 ECR 로그인 세션 혹은 전체 리포지토리 URL 네이밍 불일치
   - 해결: `docker build` 시 전체 리포지토리 URI(`123456789.dkr.ecr.region.amazonaws.com/repo:latest`)를 명시하고 IAM 권한에 `AmazonEC2ContainerRegistryPowerUser` 정책 추가

3. Lambda 함수 코드 업데이트 시 403 Forbidden 권한 에러
   - IAM 사용자 권한에 `lambda:UpdateFunctionCode` 및 실행 권한에 대한 인라인 정책을 추가하여 정상 배포 성공:
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Sid": "AllowLambdaFunctionUpload",
               "Effect": "Allow",
               "Action": [
                   "lambda:CreateFunction",
                   "lambda:GetFunctionConfiguration",
                   "lambda:UpdateFunctionCode",
                   "lambda:UpdateFunctionConfiguration"
               ],
               "Resource": "arn:aws:lambda:us-east-2:ACCOUNT_ID:function:Delver_webScrap"
           }
       ]
   }
   ```