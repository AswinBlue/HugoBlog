---
title: "DailyNote"
date: 2025-07-30T19:43:52+09:00
lastmod: 2025-07-30T19:43:52+09:00
tags: ['App',]
categories: ['dev', 'advertisement', 'design', 'deploy',]
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
# Daily Note
사진 일기 앱 "하루기록" (DailyNote) 개발 Document


##  기획서

1. 앱 개요 및 핵심 가치  

    **"하루기록"** 은 단순한 사진 기록을 넘어, 사용자의 감정과 경험을 데이터로 시각화하여 '더 나은 나'를 발견하도록 돕는 인터랙티브 사진 일기 앱입니다.


    Target User: 자신의 일상을 의미 있게 기록하고 싶어 하는 사람, 감정의 변화나 생활 패턴을 객관적으로 파악하고 싶은 사람, 꾸준한 기록을 통해 성취감을 느끼고 싶은 사람.

    Core Value (핵심 가치):
      - 간편한 기록: 사진 한 장으로 시작되는 쉽고 빠른 일기 작성.
      - 데이터 기반의 성찰: 나의 감정, 활동 등을 그래프와 지도로 돌아보며 새로운 인사이트 발견.
      - 완벽한 프라이버시: 민감한 기록을 안전하게 보관하는 기술적 선택.
      - 동기 부여 시스템: 꾸준한 기록이 즐거워지는 게이미피케이션 요소.

2. 사용자들이 중요하게 여기는 점 (User Needs)

    사진 일기 앱 사용자들이 공통적으로 중요하게 생각하는 요소는 다음과 같습니다. 이 점들을 앱의 모든 기능에 녹여내는 것이 성공의 열쇠입니다.

    - 속도와 단순함: 일기 쓰는 과정이 복잡하면 금방 지칩니다. 앱을 켜고 사진을 선택(또는 촬영)하고, 핵심 내용과 데이터를 입력하기까지의 과정이 최대한 빠르고 직관적이어야 합니다.
    - 프라이버시와 안정성: 일기는 지극히 개인적인 공간입니다. 데이터가 유출되거나 소실될 수 있다는 불안감은 앱 사용을 중단시키는 가장 큰 요인입니다. "내 데이터는 안전하고, 오직 나만 볼 수 있다"는 신뢰를 주어야 합니다.
    - 돌아보는 즐거움: 그냥 쌓아두기만 하는 일기는 의미가 없습니다. 사용자는 과거의 기록을 쉽고 재미있게 돌아보길 원합니다. 제안하신 대시보드, 지도, 캘린더 기능은 이 니즈를 정확히 충족시킵니다.
    - 동기 부여: 처음에는 의욕적으로 시작해도 꾸준히 쓰기는 어렵습니다. 사용자가 계속해서 앱을 방문하고 기록을 남기도록 유도하는 장치가 필요합니다. 출석 체크와 보상은 아주 좋은 시작점입니다.

