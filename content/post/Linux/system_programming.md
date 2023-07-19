---
title: "System_programming"
date: 2023-07-15T08:35:21+09:00
lastmod: 2023-07-15T08:35:21+09:00
tags: ["linux", "system_programming"]
categories: ["dev",]
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

# System Programming
- 프로그램이 동작하는 구조는 크게 application, kernel, HW 로 분리할 수 있다.
```
_____________
|  Library  |
¯¯¯¯¯¯¯¯¯¯¯¯¯   Application level
------------------------------
_____________
|System call|
¯¯¯¯¯¯¯¯¯¯¯¯¯   Kernel level
------------------------------
_____________
|  Hardware  |
¯¯¯¯¯¯¯¯¯¯¯¯¯   H/W level
------------------------------
```
- application level에서는 library를 사용하며, 이 코드들은 library buffer를 사용한다. (open(), read(), write(), close() ...)
- Kernel level에서는 System call을 사용하며 system buffer를 사용한다.
- application level 함수를 사용하면, 보통 library buffer를 1차적으로 사용하고, 내부적으로 system call을 수행해 system buffer를 2차적으로 사용하게 된다.
  - printf는 c library 함수이며, '\n'을 만나야 화면상에 출력을 한다.
  - '\n'이 입력되기 전 까지 문자열들은 library buffer에 기록된다.
  - fprintf는 '\n'과 상관없이 문자열을 출력한다. 즉 library buffer를 사용하지 않는다. 


## 파일 입출력

### fgetc
- C에서 파일에 접근하기 위해서는 `fopen` 함수를 사용한다. 
- `fopen`은 파일 포인터를 반환하며, 코드 내에서 파일 포인터로 해당 파일에 접근이가능하다.
- `fgetc(FPTR)` 함수는 fopen으로 연 파일 포인터를 참조해서 char 하나를 읽고 반환한다.
  - fgetc 함수의 반환 값은 int 형태이다.
  - text file을 읽을 땐, 0xFF값이 내용에 올 수 없지만, binary file을 읽을 땐 중간에 0xFF 값이 올 수 있다.
  - char 형태로 0xFF를 읽으면 -1값에 해당하기 때문에, EOF와 구분이 불가능하여 char 대신 int를 반환하도록 되어있다.

### 파일 구조체
- `fopen`은 파일 구조체의 주소(포인터)를 반환한다.
- 파일 구조체는 아래와 같은 내용을 담고 있다.
  - _flags: 
  - _IO_read_ptr : 다음 명령시 파일을 읽거나 쓸 위치
  - _IO_read_end: kernel에서 데이터를 받아서 저장할 버퍼의 끝 위치.
  - _IO_read_base: kernel에서 데이터를 받아서 저장할 버퍼의 시작 위치. 파일에 대한 읽기 명령(fgetc/fgets등) 이 발생했을 때, kernel은 4096byte(BUF_SIZE) 만큼 데이터를 미리 읽어서 이곳에 채워둔다.
  - _fileno: 파일의 offset, kernel에서 해당 파일에 정해준 index(kernel 함수에서 사용할 수 있다.)
- fopen 시에 파일 구조체가 생성 및 초기화 되지만, _IO_read_* 인자들은 파일 접근이 이루어짐과 동시에 값이 적용된다.


### EOF
- 파일을 끝까지 읽었다고 판단하는 것은, EOF 문자(-1) 으로 판단한다. 
  - 하지만 실제파일을 읽어보면 마지막에 -1값이 실제로 들어있지는 않다. 
  - **EOF 값은 file I/O 함수의 리턴값일 뿐 실제 파일에 기입된 값이 아니다.**
  - file I/O 함수는 i-node에 기록된 파일의 크기를 기반으로 파일 끝을 판단한다.

> - ASKII 코드 중 주요 문자의 값 참조
>  - a: 97
>  - A: 68
>  - 0: 48
>  - \n: 10
>  - \r: 13
>  - (공백): 32
>  - \t: 9
>  - \0: 0

- `fguts(BUFF, SIZE, FPTR)` 함수는 fopen으로 연 파일 포인터를 참조해서 line 하나를 읽어온다.
- `fputs(BUFF, FPTR)` 함수는 fopen으로 연 파일 포인터를 참조해서 line 하나를 출력한다. 
  - 리눅스에서 표준 입력/출력/에러는 기본적으로 파일 포인터를 열어둔다. 각각 아래 문자열 혹은 번호로 참조 가능하다.
  > `stdin` : 표준 입력 
  > `stdout` : 표준 출력    
  > `stderr`: 표준 에러      
  -> 파일 포인터 대신 `stdout` 을 입력하면 표준 출력으로 문자열이 출력된다. (ex: `fputc(BUF, stdout)`)
  
