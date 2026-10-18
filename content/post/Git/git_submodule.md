---
title: "Git 서브모듈(Submodule) 추가부터 재귀 클론 및 동기화 충돌 해결 가이드"
description: "Git 저장소 내에 다른 저장소를 종속성으로 관리하는 Submodule의 생성(add), 클론(recurse-submodules), 원격 동기화(sync/update) 및 부모-자식 커밋 충돌 해결법을 정리합니다."
slug: "git-submodule-management-and-troubleshooting"
date: 2022-07-09T11:00:00+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DevOps"]
tags: ["git", "submodule", "devops", "troubleshooting"]
series: ["Git 실전 트러블슈팅"]
ShowToc: true
TocOpen: true
---

엔터프라이즈 모노레포를 분리하거나 공통 프레임워크, 테마 라이브러리, 공유 SDK를 여러 프로젝트에서 재사용할 때 Git의 **Submodule(서브모듈)** 기능은 매우 효과적인 의존성 관리 도구입니다. 하지만 서브모듈의 동작 메커니즘을 정확히 이해하지 못하면 클론 시 빈 디렉터리만 남거나, 원격 커밋 불일치로 인해 빌드가 실패하는 문제가 자주 발생합니다.

이 글에서는 Git 서브모듈의 기본 개념과 등록 절차, 팀 프로젝트 클론 방법, 그리고 실무에서 자주 겪는 커밋 및 캐시 충돌 해결법을 상세히 정리합니다.

---

## 1. Git Submodule의 구조와 동작 원리

Git Submodule은 **하나의 메인 Git 저장소(Parent) 내부에 다른 독립된 Git 저장소(Child)를 특정 디렉터리로 마운트하여 관리하는 기술**입니다.

일반적인 디렉터리와 달리 부모 저장소는 서브모듈 내부의 개별 파일 변경 이력을 직접 추적하지 않습니다. 대신 부모 저장소는 오직 **서브모듈이 위치한 커밋 해시(Commit SHA-1) 포인터**만을 메타데이터(`mode 160000`)로 기록합니다.
- `.gitmodules`: 서브모듈의 로컬 매핑 경로와 원격 Git URL, 추적 브랜치 정보를 담는 설정 파일입니다.
- `.git/modules/`: 부모 저장소의 `.git` 내부에 서브모듈의 실제 Git 오브젝트 데이터베이스가 안전하게 격리 보관되는 공간입니다.

{{< ad-inarticle >}}

---

## 2. 서브모듈 생성 및 관리 절차

### 2.1. 서브모듈 추가 및 초기화
부모 저장소의 특정 경로에 외부 저장소를 서브모듈로 추가합니다.

```bash
git submodule add <REPOSITORY_URL> [PATH]
```
추가 후 프로젝트 루트의 `.gitmodules` 파일에 서브모듈 정보가 자동 등록되며, 부모 저장소는 새로운 서브프로젝트 커밋 포인터를 스테이징합니다.

### 2.2. 프로젝트 복제(Clone) 시 서브모듈 함께 가져오기
서브모듈이 포함된 저장소를 일반 `git clone`으로 내려받으면 서브모듈 디렉터리는 껍데기(빈 폴더)만 남게 됩니다. 반드시 아래 방법 중 하나를 선택해야 합니다.

- **처음부터 서브모듈을 재귀적으로 포함하여 복제할 때**:
  ```bash
  git clone --recurse-submodules <REPOSITORY_URL>
  ```
- **이미 일반 복제를 마친 상태에서 서브모듈을 채울 때**:
  ```bash
  git submodule init [PATH]
  git submodule update --recursive
  ```

### 2.3. 서브모듈 원격 변경점 동기화
원격 저장소에서 서브모듈의 최신 커밋을 받아와 부모 저장소의 참조 포인터를 갱신합니다.

```bash
git submodule sync
git submodule update --remote --merge
```
모든 서브모듈에 대해 일괄적으로 Git 명령을 실행할 때는 `git submodule foreach`를 활용할 수 있습니다.
```bash
git submodule foreach git pull origin main
```

---

## 3. 실무 트러블슈팅 및 커밋/배포 순서 원칙

### 3.1. Parent와 Child의 커밋/푸시 순서 원칙
서브모듈 작업 시 가장 빈번한 오류는 부모 저장소만 푸시하고 서브모듈은 푸시하지 않는 경우입니다.
1. **Push 순서 (Child -> Parent)**:
   반드시 **서브모듈 내부에서 먼저 commit 및 push를 완료**한 후, 부모 저장소에서 변경된 서브모듈 커밋 포인터를 add하여 push해야 합니다. 부모를 먼저 푸시하면 다른 팀원이나 CI 러너가 참조할 수 없는 커밋 해시를 요구받아 `fatal: reference is not a tree` 오류가 발생합니다.
2. **Pull 순서 (Parent -> Child)**:
   원격 저장소에서 내려받을 때는 부모 저장소를 먼저 pull한 다음 `git submodule update`를 수행하여 서브모듈을 최신 커밋으로 동기화합니다.

### 3.2. 서브모듈 완전 삭제(Deinit) 및 잔재 정리
서브모듈 연결을 해제할 때 단순 폴더 삭제로는 `.git/modules`에 캐시가 남아 추후 재등록 시 충돌을 일으킵니다.
```bash
# 1. 서브모듈 설정 등록 해제
git submodule deinit -f <MODULE_PATH>

# 2. Git 작업 트리 및 .gitmodules에서 서브모듈 제거
git rm -f <MODULE_PATH>

# 3. .git 내부 캐시 디렉터리 수동 삭제
rm -rf .git/modules/<MODULE_PATH>
```

---

## 4. 연관 가이드 (Series)
- [Git 'already exists in the index' 오류 원인과 캐시(Cache) 안전하게 삭제하기](../git/)
- [Git core.autocrlf 설정과 윈도우·리눅스 개행 문자(CRLF/LF) 충돌 해결법](../git_crlf_config/)
