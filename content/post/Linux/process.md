---
title: "Process"
date: 2023-07-18T20:15:29+09:00
lastmod: 2023-07-18T20:15:29+09:00
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


# Process
## Program vs Process
- Process : 실행중인 프로그램  
- Program : 실행 가능한 파일
- Process는 메모리에 올라가 있는 상태의 프로그램을 의미한다.

## C언어 Program to Process
- C언어로 구성된 프로그램은 전처리 - 컴파일 - 링킹 - 로딩의 과정을 거친다. 
  - 전처리 : `#` 으로 시작하는 라인들을 알맞은 형태로 치환한다.
  - 컴파일 : C언어(high-level language)를 어셈블리어(기계어) 로 변환한다.
  - 링킹 : 외부의 ELF(Executable and Linkable Format) 파일들을 호출할 수 있도록 연결한다. 
  - 로딩 : 최종 생성된 파일을 실행시켜 메모리에 올려 프로세스로 만든다. 
    - 리눅스에서는 `execv()` 함수에 의해 프로세스화 된다.
  
## 프로세스

### fork
- `fork()` 함수는 프로세스를 복사하는 함수이다. 
  - `unistd.h` 헤더에 선언되어 있다. 
  - 복사당한 프로세스를 부모 프로세스, 복사해서 생성된 프로세스를 자식 프로세스라 한다.
  - 복사된 자식 프로세스도 `fork` 실행 이후부터 코드가 진행된다.
- `fork` 함수의 반환값은 `pid_t` 타입이다. 
  - 반환값이 -1이라면 실패를 의미한다.
  - 결과가 0이라면 현재 프로세스는 자식 프로세스임을 의미한다.
  - 0이 아니닌 값이라면 현재 프로세스는 부모 프로세스이다. 
    - 반환값은 자식프로세스의 process id를 의미하며, 리눅스 명령어 `ps -ef` 로 pid를 확인 할 수 있다.
- Race Condition : 일단 fork가 되어 프로세스가 부모 자식으로 나뉘면, 프로세스의 실행은 병렬적으로 이루어지며, 같은 코드라도 어느 것이 먼저 동작할지 알 수 없다.

### wait
- fork() 로 자식 프로세스를 생성한 후 자식 프로세스가 exit()를 호출하여 종료될 때, 부모 process는 자식 process의 종료 결과를 `wait()` 으로 받을수 있다. 
- `wait(statloc *status)` : 자식 process에서 호출된 exit() 함수 안에 들어간 인자값을 status(인자는 4byte int지만, 사용하는 부분은 2byte) 에 담아낸다. 
- status 값은 상위 1byte와 하위 1byte를 구분해서 사용한다. 
  - 정상적으로 종료가 된경우는 exit() 함수에 의한 종료를 의미하며, status의 상위 1byte에 exit의 인자값을 담아낸다. 
  - 비정상 종료는 signal에 의한 종료를 의미하며, signal 번호 값을 status의 하위 1byte에 담아낸다.
  - 0~7번 bit : 자식 process 정상종료시 종료 status
  - 8번 bit : core dump 여부
  - 9~15번 bit : 시그널 번호
  - status값을 인자로 받아 종료 사유를 회신하는 매크로 함수를 사용하면 쉽게 판단할 수 있다. 
    - WIFEXITED, WEXITEDSTATUS, WIFSIGNALED ...


### 메모리 
- 부모 프로세스를 복사해 자식 프로세스를 생성해도 code 영역은 공유된다. 
  - code 영역은 read only memory 이기 때문에 
- 자식 프로세스는 부모 프로세스의 ram 영역 값도그대로 복사 해 온다.
  - 하지만, 자식 프로세스가 새성될 당시 메모리가 바로 복사되는 것이 아니라, 메모리에 값을 작성하는 시점에 복사가 된다.
  - 즉, 부모나 자식 프로세스에서 값을 덮어쓰거나 새로 생성하지 않은 변수에 대해서는 같은 메모리를 바라보고 있다고 볼 수 있다.
- 메모리는 reference count를 들고 있어 몇개의 프로세스에서 해당 영역을 참조하는지 체크한다.

### 프로세스 생명 주기 (Life Cycle)
- 모든 프로세스는 부모 프로세스가 있고, 가장 최초로 실행된 프로세스를 init 프로세스라 하며, init 프로세스의 pid는 1이다. 