### file offset
- `fopen` 으로 파일을 열게 되면 user는 파일의 읽고 쓸 위치를 설정하지 않는다.
- 파일을 읽고 쓸 위치를 file offset이라고 하며, kernel 내부의 파일 구조체를 사용하여 kernel에서 자체적으로 관리된다.

#### fseek & ftell
- `fseek(FILE_POINTER, OFFSET, POSITION)` : 파일의 POSITION에서 offset 만큼 file offset을 이동. 
  - POSITION은 아래 세 가지를 사용 가능하다.
    1) SEEK_SET : 파일의 처음 위치
    2) SEEK_CUR : 현재 커서(file offset)의 위치
    3) SEEK_END : 파일의 끝 위치
  - 반환값은 이동 후 file offset의 값이다. 
  - ex) `fseek (fp, 0, SEEK_SET)`: 커서를 파일 처음으로 이동
  - ex) `fseek (fp, -10, SEEK_END)`: 커서를 파일 끝에서 10바이트 앞으로 이동
  - ex) `fseek (fp, 10, SEEK_CUR)`: 커서를 현재 위치에서 10바이트 뒤로 이동
- `ftell(FILE_POINTER)` : 현재 file offset을 반환


### 입출력 속도
1) fgetc / fputc : 바이트 단위로 파일을 읽거나 쓰는 함수
2) fgets / fputs : 라인 단위로 파일을 읽거나 쓰는 함수 (버퍼가 허용하는 한)
3)  fread / fwrite : 특정 크기만큼 파일을 읽고 쓰는 함수   
-> 버퍼 접근 횟수를 적게 할 수록 속도 측면에서 유리하다. (1 < 2 < 3)

## Application Library vs System Call
- `stdio.h` vs `fcntl.h` : application library는 stdio.h 헤더를, system call은 fcntl.h 헤더에 함수가 정의되어 있다.
- `fopen(FILE_POINTER, TYPE)` vs `open(FILE_DESCRIPTOR, FLAG, AUTHORITY)` : 파일을 여는 함수
  - fopen은 `FILE` 타입의 file pointer를 사용하지만, open은 `int` 타입의 file descriptor를 사용한다. 
  - fopen은 "r", "w" 등 파일 용도를 지정하지만, open은 flag로 읽기/쓰기 등 옵션을 적용한다. (flag는 | 연산자로 복합 적용할 수 있음)
    - O_RDONLY: 읽기 전용
    - O_WRONLY: 쓰기 전용
    - O_RDWR: 읽기/쓰기 모두
    - O_CREAT: 파일 없으면 생성
    - O_EXCL: 파일 존재시 error 반환
    - O_APPEND: 기존에 있던 파일 맨 뒤부터 이어쓰기
    - O_TRUNC: 기존에 있던 파일 지우고 처음부터 쓰기
- `fread` vs `read` : 파일을 읽는 함수
- `fwrite` vs `write` : 파일에 출력하는 함수
- `fclose` vs `close`

### File Descriptor
- 리눅스에서 파일을 열면, 현재 열어둔 파일마다 index를 매기고, 이를 배열에 저장한다. 이 배열을 file descriptor array라 하고, index를 file descriptor라 한다.
- file descriptor array의 각 item들은 file structure를 가리킨다. 
```
 ↱ file descriptor array
[0]  -> [file structure A]
[1]  -> [file structure B]
[2]  -> [file structure C]
[3]  -> [file structure D]
```
- file structure는 파일의 metadata를 저장하고 있다(크기, file offset 등).
  - 파일을 열면, 커널 내부적으로 커서를 두고, 어느 위치를 읽을지/쓸지 결정한다. 이를 file offset이라 칭한다. 
- 리눅스는 실행시 stdin, stdout, stderr를 파일 형태로 열고, 이는 각각 0, 1, 2 index에 해당한다.
- 이후 open() 함수에 의해 열리는 파일들은 3번부터 순서대로 indexing 되며, 이는 커널이 알아서 설정하며 user는 관여할 수 없다.
- 동일한 이름의 파일들을 여러 번 열더라도, 새로운 file descriptor에 할당된다. 

