---
title: "DevTool"
date: 2025-07-19T21:44:00+09:00
lastmod: 2025-07-19T21:44:00+09:00
tags: ['React',]
categories: ['dev', 'web']
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

# DevTool

**버전:** 1.0.0
**최종 수정일:** 2025년 7월 19일

## 1. 프로젝트 개요

### 1.1. 목적

**DevTool**은 개발자들이 일상적으로 사용하는 다양한 인코딩/디코딩, 포맷팅, 텍스트 비교 등의 작업을 하나의 통합된 웹 환경에서 빠르고 편리하게 수행할 수 있도록 설계된 온라인 유틸리티 모음입니다. 여러 웹사이트를 오가며 필요한 도구를 찾아야 하는 번거로움을 줄이고, 일관된 사용자 경험을 통해 개발 생산성을 높이는 것을 목표로 합니다.

### 1.2. 핵심 가치 및 철학

본 프로젝트는 다음의 핵심 가치를 기반으로 설계되었습니다.

* **클라이언트 측 연산 (Client-Side Processing)**: 모든 데이터 변환 및 계산은 사용자의 브라우저 내에서만 이루어집니다. 이를 통해 민감한 데이터가 서버로 전송되지 않아 **보안 및 프라이버시**를 보장하며, 서버 통신 없이 즉각적인 결과를 제공하여 **최상의 속도**를 경험할 수 있습니다.
* **반응형 및 모던 UI/UX**: 모든 기기에서 최적의 사용 경험을 제공하기 위해 반응형 디자인을 채택했습니다. 또한, 일관된 디자인 시스템과 직관적인 인터페이스를 통해 사용자가 별도의 학습 없이 즉시 도구를 사용할 수 있도록 설계되었습니다.
* **성능 최적화**: React의 `useMemo` 훅을 적극적으로 활용하여, 불필요한 리렌더링과 연산을 최소화했습니다. 사용자의 입력에만 반응하여 상태를 파생시키므로, 복잡한 연산에서도 높은 성능을 유지합니다.

### 1.3. 주요 기능

* **ASCII <> Hex Converter**: 아스키(ASCII) 문자열과 16진수(Hex) 값을 상호 변환합니다.
* **Base64 Encoder / Decoder**: 문자열을 Base64로 인코딩하거나 디코딩하며, 유니코드(UTF-8)를 완벽하게 지원합니다.
* **URL Encoder / Decoder**: URL 문자열을 안전하게 인코딩/디코딩하며, 전체 URI와 URI 컴포넌트 인코딩 방식을 모두 지원합니다.
* **JSON Inspector & Formatter**: JSON 데이터의 유효성을 검사하고, 원하는 포맷으로 정렬하며, 계층 구조를 시각적으로 탐색할 수 있는 트리 뷰를 제공합니다.
* **Text Diff Checker**: 두 개의 텍스트를 비교하여 차이점을 시각적으로 보여주며, 다양한 비교 옵션과 Patch 파일 생성 기능을 제공합니다.

### 1.4. 기술 스택

* **Frontend**: React.js
* **Styling**: Tailwind CSS
* **State Management**: React Context API, React Hooks (`useState`, `useMemo`, `useEffect`)
* **Routing**: React Router
* **Core Logic Library**: `diff` (for Text Diff Checker)
* **Deployment**: GitHub Pages (via GitHub Actions)

---

## 2. 시스템 아키텍처 및 설계

본 애플리케이션은 현대적인 프론트엔드 설계 원칙에 따라 구축되었습니다.

### 2.1. 컴포넌트 기반 아키텍처

React의 컴포넌트 기반 아키텍처를 채택하여 UI를 재사용 가능하고 독립적인 단위로 분리했습니다. `Sidebar`, `Navbar`, `AreaEditor`, `CheckboxOption` 등 공통 UI 요소들을 컴포넌트화하여 전체 애플리케이션의 일관성을 유지하고 유지보수성을 높였습니다.

### 2.2. 상태 관리 전략

