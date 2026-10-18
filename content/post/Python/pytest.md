---
title: "Python pytest 프레임워크를 활용한 단위 테스트 및 TDD 실전 가이드"
description: "간결한 assert 구문, fixture를 활용한 테스트 의존성 주입, parametrize 다중 파라미터 테스트 및 coverage 코드 커버리지 측정법을 정리합니다."
slug: "python-pytest-unit-testing-and-tdd-guide"
date: 2025-07-28T21:30:40+09:00
lastmod: 2026-10-18T18:00:00+09:00
draft: false
categories: ["Python"]
tags: ["python", "pytest", "unit-test", "tdd", "testing"]
ShowToc: true
TocOpen: true
---

# Pytest를 활용한 파이썬 프로젝트 테스트 가이드 ⚙️
본문에서는 auto trading code 에 대한 test code 작성을 예시로 pytests 를 활용하는 방법에 대해 설명합니다. 

## 목차
- [Pytest를 활용한 파이썬 프로젝트 테스트 가이드 ⚙️](#pytest를-활용한-파이썬-프로젝트-테스트-가이드-️)
  - [목차](#목차)
  - [1. Pytest 환경 설정](#1-pytest-환경-설정)
      - [설치](#설치)
      - [추천 프로젝트 구조](#추천-프로젝트-구조)
  - [2. 기본 테스트 작성 및 실행](#2-기본-테스트-작성-및-실행)
      - [테스트 파일 및 함수 규칙](#테스트-파일-및-함수-규칙)
      - [기본 테스트 예시](#기본-테스트-예시)
      - [테스트 실행](#테스트-실행)
  - [3. Pytest 핵심 기능 활용하기](#3-pytest-핵심-기능-활용하기)
      - [3.1. Fixture: 테스트 준비 및 정리 자동화](#31-fixture-테스트-준비-및-정리-자동화)
      - [3.2. Mocking: 외부 의존성 분리하기](#32-mocking-외부-의존성-분리하기)
      - [3.3. Skip: 특정 테스트 건너뛰기](#33-skip-특정-테스트-건너뛰기)
  - [4. 실전 문제 해결: 트러블슈팅 가이드 🔍](#4-실전-문제-해결-트러블슈팅-가이드-)
    - [4.1. `ModuleNotFoundError`](#41-modulenotfounderror)
    - [4.2. `while True` 무한 루프 테스트하기](#42-while-true-무한-루프-테스트하기)
    - [4.3. `TypeError` (내장 타입 모킹 문제 - `datetime` 등)](#43-typeerror-내장-타입-모킹-문제---datetime-등)
    - [4.4. `Patch`가 동작하지 않을 때 (경로 문제)](#44-patch가-동작하지-않을-때-경로-문제)
    - [4.5. 터미널 출력 한글 깨짐 문제](#45-터미널-출력-한글-깨짐-문제)
  - [5. 더 알아보기](#5-더-알아보기)

---

## 1. Pytest 환경 설정

자동화된 테스트는 코드의 안정성을 보장하고, 리팩토링에 대한 자신감을 줍니다. `pytest`는 간결한 문법과 강력한 기능으로 파이썬 테스트를 쉽게 만들어주는 프레임워크입니다.

### 설치
`pytest-mock`은 `pytest`에서 모킹(Mocking)을 편리하게 사용하기 위한 플러그인입니다.
```bash
pip install pytest pytest-mock
```

### 추천 프로젝트 구조
소스 코드와 테스트 코드를 분리하면 관리가 용이합니다.
```
my_project/
├── my_strategy.py      # TradingStrategy 등 핵심 로직
└── tests/
    ├── __init__.py     # 이 폴더를 패키지로 인식시킴 (빈 파일)
    └── test_strategy.py  # 테스트 코드
```

---

## 2. 기본 테스트 작성 및 실행

### 테스트 파일 및 함수 규칙
- 테스트 파일 이름은 `test_*.py` 또는 `*_test.py`로 만듭니다.
- 테스트 함수 이름은 `test_*`로 시작해야 합니다.

### 기본 테스트 예시
`assert` 구문을 사용하여 조건이 참인지 검증합니다.
```python
# tests/test_strategy.py

def test_foo_returns_true():
    result = foo() # foo()가 True를 반환한다고 가정
    assert result is True
```

### 테스트 실행
프로젝트의 최상위 폴더(루트 디렉토리)에서 아래 명령어를 실행합니다.

```bash
# 모든 테스트 실행
pytest

# 더 상세한 결과 출력
pytest -v

# 테스트 중 print문 내용도 함께 보기 (디버깅 시 유용)
pytest -s -v
```

---

## 3. Pytest 핵심 기능 활용하기

### 3.1. Fixture: 테스트 준비 및 정리 자동화
`@pytest.fixture` 데코레이터는 테스트를 실행하기 전에 필요한 객체나 데이터를 준비하고, 테스트가 끝나면 정리하는 역할을 합니다.

```python
# tests/test_strategy.py
import pytest

@pytest.fixture
def strategy_instance():
    """모든 테스트에서 사용할 TradingStrategy 객체를 생성합니다."""
    # 실제 API 대신 가짜(Mock) 객체를 주입할 수 있습니다.
    mock_api = MagicMock()
    strategy = TradingStrategy(API=mock_api)
    return strategy

def test_boo_with_fixture(strategy_instance):
    """Fixture로 생성된 객체를 인자로 받아 사용합니다."""
    # GIVEN: strategy_instance가 주어짐
    # WHEN: boo 메서드 실행
    result = strategy_instance.boo()
    # THEN: 결과 검증
    assert result == "Expected Value"
```

### 3.2. Mocking: 외부 의존성 분리하기
`mocker`는 `pytest-mock`이 제공하는 Fixture로, API 호출, DB 연결, `time.sleep`, `datetime.now` 등 테스트를 방해하는 외부 요소를 가짜로 대체합니다.

```python
# tests/test_strategy.py
from unittest.mock import MagicMock

def test_api_call(mocker, strategy_instance):
    # GIVEN: get_data 메서드가 특정 값을 반환하도록 모킹
    mocker.patch.object(strategy_instance.API, 'get_data', return_value={"status": "OK"})

    # WHEN: 메서드 호출
    result = strategy_instance.fetch_and_process_data()

    # THEN: 모킹된 결과를 기반으로 로직이 수행되었는지 확인
    assert result is True
```

### 3.3. Skip: 특정 테스트 건너뛰기
`@pytest.mark.skip` 데코레이터를 사용하여 특정 테스트를 임시로 비활성화할 수 있습니다.

```python
@pytest.mark.skip(reason="현재 이 기능은 리팩토링 중이라 제외합니다.")
def test_a_feature_in_progress():
    assert False # 이 코드는 실행되지 않음
```

---

## 4. 실전 문제 해결: 트러블슈팅 가이드 🔍

테스트 코드를 작성하며 겪었던 주요 문제들과 해결책을 정리합니다.

### 4.1. `ModuleNotFoundError`
- **문제점:** `tests/` 폴더 안의 테스트 파일이 부모 폴더의 소스 코드(`my_strategy.py`)를 찾지 못하고 `ModuleNotFoundError` 에러 발생.
- **원인:** `pytest`를 `tests/` 폴더 안에서 실행하면, 파이썬은 부모 폴더를 자동으로 탐색하지 않습니다.
- **해결 방안:** **항상 프로젝트의 최상위 폴더(루트 디렉토리)에서 `pytest` 명령어를 실행**합니다. 그러면 `pytest`가 해당 폴더를 모듈 검색 경로에 포함시켜주어 문제를 해결합니다.

### 4.2. `while True` 무한 루프 테스트하기
- **문제점:** `run_strategy`와 같이 `while True`와 `time.sleep`을 포함하는 함수는 테스트를 영원히 멈추게 합니다.
- **원인:** 테스트가 무한 루프를 빠져나올 방법이 없습니다.
- **해결 방안:** **테스트 전용 커스텀 예외**를 만들어 `time.sleep`이 호출될 때 이 예외를 발생시키고, `pytest.raises`로 이 예외를 잡아 루프를 정상적으로 종료시킵니다.
    1. **커스텀 예외 정의 (`my_strategy.py`):**
        ```python
        # my_strategy.py
        class TestLoopExit(Exception):
            """테스트 루프 제어용 예외"""
            pass

        class TradingStrategy:
            def run_forever(self):
                while True:
                    try:
                        # ...
                        time.sleep(30)
                    except Exception as e:
                        if isinstance(e, TestLoopExit):
                            raise # 테스트용 예외는 다시 발생시켜 pytest가 잡게 함
                        # 다른 실제 에러는 처리
                        print(f"Critical Error: {e}")
        ```
    2. **테스트 코드 작성 (`tests/test_strategy.py`):**
        ```python
        # tests/test_strategy.py
        from my_strategy import TradingStrategy, TestLoopExit

        def test_run_forever_loop(mocker, strategy_instance):
            # time.sleep이 호출되면 TestLoopExit 예외를 발생시킴
            mocker.patch('my_strategy.time.sleep', side_effect=TestLoopExit)

            # TestLoopExit 예외가 발생하면 테스트가 성공적으로 종료됨
            with pytest.raises(TestLoopExit):
                strategy_instance.run_forever()
        ```

### 4.3. `TypeError` (내장 타입 모킹 문제 - `datetime` 등)
- **문제점:** `datetime.datetime.now`를 모킹하려 할 때 `TypeError: cannot set 'now' attribute of immutable type 'datetime.datetime'` 에러 발생.
- **원인:** `datetime.datetime`과 같은 C언어로 구현된 파이썬 내장 타입은 구조를 직접 수정할 수 없어 `patch`가 실패합니다.
- **해결 방안:** 메서드 하나를 바꾸려 하지 말고, **`datetime.datetime` 클래스 자체를 `MagicMock` 객체로 통째로 바꿔치기**합니다.
    ```python
    # tests/test_strategy.py
    import datetime

    def test_time_sensitive_function(mocker, strategy_instance):
        mock_datetime = mocker.MagicMock()
        # my_strategy 모듈이 사용하는 datetime.datetime을 가짜 객체로 교체
        mocker.patch('my_strategy.datetime.datetime', mock_datetime)
        
        # 이제 가짜 객체의 now()가 반환할 값을 우리 마음대로 설정
        fake_time = datetime.datetime(2025, 7, 28, 10, 30, 0)
        mock_datetime.now.return_value = fake_time
        
        # WHEN
        result = strategy_instance.do_something_at_half_hour()
        
        # THEN
        assert result is True
    ```

### 4.4. `Patch`가 동작하지 않을 때 (경로 문제)
- **문제점:** `mocker.patch('time.sleep', ...)`를 설정해도 실제 `time.sleep`이 동작하는 등 `patch`가 적용되지 않는 문제.
- **원인:** `patch`는 **"사용되는 곳(looked up)"**을 기준으로 경로를 지정해야 합니다. `my_strategy.py`가 `import time`을 했다면, `time.sleep`의 주소는 `my_strategy` 모듈 내에 복사됩니다. `patch('time.sleep')`은 원본만 수정할 뿐, 복사본은 수정하지 못합니다.
- **해결 방안:** **`모듈명.함수명`** 형태로 `patch` 경로를 정확히 지정합니다.
    ```python
    # my_strategy.py에 import time, import Message가 있을 경우
    
    # WRONG
    # mocker.patch('time.sleep', ...)
    # mocker.patch('Message.send_message', ...)
    
    # CORRECT
    mocker.patch('my_strategy.time.sleep', ...)
    mocker.patch('my_strategy.Message.send_message', ...)
    ```

### 4.5. 터미널 출력 한글 깨짐 문제
- **문제점:** `pytest -v > test.log` 명령어로 결과를 파일에 저장 시 한글이 깨짐.
- **원인:** 파이썬의 출력 인코딩(UTF-8)과 Windows 터미널의 기본 인코딩(CP949)이 달라 발생.
- **해결 방안:** 파이썬 실행 자체에 UTF-8 인코딩을 강제합니다.
    ```bash
    # Windows Command Prompt
    set PYTHONUTF8=1
    pytest -v > test_output.log 2>&1

    # 또는 python -m pytest 형태로 실행
    python -X utf8 -m pytest -v > test_output.log 2>&1
    ```

---

## 5. 더 알아보기
- [Pytest 공식 문서 (영문)](https://docs.pytest.org/)
- [pytest-mock 공식 문서 (영문)](https://pytest-mock.readthedocs.io/)