### Redirection
- `dup(FILE_DESCRIPTOR)` 명령은 FILE_DESCRIPTOR 에 해당하는 file structure 주소를 새로운 file descriptor에 담고 반환한다. 
  - 새로운 file structure를 만들지 않고 주소만 복사 해 오기 때문에, 얕은 복사와 같이 file structure 내부의 모든 인자를 두 개의 file descriptor에서 참조할 수 있다. 
  - 이 때문에 file structure 에는 몇개의 file descriptor가 file structure를 참조하고 있는지를 나타내는 count 인자가 존재한다. 

- 표준 입출력 에러는 0,1,2 file descriptor를 사용하고 있는데, 이를 close하고 dup를 이용해 원하는 파일 descriptor를 0,1,2 자리에 넣을 수 있다. 
- 예를 들어 `close(1); dup(fd1);`을 수행하면 표준 출력을 close하고 1번 descriptor에 fd1 파일을 연결하게 된다.
- application library에서 표준 입출력을 사용할 때, 내부적으로 `read(0, ...)`, `write(1, ...)` 을 사용하고 있으므로, `printf("HELLO");` 을 하면 표준 출력으로 "HELLO" 가 출력되게 된다.


-> 이렇게 file descriptor 연결 구조를 재구성 하는 작업을 redirection이라 한다.


## 파일의 속성
- `stat(FILE_NAME, STAT_STRUCT)`: FILE_NAME 파일에서 stat 데이터(파일 정보)를 추출해 STAT_STRUCT 버퍼에 저장, 데이터는 `struct stat` 형태이다.
  - `sys/stat.h` 헤더파일에 정의되어 있다.
  - `.st_mode`: 2byte로 구성되며, 파일의 종류와 권한을 나타낸다.
    - 파일의 종류는 처음 4bit로 구분이 가능하다.
      - regular, directory, symbolic link 등 종류가 있다.
      - S_ISREG(st.st_mode), S_ISDIR(st.st_mode), S_ISLNK(st.st_mode) 등 매크로로 쉽게 확인 할 수 있다.
    - 다음 3bit는 특수 권한을 타나낸다. 각 bit는 owner, group, other의 특수권한 여부를 나타낸다. 
    - 다음 3bit는 owner의 권한을 나타낸다. 각 bit는 read(읽기), write(수정), execute(실행) 권한을 나타낸다. 
    - 다음 3bit는 group의 권한을 나타낸다. 각 bit는 read(읽기), write(수정), execute(실행) 권한을 나타낸다. 
    - 다음 3bit는 other의 권한(이외 다른 사람)을 나타낸다. 각 bit는 read(읽기), write(수정), execute(실행) 권한을 나타낸다. 
    - 디렉터리도 read/write/execute권한을 가지고 있지만, 의미가 달라진다. 
      - read : 디렉터리 참조 권한(`ls`명령)
      - write : 디렉터리 내부에 파일 생성 혹은 삭제 권한
      - execute : 디렉터리 내부로 이동 권한(`cd` 명령)

```
파일 종류
  |    특수권한
  |    |    owner권한
  |    |    |    group권한
  |    |    |    |    ┌ other권한
[0000][000][000][000][000]
```
  - `.st_nlink` 값은 파일에 걸려있는 hard link의 갯수를 나타낸다. (unsigned long int)
  - `.st_uid` 값은 파일을 소유한 user의 uid값을 나타낸다. 
    - `/etc/passwd` 경로에 username과 uid 매핑 테이블이 있다. 
    - `getpwuid` 함수로 uid를 넘겨주면 `struct passwd` 구조체 포인터를 반환해 주는 함수가 있으므로, 이를 사용하면 된다. 
      - struct passwd 에는 /etc/passwd 파일에 적히는 데이터들을 그대로 구조체로 담아낸 형태이며, pw_name, pw_passwd, pw_uid, pw_gid 등 데이터를 참조 가능하다.
      - `pwd.h` 헤더에 정의되어 있다.
  - `.st_gid` 값은 파일이 속한 group의 gid 값을 나타낸다. 
    - `getgrgid` 함수로 gid를 넘겨주면 `struct group` 구조체 포인터를 반환해주는 함수가 있다. 
      - `grp.h` 헤더에 정의되어 있다..
      - 파일 하나에 속한 그룹은 한개 이상일 수 있다. 
  - `.st_size` 값은 파일 크기를 의미한다. (unsigned long int)
  - `.st_mtime` 값은 파일을 마지막으로 수정한 시간이며, 이는 epoch time 값이다. 
    - `ctime` 함수를 사용하여 `ctime(&st.st_mtime)`을 활용하면 사용자 친화적으로 변경된 string을 출력할 수 있다. 
      - `time.h` 헤더파일에 정의되어 있다. 
    - `localtime` 함수를 사용하면 epoch time을 받아서 `struct tm` 구조체에 담아주어 ctime보다 더 유연하게 출력 형태를 정의할 수 있다.
      - ex) `printf("%d월 %d일 %02d:%02d", _tm->tm_mon + 1, _tm-> tm_day, _tm->tm_hour, _tm->tm_min);`
    - `.st_rdev` 값은 device ID 값으로, 상위 1byte는 major 번호, 하위 1byte는 minor 번호이다. 
      - `ls` 입력시 block device 파일(S_IFBLK)이나 char device 파일(S_IFCHR)들은 파일 크기 대신 major 번호, minor 번호를 출력한다.
  - 심볼릭 링크에 대해 `stat`을 사용하면, 원본 파일의 정보를 받아오지만, `lstat`을 사용하면 symbolic link 파일 자체의 정보를 받아온다. 
    -  symbolic link가 가리키는 원본 파일의 이름은 `readlink()` 함수에 file path를 넣어 받아올 수 있다.
      - `unistd.h` 헤더에 선언되어 있다.

  - `ls` 명령어도 이 정보를 참조하여 파일 정보를 출력 해 준다.

