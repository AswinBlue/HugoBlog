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
- `int pthread_join(pthread_t thread, void **retval)` : 자식 thread가 종료될 때 까지 대기하고, 종료처리를 해 주는 함수, `pthread_exit()`에서 반환된 값을 retval로 받아올수 있다.
- `pthread_detach(int tid)` : thread id가 tid에 해당하는 thread를 부모 thread에서 분리하는 함수. 이후 종료되고 join 처리를 대기하지 않고 바로 free됨.
- `int pthread_self()` : 자신의 thread id 를 확인할때 사용하는 함수

```
void* func(void* data)
{
    (struct ARG*) data;
    ...
    pthread_detach(pthread_self()); // pthread_join 대신 사용 가능
}

...
// thread 생성
struct ARG *arg;
int tid = pthread_create(&thread, 0, func, arg);
...
pthread_join(tid, 0); // pthread_detach 대신 사용 가능
...
```

## process 와 thread 차이
- process는 메모리를 수정하는 순간 메모리가 분리되지만, thread는 메모리를 공유하여 수정하고 나서도 같은 영역을 참조할수 있다. (전체 가상메모리를 공유한다.)
- process는 wait 값의 인자를 확인 에러를 확인할 수 있는 반면, thread의 에러는 pthread_join의 return 값을 확인한다. (값이 0 초과이면 에러가 됨)
    - 일반적인 에러 처리는, `errno.h` 헤더파일에 `errno` 라는 변수가 전역변수로 선언되어 있고, 프로세스가 에러에 의해 종료될 경우 이 변수에 값을 채워넣는다.
    - thread는 전역변수를 공유하기 때문에 errno를 사용하지 않는 것

## Mutex
- 전역변수의 상호 참조에 의해 발생하는 race condition 문제를 해결하기 위해 사용할 수 있는 방법
  - race condition : 둘 이상의 thread가 전역변수를 참조할 때 메모리 접근하려 서로 경쟁하는 상황
- `pthread.h` 헤더를 사용하며, pthread 라이브러리를 사용하기 떄문에 빌드시 옵션에 `-lpthread`를 추가해준다.
```
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
...
pthread_mutex_lock(&mutex);
// 전역변수 참조 영역
pthread_mutex_unlock(&mutex);
```
- mutex를 사용해 임계 영역(critical section)에 대해 mutual exclusion 속성을 보장하여 동시 접속에 의한 오동작을 막을 수 있다.

### Mutex 내부 구조
- C언어로는 compare와 set을 atomic하게 수행할 수 없어 mutual exclusion을 구현할 수 없다. 
- cas(compare and set) 라는 코드를 어셈블리어에서 지원하는데, compare와 set을 atomic하게 처리할 수 있다. 
- 아래 함수는 어셈블리어를 사용하여 C에서 cas를 구현한 내용이다. cpu 칩마다 지원하는 형태가 다를 수 있음에 주의한다. (아래는 인텔이 제공하는 형태)
```
typedef int int32_t;
int mutex = 0; // 초기값 0
/**
 * @brief   old_value와 *ptr을 비교하여 같다면 *ptr에 new_value를 대입한다.
 *          mutex lock의 역할을 한다. 
 * @return  int old_value와 *ptr의 비교 결과가 같다면 false를, 다르다면 true를 반환
 */
int __bionic_cmpxchg(int32_t old_value, int32_t new_value, volatile int32_t* ptr)
{
    int 32_t prev;
    __asm__ __volatile__ ("lock; cmpxchgl %1, %2"
            : "=a" (prev)
            : "q" (new_value), "m" (*ptr), "0" (old_value)
            : "memory");
    return prev != old_value;
}
```
#### Spin Lock
- while문을 반복하며 mutex를 계속 체크하는 기법
```
void spin_lock(int* mutex)
{
    while (__bionic_cmpxchg(0, 1, mutex)); // mutex가 0이 될 때 까지 무한 대기 
}
```
- CPU 활용도가 떨어지므로 임계영역이 짧은 경우만 사용 권장

#### Sleep Lock
- mutex를 기다리는 동안 thread를 sleep 시키면 thread에 할당된 리소스를 해제하여 다른 곳에 할당해 줄 수 있게 된다.
- gcc에서는 slelep lock을 지원하는 라이브러리가 없지만, 시스템 커맨드 라이브러리에는 futex(fast user mutex)라는 함수로 sleep lock을 지원한다. C언어로 사용하려면 시스템 콜로 futex를 호출하면 된다.
```
#include <unisted.h>
int mutex = 1;
void *foo(void *data)
{
    sytstemcall 202, &mutex, 0, 1, 0); // __futex_wait();
    ... /* critical section */
    systemcall(202, &mutex, 1, 1); // __futex_wake();
}
```
- __futex_wait 은 mutex_lock, __futex_wake는 mutex_unlock에 대응된다.

