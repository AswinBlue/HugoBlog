---
title: "리눅스 멀티스레드 프로그래밍: POSIX pthread 동기화, Mutex, 조건 변수 및 TSD"
description: "리눅스 환경에서 POSIX pthread 라이브러리를 활용한 멀티스레드 프로그래밍의 기초부터 스핀락·슬립락 등 뮤텍스(Mutex) 동기화 원리, 조건 변수(Condvar), 데드락 방지, 재진입성(Reentrant)과 TSD 활용법까지 체계적으로 다룹니다."
slug: "linux-multithread-programming-pthread-mutex"
date: 2023-07-23T15:05:46+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["linux", "thread", "pthread", "concurrency", "mutex"]
ShowToc: true
TocOpen: true
---

# 리눅스 멀티스레드 프로그래밍 (POSIX pthread)

## 스레드의 기본 개념
- 스레드(Thread)는 프로세스 내에서 실행 흐름의 최소 단위로, **경량 프로세스(LWP, Light-Weight Process)**라고 부릅니다.
- 리눅스 커널은 내부적으로 스레드와 프로세스를 모두 동일한 `task_struct`로 관리하며, `ps -eLf` 명령어를 통해 동일한 PID 내에서 고유한 LWP(TID) 목록을 확인할 수 있습니다.
- 스레드는 프로세스의 코드, 데이터, 힙 세그먼트와 열린 파일 디스크립터 등의 자원을 전적으로 공유하며, 오직 자신만의 독립적인 레지스터 문맥과 스택(Stack) 영역만을 보유합니다.

### 프로세스와 스레드의 차이점
- **메모리 격리 vs 공유**: 프로세스는 `fork()` 이후 가상 메모리가 완전히 격리(COW)되지만, 스레드는 가상 메모리 공간을 공유하므로 전역 변수를 통한 상호 통신이 매우 빠릅니다.
- **에러 전달 방식**: 프로세스는 전역 변수 `errno`에 에러 코드가 저장되지만, 스레드는 스레드별 안전성을 위해 `pthread` 함수들이 에러 번호 자체를 리턴값으로 직접 반환합니다 (성공 시 0, 오류 시 양수 에러 코드).

## pthread 기본 API
컴파일 시에는 pthread 라이브러리 링크 옵션(`-lpthread`)을 반드시 지정해야 합니다.

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

void *thread_routine(void *arg) {
    int id = *(int *)arg;
    printf("스레드 실행 중: %d\n", id);
    pthread_exit((void *)100); // 스레드 정상 종료 및 결과 반환
}

int main(void) {
    pthread_t tid;
    int arg = 1;
    void *retval;

    // 1. 스레드 생성
    pthread_create(&tid, NULL, thread_routine, &arg);

    // 2. 스레드 종료 대기 및 자원 회수
    pthread_join(tid, &retval);
    printf("스레드 반환값: %ld\n", (long)retval);

    return 0;
}
```

- `int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine)(void *), void *arg)`: 새 스레드를 생성합니다.
- `int pthread_join(pthread_t thread, void **retval)`: 지정한 스레드가 종료될 때까지 대기하고 반환값을 회수하며 스레드 스택 자원을 정리합니다.
- `int pthread_detach(pthread_t thread)`: 스레드를 분리(Detached) 상태로 설정하여, 스레드가 종료되는 즉시 시스템이 자동으로 자원을 회수하도록 합니다 (`pthread_join` 불필요).
- `void pthread_exit(void *retval)`: 호출한 스레드만 명시적으로 종료합니다. 메인 스레드에서 `pthread_exit()`을 호출하면 프로세스 전체가 종료되지 않고 다른 워커 스레드들이 작업을 계속 수행할 수 있습니다.
- `pthread_t pthread_self(void)`: 현재 실행 중인 자신의 스레드 ID를 조회합니다.

## 동기화와 뮤텍스 (Mutex)
여러 스레드가 공유 메모리(전역 변수 등)에 동시에 접근하여 쓰기 작업을 수행하면 데이터 불일치(Race Condition)가 발생합니다. 이를 방지하고 **상호 배제(Mutual Exclusion)**를 보장하기 위해 뮤텍스를 사용합니다.

```c
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

