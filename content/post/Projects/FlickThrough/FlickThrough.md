---
title: "FlickThrough"
date: 2024-01-30T21:12:32+09:00
lastmod: 2024-01-30T21:12:32+09:00
tags: []
categories: []
imgs:  []
cover:  ""  # image show on top
readingTime:  true  # show reading time after article date
toc:  true
comments:  false
justify:  false  # text-align: justify;
single:  false  # display as a single page, hide navigation on bottom, like as about page.
license:  "BY-SA"  # CC License, https://creativecommons.org/licenses/?lang=ko
draft: false
---

# Flick Through

github: https://github.com/AswinBlue/FlickThrough  
Link : aswinblue.github.io/FlickThrough/  
시작날짜: August 21, 2023  

## 목표

텍스트 파일을 읽어 단어 단위로 슬라이드 쇼를 수행하는 앱 제작

## 요구사항

1. 텍스트 파일의 공백과 줄바꿈을 기준으로 단어를 나누고 이를 화면에 출력
2. 출력은 한 단어씩 이루어 지며 분당 300개를 기본으로, 속도는 조절 가능
3. 단어 자르는건 커스텀 가능
4. 특정 문자마다 딜레이 다르게 줄 수 있도록 설정
5. 스크린샷 혹은 클립보드의 내용도 사용할 수 있도록 함


# 기능 구현

## 1. 구현 내용

1. UI 구성

텍스트가 출력될 텍스트박스, 진행률 표시바, 시작/일시정지 버튼, 속도 조절 스크롤바, 파일 읽기 버튼을 구성

![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled.png)

1. 파일 로드 기능
    1. 파일 로드 버튼을 클릭해서 읽을 텍스트 파일 로드
    2. 파일을 단어 단위로 나누어 List 형태로 저장
2. 재생 기능
    1. 재생 버튼을 눌러 재생/일시정지 상태 변경
    2. List형태로 저장된 단어들을 일정 시간 delay를 두고 화면에 순서대로 출력
    
    ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%201.png)
    
3. 진행률조절
    1. 진행률 표시바를 클릭 혹은 드래그 하여 진행 위치를 조절
4. 재생속도 조절
    1. 재생 속도 설정 스크롤 바를 드래그 혹은 클릭하여 단어가 표시될 시간을 조절
5. 클립보드 사용
    1. 클립 보드를 사용할 수 있도록 Text Box 추가, dialog안의 text box에 내용을 채워넣으면 해당 내용으로 flick through 실행
        
        ![Paste from clip board 버튼을 추가](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%202.png)
        
        Paste from clip board 버튼을 추가
        
    
    ![버튼을 누르면 dialog 창이 발생하고, 여기서 confirm 을 누르면 해당 텍스트로 슬라이드 플레이 가능](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%203.png)
    
    버튼을 누르면 dialog 창이 발생하고, 여기서 confirm 을 누르면 해당 텍스트로 슬라이드 플레이 가능
    
