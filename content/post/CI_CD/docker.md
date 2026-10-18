---
title: "Docker 핵심 아키텍처와 Dockerfile 최적화 작성부터 프로덕션 배포까지"
description: "가상 머신 대비 도커의 경량화 원리, Dockerfile 핵심 명령어(COPY vs ADD, ENTRYPOINT vs CMD) 비교, 컨테이너 생명주기 관리 및 트러블슈팅을 정리합니다."
slug: "docker-architecture-dockerfile-production-guide"
date: 2021-08-12T10:41:00+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DevOps"]
tags: ["docker", "container", "devops", "ci-cd", "dockerfile"]
series: ["Docker와 컨테이너 실전 인프라"]
ShowToc: true
TocOpen: true
---

현대 소프트웨어 엔지니어링과 클라우드 네이티브 환경에서 컨테이너 기술은 표준 배포 패러다임으로 자리 잡았습니다. '내 로컬 컴퓨터에서는 잘 실행되는데 배포 서버에서는 동작하지 않는' 의존성 파편화 문제를 원천적으로 해결해주기 때문입니다.

이 글에서는 리눅스 커널 수준의 도커 동작 원리부터 멀티 스테이지 빌드를 고려한 효율적인 Dockerfile 작성법, 컨테이너 생명주기 관리 명령어, 그리고 실무에서 자주 마주치는 데몬 연결 오류 해결법을 총정리합니다.

---

## 1. 도커 컨테이너 가상화의 핵심 아키텍처

도커(Docker)는 리눅스 커널의 두 가지 핵심 기술을 바탕으로 프로세스를 격리합니다.
1. **cgroups (Control Groups)**: 프로세스 그룹별 CPU, 메모리, 네트워크 대역폭, 디스크 I/O 등 시스템 자원 할당량을 제어합니다.
2. **namespaces**: 프로세스 트리(PID), 네트워크 인터페이스(NET), 파일시스템 마운트 포인트(MNT), 사용자 계정(USER)을 완전히 분리하여 각 컨테이너가 독립된 OS 위에서 구동되는 것처럼 환경을 격리합니다.

### 1.1. 가상 머신(VM)과 컨테이너의 성능 차이
기존 하이퍼바이저 기반 가상 머신(VM)은 호스트 OS 위에 게스트 OS 전체를 별도로 구동해야 하므로 기가바이트(GB) 단위의 디스크 용량과 긴 부팅 시간, 상당한 CPU 오버헤드가 발생합니다. 반면 도커 컨테이너는 호스트 OS 커널을 직접 공유하면서 사용자 공간(User Space) 프로세스만 격리하므로 메가바이트(MB) 단위의 가벼운 이미지 크기와 밀리초(ms) 단위의 즉각적인 시작 속도를 제공합니다.

### 1.2. 불변 인프라 (Immutable Infrastructure)
도커는 인프라 변경 시 기존 컨테이너를 패치하는 대신, 변경점이 반영된 완전히 새로운 이미지를 빌드하여 통째로 교체 배포하는 **불변 인프라** 원칙을 실현합니다. 이를 통해 서버 환경의 드리프트(Drift) 현상을 원천 방지할 수 있습니다.

{{< ad-inarticle >}}

---

## 2. 실전 Dockerfile 작성과 명령어 명세

애플리케이션을 컨테이너 이미지로 패키징하기 위해 `Dockerfile` 스크립트를 정의합니다.

### 2.1. Python 웹 서버 Dockerfile 예시
```dockerfile
# 1. 경량화된 Python 기본 런타임 이미지 지정
FROM python:3.9-slim

# 메타데이터 레이블 지정
LABEL maintainer="aswinblue@example.com"

# 컨테이너 내부 작업 디렉터리 설정
WORKDIR /app/server

# 빌드 캐시 최적화를 위해 의존성 정의 파일 먼저 복사
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 전체 소스코드 복사
COPY . .

# 외부 포트 노출 선언
EXPOSE 8000

# 컨테이너 부팅 시 실행할 엔트리포인트 지정
ENTRYPOINT ["python", "Server.py"]
```

