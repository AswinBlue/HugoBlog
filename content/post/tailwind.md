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

1. 설치
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
