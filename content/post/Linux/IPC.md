---
title: "IPC"
date: 2023-07-27T20:37:08+09:00
lastmod: 2023-07-27T20:37:08+09:00
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
# IPC (Inter Process Communicatrion)

## Signal
- Signal은 프로세스간 동기화를 위해 프로세스간 전송하는 신호를 의미한다.
- Software Interrupt 라고도 한다.
- 커널에서 `kill -<SIGNAL_NUMBER> <PROCESS_ID>` 명령으로 특정 PROCESS_ID에 ISGNAL_NUMBER에 해당하는 signal을 전달할 수 있다.
- signal은 총 64까지 정의되어 있고 1~31까지가 일반적으로 사용하는 signal이다. 34~63은 고성능 네트워크 통신을 위한 시그널이다. (32, 33는 미정의)
  - `kill -l`  명령으로 signal 리스트를 확인할 수 있다. 
    1. SIGHUP
    2. SIGINT : 인터럽트, Ctrl+C 명령으로 전송 가능
    3. SIGQUIT Coredump시 발생
    4. SIGILL : Illegal instruction
    5. SIGTRAP : debugger is tracing
    6. SIGABRT : Abort process
    7. SIGBUS : bus error
    8. SIGFPE : Floating point exception
    9. SIGKILL : 강제 종료
    10. SIGUSR1	: User-defined signal 1, 마음대로 사용 가능
    11. SIGSEGV	: invalid virtual memory reference
    12. SIGUSR2 : User-defined signal 2, 마음대로 사용 가능
    13. SIGPIPE	: 반대편이 연결되지 않은 pip에 신호 전송시 발생하는 에러
    14. SIGALRM : alarm() 함수에 의해 발생한 시그널 1
    15. SIGTERM : 종료 요청, SIGKILL(9)보다 안전한 종료 방법, SIGINT와 유사한 성능
    16. SIGSTKFLT : Stack fault
    17. SIGCHLD : 자식 process가 종료될 때 부모에게 전달하는 신호
    18. SIGCONT : SIGSTOP 에 의해 정지된 경우, 다시 시작하라는 신호
    19. SIGSTOP : process 정지
    20. SIGTSTP : process 일시정지, Ctrl+Z 명령으로 전송 가능
    21. SIGTTIN	: background 에 있을 때 read 요청을 받은 경우 발생
    22. SIGTTOU : background 에 있을 때 write 요청을 받은 경우 발생
    23. SIGURG : 긴급 통신을 받은 경우 (Out Of Band)
    24. SIGXCPU : 설정된 CPU 사용량을 초과하여 프로세스가 동작 한 경우
    25. SIGXFSZ : 파일 크기가 허용된 크기를 초과한 경우
    26. SIGVTALRM : 프로세스 실행시간 관리를 위한 시그널1
    27. SIGPROF : 프로세스 실행시간 관리를 위한 시그널2
    28. SIGWINCH : Window change
    29. SIGIO, SIGPOLL : Input/output is now possible
    30. SIGPWR, SIGLOST : Power failure
    31. SIGUNUSED, SIGSYS : Unused signal. 


### Signal Library in C
- `signal.h` 에 정의된 signal 함수로 signal을 무시(ignore)하거나, 시그널 발생시 특정 함수를 동작(catch)시키도록 설정할 수 있다. 
- 처리되지 않은 (ignore 또는 catch 처리) signal을 받으면 기본적으로 해당 프로세스는 종료한다.
- SIGKILL(강제종료 용도)과 SIGSTOP(디버깅시 일시정지 용도)시그널을 제외한 모든 시그널을 무시할 수 있다.

1. `signal(SIGNAL, PID)`
  - pid > 0 : PID에 SIGNAL 전달
  - pid < 0 : PID의 절댓값에 해당하는 groupId를 가진 프로세스들에 SIGNAL 전달
  - pid == 0 : 자신과 같은 groupId를 가진 프로세스들에 SIGNAL 전달

2. `alarm(TIME)` : TIME초 이후 SIGALRM 시그널 발생
    - alarm timer가 만기되기 전 새로운 alarm을 호출하면 값을 덮어쓴다. 대신 alarm 함수는 남은 시간을 반환 한다.
    - alarm(0) 을 호출하면 알림이 취소된다.

