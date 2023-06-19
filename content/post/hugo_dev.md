+++
author = "AswinBlue"
title = "Hugo 환경세팅"
date = 2020-05-10T12:23:13+09:00
lastmod = 2020-05-10T12:23:13+09:00
tags = [
    "Hugo",
]
categories = [
    "dev",
]

cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
+++

# Hugo를 이용해 블로그 만들기

Git과 markdown을 이용하여 git을 블로그처럼 이용하는 사람들이 있다는 것을 알았다.

게다가 UI를 보기 좋게 꾸며줄 수 있는 툴들도 찾았는데, 그 중 Hugo를 사용해 보았다.


Hugo는 Go 언어로 짜여져 있어 apt-get으로도 설치가 가능하고, 소스 코드를 받아 빌드하여 쓸 수도 있다.

내 컴퓨터에는 Go가 이미 설치되 있던 터라 apt-get으로 hugo를 받아서 사용해 보았다.

설치는 정상적으로 되었고, 처음에는 잘 동작하는 듯 했는데, theme을 적용하니 ERROR들이 뜨기 시작했다.

인터넷 검색을 아무리 해 봐도 해결책이 보이지 않고, 해당 git에 issue를 날려보기도 했는데 응답이 없어서 혼자 이것저것 뒤져 보았다.

알고보니 내 hugo의 버전이 너무 낮아서 발생한 현상이었고, 덩달아 Go의 버전도 낮다는 것을 알아냈다.

Go언어는 apt-get 대신 인터넷에서 tar파일을 받아서 압축을 풀어 사용했고, Hugo는 소스코드를 받아 Go 언어로 빌드하여 사용하였다.

(brew를 이용해 보라고도 해서 brew를 설치 해 보기도 했는데, 잘 동작 하지 않아서 그만뒀다.)

버전을 최신으로 맞추고 나니 모두 정상동작, git에 올려놓은 issue를 뻘쭘하게 혼자 close했다.

-----

## 링크

1. hugo 환경설정 및 사용방법 가이드

	아래 주소의 글쓴이도 hugo로 블로그를 만들어 관리하고 있다. 이분의 글을 토대로 환경을 세팅했다.

	https://github.com/Integerous/Integerous.github.io

2. Hugo git 사이트

	Hugo의 소스파일을 다운받을 수 있다.

	https://github.com/gohugoio/hugo

3. 내가 사용한 theme의 git 주소

	설명대로 theme을 다운받고, config파일을 수정해 주어야 최종적으로 적용이 된다.

	https://github.com/cntrump/hugo-notepadium

4. Go 언어 설치 가이드

	https://golang.org/doc/install

5. Hugo 설치 가이드

	https://gohugo.io/getting-started/installing/

-----
## 환경 세팅 (window)
리눅스 환경세팅은 apt, yum을 이용하면 간단하게 수행 가능하여 생략한다.
1. Go 언어를 설치한다.
 - 설치파일로 받아서 설치하면 간단하다.
 - 리눅스에 설치할 경우, apt를 사용하면 낮은 버전이 설치될 수 있으니 코드를 받아 설치하는걸 추천한다.
2. Hugo를 설치한다.
 - 압축파일 형태로 제공되며, 압축을 푼 후 path 설정만 해주면 된다.
 - 리눅스의 경우 코드를 이용해 설치할 수 있다.
3. git 레퍼지토리를 2개 생성한다.
 - 한개는 글 작성용, 한개는 publish용이다. (이 경우, `<GITHUB_ID>.github.io` 이름으로 repository를 생성한다. 그렇지 않으면 정상동작하지 않는다.)   
 `ex) github.com/AswinBlue/AswinBlue.github.io`
 - 작성용은 소스코드에 해당하며 publish용은 컴파일된 바이너리에 해당한다고 보면 된다.
4. 로컬PC에서 Hugo 프로젝트를 생성한다.
 - `hugo new site <SITE>` 명령으로 새로운 hugo 프로젝트를 생성한다.
5. 생성한 프로젝트를 git과 연동시킨다.
 - 프로젝트 root디렉터리에 (3)에서 만든 소스용 git을 연동시킨다.
 - /public 디렉터리에 (3)에서 만든 publish용 git을 연동시킨다.
    - git 폴더 안에 git을 연동하려면 `git submodule add <URL>`명령어를 이용한다.