pthread_mutex_lock(&mutex);
// 임계 영역 (Critical Section): 공유 자원 조작
pthread_mutex_unlock(&mutex);
```

### 뮤텍스 락의 종류와 내부 구현
C 언어 레벨에서는 Compare와 Swap을 단일 사이클로 처리할 수 없으므로, CPU 하드웨어의 원자적 어셈블리 명령어(`lock cmpxchgl`)를 기반으로 상호 배제를 구현합니다.

- **스핀 락 (Spin Lock)**: 락을 획득할 때까지 루프를 돌며 원자적 명령어로 플래그를 지속적으로 검사하는 바쁜 대기(Busy-Waiting) 방식입니다. 컨텍스트 스위칭 비용이 들지 않으므로 임계 영역이 극히 짧은 경우에만 유리합니다.
- **슬립 락과 Futex (Sleep Lock & Futex)**: 락 획득에 실패하면 스레드를 대기 상태로 전환(Sleep)하여 CPU 자원을 다른 프로세스에 양보합니다. 리눅스에서는 유저 공간과 커널 공간을 연계하는 고성능 원시 장치인 `futex`(Fast Userspace Mutex) 시스템 콜을 통해 대기 및 깨우기(`FUTEX_WAIT`, `FUTEX_WAKE`)를 수행합니다.
- **재귀 락 (Recursive Mutex)**: 동일한 스레드가 이미 잠근 뮤텍스를 중복 획득하려 할 때 데드락(Self Deadlock)이 발생하는 것을 방지하기 위한 락입니다.
  ```c
  pthread_mutexattr_t attr;
  pthread_mutexattr_init(&attr);
  pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
  pthread_mutex_init(&mutex, &attr);
  // 잠근 횟수만큼 동일하게 unlock을 호출해야 최종 해제됨
  ```

## 조건 변수 (Condition Variable)
특정 공유 데이터의 조건이 충족될 때까지 스레드를 효율적으로 대기시키고, 조건이 만족되었을 때 신호(Signal)를 보내 스레드를 깨우기 위한 동기화 도구입니다.

```c
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
int ready = 0;

void *producer(void *arg) {
    pthread_mutex_lock(&mutex);
    ready = 1;
    pthread_cond_signal(&cond); // 대기 중인 스레드에 알림
    pthread_mutex_unlock(&mutex);
    return NULL;
}

void *consumer(void *arg) {
    pthread_mutex_lock(&mutex);
    while (ready == 0) { // 가짜 깨어남(Spurious Wakeup) 방지를 위해 while 사용
        pthread_cond_wait(&cond, &mutex);
    }
    // 작업 수행...
    pthread_mutex_unlock(&mutex);
    return NULL;
}
```

### 조건 변수의 내부 동작 원리
`pthread_cond_wait(&cond, &mutex)`는 원자적으로 다음 순서로 동작합니다.
1. 현재 소유한 뮤텍스를 언락(`unlock`)합니다.
2. 스레드를 수면 대기 큐(Futex 대기)에 등록합니다.
3. 다른 스레드에서 `pthread_cond_signal()`이 호출되면 깨어납니다.
4. 함수에서 반환되기 직전에 다시 뮤텍스를 재획득(`lock`)합니다.

## 교착 상태 (Deadlock)와 예방
둘 이상의 스레드가 서로가 소유한 락을 교차 대기하면서 실행이 영구히 멈추는 상태를 교착 상태(Deadlock)라 부릅니다.
- **예방 기법**: 모든 스레드가 여러 뮤텍스를 획득할 때 항상 동일한 순서(Lock Ordering)로 획득하도록 설계하면 환형 대기(Circular Wait)가 차단되어 데드락을 완전히 예방할 수 있습니다.

## 재진입성 (Reentrancy)과 스레드 안전성
- **재진입 가능 함수(Reentrant Function)**: 여러 스레드가 동시에 진입하여 실행하더라도 상호 간섭 없이 안전한 동작을 보장하는 함수입니다.
- 함수 내부에서 정적 변수(Static)나 공유 전역 변수를 조작하면 비재진입(Non-reentrant) 함수가 됩니다.
- 예: `strtok()`은 내부 정적 포인터를 사용하므로 스레드에 안전하지 않으며, 컨텍스트 포인터를 인자로 전달받는 `strtok_r()`을 사용해야 합니다.

## 스레드 로컬 스토리지 (TSD / TLS)
- 스레드마다 독립적인 전역 변수 메모리 공간을 제공하는 기법입니다.
- 리눅스에서는 TSD(Thread Specific Data) API를 지원합니다.
  - `pthread_key_create(pthread_key_t *key, void (*destructor)(void *))`: 전역 키를 생성하고 소멸자 함수를 등록합니다.
  - `pthread_setspecific(pthread_key_t key, const void *value)`: 현재 스레드만의 동적 메모리 주소를 키에 바인딩합니다.
  - `pthread_getspecific(pthread_key_t key)`: 현재 스레드에 바인딩된 메모리 포인터를 획득합니다.
- C/C++ 표준 키워드로는 `__thread` (GCC) 또는 `thread_local` (C++11) 키워드를 변수 앞에 붙여 간단히 선언할 수 있습니다.