6. 다개국어 기능
    1. intl, flutter_localizations 모듈을 사용하기 위해 pubsec.yml 파일에 필요한 모듈 및 속성들을 추가한다. 
        
        ```yaml
        dependencies:
          flutter:
            sdk: flutter
          intl: ^0.18.0
        flutter_localizations:
          sdk: flutter
        
        ...
        
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
                AppLocalizations.delegate, // 명령어로 생성할 AppLocations class도 delegate
              ],
              supportedLocales: AppLocalizations.supportedLocales, // AppLocalizations 생성시 자동으로 세팅되어 있음
              home: MyHomePage(),
            );
          }
        }
        ```
        
    3. l10n.yaml 파일을 프로젝트 root 에 아래와 같이 작성한다. 
    - arb-dir: arb파일이 들어있는 경로(project root로부터 상대경로)
    - template-arb-file: 사용 언어를 찾지 못했을 때 사용할 언어 파일
    - output-localization-file: arb 파일로 생성할 dart 파일. AppLocalizations class가 정의되어있음
        
        ```json
        arb-dir: lib/l10n
        template-arb-file: app_en.arb
        output-localization-file: app_localizations.dart
        ```
        
    4. arb 파일을 `lib/l10n` 경로에 생성하여 json 형식으로 key-value 세트로 다국어로 번역할 단어를 적는다. 아래는 영어로 번역할 내용의 예시이다. 
    arb 파일의 key는 함수 이름으로 치환되기 때문에 알파벳 소문자로 시작해야 하며, 알파벳이 아닌 다른 문자를 포함하면 안된다. (camel case 사용)
        
        ```json
        {
          "@@locale": "en",
          "pasteFromClipBoard": "Paste from clip board",
          "textFileReader": "Text File Reader",
        }
        ```
        
    5. main.dart에서 다국어를 지원할 text 를 아래와 같이 치환한다. (context 객체가 있어야 함에 주의)
        
        ```json
        AppLocalizations.of(context)!.pasteFromClipBoard # 영어 사용권에서 "Paste from clip board" 로 치환됨
        ```
        
    6. flutter pub get 명령을 실행(안드로이드 스튜디오에서는 get dependencies 버튼으로 수행 가능)하여 `pubsec.yml` 파일을 갱신하면 l10n.yaml 파일에 따라 자동으로 아래와 같은 dart 파일이 생성된다.
        
        ```dart
        import 'package:intl/intl.dart';
        
        class AppLocalizations {
          static String of(BuildContext context, String key) {
            return Intl.message(key, locale: Localizations.localeOf(context).toLanguageTag());
          }
        }
        ```
        
    
    → 이 방법은 공식 다국어 지원 방식이지만, 언어 변환에 context 객체가 필요하다는 점이 단점이다. 
    

## 2. 문제와 해결

1. logic에 적용된 delay가 UI에도 적용되어 delay 시간동안 UI가 응답하지 않음
    
     - await를 사용하여 UI와 병렬로 동작하도록 구현
    
    ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%204.png)
    
2. `LinearProgressIndicator` 형태는 터치를 지원하지 않음
 → `GestureDetector` 로 캡슐화 하여 터치를 직접 설정할 수 있음
    
    ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%205.png)
    
3. GestureDetector로 스크롤시, 화면 밖을 벗어나는 영역까지 드래그를 해도 위치가 인식이 된다.
이 때문에 진행률이 음수가 되거나, 100%를 초과하는 경우가 발생하여 logic상으로 border를 처리해 주어야 한다.
4. WebBrowser 와 AndroidApp는 파일을 로드하는 방법이 다르다. 
    
    → web에서 동작하는지, app에서 동작하는지 런타임에 확인할 수 있는 구분자를 사용하여 각각 다른 방법으로 동작하게 분기처리 한다.
    
    ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%206.png)
    
    ![loadTextFile은 `_MyHomePageState` class의 멤버 함수이다.](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%207.png)
    
    loadTextFile은 `_MyHomePageState` class의 멤버 함수이다.
    