6. 테마를 선택한다. 
 - 인터넷에서 hugo 테마를 검색하여, 원하는 테마의 git repository를 `/themes` 경로에 clone 한다. 
 - 이후, 해당 테마에서 지원하는 config 파일을 root 경로에 복사한다.
   - config 파일은 toml, yaml, json 형태로 작성이 가능하며, hugo에서는 toml -> yaml -> json 순서대로 config파일을 찾아 적용한다. (즉, config.toml파일이 있으면 config.yml파일은 적용되지 않음)
7. 기본 탬플릿을 설정한다. 
 - `/archtypes/default.md` 파일을 수정하면, `hugo new NEW_POST.md` 를 이용해 새로운 파일을 생성할 때 사용되는 기본 md파일 탬플릿을 정의할 수 있다. 
   - 파일 생성시 .md 확장자가 붙여야 정상 동작함에 주의한다. 

## 기본 동작

1. 프로젝트 생성
- 새로운 Hugo 사이트를 생성하는 명령어, <NAME> 폴더 안에 Hugo 구조에 맞게 폴더 및 파일이 자동 생성된다.
	```
	hugo new site <NAME>
	```

- 생성된 <NAME> 폴더에서 새로운 post를 생성하는 명령어, content 폴더 안에 archtype에 맞게 내용을 적어 파일을 생성한다.
	```
	hugo new <POST>.md
	ex) hugo new post/hugo.md
	```

- 테마에 맞는 형식으로 content 폴더 안의 내용을 이용해 public 폴더 안에 내용을 생성한다. : `hugo -t <THEME>`  
- config파일에 따라 `hugo --config config.yml` 와 같이 명령어를 사용할 수도 있다.
  - config파일에서 baseURL 을 페이지 주소로 설정해야 css 및 javascript가 정상 동작 한다.
  - html에서 hugo문법으로 config파일에 선언된 baseURL을 가져오는 것은 `{{ .Page.Site.BaseURL }}` 와 같이 사용하면 된다.
- 본 페이지는 hugo-PaperMod 테마를 사용했다. 

- 문서 최상단에 +++로 둘러쌓인 부분은 설정 부분이다. draft=false로 설정을 해야 화면에 표시됨에 주의한다.
  - toml을 사용한다면 `+++`로 formatter를 구성 하고, yaml은 `---`, json은 `{}` 을 사용한다. 

- public 폴더에 생성한 내용을 push 하기 전 테스트 해 본다.
	```
	hugo server [--theme <THEME_PATH>]
	```
- 서버 실행 후 http://localhost:1313 경로에서 웹 브라우저로 내용을 확인할 수 있다.

- 내용이 완벽하다면 public 폴더 안의 git을 push 하면 `<GIT_ID>.github.io` 주소에서 방금 본 내용을 볼 수 있다. `ex : aswinblue.github.io`

- Go와 Hugo의 설치만 잘 하면 사용 가이드는 인터넷에 잘 정리된 글들이 많다. 참조하면 활용에 문제는 없을 것이다.

## 문법
1. Hugo 문법
 - hugo는 html 안에 `{{ }}` 형태로 hugo용 구문을 넣을 수 있다. `{{ }}`안에 `--`, `%%`, `<>` 를 넣어 용도에 따라 다양한 변형이 있을 수 있다.
   - `{{- }}`, `{{ -}}`, `{{- -}}` 를 사용하면 앞/뒤쪽의 줄바꿈 및 빈 여백을 모두 제거해 준다. 
2. 변수 선언
 - 변수는 site, page 에 따라 다르게 선언 할 수 있다. config.yml 파일에 선언하면 site 단위로 선언되며, 전역 변수처럼 모든 page에서 참조 가능하다. 
   - `.Params` 은 page 변수를 참조하며, `site.Params` 은 site 변수를 참조하는 방식이다. 
   - page 변수는 `hugo new` 를 사용하여 만든 각 페이지(.md파일) 최상단에 작성된 메타데이터(+++ 혹은 --- 로 감싸진 구역의 데이터)를 의미한다.
 - `{{- $isHidden := Params.cover.hidden | default site.Params.cover.hiddenInSingle | default site.Params.cover.hidden }}` : page 내에서 변수를 선언하는
3.  조건문
 - `{{- if (.Param "ShowToc") }}`  : page변수에서 ShotToc가 있는지 체크