- 시그널 처리 flag는 bit연산으로 관리된다.
- sigset_t 타입의 bit 하나하나들은 1~64까지의 signal을 의미하고, 아래와 같이 set을 연산하여 process에서 signal을 설정할 수 있다.

1. `sigemptyset(siget_t* SET)` : SET 모든 비트를 0으로 세팅. 
2. `sigfillset(int SIGNAL, sigset_t* SET)` : | 연산으로 SET 에서 SIGNAL에 해당하는 비트만 1로 세팅
3. `sigdelset(int SIGNAL, sigset_t* SET)` : & 연산으로 SIGNAL에 해당하는 비트만 0으로 세팅
4. `sigismember(int SIGNAL, sigset_t* SET)` : SET에서 SIGNAL비트가 1로 세팅되었다면 true 반환
5. `sigprocmask(int HOW, siget_t* NEW, sigset_t* OLD)` : 특정 SIGNAL을 무시하도록 설정할 수 있다. 
    - 필요할 경우 OLD에 siget_t* 타입 변수를 집어넣으면 현재 프로세스에 설정된 set을 담아낸다. 
    - SIG_BLOCK : NEW에 set된 signal들을 추가로 무시한다. 
    - SIG_UNBLOCK : NEW에 set 된 signal들의 무시처리를 해제한다.
    - SIG_SETMASK : 기존 값에 상관없이 NEW에 set 된 signal들만 무시하도록 set을 덮어쓴다.

- signal 을 처리하여 signal에 의해 process가 정지되지 않는 구간을 `임계영역` 이라 한다.


## Pipe
- 프로세스간 단방향 통신을 위해 프로세스들의 표준 입출력을 서로 교차하여 연결하는 기법이다. 
- 프로세스간 데이터 전송시 주로 사용된다.
- flow control이 기본적으로 제공된다. 

### Pipe Library in C

- `pipe(int[2] fd)` : 파일 디스크립터 두개를 생성하고, 단방향 통신을 생성함
  - file descriptor를 두 개 열고, fd[0] fd[1]에 그 번호를 넣어준다.
    - `write(fd[1], ...)`, `read(fd[0], ...)` 으로 사용
  - fd[0]은 writing을, fd[1]은 reading을 위한 descriptor이다. 
  -  파이프 사용을 마치면 fd[0]과 fd[1]에 대해 각각 close를 해 주어야 한다.
     -  `close(fd[0])`, `close(fd[1])` 로 사용

- pipe를 생성하고 fork를 호출하면 자식 프로세스는 부모 프로세스의 file descriptor를 모두 가져가기 때문에, 부모와 자식간 pipe를 통해 데이터를 전송할 수 있게 된다. (물론 단방향이다. 양방향을 원한다면 pipe를 두번 생성한다)
- 쉘에서 명령을 입력할 때 `|`로 두 명령을 연결시키면, 앞선 명령의 표준 출력 값이 뒷쪽 명령의 input으로 들어간다.
  - ex) `cat file.txt | grep target` : file.txt 파일을 출력한 결과에서(cat) target 이라는 문자열을 찾는다(grep).
  - '|' 명령도 pipe로 fd[0], [1]을 생성하고, dup()를 이용해 fd[0]과 fd[1]을 표준 입력/출력 자리로 복사시키는 기법으로 구현한 것이다.
    ```
    int fd[2], pid;
    pipe(fd);
    pid = fork();
    if (pid == 0)
    {
        close(fd[1]); // 입력용 파이프 제거
        dup2(fd[0], 0); // 출력 파이프를 표준 입력으로 재배치
        ... // 이후 parent process 동작 수행
    }
    close(fd[0]); // 출력용 파이프 제거
    dup2(fd[1], 1); // 입력 파이프를 표준 출력으로 재배치
    ... // 이후 child process 동작 수행

    ```


## Message Queue

