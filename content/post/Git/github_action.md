---
title: "Github Action"
date: 2025-07-19T22:20:09+09:00
lastmod: 2025-07-19T22:20:09+09:00
tags: ['git', 'github', 'github action', 'workflow', 'pipeline']
categories: ['dev', 'CI-CD', 'deploy']
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

# Github Action
Github action 을 통해 github 에 코드를 push 함과 동시에 docker를 구동시켜 작업을 동작시킬수 있다. 
이 문서는 React로 개발된 웹 애플리케이션을 GitHub Actions를 사용하여 **자동으로 빌드하고 GitHub Pages에 배포**하는 파이프라인 구축 과정을 안내한다. `main` (또는 `master`) 브랜치에 코드를 `push`하면 모든 과정이 자동으로 실행되도록 설정하는 것을 목표로 한다.

## 1. 사전 준비

배포 자동화를 설정하기 전, React 프로젝트와 GitHub 저장소에 몇 가지 준비가 필요하다.

### 1.1. `package.json` 설정

GitHub Pages는 보통 `https://<사용자명>.github.io/<저장소명>/` 형태의 하위 경로에 배포된다. React 앱이 CSS나 JS 파일을 올바르게 찾아오게 하려면 `package.json` 파일에 `homepage` 속성을 추가해야 한다.

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

참고: `"homepage":"/<배포될 저장소 이름>"` 형태로 작성한다.

### 1.2. 배포용 저장소 준비

이 가이드는 소스 코드 저장소와 빌드 결과물이 배포될 저장소를 분리하는 방식을 기준으로 한다. 

- 소스 코드 저장소: React 프로젝트 코드가 있는 곳 (예: AswinBlue/my_react_app_code)
- 배포용 저장소: 빌드 후 생성된 정적 파일(build 폴더)이 올라갈 곳. (예: AswinBlue/my_react_app_page)

## 2. GitHub Actions 설정

본격적으로 자동화 워크플로우를 설정하는 단계이다.

### 2.1. Personal Access Token (PAT) 생성

GitHub Actions 워크플로우가 배포용 저장소에 코드를 `push`하려면 권한이 필요하다. 이를 위해 개인용 액세스 토큰(PAT)을 사용한다.

1.  GitHub 우측 상단 프로필 > **Settings** > **Developer settings** > **Personal access tokens** > **Fine-grained tokens** 으로 이동한다. (classic 을 사용해도 무방)
    ![PAT 생성 시 예시](/IMAGE_DEV_TOOL_APP/1_create_pat_scope_1.png)
2.  **Generate new token** 버튼을 클릭한다.
3.  **Note**에 토큰의 용도(예: `ACTIONS_DEPLOY_KEY`)를 적는다.
4.  **Expiration**에서 토큰 만료 기간을 설정한다.
5.  **Repository access**에서 설정을 원하는 repository 를 선택한다.
6.  **Permission**에서 저장소의 어떤 권한을 부여할지 선택한다. (content 항목이 pull/push 관련 내용이다)

    ![PAT 생성 시 repo 스코프 설정](/IMAGE_DEV_TOOL_APP/1_create_pat_scope_2.png)

8.  **Generate token** 버튼을 누르고, 생성된 토큰을 **즉시 복사하여 안전한 곳에 보관**한다. 이 페이지를 벗어나면 다시 볼 수 없다.