* **전역 상태**: `sidebarActiveMenu`, `screenSize` 등 여러 컴포넌트에서 공유해야 하는 상태는 React Context API를 사용하여 중앙에서 관리합니다. 이를 통해 Props Drilling 문제를 해결하고 상태 관리 로직을 단순화했습니다.
* **지역 상태**: 각 도구 페이지의 입력값(`textA`, `textB` 등)과 같이 해당 컴포넌트 내에서만 사용되는 상태는 `useState` 훅을 사용하여 지역적으로 관리합니다.

### 2.3. 렌더링 최적화: 파생 상태와 메모이제이션

본 애플리케이션의 핵심 성능 최적화 전략은 **파생 상태(Derived State)를 `useMemo`로 관리**하는 것입니다.

사용자의 입력값(Input)을 제외한 모든 출력 결과(Output)는 상태(state)로 직접 저장되지 않습니다. 대신, 입력값과 옵션이 변경될 때만 관련 연산을 수행하여 결과를 계산하고 메모이제이션(Memoization)합니다. 이 방식은 불필요한 리렌더링과 복잡한 함수의 반복 실행을 방지하여 앱의 반응성을 극대화합니다.

### 2.4. 반응형 디자인

Tailwind CSS의 유틸리티 우선(Utility-First) 접근법과 반응형 접두사(`md:`, `xl:`)를 사용하여 모든 컴포넌트를 설계했습니다.

* **모바일 오버레이 패턴**: 화면이 좁을 때(모바일), 사이드바는 화면 위에 오버레이 형태로 부드럽게 슬라이드되며 나타납니다. 이때 메인 콘텐츠 영역은 반투명한 백드롭(Backdrop)으로 덮여 사용자 경험을 향상시킵니다.
* **유동적인 레이아웃**: 데스크탑 환경에서는 사이드바가 레이아웃의 일부가 되어 메인 콘텐츠와 나란히 배치됩니다. 모든 콘텐츠 영역은 고정 폭 대신 유동적인 `flex`와 `grid` 레이아웃을 사용하여 어떤 화면 크기에서도 자연스럽게 정렬됩니다.

---

## 3. 주요 기능 및 사용 방법

### 3.1. ASCII <> Hex Converter

ASCII 문자를 16진수 값으로, 또는 그 반대로 변환하는 도구입니다.

* **사용 방법**: 해당하는 입력창(ASCII 또는 Hex)에 값을 입력하면, 반대편 출력창에 변환된 결과가 실시간으로 표시됩니다.
* **옵션**:
    * **Hex to ASCII**: 출력되는 ASCII 문자 사이에 공백을 넣거나, 각 문자를 따옴표(`"`)로 감쌀 수 있습니다.
    * **ASCII to Hex**: 출력되는 16진수 값에 `0x` 접두사를 붙이거나, 각 값 사이에 쉼표(`,`) 또는 공백을 추가할 수 있습니다.

![ASCII-Hex Converter 사용 예시](/IMAGE_DEV_TOOL_APP/feature_ascii_hex.png)

### 3.2. Base64 Encoder / Decoder

텍스트 데이터를 Base64 형식으로 안전하게 인코딩하거나 디코딩합니다. 한글을 포함한 모든 유니코드(UTF-8) 문자를 깨짐 없이 처리합니다.

* **사용 방법**: 인코딩 또는 디코딩할 텍스트를 해당하는 입력창에 입력하면 결과가 즉시 출력됩니다.
* **옵션**:
    * **Encode**: 입력값이 16진수(Hex) 문자열일 경우, 이를 먼저 일반 텍스트로 변환한 후 Base64 인코딩을 수행할 수 있습니다.
    * **Decode**: 디코딩된 결과를 일반 텍스트가 아닌 16진수(Hex) 형식으로 출력할 수 있습니다. `0x` 접두사, 쉼표 등 다양한 서식 옵션을 제공합니다.

![Base64 인코딩/디코딩 화면](/IMAGE_DEV_TOOL_APP/feature_base64.png)

### 3.3. URL Encoder / Decoder

URL에 사용될 수 없는 문자(한글, 특수문자 등)를 `%` 문자를 사용하는 Percent-encoding 방식으로 변환합니다.

