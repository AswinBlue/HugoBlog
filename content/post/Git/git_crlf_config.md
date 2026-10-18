---
title: "Git core.autocrlf 설정과 윈도우·리눅스 개행 문자(CRLF/LF) 충돌 해결법"
description: "Windows와 Linux 간 협업 시 발생하는 CRLF/LF 개행 문자 불일치 오류와 SHA-256 해시 불일치 문제를 core.autocrlf 및 캐시 초기화로 해결하는 방법을 설명합니다."
slug: "git-core-autocrlf-newline-troubleshooting"
date: 2022-07-09T11:05:00+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DevOps"]
tags: ["git", "crlf", "troubleshooting", "cross-platform"]
series: ["Git 실전 트러블슈팅"]
ShowToc: true
TocOpen: true
---

Windows와 Linux/macOS 환경의 개발자들이 단일 Git 저장소에서 협업할 때 가장 빈번하게 발생하는 골칫거리 중 하나가 바로 **개행 문자(End of Line, EOL) 불일치 문제**입니다. 소스코드 내용을 단 한 줄도 변경하지 않았음에도 모든 라인이 수정된 것으로 감지되거나, 암호화 해시(SHA-256) 검증 스크립트가 리눅스 CI 빌드에서만 실패하는 현상이 대표적인 예입니다.

이 글에서는 OS별 개행 문자 차이와 Git의 자동 변환 옵션(`core.autocrlf`), 그리고 이미 저장소에 잘못 커밋된 개행 문자를 깨끗하게 일괄 복구하는 실무 절차를 정리합니다.

---

## 1. 개행 문자 차이: CRLF vs LF

운영체제마다 텍스트 파일의 줄바꿈을 표현하는 방식이 다릅니다.
- **Windows**: `CRLF` (Carriage Return `\r` + Line Feed `\n`, 0x0D 0x0A)
- **Linux 및 macOS**: `LF` (Line Feed `\n`, 0x0A)

이 차이로 인해 윈도우에서 정상 동작하던 파이썬 스크립트나 쉘 스크립트가 리눅스 서버 배포 후 `\r: command not found` 에러를 뿜으며 실행이 거부되거나, 바이너리 해시 검증 시 개행 문자 1바이트 차이로 인해 무결성 검사가 실패하게 됩니다.

{{< ad-inarticle >}}

---

## 2. Git의 자동 변환 제어: core.autocrlf 설정

Git은 플랫폼 간 개행 문자 문제를 완화하기 위해 저장소에 커밋할 때와 체크아웃할 때 자동으로 개행을 치환해주는 `core.autocrlf` 설정을 지원합니다.

### 2.1. 환경별 권장 설정값
- **Windows 개발 환경 (권장: `true`)**:
  저장소로 커밋할 때는 CRLF를 LF로 변환하고, 로컬 디스크로 체크아웃할 때는 LF를 CRLF로 변환합니다.
  ```bash
  git config --global core.autocrlf true
  ```
- **Linux 및 macOS 개발 환경 (권장: `input`)**:
  체크아웃 시에는 아무런 변환을 하지 않고 LF를 유지하며, 혹시 모를 윈도우 파일이 유입될 때 커밋 단계에서만 LF로 자동 변환합니다.
  ```bash
  git config --global core.autocrlf input
  ```
- **자동 변환 비활성화 (`false`)**:
  개행 문자 변환을 전면 비활성화하여 원본 바이트 그대로 보존합니다. 바이너리 파일이나 정확한 줄바꿈이 요구되는 특수 프로젝트에서 사용합니다.
  ```bash
  git config --global core.autocrlf false
  ```

### 2.2. Git Config 스코프 우선순위
Git 설정은 적용 범위에 따라 계층을 가집니다.
- `--system`: 운영체제 전역 설정 (`/etc/gitconfig`)
- `--global`: 현재 사용자 계정 설정 (`~/.gitconfig`)
- `--local`: 현재 저장소 전용 설정 (`.git/config`, 기본값)

---

## 3. 이미 오염된 저장소의 개행 문자 일괄 정비 절차

이미 윈도우 환경에서 CRLF로 대량 커밋되어 리눅스 배포 빌드나 해시 검사에서 에러를 유발하는 경우, 아래 절차로 인덱스 캐시를 리셋하여 일괄 정상화할 수 있습니다.

```bash
# 1. 원하는 autocrlf 정책으로 설정 (예: Linux 환경 호환을 위한 input)
git config --global core.autocrlf input

# 2. 로컬 디스크의 실제 파일은 유지한 채 Git 인덱스 캐시만 일괄 제거
git rm --cached -r .

# 3. 새로운 개행 정책을 기반으로 전체 파일을 다시 인덱스에 적재
git add .

# 4. 정규화된 개행 문자로 커밋 생성
git commit -m "chore(git): normalize line endings to LF"
```

위 명령을 실행하면 작업 트리의 모든 텍스트 파일이 Git 저장소 내부에서 일관된 LF 포맷으로 재정렬됩니다.

---

## 4. 연관 가이드 (Series)
- [Git 'already exists in the index' 오류 원인과 캐시(Cache) 안전하게 삭제하기](../git/)
- [Git 서브모듈(Submodule) 추가부터 재귀 클론 및 동기화 충돌 해결 가이드](../git_submodule/)
