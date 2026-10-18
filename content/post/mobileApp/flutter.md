---
title: "Flutter 및 Dart 기반 크로스 플랫폼 모바일 앱 개발 환경 구축과 위젯 라이프사이클"
description: "구글의 크로스 플랫폼 프레임워크인 Flutter의 프로젝트 아키텍처(pubspec.yaml), StatelessWidget과 StatefulWidget의 생명주기, 레이아웃 위젯(Scaffold, Row, Column) 및 단위 체계를 총정리합니다."
slug: "flutter-dart-mobile-app-widgets-lifecycle"
date: 2023-01-19T22:01:38+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["MobileApp"]
tags: ["flutter", "dart", "mobile-app", "cross-platform", "ui"]
ShowToc: true
TocOpen: true
---

Google에서 개발한 Flutter는 단일 Dart 코드베이스로 Android, iOS, Web, Windows, macOS, Linux 애플리케이션을 빌드할 수 있는 오픈소스 크로스 플랫폼 UI 프레임워크입니다. 네이티브 OEM 위젯을 브리지 방식으로 호출하는 대신 Skia/Impeller 렌더링 엔진을 통해 픽셀을 화면에 직접 그리기 때문에 플랫폼 간 일관된 UI와 60~120fps의 부드러운 애니메이션 성능을 보장합니다.

이 글에서는 Flutter 프로젝트의 핵심 디렉터리 구조, 패키지 및 에셋 관리(`pubspec.yaml`), 상태 기반 위젯의 생명주기, 그리고 화면을 구성하는 기본 레이아웃 위젯을 체계적으로 정리합니다.

---

## 1. Flutter 프레임워크 개요 및 프로젝트 디렉터리 구조

Flutter 프로젝트를 생성하면 플랫폼별 네이티브 폴더와 공통 Dart 소스코드 폴더가 분리되어 생성됩니다.

### 1.1. 주요 구성 파일 및 역할
- **`lib/main.dart`**: 애플리케이션이 시작되는 진입점(Entry point)으로, `main()` 함수와 최상위 `runApp()`이 실행됩니다.
- **`pubspec.yaml`**: 외부 패키지 의존성(Dependencies), 폰트, 이미지 에셋(Assets) 경로를 정의하는 핵심 프로젝트 설정 파일입니다.
- **`analysis_options.yaml`**: 정적 코드 분석 린트(Lint) 규칙을 설정합니다.
- **`assets/`**: 이미지, 아이콘, 로컬 JSON 데이터 등 앱 번들에 포함될 정적 리소스를 저장하는 폴더입니다.
- **`android/app/src/main/AndroidManifest.xml`**: 안드로이드 권한(인터넷, 카메라 등) 및 패키지명을 설정하는 매니페스트 파일입니다.
- **`ios/Runner/Info.plist`**: iOS 앱 권한 및 메타데이터를 관리하는 프로퍼티 리스트 파일입니다.

### 1.2. 에셋 및 의존성 등록 (`pubspec.yaml`)
이미지나 외부 패키지를 사용할 때는 `pubspec.yaml`에 들여쓰기를 엄격히 맞춰 선언해야 합니다.

```yaml
name: my_flutter_app
description: Flutter 크로스 플랫폼 애플리케이션
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  http: ^1.2.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

---

## 2. 핫 리로드(Hot Reload)와 빌드 실행

Flutter의 가장 강력한 생산성 도구는 코드 변경 시 앱을 재시작하지 않고 밀리초 단위로 화면에 반영하는 **핫 리로드(Stateful Hot Reload)**입니다.

- **실행 명령어**: `flutter run`
- **핫 리로드 (Hot Reload - 키보드 `r`)**: 앱의 상태(State)를 보존한 채 변경된 UI 위젯 트리만 즉시 다시 그립니다.
- **핫 리스타트 (Hot Restart - 키보드 `R`)**: 앱의 전체 상태를 초기화하고 처음부터 다시 빌드합니다.

---

## 3. Flutter 위젯 아키텍처와 생명주기 (Lifecycle)

Flutter의 모든 화면 구성 요소는 **위젯(Widget)**으로 선언되며, 크게 상태가 없는 위젯과 상태를 유지하는 위젯으로 나뉩니다.

### 3.1. StatelessWidget (정적 위젯)
한 번 생성되면 내부 데이터나 UI가 동적으로 변하지 않는 정적 화면 요소입니다.

```dart
import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  final String userName;

  const GreetingWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Text(
      '안녕하세요, $userName님!',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
```

### 3.2. StatefulWidget과 State 생명주기
사용자 인터랙션에 따라 동적으로 상태가 변경되는 위젯으로, `State` 객체를 통해 생명주기가 관리됩니다.

- **`initState()`**: 위젯이 트리에 처음 삽입될 때 단 한 번 호출되며, 변수 초기화나 리스너 등록을 수행합니다.
- **`build(BuildContext context)`**: 화면 UI를 렌더링하는 함수로, `setState()`가 호출될 때마다 다시 실행됩니다.
- **`dispose()`**: 위젯이 트리에서 영구 제거될 때 호출되며, 컨트롤러나 애니메이션 리소스를 해제(Clean-up)합니다.

```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++; // 상태 변경을 알리고 UI 리렌더링 트리거
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('카운트: $_counter'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _increment,
        ),
      ],
    );
  }
}
```

---

## 4. 핵심 레이아웃 위젯과 단위 체계

Flutter에서는 디바이스 독립적 픽셀 단위인 **논리적 픽셀(LP, Logical Pixels)**을 사용합니다. 160dpi 화면에서의 1px에 해당하며, 다양한 크기와 해상도의 단말기에서 일관된 비율을 보장합니다.

### 4.1. 앱 구조 및 스캐폴드 위젯
- **`MaterialApp`**: 머티리얼 디자인 스타일과 테마, 라우팅을 총괄하는 최상위 래퍼 위젯입니다.
- **`Scaffold`**: AppBar, Body, FloatingActionButton, Drawer 등 표준 모바일 앱의 뼈대 레이아웃을 제공합니다.

### 4.2. 공간 및 배치 위젯
- **`Row` / `Column`**: 자식 위젯들을 가로 또는 세로 방향으로 나열합니다. `mainAxisAlignment`(주축 정렬)와 `crossAxisAlignment`(교차축 정렬) 속성을 사용합니다.
- **`Container`**: 패딩, 마진, 테두리, 배경색, 크기(`width`, `height`)를 한 번에 설정할 수 있는 다목적 박스 위젯입니다.
- **`SizedBox`**: 고정된 너비나 높이를 부여하거나 위젯 간 빈 여백(공간)을 줄 때 경량으로 사용합니다.
- **`Center`**: 자식 위젯을 부모 컨테이너의 정중앙에 정렬합니다.
- **`Text` / `Icon`**: 텍스트 서식 및 벡터 아이콘을 화면에 출력합니다.

더 자세한 위젯 카탈로그는 [Flutter 공식 위젯 라이브러리](https://api.flutter.dev/flutter/material/material-library.html)에서 확인할 수 있습니다.