#### Self Lock
- recursive 함수에서 mutex를 사용한다면 하나의 함수에서 동일한 mutex를 두번 호출하게 되는 "selfl lock"이 발생할 수 있다. 
- self lock이 발생하면 마찬가지로 deadlock이 발생한다.
- 재귀 호출을 위한 `recursive mutex lock` 이 존재한다. mutex 생성시 attribute로 재귀함수를 위한 설정이 존재하며, mutex_lock을 한 thread에서 중복 호출 가능하며, mutex_lock을 호출한 수만큼 mutex_unlock을 호출해 주면 mutex가 해제된다. 
```
pthread_mutexattr_t attr;
pthread_mutex_t mutex;
...
pthread_mutexattr_init(&attr);
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
pthread_mutuex_init(&mutex, &attr);
...
pthread_mutex_lock(&mutex); // 1
pthread_mutex_lock(&mutex); // 2
pthread_mutex_lock(&mutex); // 3
...
pthread_mutex_unlock(&mutex); // 1
pthread_mutex_unlock(&mutex); // 2
pthread_mutex_unlock(&mutex); // 3
```

### Condition (조건변수)
- thread에서 전역 변수에 참조할 때, 순서를 제어하기 위해 사용하는 방법
- 아래 코드는 thread1에서 전역변수를 처리해야 thread2에서 전역변수에 접근이 가능하게 하는 코드이다.
```
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
...
thread1()
{
    pthread_mutex_lock(&mutex);
    // 전역변수 처리
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
}
...
thread2()
{
    pthread_mutex_lock(&mutex);
    pthread_cond_wait(&cond);
    // 전역변수 처리
    pthread_mutex_unlock(&mutex);
}
```

#### Condition 내부 구조
```
func1()
{
    pthread_mutex_lock(); // <- (1)
    do_something();
    pthread_cond_signal();
    pthread_mutex_unlock();
}
func2()
{
    pthread_mutex_lock();
    pthread_cond_wait(); // <- (2)
    do_something();
    pthread_mutex_unlock();
}
```
- func1이 (1)에서 mutex unlock을 대기하고, func2가 (2)에서 condition signal을 대기하면 deadlock이 걸릴 것 같지만, condition wait와 mutex lock은 서로 교착상태를 만들지 않는다.
- `pthread_cond_wait()` 아래와 같이 mutex_unlock, futex_wait, mutex_lock으로 구성되어 있으므로 mutex
```
pthread_cond_wait()
{
    ...
    pthread_mutex_unlock();
    while (condition == 0) // condition 조건이 충족될 때 까지 무한 대기
    {
        futex_wait(); // sleep lock
    }
    condition = 0; // condition 초기화
    pthread_mutex_lock();
    ...
}

```
- 즉, condition wait는 condition signal이 발생한 시점이 아니라, mutex 가 unlock되는 시점에 탈출된다. 


### Deadlock
- 두 개 이상의 Mutex가 서로 해제되기를 기다리며 대기하여 더 이상 process가 진행되지 못하게 되는 상황을 deadlock이라 한다. 
- lock을 순서대로 잡고, cycle이 생기지 않게 관리하면 deadlock을 피할 수 있다.


## 재진입 가능 함수 (Reentrant)
- thread에서 사용할 수 있는 함수를 '재진입 가능 함수' 라 한다. 즉, Thread-safe 한 함수를 의미한다. 
- 내부적으롱 전역변수, 혹은 static 변수를 사용하는 함수는 '재진입 불가능' 하다.
- strtok는 대표적인 재진입 불가능한 함수이다.
```
func1()
{
    strtok()
}
func2()
{
    strtok()
}
main()
{
    pthread_create(func1);
    pthread_create(func2);
}
// -> strtok는 재진입 불가능한 함수이기 때문에 결과가 의도한 결과가 나오지 않을 수 있다.
```
- C 라이브러리에서는 strtok_r 이라는 재진입 가능한 함수를 제공한다. 

### TLS / TSD
- TLS는 thread 의 전역 변수를 저장하기 위한 공간으로, 로더(Loader)에 의해서 할당된다.
- 리눅스에서는 TSD라 부른다. 
- `int pthread_setspecific(pthread_key_t key, const void *value)` : 'key' 에 해당하는 영역에 'value'를 연결한다. value로는 동적할당한 메모리가 온다. 
- `void* pthread_getspecific(pthread_key_t key)` : 기존에 set으로 할당한 key에 해당하는 메모리를 가져온다. 
- `void pthread_key_create(pthread_key_t key, void* (*descturctor)(void*))` 할당한 메모리를 해제하는 역할을 수행할 함수 `void destructor(void* ptr){free(p);}`를 정의하고, destructor의 포인터를 key와 매핑시킨다.

```
void main(void)
{
    pthread_key_t key;
    pthread_key_create(key, void (*destructor)(void*));
}

void func1(void)
{
    int *tsd = pthread_get_specific(key) // key에 해당하는 영역 가져옴
    if (!tsd) // null 받았을 시
    {
        tsd = calloc(1, sizeof int); // int 영역이 필요해서 동적할당. 다른 자료형도 가능
        pthread_set_specific(key, tsd); // TSD 영역에 저장
    }
}

void destructor(void* ptr)
{
    free(p);
}
```

- TLS는 내부적으로 `void* tls[]` 배열을 bitmap 형태로 지니고, pthread_set_specific을 할 경우 `tls[idx]`에 메모리 주소를 대입한다.
- pthread_set_specific을 호출할 때 마다 idx는 자동으로 갱신된다.
- thread가 종료될 때 모든 key에 대해 소멸자로 정의된 destructor가 호출된다.