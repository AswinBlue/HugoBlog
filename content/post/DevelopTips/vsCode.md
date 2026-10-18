---
title: "VS Code에서 C/C++ 개발 환경 구축 및 디버깅 단축키 설정 가이드"
date: 2022-04-16T09:07:48+09:00
lastmod: 2022-04-16T09:07:48+09:00
description: "Visual Studio Code에서 MinGW/GCC 컴파일러 연동, settings.json, launch.json, tasks.json 설정 및 빌드/실행 단축키 커스텀까지 C/C++ 개발 환경을 완벽 구축하는 방법입니다."
slug: "vscode-cpp-environment-settings-debug-guide"
categories: ["DevelopTips"]
tags: ["vscode", "c-plus-plus", "gcc", "mingw", "debugging", "development-tips"]
ShowToc: true
TocOpen: true
draft: false
---

# VS Code C/C++ 개발 환경 구축 가이드

Visual Studio Code를 활용하여 Windows 환경에서 C/C++ 프로젝트를 빌드하고 디버깅하기 위한 설정 가이드입니다.

## 1. 컴파일러 및 도구 체계
C/C++ 프로그램을 빌드하기 위해 GCC 컴파일러 및 GDB 디버거 설치가 필요합니다:
- MinGW-w64 설치 후 시스템 환경 변수 `Path`에 `bin` 폴더 경로(예: `C:\mingw-w64\bin`)를 추가합니다.
- 터미널에서 `gcc --version` 및 `g++ --version` 명령어로 설치 여부를 확인합니다.

## 2. VS Code 핵심 설정 파일 구성

프로젝트 루트의 `.vscode` 디렉터리 내에 컴파일, 런타임 디버깅, 태스크 실행을 위한 설정 파일 3종을 구성합니다.

### 2.1. settings.json
C/C++ Runner 및 인텔리센스 설정을 정의합니다:
```json
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

### 2.2. launch.json
GDB 디버깅 세션 구성을 지정합니다:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "C/C++ Runner: Debug Session",
      "type": "cppdbg",
      "request": "launch",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${fileDirname}",
      "environment": [],
      "program": "${fileDirname}/${fileBasenameNoExtension}.exe",
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

### 2.3. tasks.json
빌드 컴파일 및 실행 태스크를 정의합니다:
```json
{
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
      "detail": "컴파일러: g++.exe 활성 파일 빌드"
    }
  ]
}
```

## 3. 사용자 정의 빌드 및 실행 단축키 설정

`Ctrl + Shift + P` 메뉴를 거치지 않고 원클릭으로 빌드 및 테스트를 수행할 수 있도록 바로 가기 키(`keybindings.json`)를 등록합니다:
1. `파일 > 기본 설정 > 바로 가기 키` (`Ctrl + K, Ctrl + S`) 열기
2. 우측 상단의 '바로 가기 키 열기(JSON)' 아이콘 클릭
3. 아래 설정을 추가하여 빌드(`Ctrl + Alt + C`)와 실행(`Ctrl + Alt + E`)을 매핑:

```json
[
  {
    "key": "ctrl+alt+c",
    "command": "workbench.action.tasks.build"
  },
  {
    "key": "ctrl+alt+e",
    "command": "workbench.action.tasks.test"
  }
]
```
