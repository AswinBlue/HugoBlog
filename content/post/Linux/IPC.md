---
title: "리눅스 프로세스 간 통신(IPC) 기법 총정리: 시그널, 파이프, 메시지 큐, 세마포어, 공유 메모리"
description: "리눅스 환경에서 독립적인 프로세스 간 데이터를 교환하고 동기화하기 위한 대표적인 IPC 기법인 시그널, 파이프, 메시지 큐, 세마포어, 공유 메모리의 핵심 동작 원리와 C 언어 시스템 콜 API 활용법을 상세히 정리합니다."
slug: "linux-ipc-mechanisms-overview"
date: 2023-07-27T20:37:08+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["linux", "ipc", "shared-memory", "system-programming", "semaphore", "pipe"]
ShowToc: true
TocOpen: true
---

# 리눅스 프로세스 간 통신 (IPC: Inter-Process Communication)

## 시그널 (Signal)
- 시그널은 프로세스 간 동기화 및 이벤트 전달을 위해 커널 또는 프로세스 간에 전송하는 비동기 신호입니다.
- 소프트웨어 인터럽트(Software Interrupt)라고도 부릅니다.
- 쉘에서는 `kill -<SIGNAL_NUMBER> <PROCESS_ID>` 명령으로 특정 프로세스 ID에 시그널을 전달할 수 있습니다.
- 시그널은 총 64번까지 정의되어 있으며, 1~31번이 표준 POSIX 시그널이고, 34~63번은 실시간(Real-Time) 고성능 처리를 위한 시그널입니다 (32, 33번은 미정의).
- `kill -l` 명령어로 시스템에 정의된 시그널 목록을 확인할 수 있습니다.
  1. `SIGHUP` (1): 터미널 접속 종료 시 전달되는 신호
  2. `SIGINT` (2): 인터럽트, 키보드 `Ctrl+C` 입력 시 발생
  3. `SIGQUIT` (3): 종료 및 코어덤프(Core dump) 생성
  4. `SIGILL` (4): 유효하지 않은 명령어 실행 (Illegal instruction)
  5. `SIGTRAP` (5): 디버거 트레이싱 트랩
  6. `SIGABRT` (6): `abort()` 함수 호출 시 프로세스 비정상 종료
  7. `SIGBUS` (7): 버스 에러 (잘못된 메모리 접근)
  8. `SIGFPE` (8): 부동 소수점 산술 예외 (Floating point exception)
  9. `SIGKILL` (9): 프로세스 강제 종료 (무시 및 catch 불가)
  10. `SIGUSR1` (10): 사용자 정의 시그널 1
  11. `SIGSEGV` (11): 세그멘테이션 오류 (유효하지 않은 가상 메모리 참조)
  12. `SIGUSR2` (12): 사용자 정의 시그널 2
  13. `SIGPIPE` (13): 읽기 대상이 없는 파이프(Broken pipe)에 쓰기 시도 시 발생
  14. `SIGALRM` (14): `alarm()` 타이머 만료 시 발생하는 시그널
  15. `SIGTERM` (15): 정상적인 종료 요청 시그널 (소프트웨어 종료 신호)
  16. `SIGSTKFLT` (16): 스택 오류 (Stack fault)
  17. `SIGCHLD` (17): 자식 프로세스가 종료 또는 정지될 때 부모 프로세스에 전달
  18. `SIGCONT` (18): 정지된 프로세스를 다시 재개(Continue)시키는 신호
  19. `SIGSTOP` (19): 프로세스 실행 일시 정지 (무시 및 catch 불가)
  20. `SIGTSTP` (20): 터미널 정지 시그널, 키보드 `Ctrl+Z` 입력 시 발생
  21. `SIGTTIN` (21): 백그라운드 프로세스가 터미널 입력(read)을 시도할 때 발생
  22. `SIGTTOU` (22): 백그라운드 프로세스가 터미널 출력(write)을 시도할 때 발생
  23. `SIGURG` (23): 긴급 소켓 데이터 수신 (Out-Of-Band)
  24. `SIGXCPU` (24): 설정된 CPU 시간 제한 초과 시 발생
  25. `SIGXFSZ` (25): 허용된 파일 크기 한도 초과 시 발생
  26. `SIGVTALRM` (26): 가상 타이머 만료 시그널
  27. `SIGPROF` (27): 프로파일링 타이머 만료 시그널
  28. `SIGWINCH` (28): 터미널 윈도우 크기 변경 시 발생
  29. `SIGIO` / `SIGPOLL` (29): 비동기 I/O 이벤트 발생 가능 상태
  30. `SIGPWR` / `SIGLOST` (30): 시스템 전원 장애 발생
  31. `SIGSYS` (31): 잘못된 시스템 콜 호출 시 발생

