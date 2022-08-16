+++
title = "Tailwind"
date = 2022-06-02T21:55:38+09:00
lastmod = 2022-06-02T21:55:38+09:00
tags = ["css",]
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

# Tailwind
- Css 프레임워크로 빠르고 효율적으로 css를 설정할 수 있는 툴이다.
- [Tailwind Docs](https://tailwindcss.com/docs)

## Installation
  - `npm install -D tailwindcss@latest` 명령을 사용하여 설치가 가능하다.
  - `npx tailwindcss init -P` 명령을 사용하면 tailwind.config.js 파일이 생성되며, 현재 위치에서 tailwind를 적용할 수 있게 된다.
    - tailwind.config.js 파일은 다음과 같이 구성된다.   

    ```
    module.exports = {
      // 포함할 항목
      content: ['./src/**/*.{html,js,jsx,ts,tsx, mustache}'],
      // 제외할 항목 (최신 버전에서 사용되지 않는 문법)
      // purge: ["./src/**/*.html", "./src/**/*.js"],
      // jit mode는 purge와 함께 세트로 사용되었고, 세트로 사라졌다.(?)
      // mode: process.env.NODE_ENV ? 'jit' : undefined,
      darkMode: 'class', // [false, 'mdeia', 'class']
      theme: {
        fontFamily: {
          display: ['Open Sans', 'sans-serif'],
          body: ['Open Sans', 'sans-serif'],
        },
        extend: {
          fontSize: {
            14: '14px',
          },
          backgroundColor: {
            'main-bg': '#FAFBFB',
            'main-dark-bg': '#20232A',
            'secondary-dark-bg': '#33373E',
            'light-gray': '#F7F7F7',
            'half-transparent': 'rgba(0, 0, 0, 0.5)',
          },
          borderWidth: {
            1: '1px',
          },
          borderColor: {
            color: 'rgba(0, 0, 0, 0.1)',
          },
          width: {
            400: '400px',
            760: '760px',
            780: '780px',
            800: '800px',
            1000: '1000px',
            1200: '1200px',
            1400: '1400px',
          },
          height: {
            80: '80px',
          },
          minHeight: {
            590: '590px',
          },
          backgroundImage: {
            'hero-pattern':
              "url('https://demos.wrappixel.com/premium-admin-templates/react/flexy-react/main/static/media/welcome-bg-2x-svg.25338f53.svg')",
          },
        },
      },
      plugins: [],
    };
    ```

  - tailwind는 react와 같은 framework에서는 자동으로 적용이 가능하지만, 그 외의 경우에는 postcss 등과 같은 모듈의 도움이 필요하다.  

  1. postcss
     - `npm install -D postcss postcss-cli` : postcss 모듈과, 명령어 입력을 위한 postcss-cli를 설치한다. 이후 cmd창에 postcss 명령어가 동작한다.  
     - `postcss SOURCE_FILE -o OBJECT_FILE` : SOURCE_FILE 의 내용을 참조하여 OBJECT_FILE 경로에 파일 생성. SOURCE_FILE의 내용은 아래와 같다.   
        ```
        @tailwind base;
        @tailwind components;
        @tailwind utilities;
        ```
     
     - `--watch` 옵션을 붙이면 파일 변경시 다시 빌드하지 않아도 된다.
    
  1. script
     - package.json 파일에 다음 스크립트를 작성한다. 이후 `npm run build:postcss` 명령으로 세팅을 할 수 있다. 
        ```
        "scripts": {
          "build:postcss":"npx cross-env NODE_ENV=production postcss base.tailwind.css -o target/classes/static/css/tailwind.css",
          "watch:postcss":"npx cross-env NODE_ENV=production postcss base.tailwind.css -o src/main/resources/static/css/tailwind.css -w"
        }
        ```

      - tailwind를 적용할 파일들을 앞서 tailwind.config.js 파일에서 'content' 항목에 넣어 지정했었다. 이 파일들에 새로운 class를 사용하였다면 postcss 명령으로 새로 build를 해줘야 한다.
      - build가 아닌 watch를 사용했다면 실시간으로 변경점이 적용된다.


1. Config
   - Project root 경로에 tailwind.config.js 파일에서 tailwind에 사용되는 custom 설정을 할 수 있다.   
     1. font
         - theme.extend.fontFamily에 사용할 font 이름을 정의하고, 
       
           ```
            theme: {
              extend: {
                fontFamily: {
                  body: ['Nunito'],
                }
              }
            },
           ```
        - 빌드할 tailwind.css 원본 파일에 해당 font가 정의된 url을 import한다.
        - [google에서 지원하는 font 사이트](https://fonts.google.com/) 에서 font들 import 가능

           ```
           @import url('@import url('https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200;1,200&display=swap');')
           @tailwind base;
           @tailwind components;
           @tailwind utilities;
           ```

## Classes
- tailwind에서 사용되는 대표적인 Class들에 대해 사용법을 설명한다.

### Box
1. flex
   - flex는 특정 tag 안의 내용물들을 가로로 정렬시켜준다.
       ```
         <div class="flex">
         <div>1</div>
         <div>2</div>
         <div>3</div>
         </div>
       ```

### 위치 정렬
- 위치는 `content`, `item`, `self` 세 가지에 대해 정렬이 가능하다.
- y축 정렬(위아래)은 `align`으로 하고, x축 정렬(좌우)은 `justify`로 한다.

1. justify content: 가로방향 정렬
   - `justify-start`: 좌측 모서리 기준 정렬
   - `justify-end`: 우측 모서리 기준 정렬
   - `justify-center`: 가운데 정렬
   - `justify-between`: 컨테이너 좌우 공간 없이 각 항목들 동등 간격으로 배치
   - `justify-around`: 컨테이너 좌우도 공간을 넣으며 항목들 좌우에 일정한 margin을 두고 배치
   - `justify-evenly`: 컨테이너 좌우를 포함하여 항목들 사이 간격이 동일하도록 배치
   
1. align items: 세로방향 정렬
   - `items-start`: 위쪽 모서리를 기준으로 정렬
   - `items-end`: 아래쪽 모서리를 기준으로 정렬
   - `items-center`: 정중앙 가로선을 기준으로 정렬
   - `items-baseline`: container의 baseline, 즉 내용물이 표시되는 기준점이 서로 통일되도록 정렬
   - `items-stretch`: 가장 긴 항목에 맞게 다른 항목들을 늘려서 정렬

### Responsive items
- 화면 크기에 따라 다르게 Css를 다르게 적용하고 싶다면, `sm:`, `md:`, `lg:`, `xl:`, `2xl:` class를 이용하면 된다.
- 기본 설정으로는 각각 640px, 768px, 1024px, 1280px, 1536px 이상일 때 특정 속성을 갖도록 설정할 수 있다.
- 아무것도 붙이지 않으면 0~640px의 속성을 정의하며, 더 큰 화면에 대해서는 `sm`, `md` 등으로 속성을 덮어쓰는 형식으로 반응형 페이지를 만든다.   
  - `  ` : 0px ~ 640px
  - `sm` : 640px ~ 768px
  - `md` : 768px ~ 1024px
  - `lg` : 768px ~ 1024px
  - `xl` : 1024px ~ 1280px
  - `2xl` : 1280px ~ 1536px

   ``<h1 class="text-sm md:text-lg lg:text-xl"> test </h1>``
     - 화면 크기에 따라 글자 크기가 바뀌는 예시

## Refs
