---
title: "Git 'already exists in the index' 오류 원인과 캐시(Cache) 안전하게 삭제하기"
description: ".gitignore 설정 후에도 파일 추적이 계속되거나 already exists in the index 에러가 발생할 때, 로컬 파일 삭제 없이 Git 스테이징 캐시만 초기화하는 방법을 정리합니다."
slug: "git-already-exists-in-index-remove-cache"
date: 2022-07-09T10:58:55+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DevOps"]
tags: ["git", "troubleshooting", "ci-cd"]
series: ["Git 실전 트러블슈팅"]
ShowToc: true
TocOpen: true
---

클라우드 배포 파이프라인이나 팀 프로젝트를 구성하다 보면, 환경 변수 파일(`.env`)이나 빌드 산출물이 실수로 Git에 먼저 올라간 뒤 뒤늦게 `.gitignore`를 수정하는 경우가 빈번합니다. 이때 파일을 다시 스테이징하거나 커밋하려고 하면 `'PATH' already exists in the index`라는 오류 메시지가 발생하며 커밋이 중단됩니다.

이 글에서는 왜 `.gitignore`에 등록했음에도 해당 에러가 발생하는지 Git 내부 인덱싱 원리를 살펴보고, **로컬 디스크의 실제 파일은 그대로 보존하면서 Git이 추적 중인 인덱스 캐시만 안전하게 제거하는 방법**을 단계별로 알아보겠습니다.

---

## 1. 오류 발생 원인: Git Index(Staging Area)의 동작 원리

Git은 작업 디렉터리(Working Directory)의 변경점을 저장소(Repository)에 바로 커밋하지 않고, 중간 완충 영역인 **Index(Staging Area)**에 파일의 메타데이터와 SHA 해시 스냅샷을 기록합니다.

`.gitignore` 파일에 명시된 규칙은 **아직 Git 인덱스에 한 번도 등록되지 않은 Untracked 파일에 대해서만 적용**됩니다. 즉, 이미 한 번이라도 `git add`를 통해 인덱스에 등록되었거나 이전 커밋에 포함된 파일은 `.gitignore`에 추가하더라도 Git이 지속적으로 추적 상태를 유지합니다. 이 상태에서 파일 경로 충돌이나 재추적 요청이 발생하면 Git은 이미 인덱스에 해당 경로가 존재한다는 경고(`already exists in the index`)를 출력하며 작업을 거부합니다.

따라서 문제를 해결하려면 로컬에 존재하는 실제 파일은 건드리지 않고, Git의 인덱스 트리 캐시에서만 해당 파일의 추적 플래그를 제거해야 합니다.

{{< ad-inarticle >}}

---

## 2. 단계별 해결 방법: 로컬 파일 유지하며 Git 캐시만 삭제하기

### 2.1. 인덱스 추적 상태 확인
먼저 문제의 파일이 실제로 Git 스테이지 인덱스에 등록되어 추적 중인지 확인합니다. 터미널에서 아래 명령어를 실행합니다.

```bash
git ls-files --stage <FILE_PATH>
```

위 명령어를 실행했을 때 파일의 권한 모드(예: 100644), 해시값, 스테이지 번호(0)와 함께 파일 경로가 출력된다면 현재 Git이 해당 파일을 인덱스 캐시에서 정상 추적하고 있는 상태입니다.

### 2.2. 로컬 파일 보존하며 인덱스 캐시 제거
로컬 디스크의 원본 소스코드는 보존하고 Git 인덱스에서만 추적을 중단하기 위해 `--cached` 옵션을 사용해 삭제를 수행합니다.

- **단일 파일 캐시 삭제**:
  ```bash
  git rm --cached <FILE_PATH>
  ```
- **디렉터리 전체 캐시 재귀 삭제**:
  ```bash
  git rm -r --cached <DIRECTORY_PATH>
  ```
- **프로젝트 전체 캐시 일괄 초기화 (.gitignore 전면 재적용)**:
  ```bash
  git rm -r --cached .
  git add .
  ```

`git rm --cached` 명령어는 작업 디렉터리의 실제 물리적 파일은 절대 삭제하지 않으며, Git의 Staging Area에 기록된 파일 엔트리만 제거합니다.

### 2.3. 변경사항 커밋 및 확인
캐시를 성공적으로 제거했다면 `git status` 명령을 통해 파일이 `deleted from index` 상태이면서 동시에 `Untracked files`로 분리되었는지 확인합니다. 이후 해당 변경사항을 커밋합니다.

```bash
git commit -m "fix(git): remove cached files from index to apply gitignore"
```

---

## 3. 검증 및 CI/CD 실무 배포 시 주의사항

1. **원격 저장소 반영 후 팀원 동기화**:
   캐시 삭제 커밋을 원격 저장소(`main`/`master`)에 푸시하면, 다른 팀원이 `git pull`을 수행할 때 로컬 파일이 삭제되는 경우가 발생할 수 있습니다. 민감한 설정 파일(`.env`, `config.json` 등)은 반드시 별도의 백업을 안내하고 공유 저장소의 Secrets Manager(AWS Secrets Manager, GitHub Secrets)로 이관해야 합니다.
2. **CI/CD 캐시 무효화**:
   GitHub Actions나 Docker 빌드 파이프라인에서 이전 빌드 러너 캐시(Runner Cache)가 남아있는 경우, 인덱스 캐시를 삭제했음에도 이전 레이어가 참조될 수 있습니다. `actions/cache`의 캐시 키 버전을 올리거나 도커 빌드 시 `--no-cache` 옵션을 적용해 무결성을 점검하십시오.

---

## 4. 연관 가이드 (Series)
- [Git 서브모듈(Submodule) 추가부터 재귀 클론 및 동기화 충돌 해결 가이드](../git_submodule/)
- [Git core.autocrlf 설정과 윈도우·리눅스 개행 문자(CRLF/LF) 충돌 해결법](../git_crlf_config/)