### C 언어 시그널 라이브러리
- `<signal.h>`에 정의된 함수를 통해 시그널을 무시(`SIG_IGN`)하거나 핸들러 함수를 등록(`SIG_DFL` 또는 커스텀 핸들러)하여 가로챌 수 있습니다.
- 별도의 처리가 되지 않은 시그널을 수신하면 기본 동작(대부분 프로세스 종료)이 수행됩니다.
- `SIGKILL`(9)과 `SIGSTOP`(19) 시그널은 커널 레벨에서 즉시 집행되므로 절대 무시하거나 핸들러로 가로챌 수 없습니다.

1. `int kill(pid_t pid, int sig)`
   - `pid > 0`: 지정한 프로세스 ID에 시그널 전달
   - `pid < 0`: 프로세스 그룹 ID(`|pid|`)에 속한 모든 프로세스에 시그널 전달
   - `pid == 0`: 송신 프로세스와 동일한 프로세스 그룹에 속한 모든 프로세스에 시그널 전달

2. `unsigned int alarm(unsigned int seconds)`
   - 지정한 초(`seconds`) 이후 `SIGALRM` 시그널이 발생합니다.
   - 타이머 만료 전 새로 호출하면 이전 타이머를 덮어쓰며, 남은 초를 반환합니다. `alarm(0)`을 호출하면 타이머가 취소됩니다.

- 시그널 집합(Signal Set) 제어 함수 (`sigset_t` 비트 마스크 연산):
  1. `sigemptyset(sigset_t *set)`: 시그널 집합의 모든 비트를 0으로 비웁니다.
  2. `sigfillset(sigset_t *set)`: 시그널 집합의 모든 비트를 1로 채웁니다.
  3. `sigaddset(sigset_t *set, int signum)`: 특정 시그널 번호의 비트만 1로 추가합니다.
  4. `sigdelset(sigset_t *set, int signum)`: 특정 시그널 번호의 비트를 0으로 제거합니다.
  5. `sigismember(const sigset_t *set, int signum)`: 특정 시그널이 포함되어 있는지 확인합니다.
  6. `sigprocmask(int how, const sigset_t *set, sigset_t *oldset)`: 특정 시그널을 블록(Block)하거나 해제합니다.
     - `SIG_BLOCK`: 지정된 시그널들을 블록 집합에 추가합니다.
     - `SIG_UNBLOCK`: 지정된 시그널들의 블록 상태를 해제합니다.
     - `SIG_SETMASK`: 기존 블록 마스크를 새 집합으로 완전히 덮어씁니다.
- 시그널에 의해 방해받지 않고 보호되어야 하는 코드 구간을 **임계영역(Critical Section)**이라 부릅니다.

## 파이프 (Pipe)
- 프로세스 간 단방향 통신을 위해 표준 입출력 스트림을 교차 연결하는 기법입니다.
- 주로 부모-자식 프로세스 간 데이터 전송에 사용되며, 커널 내부에 버퍼링과 흐름 제어(Flow Control)가 기본 제공됩니다.

### C 언어 파이프 라이브러리
- `int pipe(int pipefd[2])`: 단방향 통신 채널을 생성하고 읽기/쓰기용 파일 디스크립터 2개를 반환합니다.
  - `pipefd[0]`: 읽기 전용 디스크립터 (`read(pipefd[0], ...)`)
  - `pipefd[1]`: 쓰기 전용 디스크립터 (`write(pipefd[1], ...)`)
  - 사용이 끝난 디스크립터는 반드시 `close()`로 닫아주어야 합니다.
- `pipe()` 생성 후 `fork()`를 호출하면 자식 프로세스가 부모의 파일 디스크립터 테이블을 그대로 복제하므로 부모-자식 간 파이프 통신이 가능해집니다.
- 쉘의 파이프라인 연산자(`|`) 또한 내부적으로 `pipe()`와 `dup2()` 시스템 콜을 사용하여 앞 명령어의 표준 출력을 뒷 명령어의 표준 입력으로 리다이렉션하여 동작합니다.

```c
int fd[2];
pid_t pid;
pipe(fd);
pid = fork();

if (pid == 0) {
    // 자식 프로세스: 표준 입력을 파이프 읽기 채널로 대체
    close(fd[1]);       // 쓰기 디스크립터 닫기
    dup2(fd[0], 0);     // fd[0]을 STDIN_FILENO(0)으로 복제
    close(fd[0]);
    // 자식 작업 수행...
} else {
    // 부모 프로세스: 표준 출력을 파이프 쓰기 채널로 대체
    close(fd[0]);       // 읽기 디스크립터 닫기
    dup2(fd[1], 1);     // fd[1]을 STDOUT_FILENO(1)으로 복제
    close(fd[1]);
    // 부모 작업 수행...
}
```

## 메시지 큐 (Message Queue)