### IPC namespace
- 이 외에도 공유메모리, 세마포어, 소켓, FIFO 등으로 프로세스간 통신이 가능하다.
- 그중 message queue, shared memory, semaphore은 IPC 통신을 위한 framework이다.
  - 파이프나 FIFO가 file descriptor을 사용해 통신했던 것과 달리, Key_t 타입의 identifier 라는 IPC를 위한 구분자로 채널(통신을 위한 라인)을 구분한다.
  - 동일한 구조체를 통해 커널이 관리하며, 인터페이스도 유사하다.
  - 권한은 아래와 같은 형태로 관리되며, 실행 권한이 없는 것만 제외하고 파일시스템과 유사하다.
    ```
      struct ipc_perm {
        ushort uid;
        ushort gid;
        ushort cuid;
        ushort cgid;
        ushort mod;
        ushort seq;
        key_t key;
      }

    ```
  
- 커널에서 `ipcs` 명령어로 IPC 구성에 대한 정보를 확인할 수 있다. 
---

- message queue는 msqid_ds 구조체에 정보를 담아 관리하고, message들은 struct msgbuf 구조의 linked list 형태로 msqid_ds 구조체에 연결된다. 
- 각 message들은 data, length, type을 가지고 있고, type은 사용자가 원하는 대로 설정 가능한 값이다.
```
struct msgqid_ds {
    struct ipc_perm msg_perm; // 권한
    struct msg *msg_first; // msg linked list 시작점
    struct msg *msg_last; // msg linked list 종료점
    time_t msg_stime; // 마지막 send가 실행된 시각
    time_t msg_rtime; // 마지막 receive가 실행된 시각
    time_t msg_ctime; // 마지막 change가 실행된 시각
    short msg_lspid; // 마지막 send를 한 pid
    ushort msg_lrpid; // 마지막 receive를 한 pid
    ushort msg_qbytes; // message queue의 최대 사이즈
    ushort_msg_cbytes; // message queue에서 사용중인 바이트
}

struct msgbuf {
  long mtype; // message의 타입(자료형이 아니라, 어플리케이션 로직상 구분자), 필수
  char mtext[]; // data, 필수
  // 이외 사용자가 재정의하여 추가적인 데이터를 넣어 헤더를 추가할 수 있다.
}
```


### Message Queue in C Library
- `int msgget(key_t key, int msgflg)` : message queue를 생성 혹은 불러오는 함수
  - key는 int 값을 넣어주면 된다. 
  - 함수 성공시 message queue의 qid를 반환하고, 실패시 -1을 반환한다.
  - flag에 IPC_CREAT 가 설정되면 신규로 생성된다. 생성시 권한도 설정 가능하다. ex: `IPC_CREAT | 0777`
- `int messagectl(int msqid, int cmd, struct msqid_ds *buf)` : message queue의 상태값을 조회 또는 수정한다.
  - cmd 가 `IPC_STAT` 라면 buf에 현재 상태를 받아오고, `IPC_SET` 라면 buf의 값으로 message queue 상태를 설정한다.
- `int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg)` : message queue에 msgp 데이터를 넣는 함수
  - msgp는 위에서 언급한 msgbuf 형태를 따라야 한다.
  - msgsz는 msgp안의 mtext 버퍼 크기를 의미한다. (msgp 전체 구조체 크기가 아님)
  - msgflg는 blocking 여부(IPC_NOWAIT), size 에러 여부(MSG_NOERROR) 등을 설정 가능하다.
- `ssize_t msgrcv(int msgqid, void *msgp, size_t msgsz, long msgtyp, int msgflg)` : message queue에서 msgtype에 해당하는 데이터를 msgp에 받아옴
  - 반환값은 읽어온 사이즈
  - type은 지정하지 않을 경우, queue의 head에 있는 message를 가져옴. 
    - type > 0 일 경우, 동일한 타입의 첫번째 메시지를 가져옴
    - type < 0 일 경우, type의 절댓값과 작거나 같은 타입의 첫번째 메시지를 가져옴
  - flag는 msgsnd 함수와 유사


