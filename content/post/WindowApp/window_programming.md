---
title: "Windows PE 파일 구조 및 Win32 API 기반 윈도우 시스템 프로그래밍 기초"
description: "윈도우 실행 파일의 표준 포맷인 PE(Portable Executable) 구조(DOS Header, NT Header, Section Table)와 Win32 API 핸들 및 윈도우 프로시저를 분석합니다."
slug: "windows-pe-format-and-win32-system-programming"
date: 2024-05-12T16:02:25+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WindowApp"]
tags: ["windows", "win32", "pe-format", "system-programming", "c"]
ShowToc: true
TocOpen: true
---

# Window Programming

## PE
- 윈도우는 실행 가능한 목적 파일을 `PE` 포멧이라 칭한다. (리눅스의 ELF 와 유사)
- `PE` 파일은 header 와 section 으로 구성된다.
- section 에는 이름, 크기, 로드될 주소의 오프셋, 속성과 권한 등의 정보가 들어있다.
- `PE` 파일에 들어가야 할 필수 section 은 없지만, '.text', '.data', '.rdata' section 이 주로 사용된다.
  - `.text`: 실행 가능한 기계코드가 위치하는 영역 (읽기, 쓰기 가능)
  - `.data`: 컴파일 시점에 정해진 전역 변수들이 위치하는 영역 (읽기, 쓰기 가능)
  - `.rdata`: 컴파일 시점에 값이 정해진 전역 상수와 참조할 DLL 및 외부 함수들의 정보가 위치하는 영역 (읽기만 가능)
- 윈도우가 실행되면 `PE` 파일의 데이터들이 메모리에 적재된다.