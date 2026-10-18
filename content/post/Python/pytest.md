---
title: "Pytest와 pytest-mock 활용 가이드: Fixture, Mocking, 실전 트러블슈팅"
date: 2025-07-28T21:30:40+09:00
lastmod: 2025-07-28T21:30:40+09:00
description: "파이썬 단위 테스트 프레임워크 pytest의 기본 사용법부터 Fixture, pytest-mock을 활용한 외부 의존성 분리, 무한루프 및 불변 객체 모킹 트러블슈팅 노하우를 정리합니다."
slug: "python-pytest-mock-unit-test-troubleshooting"
categories: ["Python"]
tags: ["python", "pytest", "unit-test", "mocking", "test-automation", "tdd"]
ShowToc: true
TocOpen: true
draft: false
---

# Pytest를 활용한 파이썬 프로젝트 테스트 가이드

자동화 매매(Auto Trading) 로직 테스트 작성을 예시로 `pytest` 프레임워크와 `pytest-mock`을 활용하는 실전적인 단위 테스트 작성 가이드입니다.

---

## 1. Pytest 환경 설정

자동화된 단위 테스트는 코드의 안정성을 보장하고 리팩토링 과정에서의 회귀 버그를 방지합니다. `pytest`는 간결한 `assert` 문법과 풍부한 플러그인 생태계를 갖춘 대표적인 파이썬 테스트 프레임워크입니다.

### 1.1. 설치 및 의존성
모킹(Mocking)을 간편하게 제어할 수 있는 `pytest-mock` 플러그인과 함께 설치합니다:
```bash
pip install pytest pytest-mock
```

### 1.2. 권장 프로젝트 디렉터리 구조
소스 코드와 테스트 코드를 분리하여 구성합니다:
```
my_project/
├── my_strategy.py      # TradingStrategy 등 핵심 비즈니스 로직
└── tests/
    ├── __init__.py     # tests 디렉터리를 패키지로 인식
    └── test_strategy.py  # 단위 테스트 코드
```

---

## 2. 기본 테스트 작성 및 실행

### 2.1. 테스트 파일 및 함수 명명 규칙
- 테스트 파일 이름은 `test_*.py` 또는 `*_test.py` 형태를 준수해야 합니다.
- 테스트 함수 이름은 `test_*` 접두사로 시작해야 `pytest` 탐색기가 자동으로 감지합니다.

### 2.2. 기본 테스트 코드 작성
파이썬 기본 `assert` 구문으로 직관적인 검증을 수행합니다:
```python
# tests/test_strategy.py

def test_foo_returns_true():
    result = foo()  # foo()의 반환값이 True인지 검증
    assert result is True
```

### 2.3. 테스트 실행 명령어
프로젝트 최상위 루트 디렉터리에서 실행합니다:
```bash
# 전체 테스트 실행
pytest

# 상세 결과 및 테스트 함수명 출력
pytest -v

# 디버깅용 print문 콘솔 출력 함께 확인
pytest -s -v
```

---

## 3. Pytest 핵심 기능 활용하기

### 3.1. Fixture: 테스트 준비 및 정리 자동화
`@pytest.fixture` 데코레이터를 사용하여 테스트 실행 전 필요한 객체를 주입하고, 테스트 완료 후 자원을 정리합니다:

```python
# tests/test_strategy.py
import pytest
from unittest.mock import MagicMock

@pytest.fixture
def strategy_instance():
    """모든 테스트에서 공통으로 사용할 TradingStrategy 객체 생성"""
    mock_api = MagicMock()
    strategy = TradingStrategy(API=mock_api)
    return strategy

def test_boo_with_fixture(strategy_instance):
    """Fixture로 생성된 객체를 매개변수로 주입받아 검증"""
    result = strategy_instance.boo()
    assert result == "Expected Value"
```

### 3.2. Mocking: 외부 의존성 분리하기
`pytest-mock`이 제공하는 `mocker` 픽스처를 활용하면 외부 거래소 API, 데이터베이스, 슬립 딜레이 등을 손쉽게 가짜 객체로 대체할 수 있습니다:

