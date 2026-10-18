---
title: "Flutter 및 Dart 기반 크로스 플랫폼 모바일 앱 개발 환경 구축과 위젯 라이프사이클"
description: "구글 Flutter SDK 설치, StatelessWidget과 StatefulWidget의 생명주기, BuildContext 원리 및 모바일 앱 핫 리로드 개발 팁을 정리합니다."
slug: "flutter-dart-mobile-app-widgets-lifecycle"
date: 2023-01-19T22:01:38+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["MobileApp"]
tags: ["flutter", "dart", "mobile-app", "cross-platform", "ui"]
ShowToc: true
TocOpen: true
---

# 개발환경 및 기본 지식

## 구성 파일들
analysis_options.yaml : flutter rule을 설정하는 파일
assets : 이미지 등 리소스들을 저장하는 경로
lib/main.dart : 메인 App 소스가 구동되는 dart 파일
pubspec.yaml : 리소스 경로 및 API들을 설정할 수 있는 파일 (assets 폴더 설정 가능)  
```
# 경로 설정
flutter:
  assets:
    - assets/
	
# dependency 설정
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  
```
android/app/src/main/AndroidManifext.xml : 안드로이드 앱 개발시 권한 부여를 위한 파일

## 빌드 및 실행
main.dart 파일을 지정하고 실행시켜야 한다.
이때, dart 빌드가 아닌 flutter 빌드를 해준다.

## 문법

## 길이 단위 (LP)
길이 단위는 LP로 사용된다.
100LP는 약 2.4cm

## Widget
xml의 tag와 유사하게 정의된 형태의 class
widget은 대문자로 시작한다.
참조 : (flutter widget library)[https://api.flutter.dev/flutter/material/material-library.html]
1. MaterialApp()
1. Scaffold()
1. Row()
1. Column()
1. Text()
1. Icon
1. Container()
1. SizedBox()
1. Center()