> 더 알아보기: [개인용 액세스 토큰 관리하기](https://docs.github.com/ko/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

### 2.2. GitHub Secrets 등록

방금 생성한 PAT를 **소스 코드 저장소**에 안전하게 등록해야 한다.

1.  **소스 코드 저장소**의 github repository 페이지에 접속한 후 상단 메뉴의 **Settings** > 좌측 메뉴의 **Secrets and variables** > **Actions** 메뉴로 이동한다.
2.  `Secrets` 탭에서 **New repository secret** 버튼을 클릭한다.
3.  **Name**에 워크플로우에서 사용할 이름(예: `GH_PAGES_TOKEN`)을 입력한다.
4.  **Secret**에 복사해 둔 PAT 값을 붙여넣고 저장한다.

    ![GitHub Secret 등록 화면](/IMAGE_DEV_TOOL_APP/2_register_github_secret.png)

> 더 알아보기: [암호화된 비밀 사용하기](https://docs.github.com/ko/actions/security-guides/using-secrets-in-github-actions)

### 2.3. 워크플로우 파일 작성

이제 자동화 작업의 모든 단계를 정의하는 워크플로우 파일을 작성한다.

1.  **소스 코드 저장소**의 루트에 `.github/workflows` 폴더를 생성한다.
2.  해당 폴더 안에 `deploy.yml`과 같은 이름으로 YAML 파일을 생성하고 아래 내용을 붙여넣는다.

```yaml
# .github/workflows/deploy.yml
name: Build and Deploy to GitHub Pages

on:
  push:
    branches:
      - main # main 브랜치에 푸시될 때 실행

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest # 실행 환경
    steps:
      # 1. 소스 코드 체크아웃 (서브모듈 포함)
      - name: Checkout repository and submodules
        uses: actions/checkout@v4
        with:
          submodules: 'recursive'
          # private 서브모듈 접근 및 배포 권한을 위한 PAT
          token: ${{ secrets.GH_PAGES_TOKEN }}

      # 2. Node.js 환경 설정
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      # 3. 의존성 패키지 설치
      - name: Install dependencies
        run: npm install

      # 4. .env 파일 동적 생성 (필요 시)
      - name: Create .env file
        run: |
          echo "REACT_APP_ENV=${{ vars.REACT_APP_ENV }}" >> .env
          echo "REACT_APP_PAGE_NAME=${{ vars.REACT_APP_PAGE_NAME }}" >> .env
          echo "REACT_APP_KEY=${{ secrets.REACT_APP_KEY }}" >> .env

      # 5. React 앱 빌드
      - name: Build React app
        # CI=true 환경에서 경고를 에러로 처리하는 것을 방지
        env:
          CI: false
        run: npm run build

      # 6. 빌드 결과물을 다른 저장소로 배포
      - name: Deploy to external repository
        uses: peaceiris/actions-gh-pages@v4
        with:
          # 2.1 단계에서 생성한 PAT 시크릿
          personal_token: ${{ secrets.GH_PAGES_TOKEN }}
          # 빌드 결과물을 배포할 목적지 저장소
          external_repository: YOUR_GIT_NAME/TARGET_REPO_NAME
          # 빌드 결과물이 담긴 디렉터리
          publish_dir: ./build
          # 배포에 사용할 브랜치
          publish_branch: gh-pages
          # 커밋에 표시될 유저 정보
          user_name: 'github-actions[bot]'
          user_email: 'github-actions[bot]@users.noreply.github.com'
          # 커밋 메시지 설정
          commit_message: 'Deploy: ${{ github.event.head_commit.message }}'
```

---

## 3. 배포 확인

모든 설정이 완료되었다. 이제 배포가 잘 되는지 최종 확인이 필요하다.

### 3.1. 저장소 Pages 설정

빌드 결과물이 push될 **배포용 저장소**의 GitHub Pages 설정을 변경해야 한다.

1.  **배포용 저장소** (`YOUR_GIT_NAME/TARGET_REPO_NAME`)로 이동한다.
2.  **Settings** > **Pages** 메뉴로 이동한다.
3.  **Build and deployment** 항목에서 **Source**를 `Deploy from a branch`로 선택한다.
4.  **Branch**를 워크플로우에서 설정한 `gh-pages`로 선택하고 저장한다.

    ![GitHub Pages 설정 화면](/IMAGE_DEV_TOOL_APP/3_github_pages_settings.png)

> **참고**: 워크플로우가 최초로 성공적으로 실행되어야 `gh-pages` 브랜치가 생성된다. 만약 브랜치가 보이지 않는다면 워크플로우를 한 번 실행한 후 다시 시도한다.

### 3.2. `git push` 및 Actions 실행 확인

**소스 코드 저장소**의 `main` 브랜치에 코드를 `push`하면 워크플로우가 자동으로 실행된다.

1.  소스 코드 저장소의 **Actions** 탭으로 이동하여 워크플로우가 실행되는 과정을 실시간으로 확인할 수 있다.
2.  모든 작업이 성공적으로 완료되면 잠시 후 `https://<사용자명>.github.io/<배포용 저장소명>/` 주소에서 배포된 사이트를 확인할 수 있다.

    ![GitHub Actions 실행 성공 화면](/IMAGE_DEV_TOOL_APP/4_check_github_actions_run.png)

---

## 4. 참조

### 4.1. React 프로젝트 빌드시 `CI=true` 환경 변수와 경고 처리

GitHub Actions와 같은 CI 환경에서는 `CI` 환경 변수가 자동으로 `true`로 설정된다. Create React App은 이 환경에서 ESLint 경고(Warning)를 빌드를 중단시키는 에러(Error)로 취급한다. 이를 방지하려면 워크플로우의 빌드 스텝에 `env: CI: false`를 추가하여 이 기능을 비활성화할 수 있다. 하지만 가장 좋은 방법은 모든 경고를 수정하여 코드 품질을 높이는 것이다.

### 4.2. 주요 에러 해결 방안

* **`Module not found`**: `import` 경로의 파일명과 실제 파일명의 대소문자가 일치하는지, `export` 방식(`export default` vs `export const`)이 맞는지 확인한다.
* **`react-snap: No usable sandbox!`**: `react-snap`이 사용하는 내부 크롬이 Actions 환경의 권한 문제로 실행되지 못하는 에러. `package.json`에 아래 설정을 추가하여 해결한다.
    ```json
    "reactSnap": {
      "puppeteerArgs": ["--no-sandbox"]
    }
    ```
* **`npm audit` 취약점 경고**: `npm install` 시 발견되는 보안 취약점은 `npm audit fix` 명령어로 대부분 자동 해결할 수 있다.

### 4.3. GitHub Variables vs. Secrets (`.env` 생성 시)

* **Secrets**: 암호화되어 저장되며 워크플로우 로그에도 노출되지 않는다. API 키, 라이선스 키 등 민감 정보를 저장하기에 적합하다.
* **Variables**: 일반 텍스트로 저장된다. 배포 환경 이름(`production`, `development`) 등 민감하지 않은 구성 값을 저장하는 데 사용한다.
