+++
title = "Docker"
date = 2021-08-12T10:41:00+09:00
lastmod = 2021-08-12T10:41:00+09:00
tags = [ "docker",]
categories = ["dev",]
imgs = []
cover = "" # image show on top
readingTime = true # show reading time after article date
toc = true
comments = false
justify = false # text-align: justify;
single = false # display as a single page, hide navigation on bottom, like as about page.
license = "" # CC License
draft = false
+++

# Docker
- 리눅스 커널의 cgroups와 namespace에 의해 제공되는 기술
- 가상화 기능의 일종으로, 별도의 OS를 갖지 않아 VM(Virtual Machine) 보다 가볍다.
- 게스트는 호스트 OS와 자원을 공유한다.
- immutable infrastructure : 서비스 운영 환경을 통째로 이미지화 하여 배포하는 형태

## 설치
[링크 참조](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

## 실행
### 오류 및 각종 이   
1. is docker daemon running? 에러
  - `service docker status` 입력시 docker daemon이 꺼져있는지 확인
  - `service docker start` 명령으로 daemon 실행
    - 만약 명령은 수행되나 켜지지 않는다면 systemctl명령 수행
      - `systemctl start docker` : docker를 daemon으로 실행
      - `systemctl enable docker` : OS실행시 docker daemon을 기본 실행
    - systemctl 명령도 안된다면 `/lib/systemd/system/docker.service` , `/lib/systemd/system/docker.socket` 이 제대로 있는지 확인하여 설치 여부를 재확인한다.    
[참조](https://velog.io/@pop8682/Docker-Cannot-connect-to-the-Docker-daemon-at-unixvarrundocker.sock.-Is-the-docker-daemon-running-%EC%97%90%EB%9F%AC-%ED%95%B4%EA%B2%B0)   


2. init 프로세스(PID 1)이 /bin/bash로 실행되지 않을 때, docker 실행 방법   
`docker run -t -i ubuntu:16.04 /bin/bash`

## docker 명령어
- 이미지 : 특정 환경을 만들기 위해 세팅된 정보.
- 컨테이너 : 실행가능한 상태의 프로세스. 이미지를 컨테이너에 담아 실행시킬 수 있다.

### 생성 및 설정
- 버전 확인
` docker -v `
- 이미지 다운
` docker pull <이미지명>[:태그] `
- 이미지 생성 : 현재 경로에서 Dockerfile을 찾아 그 안의
` docker build -t <이미지명> `
- 설치된 도커 이미지 확인
` docker images `

### 실행
- 컨테이너 생성, 실행하지 않고 정지
` docker create [옵션] <이미지명>[:태그] `
- 컨테이너 실행 후 CLI 접속
` docker attach <컨테이너 id 또는 이름> `
- 컨테이너 실행. 지정된 작업이 수행된다.
` docker start <이미지명> `
- 이미지 다운받아 실행
` docker run <이미지명> `
- 환경변수 설정
` docker run -e <환경변수=설정값> `
#### 옵션
- 이미지 다운받아 실행 후 CLI 접속
` docker run -it <이미지명> `
- 컨테이너 실행시 이름 지정
` docker run --name <컨테이너명> <이미지명> `
- 디렉터리 연결
` docker run -v <로컬경로>:<컨테이너 내부 경로> <이미지명> `
- 포트 연결
` docker run -p <로컬포트>:<컨테이너 포트> <이미지명> `
- 백그라운드 실행
` docker run -d <이미지명> `
- 프로세스 종료시 컨테이너 자동 삭제
` docker run -rm <이미지명> `

### 관리
- 실행중인 컨테이너 확인
` docker ps `
- 일시중지
` docker container pause <컨테이너명> `
- 일시중지 해제
` docker container unpause <컨테이너명> `
- 컨테이너 삭제
` docker rm <컨테이너 id 또는 이름> `
- 모든 컨테이너 삭제
` docker rm `docker ps -a -q` `
- 볼륨까지 같이 삭제
` docker rm -v <컨테이너 id 또는 이름> `
- 이미지 삭제
` docker rmi [옵션] <이미지 id> `
- 컨테이너 내부에서 커맨드라인을 수행하도록 외부에서 입력
` docker exec [옵션] <컨테이너 id 또는 이름> <커맨드>
- 컨테이너 실행 후 지정된 명령어 수행
` docker exec -it <컨테이너 id 또는 이름> [명령어] `
- 백그라운드 실행중인 도커 로그 확인
` docker logs -f <컨테이너 id 또는 이름>`

## Dockerfile
- FROM <이미지명> : 이미 생성된 이미지에 덧붙여서 아래 내용을 수행, import와 비슷한 느낌
- MAINTAINER : 메인테이너 정보
- WORKDIR : 명령어를 실행할 위치 설멍, 리눅스 cd에 해당
- VOLUME ["경로1", "경로2", ...]: run의 -v 옵션과 유사하지만, docker가 임의로 생성한 디렉터리에 volume을 연결한다. 이는 docker volume 명령어로 관리 가능하지만, 컨테이너가 삭제되고 나면 직접 접근하기 힘들다.
- ADD <DIR_SOURCE> <DIR_DEST>: 현재 이미지의 파일들을 내부 이미지의 특정 디렉터리에 복사. 이미지 안에 해당 경로가 없으면 생성하여 추가
- RUN <명령어> : 컨테이너가 이미지를 실행하기 전 수행할 쉘 명령어
- CMD <명령> : 실행하고 나서 수행할 명령어, 쉘을 불러 실행한다.
- CMD ["인자 1", "인자 2", ...] : 쉘 없이 명령 실행. '[]' 안에 문자열 배열로 치환해 넘겨주는 형태
- EXPOSE : 외부와 연결할 포트, 컨테이너 실행시 -p 옵션을 사용하기 위해 설정해 두어야 함.
- ARG <옵션> : 설정 옵션들을 정의
- ENV <환경변수> : 환경변수 설정

## .dockerignore
- Docker 이미지 생성시 들어가지 않을 파일들을 지정 가능

## docker-compose
- 각각의 Dockerfile들을 묶어 하나의 시스템을 구성하는 도구
- docker 실행시 명령어를 미리 작성해 놓은 스크립트라고 보면 된다.
- `` docker-compose up `` 명령으로 docker-compose 파일 빌드 가능. 하위 경로에 Dockerfile들이 각각의 서비스에 해당됨
```
version: '3' 				// 도커 컴퍼즈 버전 3이상 요구
	services: 				// 서비스 내용들이 아래에 옴
		service1: 			// 서비스 이름으로, 마음대로 정의 가능
			build: ./S1 		// docker-compose 파일로부터 경로를 지정
			volumes:
				- ./S1:/home/root 	//	docker run -v 옵션 적용과 동일
			ports:
				- "1234:1234"		// docker run -p 옵션 적용과 동일
			environment:
				- DEBUG_LEVEL=debug	//	환경변수 설정 가능
			links: // docker-compose 3부터는 필요없어진 기능, 네트워크 연결을 위해 사용
				- service2
		service2: 			// 또다른 서비스, 위와 같이 작성 가능

		...
```
