---
title: "Flutter 기반 텍스트 단어 슬라이더 'FlickThrough' 개발 및 배포기"
date: 2024-01-30T21:12:32+09:00
lastmod: 2024-01-30T21:12:32+09:00
description: "Flutter로 개발한 단어 단위 슬라이드 쇼 앱 'FlickThrough'의 요구사항 분석, 크로스 플랫폼 파일 처리, 다국어 지원, GitHub Pages 및 Android Play Store 배포 전 과정을 다룹니다."
slug: "flutter-flick-through-speed-reader-app"
categories: ["Projects"]
tags: ["flutter", "dart", "cross-platform", "github-pages", "play-store", "portfolio"]
series: ["프로젝트 개발기"]
ShowToc: true
TocOpen: true
draft: false
---

# Flick Through: Flutter 텍스트 슬라이더 앱 개발 문서

- GitHub 저장소: https://github.com/AswinBlue/FlickThrough  
- 서비스 링크: aswinblue.github.io/FlickThrough/  
- 시작 날짜: 2023년 8월 21일  

## 목표

텍스트 파일을 읽어 단어 단위로 슬라이드 쇼를 수행하는 앱 제작

## 요구사항

1. 텍스트 파일의 공백과 줄바꿈을 기준으로 단어를 나누고 이를 화면에 출력
2. 출력은 한 단어씩 이루어 지며 분당 300개를 기본으로, 속도는 조절 가능
3. 단어 자르는건 커스텀 가능
4. 특정 문자마다 딜레이 다르게 줄 수 있도록 설정
5. 스크린샷 혹은 클립보드의 내용도 사용할 수 있도록 함

## 기능 구현

### 1. UI 및 핵심 기능 구현

1. UI 구성

텍스트가 출력될 텍스트박스, 진행률 표시바, 시작/일시정지 버튼, 속도 조절 스크롤바, 파일 읽기 버튼을 구성

![Untitled](/IMAGE_FLICKTHROUGH_APP/Untitled.png)

1. 파일 로드 기능
    1. 파일 로드 버튼을 클릭해서 읽을 텍스트 파일 로드
    2. 파일을 단어 단위로 나누어 List 형태로 저장
2. 재생 기능
    1. 재생 버튼을 눌러 재생/일시정지 상태 변경
    2. List형태로 저장된 단어들을 일정 시간 delay를 두고 화면에 순서대로 출력
    
    ![Untitled](/IMAGE_FLICKTHROUGH_APP/Untitled%201.png)
    
3. 진행률 조절
    1. 진행률 표시바를 클릭 혹은 드래그 하여 진행 위치를 조절
4. 재생 속도 조절
    1. 재생 속도 설정 스크롤 바를 드래그 혹은 클릭하여 단어가 표시될 시간을 조절
5. 클립보드 사용
    1. 클립 보드를 사용할 수 있도록 Text Box 추가, dialog안의 text box에 내용을 채워넣으면 해당 내용으로 flick through 실행
        
        ![Paste from clip board 버튼을 추가](/IMAGE_FLICKTHROUGH_APP/Untitled%202.png)
        
        Paste from clip board 버튼 추가
        
    ![버튼을 누르면 dialog 창이 발생하고, 여기서 confirm 을 누르면 해당 텍스트로 슬라이드 플레이 가능](/IMAGE_FLICKTHROUGH_APP/Untitled%203.png)
    
    버튼 클릭 시 Dialog가 발생하며 Confirm 시 해당 텍스트로 슬라이드 재생
    
6. 다국어 지원 (i18n / l10n)
    1. intl, flutter_localizations 모듈을 사용하기 위해 pubspec.yaml 파일에 필요한 모듈 및 속성들을 추가한다. 
        
        ```yaml
        dependencies:
          flutter:
            sdk: flutter
          intl: ^0.18.0
        flutter_localizations:
          sdk: flutter
        
        dev_dependencies:
          build_runner: ^2.4.6
          intl_translation: ^0.18.2
        
        flutter:
          generate: true # 자동생성 활성화
        ```
        
    2. StatelessWidget 에 flutter_localization 모듈 설정을 해주고, 필요한 모듈을 import 한다.
        
        ```dart
        import 'package:flutter_localizations/flutter_localizations.dart';
        import 'package:intl/intl.dart';
        import 'package:flutter_gen/gen_l10n/app_localizations.dart';
        
        void main() {
          runApp(MyApp());
        }
        
        class MyApp extends StatelessWidget {
          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              title: 'Multi-Language App',
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: MyHomePage(),
            );
          }
        }
        ```
        
    3. l10n.yaml 파일을 프로젝트 루트에 아래와 같이 작성한다. 
        - arb-dir: arb 파일이 들어있는 경로
        - template-arb-file: 기본 템플릿 언어 파일
        - output-localization-file: 생성할 dart 파일 명
        
        ```yaml
        arb-dir: lib/l10n
        template-arb-file: app_en.arb
        output-localization-file: app_localizations.dart
        ```
        
    4. arb 파일을 `lib/l10n` 경로에 생성하여 JSON 형식으로 다국어 단어를 정의한다.
        
        ```json
        {
          "@@locale": "en",
          "pasteFromClipBoard": "Paste from clip board",
          "textFileReader": "Text File Reader"
        }
        ```
        
    5. main.dart에서 다국어를 지원할 text 를 치환한다.
        
        ```dart
        AppLocalizations.of(context)!.pasteFromClipBoard
        ```
        
    6. `flutter pub get` 명령을 실행하여 의존성을 갱신하면 `app_localizations.dart` 파일이 자동 생성된다.

