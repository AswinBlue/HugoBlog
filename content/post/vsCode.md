+++
title = "VsCode"
date = 2022-04-16T09:07:48+09:00
lastmod = 2022-04-16T09:07:48+09:00
tags = []
categories = []
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = false
+++

# VS code
- visual studio code 사용법

## 개발환경
### C / C++
1. 컴파일러
  - gcc 혹은 mingw 설치가 필요하다. 인터넷에서 설치하도록 한다.

1. 설정파일
  - 컴파일 및 실행을 위해서는 launch.json, setting.json, tasks.json 파일이 필요하다.
  - vs code에서 알아서 작성해 주지만, 기본 설정으로 부족한 부분은 수정해야 한다.
```
# settings.json
{
  "C_Cpp_Runner.cStandard": "",
  "C_Cpp_Runner.cppStandard": "",
  "C_Cpp_Runner.msvcBatchPath": "",
  "C_Cpp_Runner.warnings": [
    "-Wall",
    "-Wextra",
    "-Wpedantic"
  ],
  "C_Cpp_Runner.enableWarnings": true,
  "C_Cpp_Runner.warningsAsError": false,
  "C_Cpp_Runner.compilerArgs": [],
  "C_Cpp_Runner.linkerArgs": [],
  "C_Cpp_Runner.includePaths": [],
  "C_Cpp_Runner.includeSearch": [
    "*",
    "**/*"
  ],
  "C_Cpp_Runner.excludeSearch": [
    "**/build",
    "**/build/**",
    "**/.*",
    "**/.*/**",
    "**/.vscode",
    "**/.vscode/**"
  ],
  "C_Cpp_Runner.cCompilerPath": "gcc",
  "C_Cpp_Runner.cppCompilerPath": "C:/Program Files (x86)/mingw-w64/i686-8.1.0-posix-dwarf-rt_v6-rev0/mingw32/bin/g++.exe",
  "C_Cpp_Runner.debuggerPath": "C:/Program Files (x86)/mingw-w64/i686-8.1.0-posix-dwarf-rt_v6-rev0/mingw32/bin/gdb.exe",
  "files.associations": {
    "hash_map": "cpp"
  }
}
```

```
# launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "C/C++ Runner: Debug Session",
      "type": "cppdbg",
      "request": "launch",
      "args": [],
      "stopAtEntry": false,
      "cwd": "f:/Documents/GitHub/acmicpc/15997",
      "environment": [],
      "program": "동작시킬 프로그램 경로",
      "internalConsoleOptions": "openOnSessionStart",
      "MIMode": "gdb",
      "miDebuggerPath": "C:/Program Files (x86)/mingw-w64/i686-8.1.0-posix-dwarf-rt_v6-rev0/mingw32/bin/gdb.exe",
      "externalConsole": false,
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ]
    }
  ]
}
```

```
# tasks.json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "type": "shell",
            "label": "execute",
            "command": "${fileDirname}/${fileBasenameNoExtension}.exe",
            "group": {
                "kind": "test",
                "isDefault": true
            },
            "problemMatcher": []
        },
        {
            "type": "cppbuild",
            "label": "C/C++: g++.exe 활성 파일 빌드",
            "command": "C:\\Program Files (x86)\\mingw-w64\\i686-8.1.0-posix-dwarf-rt_v6-rev0\\mingw32\\bin\\g++.exe",
            "args": [
                "-fdiagnostics-color=always",
                "-g",
                "${file}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": "build",
            "detail": "컴파일러: \"C:\\Program Files (x86)\\mingw-w64\\i686-8.1.0-posix-dwarf-rt_v6-rev0\\mingw32\\bin\\g++.exe\""
        }
    ]
}
```

1. 단축키
  - `Ctrl + Shift + P` 단축키로 명령을 일일이 수행해도 되지만, 단축키를 설정해 바로 실행하는게 빠르다.
  - 파일 -> 기본설정 -> 바로가기키 (`Ctrl + K & Ctrl + S`) 를 누르고, 우측 상단 '바로가기 키 열기' 를 클릭하여 단축키를 직접 입력한다.
```
// 키 바인딩을 이 파일에 넣어서 기본값 재정의
[
    {
        "key": "ctrl+alt+c",
        "command": "workbench.action.tasks.build",
    },
    {
        "key": "ctrl+alt+e",
        "command": "workbench.action.tasks.test",
    }
]
```