* **사용 방법**: 해당하는 입력창에 값을 입력하면 인코딩 또는 디코딩된 결과가 즉시 표시됩니다.
* **옵션**:
    * **Encode URI Component**: URL의 쿼리 파라미터 값과 같이 일부를 인코딩할 때 사용합니다. `&, =, ?` 등 URL 예약 문자까지 모두 변환합니다. **(권장)**
    * **Encode URI**: `http://`를 포함한 전체 URL을 인코딩할 때 사용하며, 예약 문자는 변환하지 않습니다.
* **에러 처리**: 잘못된 인코딩 문자열 입력 시, 앱이 멈추는 대신 "Malformed URI sequence" 에러 메시지를 표시하여 안정성을 확보했습니다.

![URL 인코딩/디코딩 화면](/IMAGE_DEV_TOOL_APP/feature_url.png)

### 3.4. JSON Inspector & Formatter

JSON 데이터의 구조를 분석하고 검증하며, 가독성을 높이는 다양한 기능을 제공합니다.

* **사용 방법**:
    1.  JSON 문자열을 입력창에 붙여넣습니다.
    2.  입력과 동시에 **유효성 검사**가 수행되며, 결과가 상단에 표시됩니다. 문법 오류 시, 에러 메시지를 통해 문제점을 알려줍니다.
    3.  **Indent 옵션**(2칸, 4칸, 탭 등)을 선택하여 원하는 포맷으로 정렬된 텍스트를 얻을 수 있습니다.
    4.  유효한 JSON일 경우, **Interactive Viewer**를 통해 계층 구조를 시각적으로 탐색하고, 각 노드를 접거나 펼 수 있습니다.

![JSON 유효성 검사 및 트리 뷰](/IMAGE_DEV_TOOL_APP/feature_json_viewer.png)

### 3.5. Text Diff Checker

두 개의 텍스트 블록을 비교하여 차이점을 시각적으로 명확하게 보여줍니다.

* **사용 방법**: 'Original Text'와 'Changed Text' 입력창에 각각 비교할 텍스트를 입력하면, 하단의 'Differences' 패널에 결과가 실시간으로 표시됩니다.
* **핵심 기능 (Side-by-Side 뷰)**: 추가되거나 삭제된 행이 있어도, 양쪽 텍스트의 줄 번호가 어긋나지 않도록 정렬하여 보여줍니다. 이를 통해 변경 사항을 직관적으로 추적할 수 있습니다.
* **옵션**:
    * **비교 단위**: 줄(Line), 단어(Word), 글자(Character) 단위로 비교 수준을 선택할 수 있습니다.
    * **무시 옵션**: 공백, 줄바꿈, 대소문자를 무시하고 비교할 수 있어 유연성을 높였습니다.
* **Patch 파일**: 두 텍스트 간의 차이점을 `Unified Diff` 형식의 Patch 파일로 생성하며, 클립보드에 복사하거나 `.diff` 파일로 다운로드할 수 있습니다.

![Side-by-Side Diff 비교 화면](/IMAGE_DEV_TOOL_APP/feature_diff_checker.png)

---

## 4. 결론 및 향후 계획

### 4.1. 요약

DevTool 프로젝트는 React와 Tailwind CSS를 기반으로 한 모던 웹 기술을 활용하여, 개발자들에게 필수적인 유틸리티들을 빠르고 안정적으로 제공하는 것을 목표로 성공적으로 구축되었습니다. 컴포넌트 기반의 확장 가능한 구조와 성능 최적화, 그리고 모든 기기를 아우르는 반응형 디자인은 본 프로젝트의 핵심적인 성과입니다.

### 4.2. 향후 개선 계획

* **도구 추가**: JWT 디코더, 타임스탬프 변환기, 정규식 테스터 등 개발자들이 자주 사용하는 도구들을 지속적으로 추가할 계획입니다.
* **사용자 설정**: 다크/라이트 모드, 선호하는 Indent 설정 등을 사용자가 저장하고 유지할 수 있는 기능 도입을 고려합니다.
* **PWA (Progressive Web App) 전환**: 오프라인에서도 일부 기능을 사용할 수 있도록 PWA로 전환하여 사용성을 극대화할 계획입니다.