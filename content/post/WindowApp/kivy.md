---
title: "Python Kivy 프레임워크를 활용한 크로스 플랫폼 GUI 앱 개발 기초"
description: "파이썬 기반 크로스 플랫폼 GUI 프레임워크인 Kivy의 핵심 아키텍처, KV 언어 선언 문법, 다양한 레이아웃(BoxLayout, GridLayout, StackLayout)과 위젯 배치, 크기/위치 힌트(size_hint, pos_hint) 활용법을 정리합니다."
slug: "python-kivy-cross-platform-gui-app-development"
date: 2021-09-09T18:43:28+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["WindowApp"]
tags: ["python", "kivy", "gui", "cross-platform", "app-development"]
ShowToc: true
TocOpen: true
---

Kivy는 Windows, macOS, Linux 데스크톱뿐만 아니라 Android, iOS 등 모바일 운영체제까지 단일 파이썬 코드베이스로 지원하는 오픈소스 크로스 플랫폼 GUI 프레임워크입니다. 멀티터치 인터페이스를 기본 지원하며, 고성능 그래픽 파이프라인(OpenGL ES 2)을 바탕으로 게임이나 반응형 터치 애플리케이션 개발에 적합합니다.

이 글에서는 Kivy의 기본 위젯 트리 아키텍처, 전용 UI 선언 언어인 KV 언어 문법, 주요 레이아웃(BoxLayout, GridLayout 등), 그리고 위젯의 크기/위치 제어 속성을 정리합니다.

---

## 1. Kivy 프레임워크 개요 및 기본 아키텍처

Kivy 애플리케이션은 화면을 구성하는 시각적 요소인 **위젯(Widget)**들의 계층적 트리 구조로 동작합니다.

### 1.1. 위젯 트리와 좌표계 시스템
- **좌표계 기준**: 일반적인 웹(좌측 상단 0,0)과 달리 Kivy는 화면의 **좌측 하단이 원점 `(0, 0)`**입니다. x축은 오른쪽으로 갈수록, y축은 위로 올라갈수록 증가합니다.
- **역할 분담**: 비즈니스 로직과 이벤트 처리는 파이썬(`.py`) 코드로 구현하고, 화면 UI 레이아웃과 스타일은 직관적인 KV 템플릿(`.kv`) 파일로 분리하여 관리합니다.

### 1.2. Python 메인 코드와 KV 언어 파일 네이밍 규칙
Kivy는 App 클래스 이름에서 `App`을 제외한 소문자(또는 원본 이름)와 일치하는 `.kv` 파일을 자동으로 찾아 로드합니다.

```python
# main.py
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout

class MainWidget(BoxLayout):
    pass

class TheLabApp(App):
    def build(self):
        return MainWidget()

if __name__ == "__main__":
    TheLabApp().run()
```
`TheLabApp` 클래스는 동일한 디렉터리에 위치한 `TheLab.kv` 파일을 자동으로 바인딩합니다.

---

## 2. Kivy 핵심 레이아웃(Layout) 종류와 특성

레이아웃은 자식 위젯들의 위치와 크기를 자동으로 계산하고 배치하는 특수 컨테이너 위젯입니다.

### 2.1. BoxLayout (선형 박스 정렬)
자식 요소들을 가로(`horizontal`, 기본값) 또는 세로(`vertical`) 방향으로 순차 적재합니다.

```yaml
# TheLab.kv
<MainWidget>:
    orientation: "vertical"
    spacing: "10dp" # 위젯 간 간격
    Button:
        text: "버튼 1"
        size_hint: 1, 0.5 # 가로 100%, 세로 50%
    Button:
        text: "버튼 2"
        size_hint: 1, 0.5
```

### 2.2. AnchorLayout (9방향 고정 배치)
화면의 모서리, 꼭짓점, 정중앙 등 9가지 기준점에 자식 위젯을 도킹할 때 사용합니다.
- `anchor_x`: `"left"`, `"center"`, `"right"` (기본값: center)
- `anchor_y`: `"top"`, `"center"`, `"bottom"` (기본값: center)