3. 주요 기능 명세
   1. 일기 작성 (Core)
      1. 사진 첨부: 갤러리에서 선택 또는 직접 촬영
      2. 텍스트 입력: 그날의 생각이나 사건을 자유롭게 기록
      3. 데이터 입력 (Key Feature):
         - 기본 속성: "오늘의 기분" (1~5점 척도)은 기본 제공
         - 사용자 정의 속성: 사용자가 "업무 집중도", "운동 시간", "소비 금액" 등 원하는 속성을 직접 추가하고, 데이터 타입(점수, 시간, 금액 등)을 선택할 수 있는 기능.

   2. 기록 탐색 (View)
      1. 대시보드 (Dashboard):
         - 선택한 속성의 데이터를 다양한 그래프(선, 막대 등)로 시각화
         - 기간 설정(주간/월간/연간) 및 속성별 필터링 기능
         - 여러 속성을 겹쳐서 비교하는 기능 (예: 기분 점수와 운동 시간의 상관관계)
         - 지도 위에 일기가 작성된 위치를 핀으로 표시
         - 지도 핀 클릭 시: 1차) 사진 썸네일과 요약 표시 → 2차) 전체 일기 화면으로 이동
      
      2. 캘린더 (Calendar):
         - 일기를 작성한 날짜에 시각적 표시 (예: 작은 사진 썸네일)
         - 연/월/주 단위 보기 전환
         - 날짜 클릭 시: 작성된 일기 있으면 → 상세 보기 / 없으면 → 새 일기 작성 화면으로 이동

      3. 동기 부여 (Gamification)
         - 출석 및 연속 기록:
           - 매일 접속 및 일기 작성 시 출석 체크
           - 연속 출석일(Streak) 표시 및 보상 (예: 3일, 7일, 30일 달성 시)
         - 포인트 시스템 및 상점:
           - 출석, 연속 기록, 특별 과제(아래 참조) 달성 시 포인트 지급
           - 포인트로 앱 내 아이템 구매: 캘린더/대시보드 테마, 폰트, 앱 아이콘 변경권 등 앱을 꾸밀 수 있는 아이템 제공 (사용자에게 개인화의 즐거움을 줍니다.)
          - 특별 과제 (Missions):
            - "처음으로 새로운 장소에서 일기 쓰기", "기분 5점인 날 3번 기록하기", "한 달 동안 15일 이상 기록하기" 등 다양한 미션을 제공하여 성취감과 함께 추가 포인트를 지급합니다.

4. 기술 스택 및 인프라 (비용 & 개인정보 고려)
          
    운영 비용 최소화와 개인정보 보호는 매우 중요합니다. 
    **Firebase (by Google)** 는 앱 개발에 필요한 다양한 백엔드 기능을 제공하며, 운영 비용과 개인정보 문제를 해결할 훌륭한 솔루션입니다.

    인증 (Authentication): 사용자가 자신의 Google 계정으로 간편하게 로그인하게 할 수 있습니다. (사용자는 별도 가입이 필요 없어 편리)

    데이터베이스 (Firestore):

        비용: 매일 수만 명이 사용하지 않는 이상, 무료 제공량(Free Tier)만으로 충분히 운영 가능합니다. 사용자가 늘어나도 사용량만큼만 비용을 내므로 매우 경제적입니다.

        기능: JSON 형태의 데이터를 저장하기에 최적화되어 있으며, 복잡한 데이터 조회 및 필터링이 매우 빠르고 효율적입니다. 대시보드 기능 구현에 필수적입니다.

    스토리지 (Cloud Storage):

        사진 저장: 사진 파일은 Firebase Storage에 저장합니다. 이 역시 상당한 양의 무료 용량을 제공합니다.

        개인정보: 데이터베이스와 스토리지는 규칙(Security Rule)을 통해 오직 본인만 자신의 데이터에 접근하도록 완벽하게 설정할 수 있습니다. 즉, 서버에 저장되지만 다른 사용자는 절대 볼 수 없습니다.

    결론: Firebase를 사용하면 초기 비용 거의 없이 빠르고 안정적이며 확장 가능한 앱을 만들 수 있습니다. 개인정보 또한 강력한 보안 규칙으로 보호할 수 있습니다.

## 개발 로드맵

처음부터 모든 기능을 다 만들기보다, 핵심 기능부터 단계적으로 개발하며 사용자의 피드백을 받는 것이 좋습니다.

Phase 1: MVP (Minimum Viable Product) 출시
 
    목표: 가장 핵심적인 '기록'과 '보기' 경험을 검증한다.
    기능: Google 계정 로그인, 사진+글+기분점수(고정) 일기 작성, 캘린더 뷰(월별), 일기 상세 보기.
    인프라: Firebase Authentication, Firestore, Storage 기본 설정.