5. dart:html 은 모바일 기기 빌드 환경에서는 import 할 수 없는 모듈이다.
→ 조건부 import 구문을 사용하여 특정 조건에서만 해당 라인이 동작하도록 한다. (참조 : [https://letyarch.blogspot.com/2021/11/dart-conditional-importexport.html](https://letyarch.blogspot.com/2021/11/dart-conditional-importexport.html))

  1) platform에 따라 web.dart와 app.dart로 파일을 분리한다. 
    
    ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%208.png)
    
     2) abstract class를 형성하고, 각 platform dependent 한 로직들은 abstract class 를 상속받아서 web.dart와 app.dart에 작성한다. 
    
    ![abstract 함수를 선언하고, 조건부 import를 통해 컴파일타임 분기](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%209.png)
    
    abstract 함수를 선언하고, 조건부 import를 통해 컴파일타임 분기
    
    ![상속받아 만든 함수 (for app)](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2010.png)
    
    상속받아 만든 함수 (for app)
    
     3) conditional import 를 활용하여 컴파일 타임에 파일을 분리해서 import하도록 세팅
    → `import ‘app.dart’ if (dart.library.html) ‘web.dart';`
    
    - conditional import 관련 문서 : [https://dart.dev/guides/libraries/create-packages#conditionally-importing-and-exporting-library-files](https://dart.dev/guides/libraries/create-packages#conditionally-importing-and-exporting-library-files)
    - 구현 예시 : https://github.com/Zeruel92/cross_picker
    - factory 생성자 관련 설명 : [https://juwon-yun.tistory.com/81](https://juwon-yun.tistory.com/81)
    - conditional import와 factory 패턴 적용 : [https://medium.com/flutter-community/conditional-imports-across-flutter-and-web-4b88885a886e](https://medium.com/flutter-community/conditional-imports-across-flutter-and-web-4b88885a886e)
    - conditional import 사용한 예시 : https://github.com/dart-lang/sdk/issues/48320
    
    → 결론, 
    
    1. conditional import를 사용해야하는 것은 맞음. 
    2. factory pattern을 사용하여, getFileLoader() 호출시 특정 객체가 호출되도록 함. (함수는 전역으로 선언해야 함)
    
    ![conditional import/export를 통해 필요한 파일만 플랫폼에 맞게 컴파일타임에 선택 ](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2011.png)
    
    conditional import/export를 통해 필요한 파일만 플랫폼에 맞게 컴파일타임에 선택 
    
    1. 파일을 나누어 각 플랫폼별로 class를 따로 정의, interface를 상속받도록 하고, 각 파일에서 getFileLoader 을 선언한다. (conditional import를 사용하기 때문에 getFileLoader은 중복 선언되지 않고 컴파일타임에 하나만 선택된다. 
    2. base class를 상속하고, 플랫폼별로 동작이 달라지는 function을 override(재정의) 해서 각 플랫폼마다 다르게 동작하도록 하면 된다. 
        
        ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2012.png)
        
        ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2013.png)
        
    3. main에서 getFlieLoader() 로 객체를 호출하면 플랫폼에 맞는 알맞은 객체가 생성된다.
        
        ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2014.png)
        
    
    실패1. main에서 호출한 AbstractFileLoader는 loadFile이 미구현된 상태. 미구현 에러 발생
    
    ![cross_platform.dart 파일, base class를 선언](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2015.png)
    
    cross_platform.dart 파일, base class를 선언
    
    ![app.dart 파일, base class를 상속받고 loadFile 함수 재정의](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2016.png)
    
    app.dart 파일, base class를 상속받고 loadFile 함수 재정의
    
    ![main.dart에서 base class 생성](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2017.png)
    
    main.dart에서 base class 생성
    
    ![base class에서 구현된 function 호출](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2018.png)
    
    base class에서 구현된 function 호출
    
6. 안드로이드 read external memory 권한

 - Platform exception: PlatformException(read_external_storage_denied, User did not allow reading external storage, null, null) 와 같은 에러 발생

 - **android/app/src/main/AndroidManifest.xml** 파일에 `<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />` 구문이 선언되어있는지 확인. 해당 태그는 manifest 직속, application 선언전에 호출되어야 한다. 

![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2019.png)

 - flutter에 권한 관리 모듈을 추가해야 한다. pubsec.yaml 파일에 permission_handler dependency를 추가한다. 

![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2020.png)

 - 이후 permission 이 필요한 동작을 호출하는 함수가 있는 파일에 permission_handler 모듈을 추가한다. 
`import 'package:permission_handler/permission_handler.dart';`
모듈을 이용하여 권한을 체크하는 함수를 생성하고, 저장소 접근 전 권한을 먼저 체크한다. 

권한이 없다면 자동으로 팝업을 띄워 권한을 요청하도록 되어있다.

![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2021.png)

이후 await 를 통해 결과를 받아서 결과에 따른 처리를 수행하도록 한다. 

![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2022.png)

1. 다개국어 지원시 AppLocations.of(context) 에서 null을 반환하여 랜더링 실패
    - `Text(AppLocalizations.*of*(context)!.pasteFromClipBoard),)` 형태를 widget에 넣을 때, 해당 값이 null로 치환되면 랜더링 오류가 발생한다.
    - 설정을 제대로 했는지 확인한다. 내 경우에는 아래 라인을 넣지 않아서 오류가 발생했다.
        
        ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2023.png)
        
    - 설정도 제대로 했다면, l10n.yaml에서 언어를 감지하지 못했을 때 동작할 default language를 설정 해 준다.
        
        ![Untitled](%5BBoosted%20Reader%5D%F0%9F%94%A8%20App%20%E1%84%80%E1%85%A2%E1%84%87%E1%85%A1%E1%86%AF%2011b84e8a72a24cb099094412c4ddd72b/Untitled%2024.png)
        
    - 이 또한 먹히지 않는다면 MaterialApp 생성시 localeListResolutionCallback 항목을 아래와 같이 파라미터로 추가해 준다. 언어를 감지하지 못했을 시 default language 팩을 en 으로 설정하는 내용이다.
        
        ```dart
        localeListResolutionCallback: (locales, supportedLocales) {
                print('device locales=$locales supported locales=$supportedLocales');
                for (Locale locale in locales!) {
                  // if device language is supported by the app,
                  // just return it to set it as current app language
                  if (supportedLocales.contains(locale)) {
                    return locale;
                  }
                }
                // if language of current location is not supported, use english
                return Locale('en');
              },
        ```
        
