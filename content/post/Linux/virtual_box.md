---
title: "VirtualBox 리눅스 가상머신 설치 및 게스트 확장(Guest Additions) 설정 가이드"
description: "VirtualBox를 활용한 Ubuntu 가상머신 생성, 포트포워딩 네트워크 세팅, 클립보드 공유 및 해상도 자동 조절을 위한 게스트 확장 설치법을 설명합니다."
slug: "virtualbox-linux-vm-install-and-guest-additions"
date: 2023-07-02T20:03:24+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["virtualbox", "linux", "virtualization", "vm", "ubuntu"]
ShowToc: true
TocOpen: true
---

# VirtualBox

## 문제와 해결

### root 계정
- virtual box를 생성하면 기본 user의 이름은 vboxuser로 세팅되어 있다. 하지만 vboxuser는 sudo 권한이 없어 다른 설정을 수행 할 수가 없다.
- virtual box에서 root 계정 비밀번호를 변경하는 방법은 다음과 같다. 
1. virtualbox에서 원하는 ubuntu machine를 실행시킨다.
2. machine이 실행되는 도중 shift키를 클릭하고 있는다.
3. 부팅 모드 선택 화면이 뜨면 `Advanced options for Ubuntu` 를 선택하고, `(recovery mode)`표시가 되어있는 항목으로 부팅을 시도한다.
4. 로딩이 완료되면 `root` 라는 항목을 선택하여 root 계정의 비밀번호를 재설정 할 수 있다. 