Phase 2: 핵심 기능 확장

    목표: 우리 앱의 차별점인 '데이터 성찰' 경험을 완성한다.
    기능: 대시보드 개발 (그래프 시각화), 지도 뷰 개발, 사용자 정의 속성 추가

Phase 3: 사용자 유지 전략 강화

    목표: 사용자가 꾸준히 앱을 사용하도록 동기를 부여한다.
    기능: 출석 체크, 연속 기록(Streak) 시스템, 포인트 및 보상 시스템(테마 등) 도입.

Phase 4: 고도화 및 수익화

    목표: 사용자 편의성을 높이고 수익 모델을 적용한다.
    기능: 키워드 검색, 데이터 백업/내보내기, 광고(배너, 보상형) 탑재, 광고 제거 유료 옵션.

추가 고려사항
 
    UI/UX 디자인: 데이터 시각화가 핵심인 만큼, 복잡한 정보를 사용자가 쉽게 이해하고 재미를 느낄 수 있도록 깔끔하고 매력적인 디자인이 매우 중요합니다.
    온보딩(Onboarding): 앱을 처음 설치한 사용자에게 사용자 정의 속성 추가 방법이나 대시보드 활용법을 친절하게 알려주는 튜토리얼 과정을 꼭 넣어야 합니다.
    개인정보 처리방침: 위치 정보, 사진, 개인 기록을 다루므로, 어떤 데이터를 수집하고 어떻게 사용하는지 명확하게 고지하는 개인정보 처리방침을 반드시 작성하고 앱 내에 게시해야 합니다.

