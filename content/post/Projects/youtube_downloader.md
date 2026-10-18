---
title: "Python yt-dlp와 FFmpeg를 활용한 YouTube 재생목록 음원 다운로더 제작기"
date: 2025-03-09T20:40:01+09:00
lastmod: 2025-03-09T20:40:01+09:00
description: "Windows 환경에서 Python yt-dlp 라이브러리와 FFmpeg를 활용하여 YouTube 재생목록의 음원을 MP3로 일괄 추출하고 중복 다운로드를 방지하는 자동화 스크립트 구현기입니다."
slug: "python-yt-dlp-youtube-mp3-downloader"
categories: ["Projects"]
tags: ["python", "yt-dlp", "ffmpeg", "youtube-downloader", "automation", "portfolio"]
series: ["프로젝트 개발기"]
ShowToc: true
TocOpen: true
draft: false
---

# YouTube Downloader: Python과 yt-dlp를 활용한 YouTube 음원 다운로더 제작 문서

Windows OS 환경에서 Python과 `yt-dlp`를 활용하여 YouTube 재생목록 영상을 고음질 MP3 음원으로 일괄 추출하는 자동화 도구 제작 과정입니다.

## 1. Python 다운로드 스크립트 작성

1. yt-dlp 패키지 설치
   - `pip install yt-dlp` 명령으로 손쉽게 설치할 수 있습니다.
   - GitHub 저장소: https://github.com/yt-dlp/yt-dlp

2. 코드 작성
   - 아래는 재생목록 다운로드 및 재시도 로직을 포함한 전체 파이썬 스크립트 예시입니다.

    ```python
    import yt_dlp
    import os
    import time

    ##########
    # 설정
    ##########
    # 최대 재시도 횟수
    MAX_RETRIES = 3
    # 재시도 사이의 대기 시간 (초)
    RETRY_DELAY = 5
    # 다운로드 리스트
    download_lists = [
        {
            "name": 'FOLDER_NAME',  # 다운로드 받을 폴더 이름
            "url": 'https://www.youtube.com/watch?v=CJuIRe_1c2g&list=RDMM&start_radio=1&rv=R4CecLdF11E',  # 다운로드 할 playlist URL
        },
        {
            "name": 'SAMPLE2',
            "url": 'https://www.youtube.com/watch?v=66l5r_IEZrI&list=RDGMEMYH9CUrFO7CfLJpaD7UR85w&start_radio=1&rv=CJuIRe_1c2g',
        },
    ]

    ##########
    # 다운로드 시작
    ##########

    for idx, list in enumerate(download_lists):
        # '폴더이름/영상제목.확장자' 형식으로 다운로드
        output_dir = os.path.join(f'./{list["name"]}/', '%(title)s.%(ext)s')

        ydl_opt = {
            'outtmpl': output_dir,
            'format': 'bestaudio/best',  # 다운로드할 포맷 지정
            'download_archive': 'downloaded.txt',  # 다운로드 아카이브 파일 지정 (중복 다운로드 방지)
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',  # mp3 포맷으로 변환
                'preferredquality': '192',
            }],
            'verbose': True,  # 자세한 디버깅 정보 출력
            'ignoreerrors': True,  # 다운로드 오류 무시
        }

        for attempt in range(1, MAX_RETRIES + 1):
            try:
                with yt_dlp.YoutubeDL(ydl_opt) as ydl:
                    ydl.download([ list["url"] ])
                print(f'{list["name"]}:: 다운로드 완료')
                break
            except Exception as e:
                print(f'{list["name"]}:: 다운로드 실패 ({attempt}/{MAX_RETRIES}): {e}')
                if attempt < MAX_RETRIES:
                    print(f'{list["name"]}:: {RETRY_DELAY}초 후 다시 시도합니다...')
                    time.sleep(RETRY_DELAY)
                else:
                    print(f'{list["name"]}:: 최대 재시도 횟수를 초과했습니다. 다운로드를 중단합니다.')

    print('모든 항목 다운로드 완료')
    ```

   - `download_lists` 변수에 다운로드할 YouTube 재생목록을 등록합니다.
     - `name`: 음원이 저장될 로컬 디렉터리 이름
     - `url`: YouTube 재생목록 URL
     ![재생목록](/IMAGE_YOUTUBE_DOWNLOADER/image1.png)

## 2. FFmpeg 코덱 설치 및 환경 변수 설정

- 음원 추출 및 MP3 변환을 위해 FFmpeg 코덱 설치가 필요합니다. [FFmpeg 공식 다운로드 페이지](https://ffmpeg.org/download.html)에서 바이너리를 다운로드합니다.
- 다운로드한 압축을 풀고 `bin/` 폴더 경로를 시스템 환경 변수 `Path`에 추가합니다.
  - Windows 11 기준 시작 메뉴에서 '환경 변수'를 검색하여 '시스템 속성' -> '환경 변수' 메뉴에서 설정 가능합니다.
  ![환경변수](/IMAGE_YOUTUBE_DOWNLOADER/image2.png)

## 3. 스크립트 실행 및 결과 확인

- 작성한 Python 코드를 실행하면 프로젝트 루트 경로에 `download_lists.name` 폴더가 생성되고, 재생목록 내의 음원들이 MP3 포맷으로 다운로드됩니다.
- `downloaded.txt` 아카이브 파일에 다운로드 완료된 영상 ID가 기록되어 다음 실행 시 이미 다운로드된 항목은 자동으로 스킵됩니다.

## 4. 저작권 유의사항 (Keep in Mind)

> [!WARNING]
> 저작권이 있는 음원 및 영상 콘텐츠를 무단으로 배포하거나 상업적 목적으로 사용하는 행위는 법적 제재를 받을 수 있습니다. 본 스크립트는 개인적인 연구 및 오프라인 보관 목적에 한하여 사용해야 합니다.