```python
# tests/test_strategy.py
def test_api_call(mocker, strategy_instance):
    # GIVEN: API get_data 호출 시 모킹된 딕셔너리 반환 설정
    mocker.patch.object(strategy_instance.API, 'get_data', return_value={"status": "OK"})

    # WHEN: 로직 수행
    result = strategy_instance.fetch_and_process_data()

    # THEN: 모킹된 응답을 바탕으로 정상 처리되었는지 확인
    assert result is True
```

### 3.3. Skip: 특정 테스트 건너뛰기
`@pytest.mark.skip`을 통해 작업 중이거나 외부 의존성이 준비되지 않은 테스트를 제외할 수 있습니다:
```python
@pytest.mark.skip(reason="해당 API는 리팩토링 중이므로 일시 제외")
def test_a_feature_in_progress():
    assert False
```

---

## 4. 실전 문제 해결: 트러블슈팅 가이드

### 4.1. ModuleNotFoundError 발생 시
- **원인**: `tests/` 하위 폴더에서 `pytest`를 실행하면 상위 루트 경로가 `sys.path`에 포함되지 않아 모듈을 찾지 못합니다.
- **해결 방안**: 반드시 **프로젝트의 최상위 루트 디렉터리에서 `pytest` 명령을 실행**하거나 `PYTHONPATH=. pytest`로 실행합니다.

### 4.2. while True 무한 루프 함수 테스트
- **원인**: 주기적인 시세 조회를 위해 `while True`와 `time.sleep`을 수행하는 함수는 테스트가 종료되지 않고 멈춥니다.
- **해결 방안**: 테스트 전용 예외(`TestLoopExit`)를 정의하고, `time.sleep` 호출 시 이 예외를 발생시키도록 패치한 뒤 `pytest.raises`로 정상 탈출을 검증합니다:

```python
# my_strategy.py
class TestLoopExit(Exception):
    pass

class TradingStrategy:
    def run_forever(self):
        while True:
            try:
                # 비즈니스 로직
                time.sleep(30)
            except Exception as e:
                if isinstance(e, TestLoopExit):
                    raise
                print(f"Error: {e}")
```

```python
# tests/test_strategy.py
from my_strategy import TradingStrategy, TestLoopExit

def test_run_forever_loop(mocker, strategy_instance):
    mocker.patch('my_strategy.time.sleep', side_effect=TestLoopExit)

    with pytest.raises(TestLoopExit):
        strategy_instance.run_forever()
```

### 4.3. TypeError: C 내장 타입 모킹 문제 (datetime 등)
- **원인**: `datetime.datetime`과 같은 C 언어 내장 불변 타입은 개별 메서드(`now` 등)를 직접 패치하려고 하면 `TypeError: cannot set 'now' attribute of immutable type` 에러가 발생합니다.
- **해결 방안**: 개별 메서드가 아닌 `datetime.datetime` 클래스 자체를 `MagicMock` 객체로 교체합니다:

```python
import datetime

def test_time_sensitive_function(mocker, strategy_instance):
    mock_datetime = mocker.MagicMock()
    mocker.patch('my_strategy.datetime.datetime', mock_datetime)
    
    fake_time = datetime.datetime(2025, 7, 28, 10, 30, 0)
    mock_datetime.now.return_value = fake_time
    
    result = strategy_instance.do_something_at_half_hour()
    assert result is True
```

### 4.4. Patch가 동작하지 않는 경로(Namespace) 문제
- **원인**: `mocker.patch('time.sleep')`과 같이 원본 라이브러리 경로를 지정하면, 해당 모듈을 `import time`하여 로컬 네임스페이스에 바인딩한 모듈에는 영향이 없습니다.
- **해결 방안**: **대상 함수가 실제로 사용되는 모듈의 네임스페이스(Where it is used)**를 지정해야 합니다:
  ```python
  # WRONG
  # mocker.patch('time.sleep')

  # CORRECT
  mocker.patch('my_strategy.time.sleep')
  ```

### 4.5. Windows 콘솔 한글 인코딩 깨짐 문제
- **원인**: 파이썬의 표준 UTF-8 인코딩과 Windows 터미널(CP949) 간의 인코딩 불일치로 발생합니다.
- **해결 방안**: 터미널에 `set PYTHONUTF8=1` 환경 변수를 선언하거나 `python -X utf8 -m pytest`로 실행합니다.

---

## 5. 참고 자료
- [Pytest 공식 문서](https://docs.pytest.org/)
- [pytest-mock 공식 문서](https://pytest-mock.readthedocs.io/)