## 구현
1. 개발환경 구축

   react native 를 사용하여 앱을 개발 할 계획이다.
  
   1. Expo CLI 설치 : `npm install -g expo-cli`
   2. 프로젝트 생성 : `expo init haru-girok`
   3. 프로젝트 실행 : `cd haru-girok; npm start`
   4. 스마트폰에 Expo Go 앱 설치 후 콘솔창의 QR코드 인식

   5. 빌드 시스템 구축
      - 원격 빌드 시스템:
        - `npm install -g eas-cli` 로 EAS 도구를 설치
        - [EXPO page](https://expo.dev/) 에 들어가서 회원가입(sign up) 진행
        - `eas build:configure` 명령을 콘솔에 입력한 후, EXPO ID와 Password로 인증 진행. 이후 나오는 설정은 기본설정 사용
        - 콘솔에 `eas build --profile development --platform android` 명령 입력하여 빌드
        - 단, 원격 빌드는 무료 플랜을 사용할 경우 대기 시간이 매우 길기 때문에 추천하지 않는다. 
      - 로컬 빌드:
        - 가상 기기나 개발자모드로 세팅한 실물 휴대폰을 PC에 연결한 후 `npx expo run:android` 명령어 실행하여 빌드

   휴대폰에 react app이 구동되면 개발환경이 정상적으로 갖춰진 것이다.

2. Firebase 연동
    1. [firebase 콘솔](https://console.firebase.google.com/) 로 이동하여 구글 로그인
    2. [프로젝트 추가] 버튼을 누른 후 프로젝트 이름 입력
    3. 생성된 프로젝트의 대시보드에서 + 버튼을 클릭,  `웹 아이콘` </> 선택하여 앱 추가
    4. 앱 이름을 선정하고 [앱 등록] 버튼 클릭
    5. 'firebase SDK 추가' 단계에서 보여주는 firebaseConfig 정보를 복사 해 놓는다. 
    6. 개발환경 구축 단계에서 생성했던 프로젝트 위치로 들어가 `npx expo install firebase` 명령어로 firebase 를 설치한다.
    7. 프로젝트 최 상위 경로에 `firebaseConfig.js` 파일을 생성하고 아래와 같이 작성한다. 이전에 복사해 놓은 firebaseConfig 정보도 넣어준다.

        ```
        // firebaseConfig.js

        import { initializeApp } from 'firebase/app';
        import { getFirestore } from 'firebase/firestore';
        import { getAuth } from 'firebase/auth';
        import { getStorage } from 'firebase/storage';

        const firebaseConfig = {
        // 여기에 아까 복사한 firebaseConfig 붙여넣기
        };

        // Firebase 앱 초기화
        const app = initializeApp(firebaseConfig);

        // 다른 파일에서 사용할 수 있도록 내보내기
        export const db = getFirestore(app);
        export const auth = getAuth(app);
        export const storage = getStorage(app);
        ```

    8. 다시 Firebase 콘솔로 돌아가서 사용할 앱들을 각각 활성화 시켜준다.
       - Authentication (인증):
         - Firebase 콘솔 왼쪽 메뉴에서 빌드 -> Authentication 클릭
         - 로그인 방법 탭에서 [새 제공업체 추가] 클릭
         - 제공업체 중 Google을 선택하고, '사용 설정' 스위치를 켠 뒤 프로젝트 지원 이메일을 선택하고 [저장]  

         ![Authentication](/IMAGE_HARUGIROK/firebase_authentication.png)

       - Firestore Database (데이터베이스):
         - 왼쪽 메뉴에서 빌드 -> Firestore Database 클릭
         - [데이터베이스 만들기] 버튼 클릭

         ![Database1](/IMAGE_HARUGIROK/firebase_database1.png)
         - 혹시나 있을 개인정보 취급 문제를 위해 저장 권역은 국내서버로 변경

         ![Database2](/IMAGE_HARUGIROK/firebase_database2.png)
         - **테스트 모드** 에서 시작을 선택하고 [다음] 버튼 클릭 (보안 규칙은 나중에 설정하고 지금은 일단 진행)
         - Cloud Firestore 위치는 기본값으로 두고 [사용 설정] 클릭

      - Storage (사진 저장소용):
        - 왼쪽 메뉴에서 빌드->Storage 클릭
        - [시작하기] 버튼 클릭
        - Storage 사용을 위해 결제 계정 연동이 필요하기에, 결제 계정을 생성하고 연동하는 작업이 선행되어야 할 수 있다.
        - 버킷 옵션(storage 위치) 은 기본설정을 유지, 보안 규칙 설정에는 **테스트 모드** 로  설정
         ![Storage](/IMAGE_HARUGIROK/firebase_storage.png)

    9. firebase 보안 규칙 수정
       1.  Firebase 콘솔로 이동하여 프로젝트를 연다.
       2.  왼쪽 메뉴에서 Storage를 클릭
       3.  상단 탭에서 규칙(Rules) 탭을 선택
       4.  기존에 있던 규칙의 `timestamp.date` 를 수정해 허가 기간을 늘리거나, 아래의 코드로 교체
            ```
            rules_version = '2';

            service firebase.storage {
                match /b/{bucket}/o {
                    // 로그인한 모든 사용자는 파일을 읽고 쓸 수 있습니다.
                    match /{allPaths=**} {
                    allow read, write: if request.auth != null;
                    }
                }
            }
            ```
       5.  게시(Publish) 버튼을 눌러 변경사항을 저장
       6.  동일한 절차를 `Firestare Database` 메뉴에 대해서도 수행해 준다.
   
3. 로그인 기능 구현
    1. Google 로그인과 Firebase 인증에 필요한 라이브러리들을 설치한다.
        ```
        npx expo install @react-native-google-signin/google-signin
        npx expo install @react-native-async-storage/async-storage
        ```
    2. 로그인 기능을 App.js 파일에 함수로 구현
        ```
        import React, { useEffect, useState } from 'react';
        import { StyleSheet, Text, View, Button } from 'react-native';
        import { GoogleSignin } from '@react-native-google-signin/google-signin';
        import { auth } from './firebaseConfig'; // 미리 만든 설정 파일
        import { GoogleAuthProvider, signInWithCredential } from 'firebase/auth';
        export default function App() {
            const [user, setUser] = useState(null);

            // Google 로그인 설정
            useEffect(() => {
                GoogleSignin.configure({
                webClientId: 'YOUR_WEB_CLIENT_ID', // 다음 설명을 따라 획득 필요
                });
            }, []);

            // Google 로그인 버튼 클릭 시 실행될 함수
            async function onGoogleButtonPress() {
                try {
                await GoogleSignin.hasPlayServices({ showPlayServicesUpdateDialog: true });
                const { idToken } = await GoogleSignin.signIn();
                const googleCredential = GoogleAuthProvider.credential(idToken);
                const firebaseUser = await signInWithCredential(auth, googleCredential);
                setUser(firebaseUser.user); // 로그인 성공 시 사용자 정보 저장
                console.log('로그인 성공:', firebaseUser.user.displayName);
                } catch (error) {
                console.log('로그인 에러:', error);
                }
            }

            // 로그아웃 함수
            function signOut() {
                auth.signOut();
                setUser(null);
            }

            // 이후 출력할 화면에 따라 return 값 세팅
        }
        ```
    3. 로그인 기능을 안드로이드 라이브러리를 사용하여 구현하기 위해서는 firebase 에 "안드로이드 앱" 을 추가 해 줘야 한다. 
       1. [firebase 콘솔 페이지](https://console.firebase.google.com/) 에 접근하여 좌측 상단 톱니바퀴 버튼 클릭 -> 프로젝트 설정 클릭 -> '내 앱' 메뉴에서 '앱추가' 버튼 클릭 -> '안드로이드 앱' 선택하면 새 창이 뜬다.  
       ![firebase app setting](/IMAGE_HARUGIROK/SHA1_setting1.png)  
       ![firebase app setting](/IMAGE_HARUGIROK/SHA1_setting2.png)  
       ![firebase app setting](/IMAGE_HARUGIROK/firebase_new_app.png)  
       ![firebase app setting](/IMAGE_HARUGIROK/firebase_new_app2.png)  
       2. firebase에 android 빌드시 사용되는 SHA1값을 등록하여야 한다. 

          1. 만약 EAS 시스템을 이용해서 빌드를 한다면, [expo 홈페이지](https://expo.dev/) 로 접근하여 'Credentials' 목록으로 진입하고, Application Identifier 에 있는 "com.example.app" 형태의 문구를 복사한다. 그후 firebase 앱 추가 화면의 "Android 패키지 이름" 란에 해당 구문을 복사해 붙여넣는다.  
          ![firebase app setting](/IMAGE_HARUGIROK/login_app_setting.png) 

          2. 추가로, 'Build Credential' 항목의 'SHA-1 Fingerprint' 란에 있는 값도 복사하여 firebase 앱 추가 화면의 '디버그 및 서명 인증서' 란에 붙여넣는다.  
          ![SHA1](/IMAGE_HARUGIROK/SHA1.png)

          3. 만약 로컬에서 빌드를 한다면, 콘솔에서 프로젝트의 `/android` 경로로 진입하여 `./gradlew signingReport` 명령어를 입력한 후 나오는 SHA1 값을 기록 해 둔다.
             - SHA1 값 외에도 다른 출력값이 많으므로 한참 스크롤을 올려야 할 수 있다. 
             - gradlew 명령이 먹히지 않는다면 JDK 설치 여부와 환경변수 설정을 확인해보라.   
          ![SHA1_local](/IMAGE_HARUGIROK/SHA1_local.png). 

          4. 만약 나중에 값을 바꾸려면 동일하게 좌측상단의 톱니바퀴 모양을 클릭하여 '프로젝트 설정' 을 선택한 후, '일반' 탭에서 스크롤을 내려 '내 앱' 항목을 찾고, 'SHA 인증서 지문' 부분을 수정하면 된다.
          5. firebase 콘솔에서 SHA1값 추가 후에는 프로젝트에서 `npx expo start --clear` 명령과 `cd android; .\gradlew clean` 을 한번 실행시킨 후 빌드를 수행 해 준다.

       3. 이후 '앱 등록' 버튼을 클릭하고, 다음 화면에서 'google-service.json' 파일 다운로드. 다운로드한 파일은 프로젝트 파일의 최 상단(app.json과 동일한 위치) 에 저장한다.
       ![firebase app setting](/IMAGE_HARUGIROK/firebase_new_app3.png)  
       4. 나머지 설정들은 기본 설정을 그대로 사용하면 된다. 앱 추가 과정이 완료된 후에는 프로젝트 경로에서 실행한 콘솔로 돌아와서 빌드 명령을 실행해서 변경점을 반영해 준다. 
          - 원격은 `eas build --profile development --platform android` 
          - 로컬은 `npx expo run:android`

    4. 이때 안든로이드 expo 앱으로 프로젝트를 실행시키면 `Invariant Violation : TurboModuleRegistry.getEnforcing(...):'RNGoogleSignin' could not be found. Verify that a module by this name is registered in the native binary.` 에러가 발생한다. 이는 Expo Go 앱에 @react-native-google-signin/google-signin 라이브러리의 네이티브 코드가 포함되어 있지 않기 때문에 발생하는 것으로, 아래 과정을 통해 해결한다.
        - `eas build --profile development --platform android` 명령을 입력하여 eas 툴로 빌드 시작. 이후 나오는 설정들은 기본 설정을 사용하면 된다.
        - 빌드가 완료되면 QR코드가 나오는데, 이 QR 코드를 휴대폰의 Expo 앱으로 스캔하고, 앱 설치 화면이 뜨면 앱 설치 파일을 다운받고 앱을 설치한다. 
          - 이 명령은 앱 빌드에 필요한 native library 를 apk 파일에 포함하여 빌드하는 명령어로, 한 번만 수행한 후 라이브러리의 수정이 없다면 추가로 실행할 필요가 없다.
        - 다운받은 앱을 바로 실행하면 실행이 되지 않는다. 서버 PC에서 `npx expo start` 명령어로 expo 서버를 구동시키고, 명령어 결과로 나오는 QR을 다시 휴대폰으로 스캔하여야 PC와 휴대폰의 앱이 연결되고, 앱이 실행된다.
        - 휴대폰에서 발생하는 에러 메시지들이 PC 콘솔을 통해 출력되게 되어 편리하게 디버깅을 할 수 있게 된다. 

    5. google cloud console 에서 webClientId 획득
       - [Google Cloud Console](https://console.cloud.google.com/) 로 이동
       - 좌측 메뉴에서 "API 및 서비스" -> "사용자 인증 정보" 항목 클릭
       - 화면에서 "OAuth2.0 클라이언트 ID" 리스트를 보면 "Web client (auto created by Google Service)" 가 기본으로 생성되어 있을 것이며, 이 클라이언트 ID 를 복사하여 앞서 작성한 App.js 파일의 webClientId 부분에 붙여넣기 한다.   
       ![OAuth2](/IMAGE_HARUGIROK/google_oauth.png)   


4. 내비게이션 및 메인 화면 구성
    1. 네비게이션 라이브러리 설치
        ```npx expo install @react-navigation/native
        npx expo install react-native-screens react-native-safe-area-context
        npx expo install @react-navigation/native-stack
        ```
    2. 
5. AI 기능 추가
   - AI API 활성화, 체험 및 비용 구조 파악을 목표로 한다.
   - 사진 분석 후 라벨 설정을 위해 "Cloud Vision API" 를 사용한다.
   1. [Google Cloud Console](https://console.cloud.google.com/) 로 이동
   2. 좌측 메뉴에서  "API 및 서비스" -> "라이브러리" 로 이동한다.

   ![AI_api](/IMAGE_HARUGIROK/AI_api.png)  
   
   3. "Cloud Vision API" 를 찾아 클릭하고 상세 페이지에서 "사용" 버튼을 클릭

   ![AI_api2](/IMAGE_HARUGIROK/AI_api2.png)  

   
   - 비용 구조 확인
     - Vision API: 이미지를 1,000건 분석할 때마다 요금이 부과됨. (예: 라벨 감지 기능은 1,000건당 약 $1.5) 즉, 사진 한 장 분석에는 약 0.2원 정도가 소요.

     - Natural Language API: 텍스트 1,000자를 '1 유닛'으로 계산하며, 1,000 유닛(총 100만 자)당 요금이 부과됨. (예: 감정 분석은 1,000 유닛당 약 $0.5) 즉, 일기 한 편(500자) 분석에는 약 0.3원 정도가 소요.

     - 결론: 크레딧($300 = 약 40만 원)이 있다면, 수십만 건의 사진과 일기를 분석할 수 있는 엄청난 양이므로 테스트 단계에서는 비용 걱정 없이 사용 가능.

6. 일기 작성 화면 UI
   1. 스마트폰의 갤러리를 연동하기 위한 라이브러리로 "expo-image-picker" 라이브러리를 사용할 것이다. `npx expo install expo-image-picker` 명령어로 모듈을 설치한다
   2. 코드에 image picker 연동부를 작성한다.
      ```
      import * as ImagePicker from 'expo-image-picker'; // ImagePicker import 추가

      export default function AddEntryScreen({ navigation }) {
          ...
            const handlePickImage = async () => {
                // 1. 미디어 라이브러리 접근 권한 요청
                const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();

                if (permissionResult.granted === false) {
                Alert.alert("권한 필요", "사진을 선택하려면 앨범 접근 권한이 필요합니다.");
                return;
                }

                // 2. 이미지 피커 실행
                const result = await ImagePicker.launchImageLibraryAsync({
                mediaTypes: ImagePicker.MediaTypeOptions.Images, // 이미지만 선택
                allowsEditing: true, // 편집 허용
                aspect: [1, 1],      // 1:1 비율로 크롭
                quality: 1,          // 최고 화질
                });

                // 3. 결과 처리
                if (!result.canceled) {
                // 선택된 이미지의 주소(uri)를 상태에 저장
                setImageUri(result.assets[0].uri);
                }
            };
      }
      ```
   3. 


7. 일기 저장 기능 구현
8. 캘린더 및 일기 보기
9. 클라이언트 측 암호화 적용하기
10. 사용자 정의 속성 추가 기능 만들기
11. 대시보드 및 그래프 시각화 구현하기
12. 지도 뷰 구현하기
13. 게이미피케이션(출석, 포인트) 적용하기





## Expo 사용법
- EAS : 원격 안드로이드 빌드 서비스를 제공하는 플랫폼이지만, 무료로 사용할 경우 대기시간이 매우 길다.
- `npx expo start --dev-client` : expo sersver 를 실행하는 명령어
- `npx expo start --clear` : cache를 제거하는 명령어. 실행후 서버 구동되면 Ctrl + c로 바로 종료
- `npx expo run:android` : 네이티브 코드를 포함하여 로컬에서 android 를 다시 빌드하는 명령어. native code가 포함된 라이브러리를 추가/삭제 할 경우 실행시켜줘야 하는 명령어다. 
  - `Exception thrown when executing UIFrameGuarded` 에러가 발새하고 각종 모듈이 부재하다는 오류가 뜨면 빌드를 다시 해보자.
- `eas build --profile development --platform android` : EAS 서비스를 사용해서 원격으로 안드로이드를 빌드하는 명령어
- `cd android; .\gradlew clean` : android 폴더 내에 gradlew와 관련된 캐시 데이터를 삭제하는 명령어