### 2.2. 핵심 Dockerfile 명령어 상세 비교
- **`FROM <IMAGE>:<TAG>`**: 빌드 기반이 될 베이스 이미지를 지정하며 모든 Dockerfile의 첫 번째 명령이어야 합니다.
- **`COPY` vs `ADD`**:
  - `COPY`: 로컬 파일/디렉터리를 컨테이너 내부로 단순 복사합니다. 일반적인 소스코드 복사 시 보안성과 명확성을 위해 항상 `COPY` 사용을 권장합니다.
  - `ADD`: 로컬 파일 복사뿐 아니라 원격 URL 다운로드 및 `tar.gz` 압축 파일의 자동 풀림 기능을 지원합니다.
- **`ENTRYPOINT` vs `CMD`**:
  - `ENTRYPOINT`: 컨테이너가 실행될 때 반드시 고정 실행되는 기본 바이너리나 명령어를 정의합니다.
  - `CMD`: `ENTRYPOINT`에 전달할 기본 파라미터를 제공하거나 단독 기본 명령을 지정합니다. 사용자가 `docker run` 시 인자를 넘기면 `CMD` 내용은 쉽게 오버라이딩됩니다.
- **`ARG` vs `ENV`**:
  - `ARG`: 이미지 빌드 시점(`docker build --build-arg`)에만 유효한 임시 변수입니다.
  - `ENV`: 빌드된 이미지 및 런타임 컨테이너 실행 환경 전반에 유지되는 영구 환경변수입니다.
- **`USER`**: 기본 `root` 계정 대신 보안을 위해 권한이 제한된 일반 사용자 계정으로 프로세스를 실행하도록 전환합니다.
- **`VOLUME`**: 컨테이너가 삭제되어도 보존되어야 하는 데이터 영속성 마운트 포인트를 선언합니다.

---

## 3. 컨테이너 생명주기 관리 및 필수 CLI 명령어

### 3.1. 이미지 빌드 및 실행
- 이미지 빌드:
  ```bash
  docker build -t my-app:1.0.0 .
  ```
- 백그라운드 분리 실행 및 포트 바인딩:
  ```bash
  docker run -d --name my-container -p 8080:8000 -v $(pwd)/logs:/app/logs my-app:1.0.0
  ```
- 실행 중인 컨테이너 내부 쉘 접속:
  ```bash
  docker exec -it my-container bash
  ```

### 3.2. 상태 모니터링 및 정리
- 실행 및 중지된 전체 컨테이너 목록: `docker ps -a`
- 컨테이너 실시간 리소스(CPU/메모리) 점검: `docker stats`
- 실시간 표준 출력 로그 모니터링: `docker logs -f my-container`
- 미사용 컨테이너 및 댕글링 이미지 일괄 정리: `docker system prune -f`

---

## 4. 자주 발생하는 실무 에러와 트러블슈팅

### 4.1. Cannot connect to the Docker daemon 에러
- **원인**: 백그라운드에서 동작해야 하는 도커 시스템 데몬(`dockerd`)이 비활성화되었거나 권한이 없는 경우입니다.
- **해결 방법**:
  ```bash
  # 서비스 상태 확인 및 기동
  sudo systemctl status docker
  sudo systemctl start docker

  # 현재 계정에 docker 그룹 권한 부여
  sudo usermod -aG docker $USER
  ```

### 4.2. Conflict. The container name is already in use
- **원인**: 동일한 이름(`--name`)으로 이미 생성된 컨테이너가 남아있어 충돌하는 현상입니다.
- **해결 방법**:
  기존 컨테이너를 중지하고 삭제하거나, `docker run --rm` 옵션을 부여하여 프로세스 종료 시 자동 파기되도록 설정합니다.
  ```bash
  docker stop my-container && docker rm my-container
  ```

---

## 5. 멀티 컨테이너 오케스트레이션: docker-compose 기초

복수의 마이크로서비스(예: 웹 서버 + DB + Redis 캐시)를 단일 스크립트로 오케스트레이션할 때는 `docker-compose.yml`을 활용합니다.

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
    restart: always

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=mydb
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

위 설정을 작성한 후 `docker compose up -d` 명령어를 입력하면 네트워크 연결과 볼륨 마운트가 자동으로 구성되며 전체 서비스 스택이 백그라운드에서 기동됩니다.
