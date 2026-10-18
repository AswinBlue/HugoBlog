---
title: "Hugo(PaperMod) 블로그 로컬 환경 구축부터 애드센스 연동 및 GitHub Actions 자동 배포까지"
description: "Go 및 Hugo Extended 버전 호환성 에러 해결, PaperMod 테마 커스텀, Google AdSense/AdFit 광고 슬롯 배치, GitHub Pages 자동 배포 CI/CD 파이프라인 구축 실전 가이드입니다."
slug: "hugo-papermod-blog-setup-adsense-github-actions"
date: 2020-05-10T12:23:13+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["DevOps"]
tags: ["hugo", "papermod", "github-actions", "ci-cd", "adsense"]
series: ["Hugo 블로그 실전 가이드"]
ShowToc: true
TocOpen: true
---

정적 사이트 생성기(SSG, Static Site Generator) 중에서도 Go 언어로 작성된 **Hugo**는 압도적인 빌드 속도(수백 페이지를 수초 내에 컴파일)와 풍부한 테마 생태계를 제공하여 개발자 기술 블로그 구축에 가장 널리 사용됩니다. 하지만 최신 테마를 적용하거나 애드센스 광고를 연동하고 GitHub Pages로 자동 배포 파이프라인을 구축하는 과정에서 라이브러리 버전 불일치나 CSS 렌더링 오류를 겪기 쉽습니다.

이 글에서는 Hugo(PaperMod 테마) 블로그의 로컬 환경 세팅부터 커스텀 광고 슬롯 배치, 그리고 GitHub Actions를 이용한 무중단 자동 배포 파이프라인 구축 및 대표적인 트러블슈팅 사례를 상세히 정리합니다.

---

## 1. Hugo 로컬 개발 환경 구축과 프로젝트 초기화

### 1.1. Go 및 Hugo Extended 설치
PaperMod와 같은 현대적인 테마는 Sass/SCSS 전처리를 요구하므로 반드시 **Hugo Extended 버전**을 설치해야 합니다.
- **Windows**: [Hugo Releases](https://github.com/gohugoio/hugo/releases)에서 `hugo_extended_..._windows-amd64.zip`을 다운로드하여 PATH 환경변수에 등록합니다.
- **Linux (Ubuntu)**: apt 패키지는 구버전이 설치될 수 있으므로 GitHub 릴리스의 `.deb` 바이너리를 직접 설치합니다.

### 1.2. 프로젝트 생성 및 테마 Submodule 연동
```bash
# 1. 신규 Hugo 사이트 생성
hugo new site HugoBlog
cd HugoBlog

# 2. PaperMod 테마를 Git 서브모듈로 추가
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/hugo-PaperMod

# 3. 설정 파일(config.yml) 구성
```

{{< ad-inarticle >}}

---

## 2. 레이아웃 커스텀과 광고(AdSense / AdFit) 슬롯 배치

### 2.1. 인아티클 광고 Shortcode 구성
본문 중간에 광고가 자연스럽게 노출되도록 `layouts/shortcodes/ad-inarticle.html` 파일을 생성하고 구글 애드센스 반응형 코드를 삽입합니다.

```html
<div class="ad-container" style="margin: 2.5rem 0; min-height: 250px; text-align: center; overflow: hidden;">
  <div style="font-size: 0.75rem; color: var(--secondary); margin-bottom: 0.5rem;">SPONSORED</div>
  <ins class="adsbygoogle"
       style="display:block; text-align:center;"
       data-ad-layout="in-article"
       data-ad-format="fluid"
       data-ad-client="ca-pub-XXXXXXXXXXXXXXXX"
       data-ad-slot="YYYYYYYYYY"></ins>
  <script>
       (adsbygoogle = window.adsbygoogle || []).push({});
  </script>
</div>
```
마크다운 본문 작성 시 원하는 위치에 `{{</* ad-inarticle */>}}` Shortcode를 삽입하면 지연 로딩 시 레이아웃 밀림(CLS) 없이 광고가 배치됩니다.

### 2.2. 사이드바 및 카카오 애드핏 연동
사이드바 배너를 추가할 때는 `themes/hugo-PaperMod/layouts/_default/baseof.html`의 grid 컨테이너 영역에 `sidebar.html`과 `adfit.html` partial을 배치하여 본문과 나란히 반응형으로 렌더링되도록 구성합니다.

---

## 3. GitHub Actions를 활용한 GitHub Pages 무중단 자동 배포

소스코드를 `master` 브랜치에 푸시하면 GitHub Actions 러너가 자동으로 사이트를 빌드하여 GitHub Pages로 호스팅하도록 워크플로우(`.github/workflows/hugo.yml`)를 구성합니다.

```yaml
name: Deploy Hugo site to Pages

on:
  push:
    branches: ["master"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.148.1
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4

      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb

      - name: Build with Hugo
        env:
          HUGO_ENVIRONMENT: production
        run: hugo --minify --config config.yml

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v3
```

---

## 4. 실무 트러블슈팅 가이드

### 4.1. 배포 페이지 CSS 깨짐 및 BaseURL 미스매칭
- **현상**: 로컬 `hugo server`에서는 스타일이 정상 적용되나 GitHub Pages 배포 후 CSS가 깨지고 민낯 HTML만 렌더링되는 현상입니다.
- **해결**: `config.yml`의 `baseURL`이 정확한 GitHub Pages 주소(`https://<ID>.github.io/<REPO>/`)로 설정되어 있는지 점검하고, `canonifyurls: true` 옵션을 활성화하여 상대 경로가 절대 URL로 온전하게 변환되도록 처리합니다.

### 4.2. Integrity 속성과 Minify 충돌 에러
- **현상**: `Failed to find a valid digest in the 'integrity' attribute for resource` 에러 발생.
- **해결**: `config.yml`의 `minify` 기능이 HTML/CSS 공백을 제거하면서 해시가 불일치하는 문제입니다. 템플릿 파일에서 `fingerprint` 함수를 호출하기 전에 `minify`를 선행 수행(`{{- $stylesheet := $stylesheet | minify | fingerprint -}}`)해야 합니다.

### 4.3. GitHub Actions 서브모듈 체크아웃 에러
- **현상**: `actions/checkout` 단계에서 `fatal: remote error: upload-pack: not our ref` 에러 발생.
- **해결**: 부모 저장소의 서브모듈 커밋 포인터가 원격 서브모듈에 푸시되지 않은 로컬 커밋을 참조할 때 발생합니다. 서브모듈 저장소를 먼저 원격에 푸시한 후 부모 저장소의 서브모듈 포인터를 갱신하여 커밋하십시오.