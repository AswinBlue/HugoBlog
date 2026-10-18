---
title: "우분투 apt 및 dpkg errorcode(1) 충돌 오류 원인과 복구 해결법"
description: "우분투(Ubuntu) 환경에서 파이썬 바이너리 삭제로 인한 dpkg errorcode(1) 오류 원인을 분석하고, /var/lib/dpkg/info 손상 메타파일 정리 및 dpkg --configure -a 명령을 통한 복구 절차를 안내합니다."
slug: "ubuntu-apt-dpkg-errorcode1-troubleshooting"
date: 2020-05-25T18:30:15+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["linux", "ubuntu", "apt", "dpkg", "troubleshooting"]
ShowToc: true
TocOpen: true
---

# 우분투 apt 및 dpkg 오류 트러블슈팅

## 장애 발생 배경
Linux 서버에 개발 환경을 구성하던 중 패키지 설정이 꼬여 원격으로 외부 지원을 요청하였으나, 작업 과정에서 시스템 파일이 잘못 수정되어 APT 패키지 매니저가 완전히 동작을 멈추는 장애가 발생하였습니다. 본 글에서는 해당 장애의 발생 원인과 복구 절차를 정리합니다.

## 오류 원인 분석
- `/bin` 디렉터리 내의 파이썬 실행 바이너리(`python`)를 강제로 임의 삭제한 것이 주원인으로 분석되었습니다.
- 패키지 의존성이 꼬인 상태에서 `sudo apt-get upgrade` 명령을 무리하게 남용하여 의존성 충돌이 가중되었습니다.
- 우분투의 다수 시스템 패키지 관리 스크립트(`py3compile`, `py3clean`)는 시스템 기본 파이썬 인터프리터에 의존하므로, 파이썬 인터프리터가 부재하면 패키지 설정 단계에서 치명적인 실패가 발생합니다.

## 장애 현상
- `apt install` 또는 `apt remove` 명령을 실행할 때마다 `py3compile`, `py3clean` 단계에서 예외가 발생하였습니다.
- APT 작업 시 다음과 같은 에러가 반복 출력되며 정상적인 패키지 작업이 중단되었습니다.
  ```bash
  /usr/bin/dpkg returned an error code (1)
  ```
- `apt-get install -f` (broken dependency fix) 명령을 시도해도 동일한 에러 코드를 반환하며 복구되지 않았습니다.

## 단계별 복구 및 해결 방법
1. **파이썬 환경 임시 복구**
   - 파이썬 실행 바이너리가 소실되어 관련 에러가 발생했으므로, 소스코드를 직접 빌드하거나 유효한 파이썬 바이너리를 다운로드하여 `/usr/bin/python3` 심볼릭 링크를 임시 복구하였습니다.
2. **손상된 dpkg 패키지 메타데이터 확인**
   - `/var/lib/dpkg/info/` 디렉터리에는 시스템에 설치된 각 패키지의 설치/삭제 스크립트(`*.postinst`, `*.prerm` 등)가 저장되어 있습니다.
   - 오류 로그에 명시된 특정 문제 패키지 목록을 파악한 후, 해당 패키지와 연관된 스크립트 파일을 안전하게 백업 및 삭제하였습니다.
   ```bash
   sudo rm /var/lib/dpkg/info/<문제가_발생한_패키지_이름>.*
   ```
3. **dpkg 상태 재구성**
   - 손상된 스크립트를 제거한 후 다음 명령으로 미완료 상태의 패키지 구성을 재설정하였습니다.
   ```bash
   sudo dpkg --configure -a
   ```
4. **APT 의존성 최종 정리**
   - dpkg 재구성을 반복 수행하여 에러가 더 이상 발생하지 않을 때까지 문제 패키지를 정리한 후 정상적인 패키지 관리가 가능해졌습니다.
   ```bash
   sudo apt-get update && sudo apt-get -f install
   ```

## 교훈 및 요약
- `/bin`, `/usr/bin` 등 운영체제 핵심 실행 파일이 위치한 디렉터리의 파일을 수동으로 임의 삭제하면 패키지 매니저 전체가 손상될 수 있으므로 절대 임의 삭제하지 말아야 합니다.
- 설치된 패키지 메타 정보는 `/var/lib/dpkg/info/` 경로에 저장되며, 개별 패키지 스크립트 결함 시 해당 경로를 점검할 수 있습니다.
- 의존성 충돌 및 패키지 설치 중단 상태는 `dpkg --configure -a` 명령어로 재설정할 수 있습니다.