- 생성된 프로세스는 `exit()` 함수를 호출하면 종료된다. (일반적으로 main 함수의 리턴값이 exit을 호출하도록 되어있다.)
- `exit`은 라이브러리로 버퍼를 flush하고, open된 모든 파일을 close하고, 프로세스가 사용하고 있는 메모리 풀을 반환한다. 그후 `_exit` 을 호출하여 프로세스를 종료시킨다.
- 하지만, `exit`만 호출되었다고 해서 프로세스가 완벽하게 종료되는 것이 아니다. exit을 호출하면 부모 프로세스에서 상태코드(exit의 인자값)를 받아가기를 대기한다. 메모리의 반환 작업은 부모 프로세스의 처리가 끝나야 이루어진다.
  - `exit`의 결과값을 처리하는 함수는 `wait` 이다. 부모 프로세스에서 `wait`을 실행하면 그제서야 자식 프로세스는 메모리를 정리하고 완벽하게 종료된다. 
  - (커널 레벨에서 자식은 부모를, 부모는 자식들의 포인터를 갖고 있어 서로 참조할 수 있도록 연결되어 있다.)

#### 좀비 프로세스
- 부모 프로세스에서 wait를 호출하지 않아 자식 프로세스를 정리해 주지 않으면 `좀비 프로세스`가 생성된다. 
- 좀비 프로세스는 사용하지 않는 메모리 및 리소스들을 차지하고 있어서 다른 프로세스들의 성능을 저하시킨다.

#### 고아 프로세스
- 자식 프로세스보다 부모 프로세스가 먼저 종료되는 경우, 그 자식 프로세스들은 `고아 프로세스`가 된다. 
- 고아 프로세스들은 종료 처리를 해줄 부모 프로세스가 없기 때문에 좀비 프로세스가 될 수 있는데, 이를 막기 위해 커널은 고아 프로세스를 주기적으로 찾아 'init' 프로세스의 자식으로 재설정한다. 

#### signal
- wait() 함수를 호출하면 부모 프로세스는 자식 프로세스가 exit를 호출하기를 기다린다. 
- 이렇게 되면, 부모 프로세스는 다른 동작을 수행하지 못하여 concurrent한 동작 수행이 불가능하다.
- 부모가 자기 할 일을 수행하다 자식이 종료될 떄 종료 처리를 해 주도록 하려면 `signal` 기능을 사용하면 된다.
  - 자식 프로세스에서 exit를 호출하면 내부적으로 부모 프로세스에 SIGCHLD(sig child) 시그널을 보내도록 되어 있다. 
  - 부모 프로세스에서는 `signal(SIGCHLD, my_function)` 형태로 SIGCHLD 시그널의 처리를 my_function 으로 받아서 처리하도록 하고, myfunction 안에서 `wait`을 호출하면 된다.   
  ```
  signal(SIGCHLD, my_function);
  ...
  fork()
  ...
  my_function() { wait(0); }
  ```

- 단, 자식 프로세스가 여러개인 경우, 동시에 종료되는 자식 프로세스들에 대해서는 단순 signal 로 처리가 불가능하다.
  - signal이 호출되어 my_function이 돌고 있는 도중에 다음 signal이 호출되면, my_function 함수가 또 호출되지 않는다. 해당 signal은 무시되는 것이다.
  - 하지만, signal은 무시되더라도 '부모 프로세스가 처리해야할 목록' 에는 추가되기 때문에, wait()를 반복한다면 동시에 종료된 자식 프로세스들도 처리할 수있다. 
  - 또한 wait 대신 waitpid 를 사용하여 timeout을 짧게 가져가는 식으로 부모 프로세스의 concurrency도 보장할 수 있다. (WNOHANG 옵션으로 더이상 처리할 내용이 없으면 기다리지 않도록 할 수 있음)
    ```
    my_function() { while ( waitpid(-1, 0, WNOHANG) > 0 ); }
    ```

  - 하지만, SIGCHLD 시그널은, 자식 프로세스가 종료되었을 때 뿐 아니라, 정지되었을 때도 호출된다. signal 설정 옵션으로 자식 프로세스가 종료되었을 때 날아오는 SIGCHLD 는 처리하지 않도록 설정해야 완벽하다.
    - signal의 상위호환인 `sigaction` 함수를 사용하면 flag를 설정하여 처리 가능하다.

### Init Process
- init 프로세스는 고아 프로세스들을 모아서 종료시켜준다. 
  - init 프로세스는 `socketpair()` 을 사용하여 3번4번 entry에 socket을 하나씩 연다. 3번 socket은 4번 socket으로 pipeline이 연결되어 있다. 
  - signal handler가 프로세스에서 고아 프로세스를 감지하면 3번 entry의 socket으로 데이터를 write 하면, init 프로세스의 4번 socket에서 데이터가 튀어나온다. 
  - 4번 socket에서 데이터를 받은 init 프로세스는 받은 데이터를 기반으로 고아 프로세스를 처리한다.
