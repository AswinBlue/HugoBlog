---
title: "GitHub Actions를 활용한 React 앱 GitHub Pages 자동 빌드 및 배포 파이프라인"
date: 2025-07-19T22:20:09+09:00
lastmod: 2025-07-19T22:20:09+09:00
description: "React 웹 애플리케이션을 GitHub Actions CI/CD 파이프라인을 통해 외부 배포 저장소의 GitHub Pages로 자동 빌드 및 배포하는 단계별 설정과 트러블슈팅 가이드입니다."
slug: "github-actions-react-gh-pages-deploy-pipeline"
categories: ["Git"]
tags: ["github-actions", "ci-cd", "react", "github-pages", "devops", "automation"]
ShowToc: true
TocOpen: true
draft: false
---

# GitHub Actions: React 앱 자동 빌드 및 GitHub Pages 배포 파이프라인

React로 개발된 웹 애플리케이션을 GitHub Actions를 사용하여 **자동으로 빌드하고 GitHub Pages에 배포**하는 CI/CD 파이프라인 구축 과정을 안내합니다. `main` (또는 `master`) 브랜치에 코드를 `push`하면 모든 빌드 및 배포 과정이 자동으로 실행되도록 설정하는 것을 목표로 합니다.

## 1. 사전 준비

배포 자동화를 설정하기 전, React 프로젝트와 GitHub 저장소에 몇 가지 준비가 필요합니다.

### 1.1. package.json 설정

GitHub Pages는 기본적으로 `https://<사용자명>.github.io/<저장소명>/` 형태의 하위 서브 경로에 배포됩니다. React 앱이 번들링된 CSS나 JS 에셋을 올바른 경로에서 로드하도록 `package.json` 파일에 `homepage` 속성을 추가해야 합니다.

```json
{
  "name": "my-react-app",
  "version": "0.1.0",
  "private": true,
  "homepage": "/TARGET_REPO_NAME",
  "dependencies": {
    // ...
  }
}
```

참고: `"homepage":"/<배포될 저장소 이름>"` 형태로 작성합니다.

### 1.2. 배포용 저장소 분리

이 가이드는 소스 코드 저장소와 빌드 결과물이 배포될 저장소를 분리하여 관리하는 패턴을 기준으로 합니다:
- **소스 코드 저장소**: React 프로젝트 소스 코드가 위치하는 저장소 (예: `AswinBlue/my_react_app_code`)
- **배포용 저장소**: 빌드 후 생성된 정적 파일(`build` 폴더)이 배포 브랜치에 올라갈 대상 저장소 (예: `AswinBlue/my_react_app_page`)

---

## 2. GitHub Actions 워크플로우 설정

본격적으로 자동화 파이프라인을 구성합니다.

### 2.1. Personal Access Token (PAT) 생성

GitHub Actions 워크플로우가 다른 배포용 저장소에 빌드 결과물을 `push`할 수 있도록 권한이 부여된 개인용 액세스 토큰(PAT)을 발급받아야 합니다.

1. GitHub 우측 상단 프로필 > **Settings** > **Developer settings** > **Personal access tokens** > **Fine-grained tokens** (또는 Classic tokens)로 이동합니다.
   ![PAT 생성 시 예시](/IMAGE_DEV_TOOL_APP/1_create_pat_scope_1.png)
2. **Generate new token** 버튼을 클릭합니다.
3. **Note**에 토큰의 목적(예: `ACTIONS_DEPLOY_KEY`)을 입력합니다.
4. **Expiration**에서 토큰 만료 기간을 설정합니다.
5. **Repository access**에서 배포 대상 repository를 선택합니다.
6. **Permission**에서 저장소의 `Contents` 권한을 `Read and Write`로 설정합니다.
   ![PAT 생성 시 repo 스코프 설정](/IMAGE_DEV_TOOL_APP/1_create_pat_scope_2.png)
7. **Generate token** 버튼을 누르고, 생성된 토큰 값을 안전한 곳에 즉시 복사합니다.

### 2.2. GitHub Secrets 등록

발급받은 PAT를 **소스 코드 저장소**에 시크릿 변수로 등록합니다.

1. **소스 코드 저장소**의 GitHub 페이지 > **Settings** > **Secrets and variables** > **Actions** 메뉴로 이동합니다.
2. `Secrets` 탭에서 **New repository secret** 버튼을 클릭합니다.
3. **Name**에 워크플로우에서 참조할 이름(예: `GH_PAGES_TOKEN`)을 입력합니다.
4. **Secret**에 복사해 둔 PAT 값을 붙여넣고 저장합니다.
   ![GitHub Secret 등록 화면](/IMAGE_DEV_TOOL_APP/2_register_github_secret.png)