4. RelPermalink vs Permalink
 - YOUR_CUSTOM_PATH.RelPermalink : baseurl을 / 로 처리한 링크 (/YOUR_CUSTOM_PATAH)
 - YOUR_CUSTOM_PATH.Permalink : baseurl을 앞에 붙인 링크 (https://localhost:1313/YOUR_CUSTOM_PATAH)

## Adsense 추가
- 구글 애드센스를 휴고 Blog에 넣고싶다면, 아래와 같은 절차를 거치면 된다.
	1. `themes/원하는_테마/layouts/partials/` 디렉터리 안에 `adsense.html` 파일을 만들고, 애드센스에 필요한 script를 붙여넣은 후 저장한다.
	2. `themes/원하는_테마/layouts/partials/` 디렉터리 안에 `head.html` 파일을 열고, `{{- partial "adsense.html" . -}}` 한줄을 추가하고 저장한다.
	3. `hugo -t 원하는_테마` 명령으로 다시 빌드하고, 서버에 push한다.

- sidebar 형태의 구문을 넣고싶다면, `baseof.html` 파일을 수정해야 한다. `<div class="grid-container">` 태그로 main을 감싸고, main과 sidebar을 동일한 level에 배치한다. 

```
# before
<main class="main">
    {{- block "main" . }}{{ end }}
</main>
```
```
# after
<div class="grid-container">
    {{ partial "sidebar.html" . }}
    <main class="main">
        {{- block "main" . }}{{ end }}
    </main>
</div>
```


## github page 자동화
github에서 제공하는 CI/CD 인 github actions 를 사용하면 push시 자동으로 배포를 할 수 있다.
1. github actions -> Categories:Pages -> Hugo 선택
2. 템플릿 파일로 `HugoBlog/.github/workflows/hugo.yml` 파일을 제공한다. 본인의 상황에 맞게 작성한 후 remote branch에 반영한다.

```
# Sample workflow for building and deploying a Hugo site to GitHub Pages
name: Deploy Hugo site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.108.0
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - name: Install Dart Sass Embedded
        run: sudo snap install dart-sass-embedded
      - name: Checkout
        uses: actions/checkout@v3
        with:
          submodules: recursive
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v3
      - name: Install Node.js dependencies
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      - name: Build with Hugo
        env:
          # For maximum backward compatibility with Hugo modules
          HUGO_ENVIRONMENT: production
          HUGO_ENV: production
        run: |
          hugo --minify --config config.yml
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: ./public

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```

## 오류 해결
### 배포 페이지 CSS 동작 오류
  - hugo server로 로컬에서 동작시키면 css가 정상적으로 나오지만, 배포한 github page에서 css가 제대로 동작하지 않는다면 stylesheet를 선언하는 부분(보통 theme/선택한_테마/layouts/partials/head.html에 있음) 에서 baseurl이 정상적으로 설정되었는지 확인한다. 
  - stylesheet는 `href="{{ $stylesheet.RelPermalink }}"` 와 같이 정상적으로 설정했는지 확인한다. (url을 직접 string으로 입력하기보다 url을 세팅해주는 함수를 사용하는것을 권장)
### Failed to find a valid digest in the 'integrity' attribute for resource
 - hugo에서 제공하는 `.Data.Integrity` 기능을 사용하여 html tag에 `integrity` 속성을 부여했을 경우 발생한다.  
 - config파일에서 minify 설정을 해 놓으면, 파일의 불필요한 줄바꿈, 공백을 제거하는데, minify 하기 전 값을 sha256으로 인코딩 하여, 결과가 틀려지는 것이다.    
 ```
 # minify 설정
 minify:
  disableXML: true
  minifyOutput: true
 ```

 - 위와 같은 설정이 config파일에 있다면, fingerprint를 사용하기 전에 minify를 먼저 수행하라. `{{- $stylesheet := $stylesheet | minify | fingerprint "sha256"}}`. fingerprint의 default값은 sha256이므로, sha256은 제거해도 무관

 
### github page 자동화 오류
1. `fatal: remote error: upload-pack: not our ref 7821df1a10579b4a62917f0f07d3a5c482e872f6`  
 - github actions/checkout@v3 에서 submodule의 특정 commit으로 checkout 이 안되는 현상이다. 
2. `render of "page" failed: "C:\HugoBlog\themes\hugo-PaperMod\layouts\_default\baseof.html:5:8": execute of template failed: template: _default/single.html:5:8: executing "_default/single.html" at <partial "head.html" .>: error calling partial: execute of template failed: template: partials/templates/opengraph.html:5:14: executing "partials/templates/opengraph.html" at <.Params.cover.image>: can't evaluate field image in type string`  
 - 빌드 했을 때 위와같은 오류가 발생 한다면, golang과 hugo 버전 차이에 따라 페이지가 파싱이 제대로 되지 않는 경우이다. hugo 문법에 따라 페이지를 수정하거나 golang, hugo 버전을 최신으로 업데이트 해 본다. 