2. 다개국어 테스트
- 구현은 성공적으로 마쳤지만, 한국에서 테스트를 하면 ‘ko’ 밖에 확인할 수 없다.

## 3. 참조

1. intl 패키지
- intl 패키지는 다국어 설정을 할 때 많이 사용되며, ‘arb’ 확장자의 파일을 dart 파일 형태로, 혹은 그 반대로 변환할 수 있는 패키지이다.
    
    ```json
    
    ex) arb 파일을 dart 파일로 변환
    
    flutter pub pub run intl_translation:generate_from_arb \
      --output-dir=lib/localizations \
      lib/localizations/app_localizations.dart \
      lib/localizations/app_localizations_en.arb \
      lib/localizations/app_localizations_es.arb
    ```
    
    ```json
    
    ex) dart 파일을 arb 파일로 변환
    
    flutter pub run intl_translation:extract_to_arb --output-dir=lib/i18n lib/i18n/messages.dart
    ```
    
- 혹은 `i18n.yaml` 이름으로 yaml 파일을 생성하여 root 폴더에 넣어두면 `pub get package` 명령어 실행, 혹은 IDE의 pubsec.yaml 파일 업데이트시 각 yaml 파일의 설정에 따라 arb 파일로 dart 파일을 생성할 수 있다. 
파일의 내용은 다음과 같다.
    
    ```json
    arb-dir: lib/l10n
    template-arb-file: app_en.arb
    output-localization-file: app_localizations.dart
    ```
    
    arb-dir: arb파일이 존재하는 디렉터리 경로
    template-arb-file: 사용할 arb 파일
    output-localization-file: arb파일을 변환하여 생성할 dart 파일의 이름, 파일은 .darttool/fluttergen/genl10n/ 경로에 생성되며 `import 'package:flutter_gen/gen_l10n/app_localizations.dart'` 형태로 import 가능하다.
    
    l10n은 localization이라는 뜻이며, 이외에도 아래와 같은 축약어가 사용된다. 
    
    > l10n.yaml (localization)
    i18n (internationalization)
    g11n (globalization)
    m17n (multilingalization)
    > 