### 특수 권한
- 특수 권한은 3비트로 이루어져 있고, 각각 set_user_id bit, set_group_id bit, sticky bit 를 의미한다. 
1. Set User Id
   - 퍼미션의 일반적인 룰 상 수정할 수 없는 파일도 set_user_id bit를 활성화 하면 수정이 가능하게 된다.
     - ex) 비밀번호는 `/etc/shadow` 파일에 저장되지만, 이 파일은 일반 user들이 접근할 수 없도록 권한이 설정되어 있다. 하지만, passwd 명령어로 비밀번호를 바꾸면, /etc/shadow에 저장된 비밀번호도 변경할 수 있다.
   - 파일을 실행했을 때 권한은 파일의 소유자가 아닌 실행한 유저의 권한을 따른다. (`ps -ef` 명령으로 권한 확인 가능) 하지만 set_user_id 비트가 설정된 파일을 실행할 때 파일의 소유자의 권한을 얻게 된다.
   - set_user_id 가 설정되면 ls 명령시 owner의 execute 권한이 's' 혹은 'S'로 표시된다.

2. Sticky Bit
- 파일을을 읽고 쓰고 실행하는 것은 '파일' 자체의 권한을 따른다.
- 하지만 파일을 생성하고 지우는 것은 파일이 속한 '디렉터리'의 권한을 따른다. 
- sticky bit를 설정하면 해당 파일은 '삭제' 동작에 대해 디렉터리의 권한을 따르지 않고, 파일의 소유자만 삭제할 수 있도록 설정된다.
- sticky bit가 설정되어 있으면 ls 명령시 other의 execute 자리에 't' 혹은 'T'로 표시된다.

### 연결 계수 & 참조 계수
- 파일이 지워지는 시점은 연결 계수와 참조 계수가 모두 0이되는 시점이다.
1. 연결 계수
   - 파일을 생성하면 directory entry와 inode 구조체, data 영역이 생성된다. 
   - inode 구조체에는 연결계수(nlink) 값이 1로 설정된다.
   - `unlink(D_ENTRY)` 함수로 특정 directory entry를 삭제할 수 있다.
   - directory entry가 삭제되면 해당 entry가 참조하던 inode 구조체의 nlink(연결계수) 값도 하나 줄어든다.
   - i-node의 nlink 값이 0 이라면 inode 더이상 해당 파일을 참조하는 entry가 없는 것이다.
   - unlink가 된 시점에 이미 directory entry가 삭제되었기 때문에 해당 파일을 새로 열거나 참조할 방법이 없어진다. 

2. 참조 계수
- `open()` 함수로 file 구조체를 생성하고, file 구조체는 inode 구조체를 참조한다.
- inode 구조체는 해당 nlink를 참조하고 있는 'file 구조체'의 갯수를 count라는 값으로 저장한다.
- `close()` 함수로 파일을 닫으면, 파일 구조체가 참조하던 nlink의 참조 계수가 하나 줄어든다. 
- 연결 계수가 0이 된상태라도 참조 계수가 0이 아니면, inode 구조체와 data 영역은 남아있을 수 있다. (file 구조체로 값 참조 가능)
  - 이후 참조 계수마저 0이 된다면 그제서야 inode 구조체와 data 영역을 지운다.