## Semaphore
- 다중 리소스에 대해 critical section을 처리하는 방법(mutex는 하나의 리소스를 보호에 사용)
- `struct semid_ds` 구조체 형태로 관리되며, 보호할 리소스의 정보를 `struct sem *sem_base` 인자에 담아 관리하며, sem_nsems 인자는 semaphore가 관리하는 리소스의 갯수를 나타낸다. 
### Semaphore in C Library
- `int semop(int sid, struct sembuf* s_buf, size_t num)` : semaphore을 조작하는 함수
  - sid : semaphore id, 식별자
  - s_buf : operation. 동작에 대한 상세 정보를 sembuf* 타입에 기록한 후 인자에 적용한다. 배열 형태로 여러개 적용 가능
    - s_buf.sem_num: 세마포어 번호
    - s_buf.sem_op : 세마포어 연산
    - s_buf.sem_flg : 작동 플래그
  - num : operation의 갯수
-  `int semctl(int sid, int num, int cmd, union semun arg)` : semaphore 설정을 가져오거나 수정
   -  sid : semaphore id, 식별자
   -  num : 세마포어가 관리하는 리소스 중 함수로 접근을 원하는 대상의 index
   -  cmd : 명령
      -  GETVAL	세마포어의 현재 값을 구한다.
      -  GETPID	가장 최근에 접근했던 프로세스의 프로세스 ID를 구한다.
      -  GETNCNT	세마포어 대기중인 프로세스의 개수
      -  GETZCNT	세마포어 값이 0 이 되기를 기다리는 프로세스의 개수
      -  GETALL	세마포어 집합의 모든 세마포어 조회
      -  SETVAL	세마포어 값을 설정
      -  SETALL	세마퍼어 집합의 모든 세마포어 값을 설정
      -  IPC_STAT	세마포어의 상세 정보 확인
      -  IPC_SET	세마포어의 권한 설정
      -  IPC_RMID	세마포어 집합 삭제
   - arg : 조회 명령시에는 해당 값에 정보를 받아오고, 설정 명령시에는 해당 값을 적용


- p연산 : semaphore에 리소스를 사용하고 있다고 체크하는 연산
  ```
  struct sembuf s_buf = {0,};
  s_buf.sem_num = 0;
  s_buf.sem_op = -1; // 한개 만큼 사용
  semop(semid, &s_buf, 1); // 한 개 operation 수행
  ```
- v연산 : semaphore에 리소스를 반환했다고 체크하는 연산
  ```
  struct sembuf s_buf = {0,};
  s_buf.sem_num = 0;
  s_buf.sem_op = 1; // 한개 만큼 사용
  semop(semid, &s_buf, 1); // 한 개 operation 수행

  ```

## Shared Memory
- 프로세스간 공용으로 사용할 수 있는 영역의 메모리를 선언하는 방법
- race condition을 해결 할 수는 없으므로, semaphore와 함께 사용해야 한다.
### Shared Mmory in C Library
- `int shmget(key_t key, size_t size, int shmflg)` : shared memory를 생성하거나 key값으로 identifier를 가져오는 함수
  - size : shared memory의 크기
  - 생성 : `shmget(key, sizeof(YOUR_STRUCT), IPC_CREAT)`
  - 참조 : `shmget(key, sizeof(YOUR_STRUCT), 0)`
  - YOUR_STRUCT는 메모리 참조시 사용할 포멧
- `void *shmat(int shmid, const void *shmaddr, int shmflg)` : 가상메모리를 할당하는 작업. attach
  - shmid : shared memory id, 식별자
  - shmaddr : 공유 메모리 연결 주소 (보통 NULL로 사용)
  - 반환값 : shared memory에 접근할 수 있는 포인터
  - ex) `YOUR_STRUCT *ptr = (YOUR_STRUCT*)shmat(shmid, 0, 0);`
- `int shmdt(const void *shmaddr)` : 가상메모리를 환원하는 작업. detach
  - ex) `shmdt(shmid);`
- `int shmctl(int shmid, int cmd, struct shmid_ds *buf)` : 공유 메모리에 대한 정보를 가져오거나 설정하는 함수
  - shmid : shared memory id, 식별자
  - cmd : 제어 명령
    - IPC_STAT : shared memory 값 받아와 buf에 작성
    - IPC_SET : buf의 값으로 해당 shared memory 정보 갱신
    - IPC_RMID : shared memory를 시스템에서 삭제
  - buf : 조회 명령시에는 해당 값에 정보를 받아오고, 설정 명령시에는 해당 값을 적용