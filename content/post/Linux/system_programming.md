---
title: "리눅스 C 시스템 프로그래밍: 파일 I/O, 디스크립터(FD), stat 속성 및 링크 구조"
description: "리눅스 C 시스템 프로그래밍의 기초인 표준 I/O 라이브러리와 저수준 시스템 콜의 차이, 파일 디스크립터(FD)와 dup 리다이렉션 원리, struct stat 기반 퍼미션 분석 및 하드·심볼릭 링크 동작 메커니즘을 상세히 다룹니다."
slug: "linux-c-system-programming-file-io-and-attributes"
date: 2023-07-15T08:35:21+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Linux"]
tags: ["linux", "c", "system-programming", "file-descriptor", "posix"]
ShowToc: true
TocOpen: true
---

# 리눅스 C 시스템 프로그래밍

## 시스템 소프트웨어 아키텍처
리눅스 상에서 프로그램이 동작하는 계층 구조는 애플리케이션, 커널, 하드웨어 계층으로 구분됩니다.

```text
+-----------------------------+
|    Application (C Library)   |  User Space (사용자 버퍼 활용)
+-----------------------------+
|    Kernel (System Call API) |  Kernel Space (커널 버퍼 캐시 활용)
+-----------------------------+
|       Hardware (Disk, RAM)  |  Physical Space
+-----------------------------+
```
- **애플리케이션 계층**: 표준 C 라이브러리(`glibc`: `fopen`, `fread`, `fwrite`)를 사용하며 유저 공간의 라이브러리 버퍼(`BUFSIZ`, 보통 4KB/8KB)를 통해 입출력 횟수를 최적화합니다.
- **커널 계층**: 저수준 시스템 콜(`open`, `read`, `write`, `close`)을 통해 커널 내부의 페이지 캐시와 파일 시스템 드라이버를 직접 호출합니다.

## 표준 입출력 라이브러리 (stdio.h)

### 파일 스트림과 fopen
- `FILE *fopen(const char *pathname, const char *mode)`: 파일 경로와 모드(`"r"`, `"w"`, `"a"`, `"r+"`)를 인자로 받아 `FILE` 구조체 포인터를 반환합니다.
- `fgetc(FILE *stream)`: 스트림으로부터 1바이트 문자(`unsigned char`)를 읽어 `int`로 반환합니다.
  - EOF(파일의 끝) 값은 `-1`로 정의되어 있습니다. 바이너리 파일 내의 `0xFF` 바이트와 EOF를 명확히 구분하기 위해 반환 타입으로 `char` 대신 4바이트 `int`를 사용합니다.
- `fgets(char *s, int size, FILE *stream)`: 지정한 크기 또는 개행 문자(`\n`)를 만날 때까지 행 단위로 문자열을 읽어옵니다.
- `fputs(const char *s, FILE *stream)`: 문자열을 파일 스트림으로 출력합니다.

### FILE 구조체와 버퍼링
- `FILE` 구조체(`_IO_FILE`)는 파일 접근을 위한 메타데이터를 유지합니다.
  - `_IO_read_ptr`: 다음 번 읽기 작업이 수행될 버퍼 위치
  - `_IO_read_end`: 커널로부터 전달받아 채워둔 버퍼의 끝 위치
  - `_IO_read_base`: 유저 공간 읽기 버퍼의 시작 위치
  - `_fileno`: 해당 스트림과 연결된 실제 커널 파일 디스크립터(FD) 정수 번호
- **EOF(End-of-File)의 본질**: 실제 디스크 파일 끝에 `-1`이라는 특별한 바이트가 기록되어 있는 것이 아닙니다. 커널이 i-node에 기록된 파일 크기를 기반으로 더 이상 읽을 데이터가 없을 때 I/O 함수의 리턴값으로 EOF(`-1`)를 반환합니다.

### 파일 오프셋과 fseek/ftell
파일을 열면 커널이 파일 내 읽기/쓰기 기준 위치를 나타내는 **파일 오프셋(File Offset)**을 내부적으로 관리합니다.

- **fseek(FILE *stream, long offset, int whence)**: 기준 위치(`whence`)로부터 `offset`만큼 파일 커서를 이동합니다.
  - `SEEK_SET`: 파일의 시작 지점 기준
  - `SEEK_CUR`: 현재 파일 오프셋 기준
  - `SEEK_END`: 파일의 끝 지점 기준