## 디렉터리 구조
```
DIR* directory_p = opendir(".");
struct direct* directory_entry_p = readdir(directory_p);
```
- 디렉터리 정보는 `struct dirent` 형태의 구조체에 저장된다. 
  - struct dirent 구조체는 디렉터리 내부의 파일들의 정보를 담아내는 구조체이다.
    - `.d_name`: 파일 이름
    - `d_reclen`: 파일 이름 길이
    - `d_ino`: inode 번호
    - `d_off`:: offset 
- `opendir()` 함수로 directory를 열고 directory pointer를 얻은 다음 `readdir()` 함수로 directory 정보를 담은 구조체 포인터를 받아온다.
  - directory pointer란, 디렉터리 정보에 접근할 수 있는 포인터이며, file pointer와 유사하게 cursor(offset)를 갖는다.
  - `dirent.h` 헤더 파일에 정의되어 있다.
- `chdir()` 함수로 현재 프로그램이 참조하는 디렉터리 위치를 변경할 수 있다. (쉘에서 cd 명령과 동일)
  - `unistd.h` 헤더 파일에 정의되어 있다.
- `rewinddir()` : 인자로 받은 directory pointer 의 cursor(offset)를 가장 처음으로 되돌리는 명령

## 커널 명령어 옵션 받기
- 커널에서 명령어를 사용할 때 `-` 문자를 사용하여 옵션을 추가할 수 있다. 
- 커널 명령어를 작성할 때 `unistd.h` 에서 지원하는 `getopt` 함수를 사용하여 커맨드에 입력된 옵션을 간편하게 파싱할 수 있다.
  - `getopt( argc, argv, OPTIONS )`: argc와 argv에서 옵션을 파싱한다.
  - `OPTIONS` 는 옵션으로 처리할 캐릭터들을 char* 형태로 나열한다. (ex: "abcd")
  - 한번 호출 할 때 마다 argv를 하나씩 확인하며 OPTIONS에 해당하는 문자열이 들어있을 경우 옵션에 해당하는 캐릭터를 int형으로 반환한다.
  - 옵션이 더이상 없으면 -1 을 반환한다.

## 파일 링크
- `cp` 명령은 directory entry와 i-node, 데이터를 모두 새로 복사하여 생성하는 deep copy 명령이다.
- 반면 `ln` 명령은 directory entry만 생성하고, i-node와 데이터를 공유하는 객체를 생성하게 된다. (shallow copy와 유사)
- `ln` 명령으로 i-node 데이터를 참조하는 directory entry를 늘리면, i-node안에 `n-link` 라는 데이터가 증가한다. (해당 i-node 데이터를 참조하는 entry의 개수 표시)


### 하드 링크 (hard link)
- `mv` 명령은 파일을 이동하는 명령으로, "복사(cp)" 동작과 "삭제(rm)" 동작을 수행해야 한다. 
- 이때, 데이터가 큰 파일은 복사와 삭제에 자원이 많이 투입된다.
- 하지만 링크를 사용하여 directory entry만 신규로 생성하고, 기존 directory entry를 unlink 하면 i-node 정보와 data 정보는 복사와 삭제 동작을 수행할 필요가 없기 때문에 연산 속도를 대폭 증가시킬 수 있다.
- 참조) 디렉터리는 생성과 동시에 n-link 값이 2가 된다. 디렉터리 내부에 '.' 데이터가 본인을 참조하기 때문. 마찬가지로 '..'도 부모 디렉터리에 대한 하드링크이다.

### 심볼릭 링크 (symbolic link)
1. 디렉터리에 대해서는 하드링크를 설정할 수 없도록 커널에서 설정되어 있다. 
  - 커널 명령어 중 `-R` 옵션이 있는 명령들이 있는데, 이는 '.'과 '..' 에 대해서는 재귀 호출을 하지 않도록 설정되어 있다. 
  - 만약 디렉터리의 하드링크가 가능해지면 이 명령들에 대해 무한 재귀호출이 발생하게 될 수 있어 디렉터리의 하드링크는 금지된다.

2. 파일 시스템이 다르면 하드링크를 설정할 수 없다. 
  - 파일 시스템이 다르면 i-node 구조가 다르기 때문에 서로 참조할 수 없다.

- 이러한 한계점을 해결할 수 있는 것이 심볼릭 링크이다.
- symbolic link는 하나의 파일로 취급되며, 디렉터리를 연결시켜도 파일로서 자신의 정보를 가진다.
  - (stat 함수와 lstat 함수가 symbolic link에 대해 다르게 동작하는 이유는 stat은 link가 가리키는 대상을 나타내고, lstat은 link 파일 자체를 가리키는 것)
- symbolic link는 다른 파일 시스템 간에도 연결시킬 수 있다.

