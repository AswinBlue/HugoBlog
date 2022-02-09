+++
title = "Tensorflow"
date = 2021-11-27T08:15:42+09:00
lastmod = 2021-11-27T08:15:42+09:00
tags = ["tensorflow", "deep learning", "python",]
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

#Tensorflow

## 설치
1. python과 pip를 설치한다.
2. `pip install tensorflow` 명령을 수행한다.
 - window에서 'client_load_reporting_filter.h' 파일을 찾지 못해 설치를 못했다면, path 경로가 너무 길어서 발생하는 오류이다.
 - 실행에서 `regedit`을 실행하고, 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem' 레지스트리를 찾아 값을 1로 세팅해준다.

### 연관 모듈
- 함께 쓰면 효율이 좋은 모듈들
1. matplotlib
2. numpy
3. keras (tensorflow 설치시 자동성치된다)

## 모델
- 딥 러닝을 위한 신경망 구조를 모델이라 한다

### 생성 방법
1. tensorflow.keras.Sequential : Sequential 함수를 이용하는 방법

2. functional approach : 직접 함수를 구성하는 방법
3. tensorflow.keras.Model : Model 클래스를 상속하고 재정의하여 사용하는 방법