- **ftell(FILE *stream)**: 현재 파일 오프셋의 절대 바이트 위치를 반환합니다.
- **버퍼 접근 속도 비교**: 단위 호출 횟수가 적을수록 시스템 콜 오버헤드가 감소하여 처리 속도가 향상됩니다 (`fgetc` < `fgets` < `fread`).

## 저수준 파일 I/O와 파일 디스크립터

### System Call API (fcntl.h / unistd.h)
| 표준 C 라이브러리 | POSIX 시스템 콜 | 제어 대상 및 특징 |
|---|---|---|
| `fopen()` | `open()` | `FILE*` 스트림 vs 정수형 `fd`, 파일 플래그(`O_RDONLY`, `O_WRONLY`, `O_CREAT`, `O_APPEND` 등) |
| `fread()` | `read()` | 버퍼링 기반 읽기 vs 즉시 커널 버퍼 직접 전송 |
| `fwrite()` | `write()` | 버퍼링 기반 쓰기 vs 즉시 커널 버퍼 직접 전송 |
| `fclose()` | `close()` | 버퍼 플러시 후 FD 해제 vs FD 즉시 반환 |

### 파일 디스크립터 테이블 (File Descriptor Table)
- 프로세스가 실행되면 커널은 프로세스마다 독립적인 파일 디스크립터 배열을 할당합니다.
- 배열의 인덱스 번호가 **파일 디스크립터(FD)**이며, 각 엔트리는 오픈 파일 테이블(Open File Table)의 객체를 가리킵니다.
  - `0`: 표준 입력 (`STDIN_FILENO` / `stdin`)
  - `1`: 표준 출력 (`STDOUT_FILENO` / `stdout`)
  - `2`: 표준 에러 (`STDERR_FILENO` / `stderr`)
- 새로 열리는 파일은 3번부터 비어 있는 가장 작은 정수 인덱스가 순차적으로 할당됩니다.

### 리다이렉션과 dup2
- `int dup(int oldfd)`: 기존 파일 디스크립터를 복제하여 비어 있는 가장 작은 인덱스에 동일한 파일 객체 주소를 바인딩합니다.
- `int dup2(int oldfd, int newfd)`: `newfd`를 원자적으로 닫은 후 `oldfd`의 사본으로 교체합니다.

```c
// 표준 출력(1)을 파일로 리다이렉션하는 C 예시
int fd = open("output.log", O_WRONLY | O_CREAT | O_TRUNC, 0644);
dup2(fd, STDOUT_FILENO); // 1번 디스크립터가 output.log를 가리킴
close(fd);

printf("이 문자열은 콘솔 대신 output.log 파일에 저장됩니다.\n");
```

## 파일 속성 분석 (struct stat)
`<sys/stat.h>`에 정의된 `stat()` 시스템 콜을 통해 파일의 상세 메타 정보를 조회할 수 있습니다.

```c
#include <sys/stat.h>
struct stat buf;
int ret = stat("./target_file", &buf);
```

- `st_mode`: 16비트로 구성된 정수값으로 파일 유형과 권한을 표현합니다.
  - **파일 유형 매크로**: `S_ISREG(buf.st_mode)` (일반 파일), `S_ISDIR()` (디렉터리), `S_ISLNK()` (심볼릭 링크), `S_ISFIFO()` (파이프), `S_ISSOCK()` (소켓).
  - **접근 권한 (Permissions)**: 9비트로 구성되며 Owner/Group/Others 각각에 대해 Read(4), Write(2), Execute(1) 권한을 나타냅니다.
  - **특수 권한 (3비트)**:
    - **SetUID (`04000`)**: 실행 시 파일 실행자의 권한이 아닌 소유자(예: root)의 권한으로 프로세스가 동작합니다 (`passwd` 명령어가 대표적, 실행 자리에 `s` 표기).
    - **SetGID (`02000`)**: 실행 시 파일 그룹의 권한으로 동작합니다.
    - **Sticky Bit (`01000`)**: 공용 디렉터리(`/tmp`)에 설정 시, 모든 사용자가 파일을 생성할 수 있으나 삭제 및 수정은 파일 소유자만 가능합니다 (`t` 표기).
