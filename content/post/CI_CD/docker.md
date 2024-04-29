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

## Startup 
### 설치
[링크 참조](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

### 실행
1. DockerFile 이름의 파일을 생성하고 내용을 채워넣는다. 
https://docs.docker.com/engine/reference/builder/
 

## DockerFile 명령어
 - `FROM`: base image를 지정하는 명령어
   - DockerFile의 시작은 무조건 FORM 이 필요하다.  
   - `FROM <IMAGE>:<VERSION>` 형태로 사용한다.
   `FROM base:${CODE_VERSION}`
 - `MAINTAINER` : 메인테이너 정보
 - `ARG`: 변수를 선언  
   - `ARG CODE_VERSION=latest`
   - 선언한 변수는 `${CODE_VERSION}` 형태로 참조 가능하며, build시 자동으로 argument로 사용된다. 
   - `ARG port` 와 같이 값을 정의하지 않고 선언만 한 경우에는, --build-arg 옵션으로 값 설정이 가능하다.  
     - `docker build --build-arg port=80`
 - `RUN`: 컨테이너가 이미지를 실행하기 전 수행할 쉘 명령어
 - `CMD`: 컨테이너 실행 시 디폴트로 실행할 커맨드를 설정
   - `CMD ["executable","param1","param2"]` 형태로 사용
   - ENTRYPOINT와 조합하여 사용 가능하며, ENTRYPOINT에서 "executable"(명령어) 를 선언한 상태라면 CMD에서 executable 없이 param만 선언 가능하다. `CMD ["param1","param2"]`
   - 여러개의 CMD를 선언하면 가장 마지막의 것만 동작
   - `CMD /code/run-app` 와 같이 사용
 - `COPY`: 호스트 컴퓨터의 디렉터리나 파일을 Docker 이미지의 파일 시스템으로 복사
   - `COPY: <SRC> <DEST>`
   - `COPY: ["<SRC1>", "<SRC2>", ... <DEST>]`
 - `ADD`: 현재 이미지의 파일들을 내부 이미지의 특정 디렉터리에 복사. 이미지 안에 해당 경로가 없으면 생성하여 추가
   - `ADD <DIR_SOURCE> <DIR_DEST>`
   - COPY의 상위호환 명령어로, 압축 파일이나 링크상의 파일도 추가 가능하다. 
 - `ENV`: 환경변수를 설정하기 위한 명령어
 - `EXPOSE`: 외부와 연결할 포트, 컨테이너 실행시 -p 옵션을 사용하여 컨테이너로 유입되는 트래픽을 관리하려면 설정해 두어야 함.
   - `EXPOSE <port> [<port>/<protocol>...]`
   - 프로토콜은 tcp,udp 중 선택 가능
 - `ENTRYPOINT`: 컨테이너 시작시 수행할 명령어
   - `ENTRYPOINT ["<CMD>", "<PARAM1>", "<PARAM2>"]` 형태로 사용
   - `ENTRYPOINT ["npm", "start"]`
 - `LABEL`: 이미지에 metadata를 정의하는 명령어
   - `LABEL <key>=<value> <key>=<value> <key>=<value> ...`
 - `STOPSIGNAL`: 시스템이 종료하기 위한 SIGNAL을 설정한다. 
   - SIGINT, SIGKILL 등을 설정할 수 있으며, 이를 전달받으면 컨테이너가 종료하게 된다.
   - 설정하지 않으면 SIGTERM 이 자동으로 세팅된다. 
 - `USER`: 
 - `VOLUME`: 볼륨을 mount 하기 위한 자리를 세팅하는 명령어
   - `VOLUME ["경로1", "경로2", ...]`
   - run의 -v 옵션과 유사하지만, docker가 임의로 생성한 디렉터리에 volume을 연결한다. 이는 docker volume 명령어로 관리 가능하지만, 컨테이너가 삭제되고 나면 직접 접근하기 힘들다.
 - `WORKDIR`: 컨테이너에서 작업 디렉터리 이동
   - 리눅스의 cd 명령과 유사
 - `ONBUILD`: 빌드 후에 동작해야 할 명령들을 설정하는 명령어
   - DockerFile 명령어는 이미지 빌드를 위한 명령어이며, 빌드 할 때 마다 동일한 결과물을 산출한다. 하지만 빌드된 이미지의 결과물을 다음 빌드 때 사용하고 싶다면 이 명령을 사용한다.
        ```
        ONBUILD
        Learn more about the "ONBUILD" Dockerfile command.
         ADD . /app/src
        ONBUILD RUN /usr/local/bin/python-build --dir /app/src
        ```
   - 다음 빌드 때 ONBUILD가 호출된 순서대로 명령이 동작한다. 
   - `docker inspect` 명령어로 확인 가능

### 예시

- python 서버 실행
```
# python:3.10의 이미지로 부터
FROM python:3.9
# 제작자 및 author 기입
LABEL maintainer="huisam@naver.com"

# 해당 디렉토리에 있는 모든 하위항목들을 '/app/server`로 복사한다
COPY . /app/server

# image의 directory로 이동하고
WORKDIR /app/server

# 필요한 의존성 file들 설치
RUN pip3 install -r requirements.txt

# 환경 설정 세팅
RUN python setup.py install

# container가 구동되면 실행
ENTRYPOINT ["python", "Server.py"]
```

- 리눅스 실행
```
FROM ubuntu:18.04

ENV PATH="${PATH}:/usr/local/lib/python3.6/dist-packages/bin"
ENV LC_CTYPE=C.UTF-8

RUN apt update
RUN apt install -y \
    gcc \
    git \
    python3 \
    python3-pip \
    ruby \
    sudo \
    tmux \
    vim \
    wget

## examples
## change directory
#WORKDIR /root
# run commands
#RUN git clone https://github.com/~~~~
```

### 오류 와 해결방법
1. is docker daemon running? 에러
  - `service docker status` 입력시 docker daemon이 꺼져있는지 확인
  - `service docker start` 명령으로 daemon 실행
    - 만약 명령은 수행되나 켜지지 않는다면 systemctl명령 수행
      - `systemctl start docker` : docker를 daemon으로 실행
      - `systemctl enable docker` : OS실행시 docker daemon을 기본 실행
    - systemctl 명령도 안된다면 `/lib/systemd/system/docker.service` , `/lib/systemd/system/docker.socket` 이 제대로 있는지 확인하여 설치 여부를 재확인한다.    
[참조](https://velog.io/@pop8682/Docker-Cannot-connect-to-the-Docker-daemon-at-unixvarrundocker.sock.-Is-the-docker-daemon-running-%EC%97%90%EB%9F%AC-%ED%95%B4%EA%B2%B0)   

2. init 프로세스(PID 1)이 /bin/bash로 실행되지 않을 때, docker 실행 방법
  - `docker run -t -i ubuntu:16.04 /bin/bash`

3. `The container name "CONTAINER" is already in use by container`
  - 동일 한 이름의 컨테이너가 이미 존재해서 발생하는 에러
  - `docker ps -l` 로 컨테이너를 확인한다. 
  - `docker stop CONTAINER` 로 컨테이너 종료
  - `docker rm CONTAINER` 로 컨테이너 삭제
  - 다시 docker를 실행시키면 문제가 해결된다.


## Docker 라이브러리 명령어
- 이미지 : 특정 환경을 만들기 위해 세팅된 정보.
- 컨테이너 : 실행가능한 상태의 프로세스. 이미지를 컨테이너에 담아 실행시킬 수 있다.

### 생성 및 설정
- 버전 확인: ` docker -v `
- 이미지 다운: ` docker pull <이미지명>[:태그] `
- 이미지 생성 : 현재 경로에서 Dockerfile을 찾아 그 안의: ` docker build -t <이미지명> `
- 설치된 도커 이미지 확인: ` docker images `

### 실행
- 컨테이너 생성, 실행하지 않고 정지: ` docker create [옵션] <이미지명>[:태그] `
- 컨테이너 실행 후 CLI 접속: ` docker attach <컨테이너 id 또는 이름> `
- 컨테이너 실행. 지정된 작업 수행: ` docker start <이미지명> `
- 이미지 다운받아 실행: ` docker run <이미지명> `
- 환경변수 설정: ` docker run -e <환경변수=설정값> `

#### 옵션
- 이미지 다운받아 실행 후 CLI 접속: ` docker run -it <이미지명> `
- 컨테이너 실행시 이름 지정: ` docker run --name <컨테이너명> <이미지명> `
- 디렉터리 연결: ` docker run -v <로컬경로>:<컨테이너 내부 경로> <이미지명> `
- 포트 연결: ` docker run -p <로컬포트>:<컨테이너 포트> <이미지명> `
- 백그라운드 실행: ` docker run -d <이미지명> `
- 프로세스 종료시 컨테이너 자동 삭제: ` docker run -rm <이미지명> `

### 관리
- 실행중인 컨테이너 확인: `docker ps`
- 컨테이너 종료: ` docker stop <컨테이너 id 또는 이름> `
- 일시중지: ` docker container pause <컨테이너명> `
- 일시중지 해제: ` docker container unpause <컨테이너명> `
- 컨테이너 삭제: ` docker rm <컨테이너 id 또는 이름> `
- 모든 컨테이너 삭제: ``` docker rm `docker ps -a -q```
- 볼륨까지 같이 삭제: ` docker rm -v <컨테이너 id 또는 이름> `
- 이미지 삭제: ` docker rmi [옵션] <이미지 id> `
- 컨테이너 내부에서 커맨드라인을 수행하도록 외부에서 입력: `docker exec [옵션] <컨테이너 id 또는 이름> <커맨드>`
- 컨테이너 실행 후 지정된 명령어 수행: ` docker exec -it <컨테이너 id 또는 이름> [명령어] `
- 백그라운드 실행중인 도커 로그 확인: ` docker logs -f <컨테이너 id 또는 이름>`


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
