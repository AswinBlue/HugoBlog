---
title: "리눅스 프로세스(Process) 심층 분석: 생명주기, fork·exec·wait 원리와 데몬 프로세스 구현"
description: "리눅스 프로세스의 메모리 구조와 생명주기, fork()와 exec 계열 시스템 콜의 동작 원리, Copy-on-Write(COW), 좀비 및 고아 프로세스 방지 기법, 프로세스 그룹과 세션 제어, 데몬(Daemon) 프로세스 생성 단계까지 완벽하게 정리합니다."
slug: "linux-process-lifecycle-management-daemon"
date: 2023-07-18T20:15:29+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["linux", "process", "system-programming", "fork", "daemon", "signals"]
ShowToc: true
TocOpen: true
---

# 리눅스 프로세스 (Process) 심층 분석

## 프로그램과 프로세스의 기본 개념
- **프로그램(Program)**: 보조기억장치(디스크)에 정적으로 저장되어 있는 실행 가능한 바이너리 파일입니다.
- **프로세스(Process)**: 실행을 위해 메모리에 로드되어 운영체제로부터 CPU 스케줄링과 시스템 자원을 할당받아 실행 중인 인스턴스입니다.

### C 프로그램의 빌드 및 로딩 과정
C 언어 소스코드가 프로세스로 실행되기까지는 다음 4단계를 거칩니다.
1. **전처리(Preprocessing)**: `#include`, `#define` 등 매크로 및 지시어를 확장합니다.
2. **컴파일(Compilation)**: C 고수준 언어를 타깃 아키텍처의 어셈블리어로 변환합니다.
3. **어셈블(Assembly) & 링크(Linking)**: 어셈블리어를 기계어 오브젝트 파일(`.o`)로 만들고, 라이브러리 및 타 오브젝트 심볼을 연결하여 ELF 실행 파일을 생성합니다.
4. **로딩(Loading)**: 커널이 `execve()` 시스템 콜을 통해 가상 메모리 공간을 구성하고 바이너리를 로드하여 프로세스로 활성화합니다.

## 프로세스 복제와 생명주기 제어

### 프로세스 생성과 종료 대기 (fork & wait)
- `pid_t fork(void)`: 부모 프로세스의 가상 주소 공간, 파일 디스크립터 테이블, 실행 문맥을 그대로 복제하여 새로운 자식 프로세스를 생성합니다.
  - 반환값: 자식 프로세스에는 `0`, 부모 프로세스에는 자식의 `PID`(양수), 실패 시 `-1`을 반환합니다.
  - `fork()` 직후 부모와 자식은 독립적으로 병행 실행되므로 스케줄링 순서를 보장할 수 없는 **경쟁 상태(Race Condition)**가 발생할 수 있습니다.
- `pid_t wait(int *wstatus)`: 자식 프로세스가 종료될 때까지 부모 프로세스의 실행을 블록(대기)하고 자식의 종료 상태 코드를 수거합니다.
  - 상태 값 비트 구조:
    - 정상 종료 시: 종료 코드 값(`exit(code)`)이 상위 8비트에 저장됩니다. 매크로 `WIFEXITED(status)`, `WEXITSTATUS(status)`로 확인합니다.
    - 비정상 종료 시: 프로세스를 종료시킨 시그널 번호가 하위 7비트에 저장됩니다. 매크로 `WIFSIGNALED(status)`, `WTERMSIG(status)`로 확인합니다.

### 가상 메모리와 Copy-on-Write (COW)
- `fork()`가 발생하더라도 코드 영역(Text Segment)은 읽기 전용(Read-Only)이므로 부모와 자식이 동일한 물리 메모리 페이지를 공유합니다.
- 데이터 및 힙/스택 영역 또한 복제 시점에 물리 메모리를 즉시 복사하지 않고 동일 페이지를 읽기 전용으로 공유하다가, 둘 중 하나가 쓰기(Write) 작업을 시도하는 순간 페이지 폴트(Page Fault)가 발생하여 해당 페이지만 별도로 복제하는 **Copy-on-Write (COW)** 메커니즘을 사용합니다. 이를 통해 프로세스 생성 비용과 메모리 낭비를 극적으로 줄입니다.

