---
title: "Delver"
date: 2024-01-30T21:21:43+09:00
lastmod: 2024-01-30T21:21:43+09:00
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

# Delver

시작날짜: March 18, 2023  
종료날짜: March 28, 2023  

## 목표

python 기반 웹 scrapping 및 결과를 slack 에 전송하는 slack bot

## 요구사항

1. AWS lambda를 사용하여 동작
2. 매 시간마다 동작하도록 설정

# [Delver]🔨 Web scrapper 작성

## 1. 구현 내용

1. beautiful soup를 사용하여 특정 web을 scrap 
(API 참조: [https://beautiful-soup-4.readthedocs.io/en/latest/](https://beautiful-soup-4.readthedocs.io/en/latest/))
- 여러 사이트에 호환되도록 구조를 설정

    
    ![사이트별 속성을 json 형태로 기록](/IMAGE_DELVER_WEB_SCRAPPER/Untitled.png)
    
    사이트별 속성을 json 형태로 기록
    
    ![json 형태를 읽어 코드 변경 없이 사이트 추가할 수 있는 구조로 작성](/IMAGE_DELVER_WEB_SCRAPPER/Untitled1.png)
    
    json 형태를 읽어 코드 변경 없이 사이트 추가할 수 있는 구조로 작성
    

## 2. 문제와 해결

1. Beautiful soup를 사용하여 특정 문자 찾기
 - find() 혹은 find_all() 에 string 인자를 넣어서 검색을 하면 반환 값으로html tag 배열이 아니라, string 배열이 온다. 
 - 검색 결과에서 추가적으로 find를 해야할 경우 문자열을 따로 추출하여 검색을 하도록 한다.
    
    ![item 안에 특정 문자열(keywords)이 있는지 확인하는 구문](/IMAGE_DELVER_WEB_SCRAPPER/Untitled2.png)
    
    item 안에 특정 문자열(keywords)이 있는지 확인하는 구문
    
    ![위와같이 find_all() 구문에 ‘string’ 파라미터를 넣으면 detected 는 string의 배열을 갖게 된다.](/IMAGE_DELVER_WEB_SCRAPPER/Untitled3.png)
    
    위와같이 find_all() 구문에 ‘string’ 파라미터를 넣으면 detected 는 string의 배열을 갖게 된다.


# [Delver]🔨 배포

## 작업 설명

- 작성한 코드를 서버에 배포하고, 구동시킨다.
- github 의 action 을 사용하여 push와 동시에 자동으로 서버에 배포되도록 pipeline을 구축한다.

## 1. 구현 내용

- Delver는 상시 구동이 필요한 프로그램이 아니므로, 비용 절감을 위해 AWS의 lambda 를 사용하여 일정 시간마다 코드를 동작 시킨다.
- 그러기 위해서는 Delver가 Docker 위에서 실행되도록 세팅이 필요하며, Delver 가 실행되기 위한 모든 사전 조건들(파이썬 버전, 라이브러리 등) 이 Docker 실행과 동시에 모두 설치 되도록 해야 한다.

### Docker 모듈화

1. python 코드가 배포될 때, 동작에 필요한 모듈들이 설치 되도록 dependency 설정
    - `pip freeze` 명령으로 설치된 모듈들을 확인한 후, 이를 requirements.txt 에 기입한다.
        
        ![Untitled](/IMAGE_DELVER_DEPLOY/Untitled.png)
        
    - 이후 `pip install -r requirements.txt` 명령어를 사용해 주면 설정된 의존성 파일들이 모두 설치된다.

1. DockerFile을 설정하여 AWS에 docker 형태로 배포될 수 있도록 작성
    
    ![Untitled](/IMAGE_DELVER_DEPLOY/Untitled%201.png)
    

### AWS 연동

1. AWS 접속 계정 생성
    - IAM에서 AWS API 호출 시 인증에 사용 될 access key 를 발급 받는다.
    - IAM → 사용자 → 보안 자격증명 → 액세스키 → 액세스 키 만들기 경로로 생성이 가능하다.
        
        ![Untitled](/IMAGE_DELVER_DEPLOY/Untitled%202.png)
        
2. ECR 생성
    - [Amazon ECR](https://us-east-2.console.aws.amazon.com/ecr/get-started?region=us-east-2) → **리포지토리** 에 접속하여 ‘리포지토리 생성’ 버튼을 클릭한다.
    - 프라이빗 설정으로, 이름을 지정한다.
    - 태그는 리포지토리 마지막에 붙는 버전을 나타내는 postfix이다. 태그 변경 옵션은, 같은 이름의 태그를 덮어쓸 수 있는지 설정하는 항목이다.
        
        ![리포지터리 생성 화면](/IMAGE_DELVER_DEPLOY/Untitled%203.png)
        
        리포지터리 생성 화면
        
3. Lambda 함수 생성
    - [Lambda](https://us-east-2.console.aws.amazon.com/lambda/home?region=us-east-2#/) 에 접속하여 ‘함수생성’ 버튼을 클릭해 함수를 생성한다.
    - 생성된 ECR 을 실행하는 람다 함수를 생성한다.
        
        ![‘컨테이너 이미지’ 를 동작시키도록 설정하여 생성하면 된다.](/IMAGE_DELVER_DEPLOY/Untitled%204.png)
        
        ‘컨테이너 이미지’ 를 동작시키도록 설정하여 생성하면 된다.
        
4. Lambda 함수가 매일 실행되도록 AWS Cloud Watch (EventBridge) 세팅
    - 설정 참조: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)
    
    ![시각 표시 규칙](/IMAGE_DELVER_DEPLOY/Untitled%205.png)
    
    시각 표시 규칙
    
    - 한국 시간 기준 매일 12시에 동작하도록 설정. 띄워 쓰기 기준으로, `cron(분 시 일 월 요일 해)` 를 뜻한다.
        
        ![EventBridge 설정 내용](/IMAGE_DELVER_DEPLOY/Untitled%206.png)
        
        EventBridge 설정 내용
        
5. Lambda 함수 설정
    1. python code가 정상적으로 종료되었다는 것을 판단하는 조건 설정필요
    2. lambda 함수는 실패한 경우 재시도를 수행하는데, 재시도 횟수를 설정할 수 있다.
    ( Lambda 함수 재시도 참조 : [https://repost.aws/knowledge-center/lambda-function-retry-timeout-sdk](https://docs.aws.amazon.com/ko_kr/lambda/latest/dg/invocation-retries.html))
        
        ![Untitled](/IMAGE_DELVER_DEPLOY/Untitled%207.png)
        
    3. lambda 함수가 비동기로 실행되는 경우, 실행 완료까지 timeout을 설정할 수 있다. 너무 짧게 잡으면 실행이 완료되지 않아 정상 동작을 해도 실패로 처리될 수 있다.
        
        ![Untitled](/IMAGE_DELVER_DEPLOY/Untitled%208.png)
        

### Github action 연동

1. 배포에 필요한 내용들 중 민감한 정보들은 Secret 기능을 활용하여 github 내부적으로 관리한다. 
    - API KEY 혹은 AWS 계정 정보와 같이 외부에 공개되면 안되는 정보들은 github 의 action secret 기능을 통해 코드와 분리된 채로 배포 시 추가될 수 있도록 한다. 
    (참조: [https://ji5485.github.io/post/2021-06-26/create-env-with-github-actions-secrets/](https://ji5485.github.io/post/2021-06-26/create-env-with-github-actions-secrets/))
        
        ![다른 사용자에게 공개되지 않는 비밀 변수를 생성할 수 있다. ](/IMAGE_DELVER_DEPLOY/Untitled%209.png)
        
        다른 사용자에게 공개되지 않는 비밀 변수를 생성할 수 있다. 
        
2. Github Action 에서 새로운 작업을 정의한다. 
    - github 레퍼지터리에 들어가면 Action 이라는 탭이 있다.
        
        ![image.png](/IMAGE_DELVER_DEPLOY/image.png)
        
    - New Workflows 버튼을 누르면 새로운 Action 을 생성할 수 있는데, 그 중에서 미리 만들어진 template 을 골라 사용 할 수도 있지만, 우리는 직접 코드를 짜서 action을 만들 것이기 때문에 아무 템플릿이나 선택한다.
        
        > Github 와  aws의 pipeline 을 통해 push시 자동으로 aws배포되도록 하는 방법도 있었으나, github action을 이용했다.
        > 
        > - AWS 설정 참조([https://docs.aws.amazon.com/codepipeline/latest/userguide/connections-github.html](https://docs.aws.amazon.com/codepipeline/latest/userguide/connections-github.html))
        > - Docker를 활용하여 ECR 생성 참조([https://www.youtube.com/watch?v=6O-7zb-igUs](https://www.youtube.com/watch?v=6O-7zb-igUs))
    - 이후, 아래와 같은 yml 파일을 작성 할 수 있는 창이 뜨는데, 파일의 이름과 내용을 알맞게 집어넣는다.
        
        ![image.png](/IMAGE_DELVER_DEPLOY/image%201.png)
        
    - 필자가 작성한 yml 파일의 이름은 `uploadECR.yml` 이고, 내용은 아래 링크에서 확인 가능하다. 파일의 내용은, push한 코드를 앞서 생성한 aws lambda 모듈에 연동시키는 것이다.
        - [https://github.com/AswinBlue/SlackBot/blob/master/.github/workflows/uploadECR.yml](https://github.com/AswinBlue/SlackBot/blob/master/.github/workflows/uploadECR.yml)
        - 앞서 생성한 AWS 계정, ECR, lambda함수 정보가 모두 포함된다.
    - 이렇게 Action 을 설정하면 `.github/workflows` 디렉터리가 생성되며, git에 commit 을 새로  push 할 때 마다 aws 의 lambda 모듈에 최신 코드가 적용되게 된다.

## 2. 문제와 해결

1. AWS lambda 를 통해 함수를 구동하려면, aws에서 제공하는 기본 python 환경의 모듈들만 사용 가능하다. 나는 slack과 beautifulsoup를 추가로 사용하고 있으므로, 별개의 이미지를 생성해야 한다.
- ECR(Elastic Container Registry) 를 생성하고 lambda 함수가 그 환경에서 동작하도록 한다. 
- docker를 통해 ECR이 빌드될 수 있도록 DockerFile 및 requirements.txt을 세팅한다.
2. AWS ECR 배포시 EOF 에러가 발생하였다.
TRY 1:
  - `uses: docker/build-push-action@v2` 를 사용하는 대신 `run` 을 이용하여 직접 docker 명령을 입력하였다.
  - docker build 명령 시 `docker build [123456789.dkr.ecr.us-east-1.amazonaws.com/](http://435370146413.dkr.ecr.us-east-2.amazonaws.com/)repo:latest .` 와 같이 full repository name을 입력하여야 해당 이름으로 tag가 설정된다. (아니면, 빌드 후 `docker tag` 명령으로 직접 태그를 설정할 수도 있다.)

TRY 2:
  - IAM에서 사용자 권한을 변경하였다. 
  - [AmazonEC2ContainerRegistryReadOnly](https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn%3Aaws%3Aiam%3A%3Aaws%3Apolicy%2FAmazonEC2ContainerRegistryReadOnly) 권한에 [AmazonEC2ContainerRegistryPowerUser](https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser) 를 추가로 부여하였다.
3. AWS Lambda 함수 설정에도 403 에러가 발생하였다.
 - 아래 권한을 추가로 부여하여 github action에서 `uses: appleboy/lambda-action@master` 을 호출하여 lambda 함수 설정이 가능하도록 하였다. 
    
    ```jsx
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
                "Resource": "arn:aws:lambda:us-east-2:435370146413:function:Delver_webScrap"
            },
            {
                "Sid": "AllowLambdaExecutionRole",
                "Effect": "Allow",
                "Action": [
                    "lambda:CreateFunction",
                    "lambda:GetFunctionConfiguration",
                    "lambda:GetFunction",
                    "lambda:ListFunctions"
                ],
                "Resource": "*"
            }
        ]
    }
    ```