---
title: "C++ 초고속 로깅 라이브러리 spdlog 소개 및 특징"
date: 2021-08-12 10:41:00+09:00
lastmod: 2021-08-12 10:41:00+09:00
description: "C++ 고성능 비동기 및 동기 로깅 프레임워크인 spdlog의 주요 특징(초고속 처리 속도, 헤더 온리 지원, 외부 무의존성 구조)과 C++ 프로젝트에서의 싱크 설정 활용 방안 및 공식 참조 문헌을 상세히 정리합니다."
slug: "cpp-spdlog-logging-library"
categories:
  - "C++"
tags:
  - "c++"
  - "spdlog"
  - "logging"
  - "header-only"
ShowToc: true
TocOpen: true
draft: false
---

## spdlog 개요

spdlog는 C++11 이상 환경에서 사용할 수 있는 매우 빠르고 가벼운 오픈소스 로깅(Logging) 라이브러리이다. 서버 애플리케이션 및 고성능 임베디드 시스템에서 표준적인 로깅 프레임워크로 널리 채택되고 있다.

## 주요 특징 및 장점

1. **초고속 성능 (Very Fast)**:
   - 비동기 로깅(Asynchronous Logging) 모드를 지원하여 락 프리(lock-free) 큐 기반으로 메인 스레드의 지연을 최소화한다.

2. **헤더 온리(Header-only) 및 컴파일 라이브러리 지원**:
   - 빌드 환경에 따라 헤더 온리 모드로 손쉽게 연동하거나, 빌드 속도 단축을 위해 사전 컴파일된 정적 라이브러리 형태로 링크할 수 있다.

3. **외부 의존성 부재 (No Dependency)**:
   - C++ 표준 라이브러리만을 활용하며 별도의 무거운 외부 종속성이 없다.
   - 우수한 문자열 포맷팅 라이브러리인 `{fmt}`가 내장되어 있어 직관적이고 타입 안전한 서식 지정이 가능하다.

4. **다양한 싱크(Sink) 지원**:
   - 콘솔(표준 출력, ANSI 색상 지원), 기본 파일, 일별 회전 파일(Rotating/Daily File), Syslog 등 다양한 출력 대상을 손쉽게 설정할 수 있다.

## 참고 자료
- 공식 GitHub 저장소: https://github.com/gabime/spdlog
- ISO C++ 블로그 spdlog 소개: https://isocpp.org/blog/2014/11/spdlog