- `st_nlink`: 해당 i-node를 참조하는 디렉터리 엔트리(하드 링크)의 총 개수입니다.
- `st_uid` / `st_gid`: 소유자 UID와 소유 그룹 GID (`getpwuid(uid)`, `getgrgid(gid)`로 이름 변환 가능).
- `st_size`: 파일의 실제 바이트 크기.
- `st_mtime`: 최근 파일 내용 수정 시간 (Unix Timestamp, `localtime()` 또는 `ctime()`으로 포맷팅 가능).
- `lstat()` vs `stat()`: 심볼릭 링크 파일에 대해 `stat()`은 원본 대상 파일의 정보를 가져오지만, `lstat()`은 심볼릭 링크 자체의 정보를 가져옵니다.

## 링크 구조와 파일 삭제 메커니즘

### 하드 링크 (Hard Link)와 심볼릭 링크 (Symbolic Link)
- **하드 링크 (`ln file link`)**:
  - 기존 파일과 동일한 i-node 번호를 가리키는 새로운 디렉터리 엔트리를 추가합니다.
  - 파일 데이터와 메타데이터를 완벽히 공유하며, 생성 시 i-node의 `nlink` 값이 1 증가합니다.
  - 파일 시스템이 서로 다른 파티션 간에는 i-node 번호 체계가 다르므로 생성이 불가능하며, 무한 루프 위험으로 인해 디렉터리의 하드 링크는 금지되어 있습니다.
- **심볼릭 링크 (`ln -s file symlink`)**:
  - 원본 파일의 경로 문자열을 데이터 블록에 저장하는 독립된 파일입니다.
  - 새로운 i-node를 할당받으며, 다른 파일 시스템 및 디렉터리에 대해서도 자유롭게 링크할 수 있습니다.
  - 원본 파일이 가리키는 실경로는 `readlink()` 시스템 콜로 읽어올 수 있습니다.

### 파일의 완전 삭제 시점 (연결 계수와 참조 계수)
리눅스 파일 시스템에서 파일 데이터 블록과 i-node가 실제로 디스크에서 해제(Free)되는 조건은 다음 두 가지가 모두 만족될 때입니다.
1. **연결 계수(Hard Link Count, `st_nlink`)가 0**: `unlink()` 시스템 콜로 모든 디렉터리 엔트리가 삭제되어 파일 이름 매핑이 소멸한 상태.
2. **참조 계수(Reference Count)가 0**: 실행 중인 어떠한 프로세스도 해당 파일에 대해 열린 파일 디스크립터(`open`)를 유지하고 있지 않은 상태.

## 디렉터리 탐색 및 옵션 파싱

### 디렉터리 엔트리 순회 (dirent.h)
디렉터리는 내부 파일 목록을 저장하는 특수 파일입니다.
- `DIR *opendir(const char *name)`: 디렉터리 스트림 포인터를 획득합니다.
- `struct dirent *readdir(DIR *dirp)`: 디렉터리 내 엔트리를 한 개씩 순차적으로 읽어 반환합니다 (끝에 도달하면 `NULL`).
  - `d_ino`: 파일 i-node 번호
  - `d_name`: 파일 이름
- `int closedir(DIR *dirp)`: 디렉터리 스트림을 닫습니다.

### 커맨드라인 옵션 파싱 (getopt)
`<unistd.h>`의 `getopt()` 함수를 활용하여 POSIX 표준 명령줄 옵션을 손쉽게 파싱할 수 있습니다.

```c
#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    int opt;
    // -a, -b, -c <값> 옵션 정의 (콜론 뒤에는 인자 필수)
    while ((opt = getopt(argc, argv, "abc:")) != -1) {
        switch (opt) {
            case 'a': printf("옵션 -a 설정\n"); break;
            case 'b': printf("옵션 -b 설정\n"); break;
            case 'c': printf("옵션 -c 인자값: %s\n", optarg); break;
            default: break;
        }
    }
    // 남은 비옵션 인자 출력
    for (int i = optind; i < argc; i++) {
        printf("일반 인자: %s\n", argv[i]);
    }
    return 0;
}
```