### 좀비 프로세스와 고아 프로세스 방지
- **좀비 프로세스 (Zombie Process)**: 자식 프로세스가 `exit()`을 호출하여 실행을 마쳤으나, 부모 프로세스가 `wait()` 시스템 콜을 호출하여 자식의 종료 상태를 회수하지 않은 상태입니다. 프로세스 테이블 엔트리와 PID 자원을 계속 점유하여 누적 시 시스템 PID 고갈을 유발합니다.
- **고아 프로세스 (Orphan Process)**: 자식 프로세스보다 부모 프로세스가 먼저 종료된 경우입니다. 리눅스 커널은 고아 프로세스를 감지하면 최상위 부모인 `init` 프로세스(PID 1) 또는 systemd의 자식으로 재할당(Adopt)하여 자식이 종료될 때 자동으로 `wait()`을 수행해 좀비 상태가 되는 것을 방지합니다.

### 비동기 SIGCHLD 시그널과 넌블로킹 회수
부모 프로세스가 동기적으로 `wait()`에서 대기하지 않고 본연의 작업을 수행하면서 자식을 안전하게 정리하려면 `SIGCHLD` 핸들러를 사용합니다.

```c
#include <signal.h>
#include <sys/wait.h>
#include <unistd.h>

void sigchld_handler(int sig) {
    // 여러 자식이 동시에 종료될 경우 시그널이 병합(Coalesce)될 수 있으므로 루프로 모두 회수
    while (waitpid(-1, NULL, WNOHANG) > 0);
}

int main(void) {
    struct sigaction sa;
    sa.sa_handler = sigchld_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART | SA_NOCLDSTOP;
    sigaction(SIGCHLD, &sa, NULL);

    pid_t pid = fork();
    if (pid == 0) {
        // 자식 작업 수행 후 종료
        _exit(0);
    }

    // 부모는 블록되지 않고 계속 실행
    while (1) {
        pause();
    }
    return 0;
}
```

## 프로세스 이미지 교체 (exec 계열 함수)
`exec` 계열 시스템 콜은 현재 프로세스의 코드, 데이터, 힙, 스택을 새로운 바이너리 이미지로 완전히 덮어써서 실행합니다. 프로세스 ID(PID)는 유지됩니다.

- `execl`, `execlp`, `execle`: 인자를 가변 인자 리스트(`char *arg0, char *arg1, ..., NULL`)로 전달
- `execv`, `execvp`, `execve`: 인자를 벡터 배열(`char *const argv[]`)로 전달
- 접미사 `p`: `PATH` 환경 변수에서 실행 파일 경로를 자동 탐색
- 접미사 `e`: 새 프로세스에 전달할 환경 변수 배열(`char *const envp[]`)을 명시적으로 전달
- 기본 커널 시스템 콜은 `execve()` 하나이며, 나머지는 C 표준 라이브러리(glibc) 래퍼 함수입니다.

### 상속되는 속성과 초기화되는 속성
- **상속되는 속성**: 프로세스 ID(PID), 부모 PID(PPID), 열린 파일 디스크립터(단, `FD_CLOEXEC` 플래그가 설정된 FD는 제외), 사용자 및 그룹 ID(UID/GID), 작업 디렉터리, 시그널 마스크.
- **초기화되는 속성**: 사용자 정의 시그널 핸들러는 모두 기본 동작(`SIG_DFL`)으로 복원되며, 메모리 잠금 및 스레드 자원은 해제됩니다.

## 프로세스 그룹과 세션 제어