### 2.3. 워크플로우 파일 작성 (.github/workflows/deploy.yml)

자동화 작업의 각 단계를 정의하는 YAML 워크플로우 파일을 소스 코드 저장소의 `.github/workflows/deploy.yml` 경로에 생성합니다:

```yaml
name: Build and Deploy to GitHub Pages

on:
  push:
    branches:
      - main # main 브랜치 푸시 시 자동 실행

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      # 1. 소스 코드 체크아웃 (서브모듈 포함)
      - name: Checkout repository and submodules
        uses: actions/checkout@v4
        with:
          submodules: 'recursive'
          token: ${{ secrets.GH_PAGES_TOKEN }}

      # 2. Node.js 런타임 환경 설정
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      # 3. 의존성 패키지 설치
      - name: Install dependencies
        run: npm install

      # 4. .env 파일 동적 생성 (필요 시 주입)
      - name: Create .env file
        run: |
          echo "REACT_APP_ENV=${{ vars.REACT_APP_ENV }}" >> .env
          echo "REACT_APP_PAGE_NAME=${{ vars.REACT_APP_PAGE_NAME }}" >> .env
          echo "REACT_APP_KEY=${{ secrets.REACT_APP_KEY }}" >> .env

      # 5. React 프로덕션 빌드
      - name: Build React app
        env:
          CI: false # 경고를 에러로 처리하지 않도록 방지
        run: npm run build

      # 6. 빌드 결과물을 배포 대상 저장소의 gh-pages 브랜치로 배포
      - name: Deploy to external repository
        uses: peaceiris/actions-gh-pages@v4
        with:
          personal_token: ${{ secrets.GH_PAGES_TOKEN }}
          external_repository: YOUR_GIT_NAME/TARGET_REPO_NAME
          publish_dir: ./build
          publish_branch: gh-pages
          user_name: 'github-actions[bot]'
          user_email: 'github-actions[bot]@users.noreply.github.com'
          commit_message: 'Deploy: ${{ github.event.head_commit.message }}'
```

---

## 3. 배포 확인 및 호스팅 설정

### 3.1. 저장소 Pages 브랜치 설정

빌드 결과물이 배포될 **배포용 저장소**(`YOUR_GIT_NAME/TARGET_REPO_NAME`)의 GitHub Pages 설정을 활성화합니다:
1. 대상 저장소의 **Settings** > **Pages** 메뉴로 이동합니다.
2. **Build and deployment** 항목의 **Source**를 `Deploy from a branch`로 선택합니다.
3. **Branch**를 워크플로우가 생성한 `gh-pages` 브랜치(`/(root)`)로 지정하고 저장합니다.
   ![GitHub Pages 설정 화면](/IMAGE_DEV_TOOL_APP/3_github_pages_settings.png)

### 3.2. git push 및 실행 확인

소스 코드 저장소의 `main` 브랜치에 코드를 푸시하면 **Actions** 탭에서 배포 파이프라인이 실행되는 과정을 실시간으로 확인할 수 있습니다. 완료 후 배포 주소(`https://<사용자명>.github.io/<저장소명>/`)에서 사이트 동작을 검증합니다.
![GitHub Actions 실행 성공 화면](/IMAGE_DEV_TOOL_APP/4_check_github_actions_run.png)

---

## 4. 실전 트러블슈팅 및 팁

### 4.1. CI=true 환경 변수와 빌드 경고 에러 처리
GitHub Actions와 같은 CI 환경에서는 기본적으로 `CI=true`가 강제 적용됩니다. Create React App은 사소한 ESLint 경고(Warning)도 치명적 에러로 간주하여 빌드를 중단시킵니다. 이를 방지하기 위해 빌드 스텝에 `env: CI: false`를 지정하거나, 소스 코드의 Lint 경고를 모두 수정하는 것을 권장합니다.

### 4.2. 주요 에러 해결 방안
- **Module not found**: 파일명 대소문자 불일치(Linux 환경은 대소문자를 엄격히 구분) 여부 및 export/import 구문 확인
- **react-snap 샌드박스 에러 (`No usable sandbox!`)**: Puppeteer 실행 권한 문제로 발생하므로 `package.json`에 아래 설정 추가:
  ```json
  "reactSnap": {
    "puppeteerArgs": ["--no-sandbox"]
  }
  ```
- **npm audit 취약점 경고**: `npm audit fix` 명령으로 보안 패키지 버전 갱신

### 4.3. GitHub Variables vs. Secrets 차이점
- **Secrets**: 마스킹 처리되어 로그에 노출되지 않으며 암호화 보관 (API 키, PAT 등 민감 정보)
- **Variables**: 평문으로 관리되며 설정값(도메인명, 환경 이름 등) 공유에 적합