- 다국어 설정 방법 1 (intl, l10n.yaml을 사용한 공식 방식) : [https://fronquarry.tistory.com/8](https://fronquarry.tistory.com/8)
- 다국어 설정 방법 2 (intl과 command를 통한 방식) : [https://fronquarry.tistory.com/8](https://fronquarry.tistory.com/8)
- 두 방식을 비교한 내용 : [https://jay-flow.medium.com/flutter-localizations-완전-정복-하기-8fa5f50a3fd2](https://jay-flow.medium.com/flutter-localizations-%EC%99%84%EC%A0%84-%EC%A0%95%EB%B3%B5-%ED%95%98%EA%B8%B0-8fa5f50a3fd2)

# 배포

## 1. 구현 내용

### github에 web 페이지 배포

1. root 경로에 `.github/workflows/web.yml` 파일을 만든다.

```yaml
name: github-page-work # 작업 이름

on:
  push:
    branches: [master] # master 브랜치의 코드 사용해서 동작

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
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

1. https://github.com/settings/tokens 에 접속하여 ‘generate new token’을 선택하여 신규  token을 생성한다. 
    
    ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled.png)
    
- 배포만이 목적이라면 아래와 같이 권한을 설정 해 주면 충분하다.

![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%201.png)

- 토큰이 생성되면 페이지를 닫지 말라. 현재 페이지를 벗어나면 다시 토큰을 볼 수 없다.
그 상태에서 바로 코드가 들어있는 github repository의 setting 으로 진입한다. ([https://github.com/AswinBlue/FlickThrough/settings](https://github.com/AswinBlue/FlickThrough/settings))
- repository 설정에서 “Secrets and variables” 메뉴에 진입하고, ‘Secrets’ 탭을 선택한 후 ‘New Repository Secret’ 버튼을 눌러서 `GIT_TOKEN` 을 key로, 이전 단계에서 받은 token을 value로 설정하여 secret variable을 하나 생성한다. (생성한 secret variable도 다시 확인할 수 없으므로 주의한다. 또한 GITHUB_ 로 시작하는 key의 secret varaible은 생성할 수 없다)
([https://github.com/AswinBlue/FlickThrough/settings/secrets/actions](https://github.com/AswinBlue/FlickThrough/settings/secrets/actions))
    
    ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%202.png)
    
1. 내용을 작성하고 github에 푸쉬하면 github 의 action 탭에서 action의 실행 결과를 확인할 수 있다.  ([https://github.com/AswinBlue/FlickThrough/actions/new](https://github.com/AswinBlue/FlickThrough/actions/new))
    
    ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%203.png)
    
2. action이 정상적으로 완료되었다면, setting/page 항목에서 브랜치 ‘gh-pages’로 설정 해 준다. (자동으로 되는 경우도 있음)
([https://github.com/AswinBlue/FlickThrough/settings/pages](https://github.com/AswinBlue/FlickThrough/settings/pages))
    
    ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%204.png)
    

### 2. 아이콘 변경

[https://www.appicon.co/](https://www.appicon.co/) 에 이미지 파일을 넣으면 android 아이콘 형태로 이미지를 변환하여 추출 해 준다. 

추출된 아이콘을 `\android\app\src\main\res` 경로에 복사 붙여넣으면 된다. 

IOS는 `ios/Runner/Assets.xcassets` 폴더 안에 AppIcon.appiconset 폴더를 교체 해 준다. 

### 3. Android 앱 배포

1. 구글 플레이스토어 개발자 계정 생성
개발자 계정이 없다면, [https://play.google.com/console](https://play.google.com/console) 에 접속하여 안내에 따라 계정을 생성한다. 생성에는 $25의 비용이 부과되므로 달러 결제가 가능한 카드를 준비한다.
2. 안드로이드 앱 배포시 자신이 앱의 개발자가 맞다는 것을 증명하고 앱을 업데이트 하기 위해서는 앱에 설정된 key와 동일한 key를 알고 있어야 한다. 이를 key store 시스템이라 하며, 배포전 반드시 설정을 해야 한다. 
    - jdk에서 제공하는 keytool 명령어를 사용해야 한다. jdk를 설치하면 `C:\Program Files\Java\jdk-21\bin` 경로에 keytool 실행파일이 있다.
    - `keytool -genkey -v -keystore C:/Users/USER_NAME/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`명령으로 key를 생성한다. key 생성시 비밀번호를 입력 해 주고, 묻는 질문에 필요하다면 대답해 준다.
    - 생성된 key.jks 파일을 `android/app/` 경로로 이동시키고, [key.properties](http://key.properties) 파일을 생성한 후, 아래와 같이 내용을 채워 넣는다.
        
        ```dart
        storePassword=<키생성시 입력한 암호>
        keyPassword=<키생성시 입력한 암호>
        keyAlias=key
        storeFile=./key.jks
        ```
        
    - .gitignore 파일로 key.jks와 [key.properties](http://key.properties) 파일이 유출되지 않게 잘 조정한다.
    - app/build.gradle 파일에 keystore 을 사용하기 위한 내용을 추가한다.
        
        ```dart
        def keystoreProperties = new Properties()
        def keystorePropertiesFile = rootProject.file('app/key.properties')
        if (keystorePropertiesFile.exists()) {
            keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
        }
        
        ...
        
        android {
        ...
        	signingConfigs {
        	  release {
        	    keyAlias keystoreProperties['keyAlias']
        		  keyPassword keystoreProperties['keyPassword']
        	    storeFile file(keystoreProperties['storeFile'])
              storePassword keystoreProperties['storePassword']
            }
          }
        	
          buildTypes {
            release {
              signingConfig signingConfigs.release
            }
          }
        ```
        
    - gradle 파일 수정 후에는 gradle을 프로젝트에 sync 해 주어야 한다. 
    gradle sync라는 항목이 ‘file’ 밑에 있는 경우도, ‘tool → android’ 밑에 있는 경우도 있는데 둘다 보이지 않는다면 build.gradle 파일을 우클릭 한 후 ‘Link gradle project’ 를 눌러준다.
        
        ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%205.png)
        
    - 마지막으로 build를 release 버전으로 수행해야 한다. 좌측 하단에 Build Variants 창을 찾아(혹은 build → Select build variant 선택) 설정을 release로 변경한다.
        
        ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%206.png)
        
    - 이후 콘솔창에 `flutter build appbundle` 명령어를 입력하여 app bundle을 빌드한다. 빌드한 결과는 /build/app/outputs/bundle/release 경로에 생성된다.
    - 파일명은 app-release.aab 로 생성되어 있다. playstore console에 배포할때도 aab 파일을 업로드 한다.
    - 업로드한 파일의 manifest에 적힌 버전과 동일한 버전은 중복 업로드를 할 수 없으므로, 이후 업로드 시에는 높은 버전을 업로드 해야 하며, 기존 버전을 삭제하고 싶다면 playstore console에서 ‘app bundle 탐색기’ 메뉴를 찾아 삭제가 가능하다.

## 2. 문제와 해결

1. `fatal: unable to access '[https://github.com/AswinBlue/FlickThrough/](https://github.com/AswinBlue/FlickThrough/)': The requested URL returned error: 403` 에러
    - “erickzanardo/flutter-gh-pages@v3” 과 “bluefireteam/flutter-gh-pages@v7” 을 사용해도 모두 동일한 에러가 발생했다.
    - 해당 url에 접근 권한이 없는 경우 발생한다.
        - 1) gitbash를 이용하여 url을 계정 이름이 포함된 형태로 변경해 준다.
        `git remote set-url origin https://AswinBlue@github.com/AswinBlue/FlickThrough.git`
        - 2) checkout job 실행시 token 사용하도록 적용 해 주면 이후 명령들도 권한이 적용 되는듯 하다.
            
            ![Untitled](%5BBoosted%20Reader%5D%20%F0%9F%94%A8%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20a32ac3fe24cf4b8fb50fd6345d1460ac/Untitled%207.png)