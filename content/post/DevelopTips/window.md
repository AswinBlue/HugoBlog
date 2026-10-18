---
title: "Windows 개발자 꿀팁 모음: WSL2 설치, 환경변수 즉시 반영, 배치 call, SCP 전송"
date: 2022-03-19T08:29:51+09:00
lastmod: 2022-03-19T08:29:51+09:00
description: "Windows 개발 환경에서 유용한 필수 팁 모음입니다. WSL2 설치 및 파일 공유, 재부팅 없는 환경변수 즉시 갱신, 배치 스크립트 call 명령어, 원격 Linux와의 SCP 파일 전송 방법을 다룹니다."
slug: "windows-dev-tips-wsl2-env-batch-scp"
categories: ["DevelopTips"]
tags: ["windows", "wsl2", "batch-script", "scp", "development-tips", "environment-variables"]
ShowToc: true
TocOpen: true
draft: false
---

# Windows 개발 환경 유용한 팁 모음

Windows 환경에서 개발을 진행할 때 작업 효율을 높여주는 필수 명령어와 시스템 팁을 정리합니다.

## 1. WSL2 설치 및 Windows-Linux 파일 공유
Windows 10/11 환경에서 가상 머신 없이 리눅스 커널을 구동하는 WSL2(Windows Subsystem for Linux 2) 설정법입니다:
1. PowerShell을 관리자 권한으로 실행한 후 아래 명령어를 입력하여 기능을 활성화합니다:
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   wsl --set-default-version 2
   ```
2. Microsoft Store에서 원하는 Linux 배포판(예: Ubuntu 22.04 LTS)을 설치합니다.
3. WSL 콘솔 내부에서 `explorer.exe .` 명령을 실행하면 현재 리눅스 파일 시스템 경로가 Windows 파일 탐색기 창으로 즉시 열려 간편하게 파일을 이동하거나 복사할 수 있습니다.

## 2. 재부팅 없이 환경 변수 즉시 적용하기
시스템 환경 변수(`Path` 등)를 새로 추가한 후 시스템 재부팅 없이 Windows 탐색기와 프로세스에 즉시 반영하는 방법입니다:
1. 명령 프롬프트(CMD) 또는 PowerShell에서 아래 명령어를 순서대로 실행합니다:
   ```cmd
   taskkill /f /im explorer.exe
   explorer.exe
   ```
2. 작업 표시줄이 일시적으로 사라졌다가 다시 실행되면서 새로 설정된 환경 변수가 시스템 전반에 즉시 로드됩니다. (열려 있던 탐색기 창은 닫히므로 작업 중인 폴더 확인 필요)

## 3. 배치 파일(.bat) 다중 패키지 명령 실행 (call)
배치 스크립트에서 `npm`, `gradle` 등 별도의 배치/패키지 명령을 실행할 때 단순 명령 줄만 나열하면 첫 번째 명령 실행 후 스크립트가 그대로 종료되는 문제가 발생합니다:
- 이를 방지하고 순차적으로 모든 명령을 실행하려면 각 명령어 앞에 `call` 키워드를 반드시 붙여주어야 합니다:
  ```bat
  @echo off
  call npm run build
  cd server
  call gradlew.bat build
  echo 모든 빌드가 성공적으로 완료되었습니다.
  ```

## 4. SCP 명령어를 통한 원격 Linux 파일 전송
OpenSSH가 기본 탑재된 Windows 10/11에서는 추가 프로그램 없이 `scp` 명령으로 원격 리눅스 서버와 파일을 주고받을 수 있습니다:
- 원격 리눅스 서버에서 로컬 Windows로 파일 가져오기:
  ```cmd
  scp user@192.168.0.10:/home/user/target_file.tar.gz C:\Downloads\
  ```
- 로컬 Windows에서 원격 리눅스 서버로 파일 보내기:
  ```cmd
  scp C:\Project\app.zip user@192.168.0.10:/var/www/html/
  ```
- 절대 경로를 사용하는 것이 경로 혼선을 방지하는 가장 안전한 방법입니다.