```yaml
<AnchorExample@AnchorLayout>:
    anchor_x: "right"
    anchor_y: "bottom"
    Button:
        text: "우하단 플로팅 버튼"
        size_hint: None, None
        size: "120dp", "60dp"
```

### 2.3. GridLayout (격자 행렬 배치)
지정된 행(`rows`)과 열(`cols`)의 격자 칸에 위젯을 순서대로 채워 넣습니다.
- `rows`, `cols` 중 최소 하나를 명시해야 합니다.
- 특정 칸의 크기를 조정하려면 해당 행/열의 다른 위젯들과 비율이 일치해야 왜곡 없이 렌더링됩니다.

```yaml
<GridExample@GridLayout>:
    cols: 3
    rows: 2
    Button:
        text: "1행 1열"
    Button:
        text: "1행 2열"
    Button:
        text: "1행 3열"
    Button:
        text: "2행 1열"
    Button:
        text: "2행 2열"
    Button:
        text: "2행 3열"
```

### 2.4. StackLayout (가변 줄바꿈 배치)
한 행에 위젯들을 가로로 나열하다가 너비가 100%를 초과하면 자동으로 다음 행으로 개행하여 배치하는 흐름형 레이아웃입니다.

---

## 3. 위젯 크기 및 위치 제어 속성 (`size_hint`, `pos_hint`)

Kivy 레이아웃 내부의 자식 위젯은 기본적으로 레이아웃의 제어를 받으므로 단순 `size`나 `pos` 속성은 무시될 수 있습니다.

### 3.1. 상대 비율 제어 (`size_hint`)와 고정 크기 (`dp`)
- **`size_hint` (기본값 `(1, 1)`)**: 부모 레이아웃 공간 대비 가로/세로 비율(0.0 ~ 1.0)을 지정합니다. 창 크기가 변경되면 위젯 크기도 유동적으로 반응합니다.
- **고정 크기 지정**: 화면 비율이 아닌 픽셀 단위 고정 크기를 적용하려면 반드시 `size_hint: None, None`을 선언한 뒤 `size: "width", "height"`를 부여해야 합니다.
- **디바이스 독립 픽셀 (`dp`)**: 해상도가 다른 다양한 모바일 기기에서 동일한 물리적 크기를 유지하기 위해 `dp` 단위를 사용합니다.

```yaml
Button:
    text: "고정 크기 버튼"
    size_hint: None, None
    size: "150dp", "50dp"
```

### 3.2. 상대 위치 제어 (`pos_hint`)
부모 컨테이너 내에서 위젯의 기준점 위치를 백분율 딕셔너리로 지정합니다.
- x축 키: `"x"` (좌측 기준), `"center_x"` (중앙 기준), `"right"` (우측 기준)
- y축 키: `"y"` (하단 기준), `"center_y"` (중앙 기준), `"top"` (상단 기준)

```yaml
Button:
    text: "화면 정중앙 배치"
    size_hint: 0.3, 0.2
    pos_hint: {"center_x": 0.5, "center_y": 0.5}
```

---

## 4. 핵심 위젯(Widget)과 파이썬 클래스 연동

### 4.1. Button 및 Label 위젯 선언
KV 언어에서는 위젯의 텍스트, 폰트 크기, 배경색, RGBA 텍스트 색상을 직관적으로 선언할 수 있습니다.

```yaml
<CustomWidget@BoxLayout>:
    orientation: "vertical"
    Label:
        text: "환영합니다!"
        font_size: "24sp" # 텍스트는 sp 단위 권장
        color: 0.2, 0.6, 1.0, 1.0 # R, G, B, A (0~1 범위)
    Button:
        text: "확인"
        on_press: root.on_button_click() # 상위 클래스 메서드 호출
```

### 4.2. Python 클래스와 생성자 실행 순서
Python 클래스에서 `__init__` 메서드가 실행된 이후 KV 파일에 정의된 속성들이 적용됩니다. 따라서 초기 동적 위젯 생성은 Python `__init__`에서 수행하고, 정적 디자인과 계층 배치는 KV 파일에 정의하는 것이 모범 사례입니다.