### 프로세스 그룹 (Process Group)
- 관련 있는 프로세스들을 하나로 묶어 동일한 시그널을 일괄 전송할 수 있도록 그룹화한 논리적 단위입니다.
- 각 그룹은 고유한 프로세스 그룹 ID(PGID)를 가집니다.
- 파이프로 연결된 명령어 집합(`cat file | grep target | wc -l`)은 동일한 프로세스 그룹에 속합니다.
- `pid_t getpgrp(void)`: 현재 프로세스의 PGID를 조회합니다.
- `int setpgid(pid_t pid, pid_t pgid)`: 특정 프로세스의 프로세스 그룹을 설정하거나 변경합니다.

### 세션과 제어 터미널 (Session & Terminal)
- 하나 이상의 프로세스 그룹이 모여 세션(Session)을 이룹니다 (`프로세스 ⊂ 프로세스 그룹 ⊂ 세션`).
- 사용자가 터미널에 로그인할 때 새로운 세션이 생성되며, 세션을 생성한 프로세스를 **세션 리더(Session Leader)**라 부릅니다.
- 세션은 최대 1개의 제어 터미널(Controlling Terminal: tty/pts)과 연결될 수 있습니다.
- 세션 내에는 단 1개의 **포어그라운드(Foreground) 프로세스 그룹**만이 제어 터미널로부터 키보드 입력 및 시그널(`Ctrl+C` 등)을 수신할 수 있습니다.
- `pid_t setsid(void)`: 호출한 프로세스가 프로세스 그룹 리더가 아닐 때, 제어 터미널이 없는 새로운 세션과 프로세스 그룹을 생성하고 스스로 세션 리더가 됩니다.

## 데몬 프로세스 (Daemon Process) 구현
데몬은 사용자와 상호작용하는 제어 터미널 없이 백그라운드에서 상주하며 시스템 서비스나 주기적인 작업을 수행하는 프로세스입니다 (`systemd`, `sshd`, `cron` 등).

### 데몬 프로세스 제작 6단계 절차
1. **1차 fork() 호출 및 부모 프로세스 종료**: 프로세스를 백그라운드로 전환하고 프로세스 그룹 리더가 아님을 보장합니다.
2. **setsid() 호출**: 제어 터미널과의 연결을 완전히 분리하고 독자적인 새 세션을 생성하여 세션 리더가 됩니다.
3. **2차 fork() 호출 및 부모 종료 (선택적 권장)**: 세션 리더 특권을 포기하여 향후 실수로 터미널을 다시 획득하지 못하도록 영구 방지합니다.
4. **작업 디렉터리를 루트(`/`)로 변경**: 마운트된 특정 파일 시스템의 unmount 작업을 방해하지 않도록 `chdir("/")`을 실행합니다.
5. **파일 생성 마스크 초기화**: `umask(0)`을 호출하여 파일 생성 시 의도치 않은 권한 마스킹을 방지합니다.
6. **표준 입출력 닫기 및 리다이렉션**: 모든 파일 디스크립터(0, 1, 2)를 닫고 `/dev/null`로 연결합니다.

```c
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

void daemonize(void) {
    pid_t pid = fork();
    if (pid < 0) exit(EXIT_FAILURE);
    if (pid > 0) exit(EXIT_SUCCESS); // 1. 부모 프로세스 종료

    if (setsid() < 0) exit(EXIT_FAILURE); // 2. 새 세션 생성

    signal(SIGCHLD, SIG_IGN); // 자식 종료 시그널 무시 (좀비 방지)
    signal(SIGHUP, SIG_IGN);

    pid = fork();
    if (pid < 0) exit(EXIT_FAILURE);
    if (pid > 0) exit(EXIT_SUCCESS); // 3. 세션 리더 자격 포기

    umask(0); // 4. 파일 생성 마스크 초기화
    chdir("/"); // 5. 루트 디렉터리로 이동

    // 6. 표준 파일 디스크립터(0, 1, 2)를 /dev/null로 리다이렉트
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    int fd = open("/dev/null", O_RDWR);
    if (fd != -1) {
        dup2(fd, STDIN_FILENO);
        dup2(fd, STDOUT_FILENO);
        dup2(fd, STDERR_FILENO);
        if (fd > 2) close(fd);
    }
}
```