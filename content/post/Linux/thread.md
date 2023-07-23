---
title: "Thread"
date: 2023-07-23T15:05:46+09:00
lastmod: 2023-07-23T15:05:46+09:00
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

# Thread
- thread는 process의 경량화 버전으로 생각할 수 있다. 
- `pthread_create()` 함수로 `fork` 명령을 대체하고, `pthread_join()` 으로 `wait` 명령을 대체하면 process 대신 thread를 동작시킨다.
- thread는 함수를 실행시키는 것이 기본이며, 함수를 실행시킬 때 넣을 인자와, 함수의 리턴값을 받을 인자를 pthread_create의 파라미터로 받는다.
- 리눅스 프로세스 표시 목록에 `LWP(light-weight-process)` 항목으로 표시되며, proces ID가 같더라도 LWP ID가 다르면 같은 process 안의 thread인 것.
- `pthread_exit()` 로 thread만 종료시킬 수 있다. 
- main process가 종료되면 딸려있는 thread들도 함께 종료된다. 다만, main thread만 pthread_exit으로 종료시키면 process가 종료되지 않고 main thread만 종료되고 다른 thread들은 계속 구동되는 형태가 되므로 주의한다.

## process 와 thread 차이
- process는 메모리를 수정하는 순간 메모리가 분리되지만, thread는 메모리를 공유하여 수정하고 나서도 같은 영역을 참조할수 있다. (전체 가상메모리를 공유한다.)
- process는 wait 값의 인자를 확인 에러를 확인할 수 있는 반면, thread의 에러는 pthread_join의 return 값을 확인한다. (값이 0 초과이면 에러가 됨)
    - 일반적인 에러 처리는, `errno.h` 헤더파일에 `errno` 라는 변수가 전역변수로 선언되어 있고, 프로세스가 에러에 의해 종료될 경우 이 변수에 값을 채워넣는다.
    - thread는 전역변수를 공유하기 때문에 errno를 사용하지 않는 것

## Mutex
- 전역변수의 상호 참조 