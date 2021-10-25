+++
title = "Kivy"
date = 2021-09-09T18:43:28+09:00
lastmod = 2021-09-09T18:43:28+09:00
tags = ["python", "kivy", "gui",]
categories = ["dev",]
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

#kivy

## Basic concepts
1. Widget
- 어플리케이션을 구성하는 객체
- widget은 다른 widget을 tree형태로 포함 가능하며 버튼, 라벨 등상호작용 가능한 객체 또는 Widget의 집합
- 위치는 좌표로 표현되는데 좌표는 좌측하단이 (0,0)이다.

2. Layout
- 화면 구성을 설정한 요소
- widget 혹은 layout을 포함 가능하다.

3. structure
- main.py에 python으로 내용을 작성한다.
```
class TheLabApp(App):
pass
TheLabApp().run()
```
- main.py에서 선언한 class 'TheLabApp' 에서 App을 뺀 TheLab을 따서 main.py와 같은 경로에 'TheLab.kv'파일을 생성한다.
```
/
|-main.py
|-TheLab.kv
```
- .py파일에서 원하는 layout class를 상속받아 객체를 구성할 수도 있고, .kv파일에서 바로 작성할 수도 있다.
- 단, .kv파일에서 객체를 생성하려면 .py파일에 정의된 class를 사용해야 한다.
- `<EXAMPLE@BoxLayout>` 와 같이 .py파일의 class 선언을 생략하고 default 객체를 사용하는 방법도 있다.

```
///////// .py /////////
class Box(BoxLayout):
  pass
///////// .kv /////////
<Box>: # .py에서 정의된 Box객체를 사용 가능
  GridLayout:  # 이후부터는 kivy에서 제공하는 객체들 사용 가능
    label:
      text:"lb"

<Box2@BoxLayout>: # .py파일에서 아무것도 하지 않는 객체를 선언하기 싫을 때 사용
///////////////////////
```
 - ex) class 안에서 속성 설정 :`self.orientation = "vertical"`
 - ex) kv파일에서 속성 설정 : `orientation: "vertical"`
- `<NAME>`형태로 선언한 객체는 다른 객체에서 사용할수 있게 된다.

```
<Box>:
  ...
<Box2>:
  Button:
    ...
  Box:  # 사용자 정의 객체
    ...
```
> - .kv파일은 아래와 같이 구성된다.
> - 화면을 구성하는 내용들의 속성을 정의하고 배치할 수 있다.
> ```
 MainWidget:         # 화면에 표기할 객체(widget, layout, ...)
 <MainWidget>:       # widget 정의
   Button:           # widget 내부 항목 선언, kivy에서 지원하는 객체의 종류
     text:"A"
   Button:
     text:"B"
> ```
> - .py파일에서도 화면을 구성할 수 있다.
> ```
class LayoutExample(BoxLayout): # BoxLayout은 기본적으로 가로로 구성된다.
  def __init__(self, **kargs):  
      super().__init__(**kargs)
        b1 = Button(text="A") # 객체를 생성
        b2 = Button(text="B")
        self.add_widget(b1)   # 객체를 layout에 추가
        self.add_widget(b2)
> ```
-----
## Usage

### layout
1. BoxLayout
 - 가로 혹은 세로로 차곡차곡 쌓아가는 레이아웃
2. AnchorLayout
 - 화면의 각 모서리, 꼭지점, 정중앙 총 9개의 위치를 지정할 수 있는 레이아웃
3. GridLayout
 - n행m열의 그리드를 나누고, 내용을 채우는 레이아웃
4. StackLayout
 - n행m열의 표에 좌측상단부터 차곡차곡 쌓아가는 레이아웃. BoxLayout의 2차원형태
5. ScrollView
 - 상하 또는 좌우로 스크롤이 가능한 화면
6. PageLayout
 - 디스플레이간 slide를 통해 이동이 가능한 레이아웃
7. FloatLayout
8. RelativeLayout
9. ScatterLayout

#### Commons
- `size_hint` : 레이아웃 내 객체의 비율 설정
 - layout 안의 객체는 size 조절이 불가능하다. (`size:` 설정 해도 적용 안됨) `size_hint` 값이 default로 설정되어있기 때문이다.
 - `size_hint`값이 적용된 객체는 화면 크기에 따라 객체 크기도 함께 변경된다.
 - `size_hint`값은 default 1,1로 설정되어있다.
 - `size_hint: None, None`으로 설정한다면 `size:` 값을 설정할 수 있다. (화면 크기에 상관없이 고정된 크기를 가질 수 있게 된다.)
 ex)
 - `spacing:"10dp"` : layout내부 요소간 간격 설정

#### BoxLayout
- `orientation: "vertical"`: 세로정렬(가로 : "horizontal")
```
<BoxLayoutSample>:
    orientation: "vertical"
    Button:
    # 배정받은 크기에 대해 가로비율 50%, 세로비율 60%로 설정.
        text: "b1"
        size_hint: .5, .6
```

#### AnchorLayout
- `ahcnor_x:"center"`: x축 정렬 위치, `left, right, center` 가능, default `center`
- `ahcnor_y:"center"`: y축 정렬 위치, `top, bottom, center` 가능, default `center`
- 객체를 순서대로 쌓는것이 아니라 지정한 자리에 그대로 넣는것이므로, 이전 객체는 이후에 나오는 객체에 덮어씌워질 수 있음

