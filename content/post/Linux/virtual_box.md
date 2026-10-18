---
title: "VirtualBox 우분투 가상머신 root 비밀번호 재설정 및 복구 모드 진입 방법"
description: "VirtualBox에 설치된 우분투(Ubuntu) 가상머신에서 기본 사용자 계정의 sudo 권한 부재 시, GRUB 리커버리 모드로 부팅하여 root 쉘 프롬프트에서 비밀번호를 안전하게 재설정하고 관리자 권한을 복구하는 절차를 정리합니다."
slug: "virtualbox-ubuntu-root-password-reset-recovery"
date: 2023-07-02T20:03:24+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["virtualbox", "ubuntu", "linux", "troubleshooting", "vm"]
ShowToc: true
TocOpen: true
---

# VirtualBox 우분투 root 비밀번호 복구 가이드

## 문제 상황 및 원인
VirtualBox에서 우분투(Ubuntu) 가상머신 이미지를 새로 생성하거나 사전 구성된 VDI 이미지를 불러올 때, 기본 생성된 사용자 계정(예: `vboxuser`)에 `sudo` 관리자 권한이 부여되어 있지 않거나 패스워드가 올바르지 않아 패키지 설치 및 시스템 설정을 진행하지 못하는 문제가 발생할 수 있습니다.
이러한 경우 GRUB 부트로더의 복구 모드(Recovery Mode)를 통해 관리자 권한을 복구할 수 있습니다.

## GRUB 복구 모드를 통한 해결 절차

### 1. GRUB 부팅 메뉴 진입
1. VirtualBox 관리자 창에서 해당 우분투 가상머신을 시작합니다.
2. 가상머신 화면이 켜지는 즉시 키보드의 `Shift` 키(UEFI 시스템인 경우 `ESC` 키)를 연속으로 누르고 있어 GRUB 부트로더 화면을 호출합니다.

### 2. 리커버리 모드 (Recovery Mode) 선택
1. GRUB 메뉴 화면이 나타나면 `Advanced options for Ubuntu` 항목으로 이동하여 `Enter`를 입력합니다.
2. 표시되는 커널 목록 중 끝에 `(recovery mode)`가 명시된 최신 커널 버전을 선택하여 부팅합니다.

### 3. root 쉘 프롬프트 진입 및 비밀번호 변경
1. 복구 메뉴(Recovery Menu) 화면이 나타나면 방향키로 `root (Drop to root shell prompt)` 항목을 선택하고 `Enter`를 누릅니다.
2. 화면 하단에 root 쉘 프롬프트가 열리면, 기본 읽기 전용(Read-Only)으로 마운트된 루트 파일 시스템을 쓰기 가능하도록 다시 마운트합니다.
   ```bash
   mount -o remount,rw /
   ```
3. `passwd` 명령어로 root 관리자 계정의 비밀번호를 새로 설정합니다.
   ```bash
   passwd root
   ```

### 4. 일반 사용자 계정에 sudo 권한 부여
root 계정의 비밀번호 설정과 더불어, 기본 사용자(`vboxuser`)를 `sudo` 관리자 그룹에 추가해 두면 향후 편리하게 관리자 명령을 실행할 수 있습니다.
```bash
# 사용자를 sudo 그룹에 추가
usermod -aG sudo vboxuser

# 시스템 정상 재부팅
reboot -f
```
재부팅 완료 후 새로 변경한 패스워드로 로그인하여 정상적으로 `sudo` 명령어가 동작하는지 확인합니다.
