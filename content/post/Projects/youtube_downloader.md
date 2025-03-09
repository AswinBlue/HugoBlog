---
title: "Youtube Downloader"
date: 2025-03-09T20:40:01+09:00
lastmod: 2025-03-09T20:40:01+09:00
tags: []
categories: []
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
# Youtoube Download
Window OS에서 Python으로 Youtube 영상을 다운로드 하는 방법

## 1. Python Code 작성

1. yt-dlp 패키지를 다운받는다.
  - `pip install yt-dlp` 명령으로 손쉽게 다운로드 가능하다.
  - github 주소는 다음과 같다. : https://github.com/yt-dlp/yt-dlp

2. 코드를 작성한다.
  - 아래는 샘플 코드이다. 

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
                    'download_archive': 'downloaded.txt',  # 다운로드 아카이브 파일 지정(미리 다운받은 항목들을 체크하여 중복으로 받지 않도록 하는 기록파일)
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',  # mp3포멧으로 변환
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

   - 다른것들은 수정할 필요 없고, `download_lists` 에 다운로드 할 Youtube 재생목록을 넣어준다.
     - `name` 에는 다운로드할 폴더의 이름을 적어준다.
     - `url` 에는 Youtube 재생목록의 url 을 기입한다. 
       - ![재생목록](/IMAGE_YOUTUBE_DOWNLOADER/image1.png)
       - 위 이미지에 보이는 화면에서 url 을 복사해서 붙여넣는다.

## 2. 코덱 다운

- ffmpeg 코덱을 다운받아야 하며, [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html) 에서 다운로드 가능하다.
- 실행 파일을 다운로드 받고, 환경 변수에 `bin/` 폴더 경로를 추가한다.
  - 환경변수 세팅은 Window 11 기준 아래 그럼처럼 '시작' 버튼에서 '환경' 이라는 글자를 입력해서 설정 창으로 진입할 수 있다.
  - ![환경변수](/IMAGE_YOUTUBE_DOWNLOADER/image2.png)

## 3. 실행

- 작성한 python 코드를 실행시키면 프로젝트 루트 경로에 download_lists.name 으로 설정한 폴더가 생성되고, 폴더 안에 download_lists.url 재생목록에 있는 음악들이 다운로드 된다.
- `downloaded.txt` 파일로 이미 다운받은 파일들을 체크하여 중복 다운로드를 수행하지 않는다. (python 코드에서 ydl_opt 변수 참조)

## Keep in mind

<aside>
☀️ 저작권이 있는 영상을 무단으로 배포하거나 상업적으로 사용하는 행위는 불법입니다.

</aside>