```
<AnchorExample>:
    Button:
        text:"btn"
        size_hint: .2, .2
        pos_hint:{"X":.1, "Y": .1}
    Button:
        text:"btn2"
        size_hint: .1, .1
        pos_hint:{"X":.5, "Y": .5}

```

#### GridLayout
- `rows`: Grid의 행 개수를 선언한다. default 1
- `cols`: Grid의 열 개수를 선언한다. default 1
- `size_hint`로 내부 요소의 비율을 조절하고 싶을 때, 같은 행/열에 속한 값들도 모두 같은 값으로 설정해야 적용이 된다.
- 설정한 Grid를 초과하는 객체를 선언하면 Widget에서 객체를 생성한것으로 취급된다.
```
<GridExample@GridLayout>:
    rows: 2
    cols: 3
    Button: # 0,0
        text: "btn"
        size_hint: .5, 1  # 비율 조정
    Button: # 0,1
        text: "btn"
        size_hint: None, 1
        width:"100dp" # 고정된 크기
    Button: # 0,2
        text: "btn"
    Button: # 1,0
        text: "btn"
        size_hint: .5, 1
    Button: # 1,1
        text: "btn"
        size_hint: None, 1
        width:"100dp" # 고정된 크기
    Button: # 1,2
        text: "btn"
    Button: # out of bound
        text: "btn"
        pos:100, 200
```

#### StackLayout
- 내부 객체들을 가로 한줄로 나열한다. 한 줄에 있는 객체들의 비율이 100%를 넘어가면 다음줄부터 객체를 채워넣는다.
- 가로 혹은 세로는 가장 큰 크기의 객체에 맞춰져 grid형식으로 정렬된다.
```
<StackExample>:
Button:
    text:"btn"
    size_hint: .3, .3
Button:
    text:"btn"
    size_hint: .3, .4
Button:
    text:"btn"
    size_hint: .3, .5
Button:                 # 가로비율이 1을 넘어가기때문에 줄바뀜됨
    text:"btn"
    size_hint: .3, .5
Button:
    text:"btn"
    size_hint: .4, .5
Button:
    text:"btn"
    size_hint: .3, .5
Button:                 # 세로 비율상으로 1을 넘어가기 때문에 화면 밖으로 나가서 보이지 않음
    text:"btn"
    size_hint: .3, .5
```
- 고정된 크기로 wiwdget을 추가하면 화면 크기가 변함에 따라 widget의 행,열이 변경된다.    
- class로 설정을 할 수도 있다. 이때 class의 __init__에 설정한 내용이 .kv파일에서 설정한 내용보다 우선하여 적용된다.

```
class StackExample(StackLayout):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        for i in range(0, 10):
            size = dp(100)  # dp로 크기 선언법
            b = Button(text=str(i + 1), size_hint=(None, None), size=(size, size))  # 버튼 세팅
            self.add_widget(b)  # layout에 widget 추가
```

-----
### Widgets
- 기본크기 100 X 100, 기본위치 (0,0) 이다.

#### Commons
- `pos_hint`: 정렬 위치
  - `size_hint`등으로 비율을 조절하면 기본적으로 좌측 상단으로 정렬이 된다.
  - 이때, 다른 방향으로 정렬을 하려면 `pos_hint:{"x":.5, "y":.5}`와 같이 설정 가능하다.
  - `pos_hint:` 다음에는 dictionary가 와야하며, 두 개의 항목이 들어간다.
  - 첫번째 인자는 "x", "center_x", "right" 중 하나를 사용하며,
  - 두번째 인자는 "y", "center_y", "top" 중 하나를 사용한다.

```
pos_hint:{"x":.5} # 좌측부분을 50%위치로 설정
pos_hint:{"center_x":.5} # 중앙을 50%위치로 설정
pos_hint:{"right":.5} # 우측부분을 50%위치로 설정
```

#### Button
- 텍스트, 크기, 위치를 지정한 버튼
- 아래쪽에 있는 내용이 나중에 그려져 이전 내용을 덮어씌운다.

```
MainWidget:

<MainWidget>:
# 고정 크기를 가진 버튼
  Button:
    text: "Hello"
    size: 400, 200
    pos: 100, 200
# 기기 화면 크기에 따른 크기와 위치를 가진 버튼
  Button:
    text: "hello2"
    size: "400dp", "200dp"
    pos: "100dp", "200dp"
```

#### lalbel
- 텍스트, 크기, 위치, 글자색을 지정한 레이블

```
MainWidget:

<MainWidget>:
  Label:
    text: "Hello"
    size: "100dp", "80dp"
    pos: "100dp"
    color: 1, 2, 3, 1 # r, g, b, a
```
-----
## 기타
- .kv파일에서 동일한 이름의 객체를 여러개 정의하면, 하나의 정의로 보고 내용을 이어붙인다.

```
<BoxLayoutSample>   # layout 정의
    Button:
        text:"A"
        size_hint: ".1"
  ...

<BoxLayoutSample>   # 동일한 이름의 layout 정의
  Button:
      text:"B"      #버튼 B는 버튼 A 다음에 생성됨
      size_hint: ".1"
```

- .py 에서 class를 선언하고, .kv파일에서 해당 class를 사용한다면, .py의 __init__() 함수가 먼저 호출된 후 .kv파일에서 세팅한 내용이 적용된다.


## 참조
[유튜브 강의](https://youtu.be/l8Imtec4ReQ?list=PLXb1UadfFv1Ff9h4zrbkAaNzPHSc-fb4w)
import:
```
from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.widget import Widget
```
