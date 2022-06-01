+++
title = "Window"
date = 2022-03-19T08:29:51+09:00
lastmod = 2022-03-19T08:29:51+09:00
tags = []
categories = []
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = false
+++

#MS Window
- MS window 사용시 필요한 편이 기능들을 나열

## WSL2
- 윈도우에서 리눅스를 실행하는 방법이다.
- windows 10 이상부터 지원 가능하며, microsoft store에서 ubuntu를 설치하는 방식이다.
1. PowerShell을 관리자 권한으로 실행하여 아래 명령어 입력
> $ dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart  
> $ dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart  
> $ wsl --set-default-version 2

## 환경변수
  - 환경변수 설정시 컴퓨터를 재부팅하지 않고 적용하는 방법
  - 콘솔에 `taskkill /f /im explorer.exe`, `explorer.exe` 명령을 순서대로 입력한다.
  - 작업표시줄이 없어졌다 생겨나면 적용이 된 것이다. 켜져있던 탐색기는 복원되지 않으니 주의