- 이런 식으로 구조를 짜면, 커널에서 직접 프로세스를 처리하지 않고, init process가 프로세스 처리를 하도록 할 수 있다. 


```
| signal handler | ---write()------↴  ↷ 
                     |[0] [1] [2]  [3]  [4]|
                     | init process     ↙  |
                     |             wait()  |
                     |                     | 
                     |                     |                       
                     |                     | 
```


### exec 함수
`system()` 이라는 라이브러리 함수로 커널 명령을 실행할 수 있다. 내부적으로 exec 함수들을 사용한다.
- exec뒤에 붙은 글자에 따라 인자로 받는 데이터의 형태나 종류가 달라지며, 여러 속성들을 합해서 사용 가능하다. 
- exec함수들은 `execve` 를 제외하고는 모두 라이브러리이며, 최종적으로 execve를 호출한다. 
1. `l` : 리스트 형태의 인자를 받아 명령어 호출시 전달
   - ex) `execl("ls", "-l")`

2. `v` : 벡터 형태의 인자를 받아 명령어 호출시 전달
   - ex) 
     ```
     char* cmd[] = {"/bin/ls", "ls", "-l", null}; // 파일 위치, 프로세스 이름, argument
     excecv(cmd);
     ```

3. `e` : 환경변수를 인자를 받아 명령어 호출시 전달
   - ex)
      ```
      char* env[] = {"name=justin", "age=20", null}; 
      excece(cmd);
      ```
   - ex) v와e를 혼합해서 사용 가능
      ```
      char* cmd[] = {"/bin/ls", "ls", "-l", null}; // 파일 위치, 프로세스 이름, argument
      char* env[] = {"name=justin", "age=20", null}; 
      excecve(cmd, env);
      ```
    - c에서 main 함수는 `int main(int argc, char** argv, char** envp)` 형태이다.
      - argc: 인자의 갯수
      - argv: 인자의 배열
      - envp: 환경변수의 배열

4. `p` : 환경변수 path를 참조하여 명령어 실행
   - exec 파일들은 기본적으로 path를 참조하지 않고 실행되어 명령어 파일의 절대경로를 인자로 넣어야 한다. 
   - p옵션이 붙은 함수를 사용하면 환경변수 path를 사용하여 명령어를 실행할 수 있다.
   - ex) `execlp("ls", "ls", "-l", null)`

#### 쉘을 이용한 옵션처리
- `execlp(command, command, null);` 형태로 실행하지 않고, `execl("/bin/sh", "sh", "-c", command, null);` 형태로 실행하면 'command' 명령을 쉘이 실행하게 되어 옵션을 알아서 처리해 준다.

#### exec로 생성한 프로세스의 속성
1. 상속되는 속성
  - 파일 디스크립터
  - 사용자 ID, 그룹 ID, 프로세스 그룹 ID, 세션 ID, 제어 터미널
  - alarm 시그널 남은 설정시간
  - 작업 디렉터리, root 디렉터리
  - 파일 잠금 여부, 파일 생성 마스크
  - 자원 제약, CPU 사용시간
2. 상속되지 않는 속성
  - signal의 처리는 SIG_IGN 처리되던 시그널 외에는 default로 복구된다. 
  - 유효 사용자 ID (파일 속성에서 set_user_ID 비트가 설정된 경우)
  - 유효 그룹 ID (set_group_id 비트가 설정된 경우)

#### reference count
- exec를 사용하여 프로세스를 호출하면, 그 아래 line들은 실행이 되지 않는다. 
  - 프로세스는 코드 영역 메모리를 참조하고, 메모리는 reference count를 두어 몇개의 프로세스가 해당 메모리를 참조하는지 체크한다.
  - 이때, exec를 사용하면 기존 프로세스는 code 영역을 내버려두고 exec에서 사용할 새로운 코드영역을 참조하게 된다. (+program counter 이동)
  - 그렇게 되면 기존에 남아있던 코드 영역 메모리는 reference count가 0이되어 더이상 사용하지 않는 메모리로 취급되어 free된다.

-> fork와 exec를 함께 사용하면 exec 아래의 코드도 실행할 수 있게 할 수 있다. 
```
...
pid = fork()
if (pid)
  exec(...);
wait(0);
something_to_do(); // 부모 process에서 실행 가능
...
```