### 2. 크로스 플랫폼 및 권한 이슈 해결

1. 로직 딜레이로 인한 UI 블로킹 이슈
   - `await`를 사용하여 UI와 병렬로 동작하도록 비동기 루프로 개선
   ![Untitled](/IMAGE_FLICKTHROUGH_APP/Untitled%204.png)

2. `LinearProgressIndicator` 터치 미지원 이슈
   - `GestureDetector`로 감싸 직접 제스처 이벤트를 캡처하도록 구현
   ![Untitled](/IMAGE_FLICKTHROUGH_APP/Untitled%205.png)

3. 드래그 오버플로우 문제
   - 화면 밖으로 드래그 시 진행률이 0% 미만 혹은 100%를 초과하는 문제를 방지하기 위해 로직상 클램핑(Border) 처리 적용

4. Web과 Android 간 파일 로딩 방식 차이
   - 웹과 네이티브 런타임을 감지하여 분기 처리 구현
   ![Untitled](/IMAGE_FLICKTHROUGH_APP/Untitled%206.png)
   ![loadTextFile 함수](/IMAGE_FLICKTHROUGH_APP/Untitled%207.png)

5. 모바일 환경에서 `dart:html` import 불가 문제
   - 조건부 임포트(Conditional Import)와 팩토리 패턴을 적용하여 플랫폼별 코드 분리
   - `import 'app.dart' if (dart.library.html) 'web.dart';`
   - 공통 인터페이스 추상 클래스(`AbstractFileLoader`) 정의 후 플랫폼별 구체 클래스 구현
   ![조건부 import](/IMAGE_FLICKTHROUGH_APP/Untitled%209.png)
   ![상속 구현](/IMAGE_FLICKTHROUGH_APP/Untitled%2010.png)
   ![factory 패턴](/IMAGE_FLICKTHROUGH_APP/Untitled%2011.png)

6. Android 외부 저장소 접근 권한 (`READ_EXTERNAL_STORAGE`)
   - `AndroidManifest.xml`에 권한 선언: `<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />`
   - `permission_handler` 모듈을 도입하여 런타임 권한 요청 처리
   ![권한 확인](/IMAGE_FLICKTHROUGH_APP/Untitled%2021.png)
   ![권한 결과 처리](/IMAGE_FLICKTHROUGH_APP/Untitled%2022.png)

7. 다국어 지원 시 `AppLocalizations.of(context)` Null 에러
   - 기본 언어 폴백(default language) 및 `localeListResolutionCallback`을 추가하여 안전한 언어 감지 지원
   ```dart
   localeListResolutionCallback: (locales, supportedLocales) {
     for (Locale locale in locales!) {
       if (supportedLocales.contains(locale)) {
         return locale;
       }
     }
     return Locale('en');
   },
   ```

### 3. 참고 자료 (References)

- intl 패키지 및 ARB 파일 변환 명령
  ```bash
  flutter pub run intl_translation:generate_from_arb \
    --output-dir=lib/localizations \
    lib/localizations/app_localizations.dart \
    lib/localizations/app_localizations_en.arb
  ```
- [Flutter 공식 다국어 가이드](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [Conditional Import 가이드](https://dart.dev/guides/libraries/create-packages#conditionally-importing-and-exporting-library-files)

## 배포 (Deployment)

### 1. 배포 파이프라인 및 패키징

- **GitHub Pages 배포**:
  `.github/workflows/web.yml`을 구성하여 `master` 브랜치 푸시 시 자동 배포 구성:
  ```yaml
  name: github-page-work
  on:
    push:
      branches: [master]
  permissions:
    contents: read
    pages: write
    id-token: write
  jobs:
    build:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
          with:
            token: ${{ secrets.GIT_TOKEN }}
        - uses: subosito/flutter-action@v1
        - uses: bluefireteam/flutter-gh-pages@v7
          with:
            baseHref: /FlickThrough/
  ```
  GitHub Secret에 `GIT_TOKEN` 등록 후 Actions 정상 빌드 시 `gh-pages` 브랜치 호스팅 연결.

- **앱 아이콘 변경**:
  AppIcon 변환기를 사용하여 Android(`android/app/src/main/res`) 및 iOS(`ios/Runner/Assets.xcassets/AppIcon.appiconset`) 리소스 교체.

- **Android 앱 배포 (Keystore 및 AAB)**:
  1. JDK keytool을 사용한 서명 키 생성:
     `keytool -genkey -v -keystore C:/Users/USER_NAME/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`
  2. `android/app/key.properties` 파일 생성 및 서명 정보 기입
  3. `app/build.gradle`에 `signingConfigs.release` 등록
  4. `flutter build appbundle` 명령으로 release용 AAB 파일 생성 (`build/app/outputs/bundle/release/app-release.aab`)
  5. Google Play Console에 번들 업로드 및 출시 관리

### 2. 배포 문제와 해결

- `fatal: unable to access ... 403` 에러:
  - GitHub 원격 저장소 URL을 인증 정보가 포함된 형태로 재설정:
    `git remote set-url origin https://AswinBlue@github.com/AswinBlue/FlickThrough.git`
  - GitHub Actions checkout 스텝에서 명시적으로 `token: ${{ secrets.GIT_TOKEN }}`을 주입하여 권한 문제 해결