### IPC 네임스페이스
- 메시지 큐, 공유 메모리, 세마포어는 커널 레벨의 IPC 프레임워크(System V IPC)입니다.
- 파일 디스크립터 대신 `key_t` 타입의 고유 키(Identifier)를 통해 통신 채널을 식별합니다.
- 권한은 `struct ipc_perm` 구조체를 통해 파일 시스템과 유사하게 관리됩니다 (실행 권한 제외).
- 리눅스 쉘 명령어 `ipcs`를 통해 현재 시스템에 할당된 IPC 자원 현황을 확인할 수 있습니다 (`ipcrm`으로 수동 삭제 가능).

```c
struct msgbuf {
    long mtype;       // 메시지 타입 (1 이상의 정수, 애플리케이션 구분자)
    char mtext[512];  // 메시지 본문 데이터
};
```

### C 언어 메시지 큐 라이브러리
- `int msgget(key_t key, int msgflg)`: 메시지 큐를 생성하거나 기존 큐의 ID(msqid)를 획득합니다.
  - `IPC_CREAT | 0666` 형태로 신규 생성 및 권한을 부여합니다.
- `int msgctl(int msqid, int cmd, struct msqid_ds *buf)`: 메시지 큐 상태 조회(`IPC_STAT`), 설정 변경(`IPC_SET`), 큐 삭제(`IPC_RMID`)를 수행합니다.
- `int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg)`: 메시지 큐에 메시지를 전송합니다 (`msgsz`는 `mtext`의 바이트 크기).
- `ssize_t msgrcv(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg)`: 메시지 큐에서 지정한 타입의 메시지를 수신합니다.
  - `msgtyp == 0`: 큐의 맨 앞 메시지를 수신합니다.
  - `msgtyp > 0`: 해당 타입과 일치하는 첫 번째 메시지를 수신합니다.
  - `msgtyp < 0`: 절댓값보다 작거나 같은 타입 중 가장 작은 타입의 메시지를 수신합니다.

## 세마포어 (Semaphore)
- 여러 프로세스가 공유 자원에 동시에 접근할 때 동기화를 보장하고 임계 영역(Critical Section)을 보호하기 위한 기법입니다.
- 뮤텍스(Mutex)가 1개의 자원을 보호하는 데 비해, 세마포어는 복수 개의 자원 카운트를 관리할 수 있습니다.

### C 언어 세마포어 라이브러리
- `int semget(key_t key, int nsems, int semflg)`: 세마포어 집합을 생성하거나 식별자를 가져옵니다.
- `int semop(int semid, struct sembuf *sops, size_t nsops)`: 세마포어 원자적 연산을 수행합니다.
  - P 연산 (자원 획득, `sem_op = -1`): 세마포어 카운트를 1 감소시킵니다. 카운트가 0이면 대기합니다.
  - V 연산 (자원 반납, `sem_op = +1`): 세마포어 카운트를 1 증가시켜 대기 중인 프로세스를 깨웁니다.
- `int semctl(int semid, int semnum, int cmd, ...)`: 세마포어 값 조회(`GETVAL`), 초기화(`SETVAL`), 집합 삭제(`IPC_RMID`) 등을 제어합니다.

```c
// P 연산 (자원 잠금)
struct sembuf p_op = {0, -1, SEM_UNDO};
semop(semid, &p_op, 1);

// 임계 영역 (공유 자원 접근)

// V 연산 (자원 해제)
struct sembuf v_op = {0, 1, SEM_UNDO};
semop(semid, &v_op, 1);
```

## 공유 메모리 (Shared Memory)
- 둘 이상의 프로세스가 물리적 메모리 공간의 특정 영역을 가상 주소 공간에 함께 매핑하여 사용하는 IPC 기법입니다.
- 커널 공간을 거치지 않고 메모리에 직접 읽고 쓰기 때문에 IPC 기법 중 데이터 전송 속도가 가장 빠릅니다.
- 자체적인 동기화 기능이 없으므로 데이터 무결성을 위해 세마포어나 뮤텍스를 반드시 병행해야 합니다.

### C 언어 공유 메모리 라이브러리
- `int shmget(key_t key, size_t size, int shmflg)`: 공유 메모리 세그먼트를 생성하거나 식별자(shmid)를 반환받습니다.
  - 생성: `shmget(key, size, IPC_CREAT | 0666)`
- `void *shmat(int shmid, const void *shmaddr, int shmflg)`: 공유 메모리를 현재 프로세스의 가상 주소 공간에 부착(Attach)합니다.
  - 반환된 포인터를 구조체 포인터 등으로 캐스팅하여 즉시 메모리에 접근할 수 있습니다.
- `int shmdt(const void *shmaddr)`: 공유 메모리 매핑을 현재 프로세스에서 분리(Detach)합니다.
- `int shmctl(int shmid, int cmd, struct shmid_ds *buf)`: 공유 메모리 세그먼트의 상태 조회(`IPC_STAT`) 및 시스템 제거(`IPC_RMID`)를 수행합니다.