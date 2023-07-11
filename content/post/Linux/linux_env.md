---
title: "Linux_env"
date: 2023-07-10T21:04:56+09:00
lastmod: 2023-07-10T21:04:56+09:00
tags: ["linux"]
categories: ["dev"]
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

# Dev in Linux
리눅스 개발환경 구축을 위한 가이드

## .bashrc
홈 디렉터리에 위치한 user별 설정 파일이다.  
- `source ~/.bashrc` 명령어로 언제든 새로고침 할 수 있다.  

- 리눅스 콘솔 프롬프트를 보기 쉽게 색칠하기 위한 설정할 수 있다.  
```
force_color_prompt=true
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_root)}\[\033[01;32m\]\u\[\033[01;36m\]@\[\033[01;35m\]\h\[\033[00m\]:\[\033[01;033m\]\w\$\[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
```

## vi
리눅스에서 활용할 수 있는 기본적인 에디터이다. 진입장벽은 높은 편이지만, 한번 익숙해지면 매우 편리하다.  
~/.vimrc 폴더에 기본 설정을 적용할 수 있다.  
기본적인 설정은 아래와 같이 세팅할 수 있다.  
```
# 탭을 spacebar 4개로 설정한다. 
set ts=4  
set sw=4  
set sts=4
# 자동으로 indent를 넣어주도록 설정한다. 
set smartindent
# 검색시 하이라이트를 넣어준다. 
set hlsearch
"   " indent for python"
set smartindent
"   cinwords=if,elif,else,for,while,try,except,finally,def,class
# 테마를 설정 해 준다. 테마는 '/usr/share/vim/vim[VER]/colors/' 경로에 *.vim 파일이 있어야 한다. 아래는 molokai.vim 파일을 설정하는 방식이다.
:colorscheme molokai
:highlight comment term=bold cterm=bold ctermfg=4

:set hlsearch
:set expandtab
:set smartindent
:set tabstop=4

:set autoindent
:set si
:set shiftwidth=4
:set cinoptions+=j1
```
## Ctag
vi와 함께 쓰이는 툴로, vi 환경에서 파일간 함수/변수 선언위치를 버튼 하나로 이동할 수 있도록 해주는 모듈이다.   
tags라는 파일을 생성하여 
기본적인 사용법은 다음과 같다. 
1. 설정 (리눅스 명령어로)
 - ctag를 사용할 가장 root 폴더로 이동한다.
 - `ctags -R *` 명령어로 하위 폴더의 모든 파일에 대해 태그를 생성한다. (* 대신 *.cpp *.java 등 원하는 파일만 설정할 수도 있다. )
 - make 모듈이 깔려있다면 `make tags` 명령으로 커널을 이용하여 더 빠르게 생성할 수도 있다.
 - `set tags+=PATH_TO_FILE` 형태로 ~/.vimrc 파일에서 tags 경로를 설정해주면, 어떤 위치에서도 ctag 검색이 가능하다. 
2. 사용 (vi 창에서)
 - `Ctrl + ]` : 커서 위치의 함수/변수의 선언부로 이동 (g + ] 로도 가능)
 - `Ctrl + T` : 이전 위치로 이동



