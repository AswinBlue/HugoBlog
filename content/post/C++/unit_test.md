---
title: "Unit Test"
date: 2024-08-19T04:00:00+09:00
lastmod: 2024-08-19T04:00:00+09:00
tags: ["C++", "test", "unit test", "google test framework"]
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
# Unit Test
## 테스트의 속성
- 좋은 단위 테스트를 작성하기 위해서는 아래 세 가지 기준을 만족해야 한다. 
  1. 가독성
     - 3A(Arrange / Act / Assert) 순서대로 test case 코드가 작성되어 있어야 한다.
     - test case 가 어떤 동작을 검증하는지 알 수 있어야 한다.
       - test case 의 이름을 명확하게 작성 필요
       - 최신 test framework (java 에서 사용하는 spock)에서는 자연어로 test case 이름을 작성할 수 있도록 지원하는 경우도 있다. (google test 는 미지원)
       - test case 실행 시 printf 문을 한 번 출력 하도록 규칙을 정하여 사용할 수 있다.
          ```
          #define SPEC(msg) printf("[SPEC] %s\n", msg)
          TEST(SampleTestCase, SampleTest) {
              SPEC("이 테스트는 무엇을 하는 테스트 입니다");
          }
          ```
      - 코드를 보지 않고 오류의 원인을 알 수 있어야 한다.
      - 자연여와 가깝게 테스트 코드를 표현하는 것이 유리하다.
        - 함수 이름을 자연어로 상세히 지정
        - 에러 메시지를 자연어로 출력

  2. 유지보수성
     - 테스트 코드는 비용이 증가하지 않아야 한다. 
     - 테스트 코드의 오류 가능성이 있는 제어 구문(조건문, 반복문, 예외처리)은 최소화 되어야 한다.
       - 조건문을 최소화 하기 위해서 if 문 대신 ASSERT 구문을 사용할 수 있다.

  3. 신뢰성
     - 테스트는 테스트 순서 및 수행 횟수에 상관없이 항상 동일한 결과가 나와야 한다.
     - BDD(Behavior Driven Development) 관점의 개발을 위해 Mock Object 를 이용한 행위 기반 검증을 수행하여 신뢰성을 높일 수 있다.
       - 다만, 테스트 비용 관점에서 상태기반 검증이 행위기반 검증보다 우월하다. 코드 작성 시 상태기반 검증이 가능하게 구현한다면 행위기반 검증 적용하는 것 보다 유지보수성 관점에서 유리하다.

## 테스트의 조건
- 자동화 : 테스트는 실행 이후 완료 까지 추가 조작 없이 돌릴 수 있어야 한다. (필요하다면 최소화)
- 자체 검사 : 코드를 확인하지 않고 테스트의 결과 만으로 테스트 목적과 에러 원인을 알 수 있어야 한다.
- 반복 : 테스트를 여러 번 돌려도 동일한 결과가 도출되어야 한다.
- 독리비 : 각각의 테스트는 개별로 동작이 가능해야 한다.

## 테스트 가능 설계 SOLID 
- Open-Closed Principle : 개방 폐쇄 원칙
  - 확장에는 열려있고, 수정에는 닫혀있는 설계
- Liskov Substitution Principle : 리스코프 치환 원칙
  - 다형성을 활용한 설계
- Interface Segregations Principle: 인터페이스 분리 원칙
  - 세분화된 인터페이스 지향, 범용 인터페이스 지양
- Dependency Inversion Principle : 의존 관계 역전 원칙
  - 약한 의존관계, 의존성 주입 적극 활용
  - 추상 개념 활용

- 코드 설계 지침
  - 복잡한 private method 지양
  - 정적 멤버 함수 지양
  - Single 톤 지양
  - 의존성 주입에 기반한 composition 모델을 사용
  - 종속성은 최소화
  - 생성자는 간단하게 구성하고, 생성자에서 작업은 최소화
  - 최소 지식의 원칙 수용 (인터페이스에 없는 함수는 호출하지 않도록)
  - 숨겨진 종속성과 전역 상태는 지양

### 용어
- `Test Suite`: 동일한 fixture 를 사용하는 test case 의 집합
- `SUT` : (System Under Test) 테스트 할 대상 시스템. Code Under Test, Class Under Test 등으로 사용하기도 한다.


### Test Coverage
- 공식적인 test coverage의 기준은 없다. 프로젝트마다 다르게 설정될 수 있기 때문이다.
- 높은 coverage 를 확보하기 위해서는 오류 case 에 대한 동작도 검증 할 필요가 있다. 
- test coverage 가 높다고 테스트가 잘 작성 된 것은 아니다.
  - assertion 없이 동작하는 test case 들이 많아도 coverage는 높아질 수 있다.
  - 코드가 의도한 대로 잘 동작하는지, 의도한 대로 잘 실패하는지 모두 살펴보는 것이 필요하다.

## xUnit Framework
- Unit Test의 3A 순서에 대해 단계가 하나 더 추가된 `4단계 테스트 패턴`을 추구한다.

### 4단계 테스트 패턴
1. test fixture 설정
   - 사전조건 설정
   - SetUp()
2. SUT 와 상호작용
   - 테스트 할 동작 수행
3. 기대 결과 확인
   - ASSERT
4. test fixture 해체
   - 테스트 이전의 상태로 복구
   - TearDown()

## Google Test Framework
- C++ 을 대상으로 하는 xUnit Test Framework 중 하나이다.
- C 언어를 대상으로 한다면 Google Test Framework 를 변환하여 사용하기보다 [FFF 프로젝트](https://github.com/meekrosoft/fff) 와 같이 다른 라이브러리를 사용하는 것을 권장한다.

### 설치 및 실행
1. `wget https://github.com/google/googletest/releases/download/v1.15.2/googletest-1.15.2.tar.gz` 명령으로 소스코드 다운로드
2. `g++ googletest/googletest/src/gtest-all.cc -c -I ./googletest/googletest/include/ -I ./googletest/googletest -std=c++14 -O2` 명령으로 소스코드 컴파일
   - include 경로를 설정하여 빌드, 목적파일을 생성한다. 
3. ar rcv libgtest.a gtest-all.o
   - 목적파일 라이브러리화 하여 .lib 파일 생성
4. google test의 main 작성. 아래 형태가 기본적으로 설정되어야 한다.
    ```
    int main(int argc, char* argv[]) {
        testing::InitGoogleTest(*argc, argv);
        return RUN_ALL_TESTS();
    }
    ```
    - `googletest/src/gtest_main.cc` 경로에 있는 main을 사용해도 된다. 
      - `g++ -c ./googletest/googletest/src/gtest_main.cc -I ./googletest/googletest/include/ -std=c++14 -O2` 명령으로 gtest_main.o 를 생성한다.
      - `ar rcv libgtest.a gtest-all.o gtest_main.o` 명령으로 test.a 라이브러리에 gtest_main 을 포함시킨다.
      - 이후에는 main 함수를 따로 작성하지 않아도 라이브러리만 추가하여 빌드하면 main 함수를 직접 작성 한 것과 동일하게 동작한다.
     > main 함수는 직접 정의해서 사용 하는것을 권장한다.  
     > main 함수는 두 개 이상 선언할 경우에는 컴파일러에 따라 링크 오류가 발생하거나 원하지 않는 main 함수가 실행될 수도 있다.

5. `g++ main.cpp -I ./googletest/googletest/include/ -lgtest -L. -std=c++14 -pthread`
    - 소스코드와 함께 라이브러리를 연동하여 실행 파일 빌드

### 기본 사용법
1. gtest/gtest.h 헤더 하나만 include 하면 g-test의 모든 기능 사용 가능
2. Test Case 작성
   - TEST(Test_Suite_Name, Test_Case_Name) 형태의 매크로를 사용하여 TC 생성 가능
      ```
      TEST(SampleTestCase, SampleTest) {
          FAIL() << " 실패";  // 실패처리 이후 화면에 "실패" 문자열 출력
      }
      ```
   - FAIL() 매크로가 호출되지 않는 Test Case는 성공으로 처리된다.
     - SUCCEED() 라는 매크로가 있지만, 이는 가독성을 위한 것일 뿐, 아무것도 하지 않는 매크로이다.

   - 3A 에 기반하여 test case 를 구성한다.
     1) Arrange (Given) : 테스트 대상 코드를 초기화하고 필요한 경우 설정하고 준비
        - 객체 선언, 초기화 등
     2) Act (When) : 테스트 대상 코드에서 동작을 수행
        - 동작 수행
     3) Assert (Then) : 기대하는 바와 실제 결과를 비교
        - ASSERT 매크로 활용
          - `ASSERT_EQ(a, b)` : a ==b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
          - `ASSERT_NE(a, b)` : a != b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
          - `ASSERT_LT(a, b)` : a < b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
          - `ASSERT_LE(a, b)` : a <= b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
          - `ASSERT_GT(a, b)` : a > b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
          - `ASSERT_GE(a, b)` : a >= b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
          - ex) `ASSERT_EQ(a, b) << "a == b 를 만족하지 못합니다"

### Test Suite Class
- `testing::Test` Class 를 상속받는 Class이다. 
  - ex) `class TestSuiteName : public testing::Test`
  
- `신선한 Fixture 전략`
  - test case 간 동작의 독립성을 보장하기 위해 test case 가 하나 수행되면 새로운 fixture 객체를 생성하고 소멸하는 방식
  - "느린 테스트 문제"가 발생하여 개발자의 생산성을 떨어뜨리고, 개발자가 regression test를 수행하지 않게 될 수 있다.
- `공유 fixture 전략`
  - fixture 설치/해체에 소요되는 시간을 절감하여 테스트 속도를 증가시키기 위해 모든 test case 가 공유된 fixture를 사용하는 방식
    - "변덕스런 테스트 문제"가 발생 할 수 있다. 
- 대부분의 xUnit framework 는 '신선한 fixture 전략' 을 사용하지만, test framework 마다 차이가 있을 수 있으므로, test case 의 독립성을 유지시키기 위해서는 framework 에 따라 다른 전략이 필요하다. 

- test suite 에 대응되는 class 이므로, 용도도 test suite 에 맞게 동일한 fixture 를 사용하는 test ase 들을 관리할 수 있는 class 로 활용하면 되겠다.

### Test Case Class
- `TEST` 혹은 `TEST_F` 매크로를 사용하면 자동으로 생성된다.
  - `TEST` 매크로 : 암묵적으로 test suite class 를 생성하고 test case class 를 생성하는 매크로
  - `TEST_F` 매크로 : 명시적으로 생성된 test suite class 를 참조하여 test case class 를 생성하는 매크로
    - 'F' 는 fixture 의 약자
- Test Suite Class 를 상속받아 생성된다. 
  - ex) `TEST(TestSuiteName, TestCaseName)` -> `class TestSuiteName_TestCaseName_test : public TestSuiteName`

### Test Fixture
- xUnit Test Framework 에서 SUT 를 실행하기 위해 준비해야 하는 사전 작업(사전 조건)
- Arrange 단계가 fixture setup 를 수행하는 단계이다.
- Test Fixture 를 구성(setup)하는 방식은 두 가지가 있고, 각각 장단이 있다.
  1. Inline Fixture Setup
     - 모든 fixture setup을 test case 안에서 수행
     - 장점 : 인과관계 분석이 쉽다.
     - 단점 : 테스트 코드의 중복이 발생한다. 
       - test smell (테스트의 가독성, 유지보수성, 신뢰성을 떨어뜨리는 요소) 에 해당한다.

  2. Delegate Setup
     - fixture setup 단계를 test utility 함수를 통해 캡슐화 한다.
     - `TEST()` 매크로를 호출하는 것은, `testing::Test` class 를 상속하여 class 를 생성하고, 그 생성된 class를 호출하는 형태이다. 이러한 형태를 암묵적인 방법으로 test suite class 를 선언하는 형태라 한다.
     - test suite class 를 명시적으로 선언한다면, delegate setup 기법을 사용할 수 있다.
       ```
       // 명시적인 test suite class 선언
       class TestSuiteName : public testing::Test {
       public:  // 자식 class 에서 접근할 수 있어야 하기 때문에 public 혹은 protected 설정 가능
           class target = new TargetClass()  // 공통된 fixture setting 동작 수행(변수 선언)
           // 여기서 선언된 변수를 TEST_F 에서 참조하여 사용 
       };

       TEST_F(TestSuiteName, TestCaseName) { 
         target.do_something(); // TestSuiteName class 의 'target' 변수 사용 가능
       } // TEST() 매크로 대신 TEST_F() 매크로 사용하여 test case class 선언
       // c++ 내부적으로 class TestSuiteName_TestCaseName_test : public TestSuiteName 형태의 class 가 선언 된다. 

       ```
         - 명시적으로 test suite class 를 선언하고, TEST() 대신 TEST_F() 매크로로 test case class 를 선언한다.

      - 장점 : 테스트 코드의 중복을 제거하고, redundant 한 테스트 준비 과정을 test case 안에서 제거 할 수 있다.
      - 단점 : 인과관계 분석이 어렵다

   3. Implicit Setup
      - xUnit test framework 이 제공하는 방법
      - `Delegate Setup` 과 마찬가지로 명시적인 test suit class 작성이 필요
      - test suit class 에서 `SetUp()` 함수를 정의 해 놓으면, test case 가 실행 될 때 `SetUp()` 함수가 호출된다. (암묵적 수행)
        ```
        // 명시적인 test suite class 선언
        class TestSuiteName : public testing::Test {
        protected:
            void SetUp() override
            {
                class target = new TargetClass()  // 공통된 fixture setting 동작 수행(변수 선언)
            }
            void TearDown() override
            {
                delete target
            }
        };

        TEST_F(TestSuiteName, TestCaseName) { 
          target.do_something(); // TestSuiteName class 의 'target' 변수 사용 가능
        }
        ```
      - 장점 : 테스트 코드의 중복을 제거하고, redundant 한 테스트 준비 과정을 test case 안에서 제거 할 수 있다.
      - 단점 : 인과관계 분석이 어렵다

- Delegated Setup 혹은 Implicit Setup 을 사용할 때 메모리 누수에 대해 주의할 필요가 있다.
  - ASSERT 구문은, 실패로 판단되는 경우 이후 동작은 수행하지 않는다.
  - 만약 ASSERT 구문에 의해 실패가 발생하면 이후 객체의 소멸자가 호출하지 않게 된다.
- Implicit Setup 을 사용 할 경우에는 테스트가 시작되기 전 `SetUP()` 함수가 호출되고, 테스트가 완료 되면 `TearDown()` 함수가 호출된다. 
  - `SetUp()` 에서 fixture setup을 완료 해 주고, `TearDown()` 에서 사용한 리소스를 정리하면 되겠다.

#### Global Fixture
- `testing::Environment` 를 상속받은 class 로 전역 fixture 를 설정 할 수 있다.
  - ex) `class MyEnvironment : public testing::Environment`
- Environment class 에는 Test class 와 마찬가지로 `Setup`, `TearDown` 이 제공된다.

- main 함수 안에 `testing::AddGlobalTestEnvironment(new MY_OBJECT); ` 구문을 추가 해 주면, 모든 test 수행 직전에 Environment의 `SetUp()` 함수가 동작하고, 모든 test case 들이 수행된 이후 Environment의 `TearDown()` 함수가 실행된다. 
  - ex) `testing::AddGlobalTestEnvironment(new MyEnvironment)` // 인자로 들어갈 객체를 new 를 통해 생성해야 함에 주의. 완료 후 자동으로 해제됨

- main 함수를 직접 구현하지 않은 경우에는 아래 구문으로도 적용 가능하다.
  - `testing::Environment* myEnvironment = testing::AddGlobalTestingEnvironment(new MyEnvironment);` 
  - 전역 변수는 main 함수가 실행되기 전에 설정된다는 점을 이용한 방식
  - 하지만, 가독성을 떨어뜨리고 아래 문제를 발생시킬 수 있기 때문에 공식적으로는 권장하지 않는 방식이다. 
  > - 둘 이상의 environment를 선언하면 environment 의 설정과 해체 순서가 중요하다. 먼저 설정된 environment 가 가장 나중에 해제되어야 한다.(LIFO)  
  > - 하지만 C++ 에서는 둘 이상의 파일에 선언된 전역변수의 초기화 순서가 명확히 정의되어있지 않다.
  > - 여러 파일에서 포인터를 활용하여 environment를 선언하면 environment 의 설정과 해체 순서가 보장되지 않아 위험하다.  
  > - main 함수를 직접 구현하여 environment를 설정하면 environment 의 해체 순서가 명확히 정의 되어 안전하다.   



#### 느린 테스트 문제
- "신선한 fixture 전략" 을 사용하는 경우, SetUp 과 TearDown 에 시간이 많이 소요된다면 TestCase 가 많아질 수록 test 에 소요되는 시간이 늘어나 생산성이 떨어진다.
  - 테스트가 느리면 code 가 변경되어도 테스트를 수행하지 않게 될 수도 있다.
- 이러한 문제를 해결하기 위해, xUnit Framework 에서는 수동으로 호출 할 수 있는 fixture 설치/해제 동작을 제공한다.
  - 아래와 같이 함수를 대체하면 test case 마다 SetUp / Teardown 을 수행하지 않고, SetUp은 최초 한 번, TearDown은 최후 한번만 수행한다.
    - `void SetUp()` -> `static void SetUpTestSuite()`
    - `void TearDown()` -> `static void TearDownTestSuite()` 

    - ex)
      ```
      // AS IS
      SetUp()
      TC1()
      TearDown()
      SetUp()
      TC2()
      TearDown()
      SetUp()
      TC3()
      TearDown()

      // TO BE
      SetUpTestSuite()
      TC1()
      TC2()
      TC3()
      TearDownTestSuite()
      ```
    - static 함수를 사용하기 때문에 class 멤버 변수도 static 으로 변경하여 선언이 필요하다.
- 여러 test case 가 하나의 fixture 객체를 공유하기 때문에, fixture 관리가 제대로 되지 못한다면 "변덕스런 테스트 문제"가 발생할 수 있다. 즉, 신뢰성이 떨어질 수 있다.
- C++ 에서는 생성자와 소멸자와 유사하고 대체 가능하지만, 특정 언어에서는 소멸자 개념이 없기 떄문에 xUnit Framework 관점에서는 생성자 소멸자 대신 SetUpTestSuite, TearDownTestSuite 를 사용하는 것이 바람직하다.

#### 변덕스런 테스트 문제
- test case 의 수행 횟수, 순서 등에 따라 test case 의 결과가 달라지는 현상
- 어떤 test case 에 의해 다음 test case 의 test fixture 가 영향을 받아 발생


### ASSERTION / EXCEPTATION
1. ASSERTION
   - ASSERTION 종류는 다음같다.
     - `ASSERT_EQ(a, b)` : a ==b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_NE(a, b)` : a != b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_LT(a, b)` : a < b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_LE(a, b)` : a <= b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_GT(a, b)` : a > b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_GE(a, b)` : a >= b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_TRUE(a)` : a == true 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `ASSERT_FALSE(a)` : a == false 라면 `SUCCEED()`, 아니면 `FAIL()` 호출

   - ASSERTION 은 FAIL로 판별되면 다음 동작은 수행하지 않는다. 이러한 ASSERTION 의 특징상 하나의 test case 안에서 여러 ASSERTION 을 사용하면 한 번의 검증으로 모든 ASSERTION 을 검증할 수 없다.
     - "죽은 단원문의 문제" 발생
     - xUnit Framework 에서는 하나의 test case 에 하나의 ASSERTION 만 사용하도록 권장
     - 하지만, ASSERTION 을 분리하면 관리해야 하는 test case 가 늘어나고, test code 중복의 문제가 발생한다.
     - 이를 대체하기 위해 `EXPECT` 구문이 존재한다.

   - 특정 구문이 FAIL 일 때, 이후 코드를 동작시킬 때 segmentation fault 가 발생한다면 ASSERTION 을 사용하는 것이 좋다.
     - 테스트 프로그램이 안전하게 동작 할 수 있는 보호 역할을 수행한다.

2. EXCEPTATION
   - google framework 에서 제공하는 기능으로, 지원하지 않는 test framework 들도 있다.
   - ASSERTION과 유사하지만, FAIL 판정이 되더라도 이후의 코드도 끝까지 수행한다. 
   - ASSERTION 대신 EXCEPTATION 을 사용하면 "죽은 단원문의 문제" 를 해결할 수 있다.
   - EXCEPTATION 종류는 다음과 같다.
     - `EXCEPTATION_EQ(a, b)` : a ==b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_NE(a, b)` : a != b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_LT(a, b)` : a < b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_LE(a, b)` : a <= b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_GT(a, b)` : a > b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_GE(a, b)` : a >= b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_TRUE(a)` : a == true 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
     - `EXCEPTATION_FALSE(a)` : a == false 라면 `SUCCEED()`, 아니면 `FAIL()` 호출

   - segmentation fault 등으로 인해 테스트 프로그램이 비정상 종료 될 수 있는 경우 EXCEPTION 보다는 ASSERTION 을 사용하는 것이 권장된다.

- C 문자열을 비교
  - `EXCEPTATION_STREQ(a, b)` : 문자열a == b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
  - `EXCEPTATION_STRNE(a, b)` : 문자열a != b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
  - `EXCEPTATION_STRCASEEQ(a, b)` : 대소문자 상관없이 문자열a == b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출

- 부동소수점 비교
  - 부동 소수점을 일반 판정문으로 비교를 하면 메모리에 표시되는 형태를 바로 비교하기 때문에 원하는 결과가 나오지 않을 수 있다.
    - ex) `EXPECT_EQ(0.7, 0.1 * 7)` -> FAIL()
  - 부동 소수점의 오차 범위(라이브러리에 정의된) 안에 들어오는지 판단하는 로직이 추가로 존재한다. 
  - `EXPECT_DOUBLE_EQ(a, b)`: 부동소수점 a == b 라면 `SUCCEED()`, 아니면 `FAIL()` 호출
  - `EXPECT_NEAR(a, b, c)`: |a-b| <= C 라면 `SUCCEED()`, 아니면 `FAIL()` 호출 (오차 허용 범위)
    - 라이브러리에 정의된 오차 범위 말고 직접 오차 범위를 설정하여 판별하는 방법


- Error case 비교
  - try-catch 구문에서 catch 로 처리된 구문과 의도하지 않은 error 를 구분하여 검증 할 수 있다.
    - `EXPECT_THROW(FUNCTION_TO_RUN, ERROR)` : FUNCTION_TO_RUN 에서 예외를 throw 한다면 `SUCCEED()`, 아니면 `FAIL()` 호출
    - ex) `EXPECT_THROW(do_something(arg), std::invalid_argument)`<< "의도하지 않은 인자"
    - `EXPECT_ANY_THROW(FUNCTION_TO_RUN)` : FUNCTION_TO_RUN 에서 예외를 throw 한다면 `SUCCEED()`, 아니면 `FAIL()` 호출
    - `EXPECT_NO_THROW(FUNCTION_TO_RUN)` : FUNCTION_TO_RUN 에서 예외를 throw 한다면 `FAIL()`, 아니면 `SUCCEED()` 호출

### Disabled Test Case
- test case 의 결과는 FAIL 과 SUCCESS 외 "유지 보수가 필요한 상태" 가 하나 더 존재한다.
  - 유지 보수가 필요한 test case 를 주석처리 하면 test case 존재 자체가 잊혀질 수 있다("잊혀진 테스트 문제")
  - 유지 보수가 필요한 test case 를 fail 처리하면 false alarm 이 발생한다.
  - 유지 보수가 필요한 test case 를 true 처리 하면 정상 TC로 판단되어 유지보수가 필요하다는 것이 드러나지 않을 수 있다.

- 유지보수가 필요한 경우, test 를 비활성화 하여 결과에 포함되지 않지만 비활성화 테스트를 따로 표기 되도록 하려면, test case 의 이름 앞에 prefix 로 `DISABLED_` 를 붙이면 된다.
  - ex) `TEST(MyTestSuite, DISABLED_MyTestCase)`
  - 테스트 실행 결과에 `YOU HAVE # DISABLED TEST` 문구가 표시된다. 
- test suite 이름에 `DISABLED_` 를 붙여도 test case 를 비활성화 시킬 수 있다. 
  - ex) `TEST(DISABLED_MyTestSuite, MyTestCase)`
- 테스트 실행시 `--gtest_aosl_run_disabled_tests` 옵션을 추가하면 disabled 된 테스트도 실행 할 수 있다.
  - ex) `./a.out --gtest_aosl_run_disabled_tests`

### Test Filter
- 원하는 테스트를 선택적으로 실행 할 수 있도록 하는 기능
- 테스트 실행시 test case 의 이름으로 필터를 걸 수 있다.
  - `--gtest_filter=TEST_SUITE_NAME.TEST_CASE_NAME` 옵션을 추가한다.
  - ex) `./a.out --gtest_filter=myTestSuite.MyTestCase`
  - ex) `./a.out --gtest_filter=myTestSuite.MyTestCase:myTestSuite2.MyTestCase2` // 복수의 조건 설정
  - wild card 를 지원한다.
    - ex) `./a.out --gtest_filter=my*.*`
  - 특정 항목을 제외하는 조건을 설정 가능하다.
    - ex) `./a.out --gtest_filter=my*.*:*.foo`

### Test 신뢰성 점검
- 테스트는 수행 횟수와 순서에 상관없이 동일한 결과가 나와야 한다. 테스트의 신뢰성을 점검하기 위해 테스트 실행시 설정 가능한 옵션이 존재한다.
  - `--gtest_shuffle` : 테스트 순서를 무작위로 섞어준다. 
  - `--gtest_repeat=REPEAT_NO` : REPEAT_NO 횟수만큼 테스트 반복 실행
    - 몇 번째 테스트에서 실패 했는지 확인하기 어렵다.
  - `--gtest_break_on_failure` : 테스트 실패시 강제적으로 프로그램을 종료하는 옵션. 특히 반복 테스트 시에 유용하다.

### Test 산출물
- 테스트 실행시 옵션을 추가하여 test 결과를 원하는 형태로 export 가능하다.
  - `--gtest_output=xml`: `test_detail.xml` 파일에 test 결과를 xml 형태로 저장
    - `--gtest_output=xml:OUTPUT_NAME.xml`: 출력 결과물 이름 `OUTPUT_NAME.xml` 로 설정
  - `--gtest_output=json` : `test_detail.json` 파일에 test 결과를 json 형태로 저장
    - google test framework 고유의 기능으로 1.10 버전 이후부터에 지원
  - xUnit Test Framework 정립 이전(google test framework 1.10버전 이전)에는 용어가 상이할 수 있다.
- 비 기능적인 부분도 산출물에 출력되도록 설정 가능하다..
  - 코드에 `RecordProperty(KEY, VALUE)` 항목을 추가하여 산출물에 사용자가 정의한 key, value 를 추가할 수 있다.

### 비기능 테스트
- 시간, 메모리 등 성능에 대한 검증이 필요할 때, 가독성을 높이며 로직 추가를 최소화 하여야 한다.
1. 시간 측정
   - 매크로를 활용한 *사용자 정의 단언문*으로 가독성 문제를 해결 가능하다.
      ```
      #define EXPECT_TIMIEOUT(fn, t)                                                        \
          do {                                                                              \ 
              time_t timeout = t;  // 테스트 결과에 변수명이 찍히므로, 변수명도 유의미하게 선언  \ 
              time_t start = time(nullptr);                                                 \
              fn;                                                                           \ 
              time_t duration = time(nullptr) - start;                                      \
              EXPECT_LE(duration, timeout) << "Timeout " << duration << "/" << timeout;     \
          } while (0)
      ```

2. 메모리 측정
   1) operation new, operation delete 을 재정의
      - 메모리 할당 횟수를 전역변수로 관리하여 new 와 delete 의 횟수가 일치하는지 점검
      - GTEST_LEAK_TEST define 을 추가하여 메모리 검증 테스트 코드는 컴파일시 선택적으로 적용 가능하도록 구현
        - 컴파일 옵션에 `-DGTEST_LEAK_TEST` 추가하여 코드 적용 가능
        ```
        static int cnt

        class SUT {
        public:
          // 테스트 할 함수
          void do_something() {
            ;
          }
        # ifdef GTEST_LEAK_TEST
          // 재정의
          void* operator new(size_t size)
          {
              ++allocCount;
              return malloc(size);
          }
          // 재정의
          void operator delete(void* p, size_t)
          {
              free(p);
              --allocCount;
          }
        #endif
        };
        # ifdef GTEST_LEAK_TEST
        int SUT::cnt = 0; // 전역변수
        # endif

        TEST(TS,TC) {
            int alloc = SUT::cnt;
            EXPECT_TRUE(SUT::do_something());
            int diff = SUT::cnt - alloc;
            EXPECT_EQ(diff, 0) << diff << "memory leacked!";
        }
        ```

      - 명시적으로 class 를 만들고 SetUp 과 TearDown 활용 할 수도 있다.
         ```
         class SUTTest : public testing::Test {
         protected:
             void SetUp() override
             {
         # ifdef GTEST_LEAK_TEST
                 alloc = SUT::cnt;
         #endif
             }
             void TearDown() override
             {
         # ifdef GTEST_LEAK_TEST
                 int diff = SUT::cnt - alloc;
                 EXPECT_EQ(diff, 0) << diff << "memory leacked!";
         #endif
             }
         }

         TEST(TS,TC) {
            EXPECT_TRUE(SUT::do_something());
         }
         ```
      - 단점
        - 제품 코드에 테스트용 코드가 추가된다.
        - test code 가 특정 제품 코드에 국한되고, 재사용이 어렵다.
        - SetUp 과 TearDown 이 fixture 외 용도로 사용된다.

   2) Sanitizer 사용
      - Sanitizer : 메모리, 속도, 미정의 동작을 체크 할 수 있는 컴파일러가 제공하는 도구
      - 다만, 모든 플랫폼에서 제공되지는 않는다. (리눅스 플랫폼에서는 지원 됨)
      - 컴파일 옵션에 `-fsanitize=address` 를 추가하면 설정 가능하다.
        - google test framework 결과와 별개로 실행 결과 출력에서 memory leak 이 발생한 크기 및 위치 정보가 출력된다.
      - C++ 에서는 1번 방법보다 Sanitizer 를 사용하는 것이 더 효과적이다.
      - 컴파일러 sanitize 옵션
        - `-fsanitize=address` : 메모리 릭 감지
        - `-fsanitize=thread` : 데드락 감지
        - `-fsanitize=undefined` : 미정의 동작 감지 

### Private 영역 검증
- private 영역에 존재하는 함수는 test code 클래스에서 호출할 수 없어 검증이 불가능하다. (xUnit Test framework 표준에는 방법이 없음)
- xUnit Test pattern 에서는, 테스트가 필요한 method 는 private 영역에 두지 않아야 한다고 권장한다.
  - "검증되지 않은 private method 는 검증된 public method 보다 위험하다"
  - private method 는 public method 의 가독성을 높이는 목적으로 사용되어야 한다. 
    - private method 는 public method 에서 호출되는 형태로 구성
      ```
      private:
      A();
      B();
      public:
      C() {
        A();
        B();
      }

      ```
- Google Test Framework 는 `FRIEND_TEST` 기능을 제공하여 test case 에서 private 함수에 접근이 가능하게 할 수 있다.
    ```
    class SUT {
        void process1() { }
        void process2() { }
    public:
        void foo() { }
        void goo() {
            process1();
            process2();
        }

        FRIEND_TEST(TS, TC);  // 'TS' test suite 의 'TC' test case 이름을 가진 test case 에서 private 영역에 참조 가능
    };

    TEST(TS, TC) {
      SUT sut;
      sut.goo();
      sut.process1(); // 에러 발생하지 않음
    }
    ```
- 단점 : 제품코드에 google test framework 의존성이 생기게 된다.
  - `#include <gtest/gtest_prod.h>` 를 추가하면 FRIEND_TEST 를 사용할 수 있다.
- 장점 : 은닉 정책을 변경하지 않고 테스트를 수행 할 수 있다.


### 테스트 전용 하위 class
1. 테스트가 필요한 함수가 protected 영역에 존재한다면, test code 영역에서 SUT class 를 상속받는 하위 class 를 만들어서 테스트 되지 않은 요구사항을 검증할 수 있다.
  ```
  class SUT {
      protected:
          void foo() { }
  };

  class TestSUT : public SUT {  // SUT 를 상속한 test class
  public:

  using SUT::foo();  // parent 의 foo 함수를 public 영역에서 재선언. 아래 주석과 동일한 역할
  /*
      void foo() {
          return foo();  // SUT 의 foo 함수를 호출
      }
  */
  }
  TEST(TS, TC) {
      TestSUT sut;
      sut.foo(); // 호출 가능
    }
  ```
- 장점 : 제품 code를 변경하지 않고 요구사항을 검증 할 수 있다.


2. 제품 코드에서 검증을 위해 확인 할 수 있는 요소가 없고, 테스트 할 함수가 가상함수로 구현된 경우
  - ex)
    ```
      class SUT1 {
          virtual ~SUT() {}
          virtual void foo() { }  // 가상함수
      };

      class SUT2 {
          SUT1* sut;
          SUT2 (SUT1* sut) : sut { sut };  // 생성자, 초기화
          void goo() {
              sut->foo();
          }
      };
    ```
    - goo 호출시 foo 가 호출됨을 확인하고싶지만, SUT1 객체에 foo 호출 여부를 알 수 있는 변수가 없다.
    - 테스트 class 를 추가한다.
    ```
    class TestSUT1 : public SUT1 {
    public:
        bool flag = false;  // foo 가 호출되었는지 여부를 표시하는 변수 추가
        void foo() override {
            SUT1::foo();
            flag = true;
        }
    };

    TEST(TS, TC) {
        TestSUT1 sut1;
        SUT2 sut2 {&sut1};

        sut2.goo();  // foo 가 가상함수이기 때문에 goo 에서 TestSUT1.foo 를 호출

        EXPECT_TRUE(sut1.flag);  // foo 가 호출되었는지 여부를 확인 가능
    }
    ```

- 제품 코드를 수정하여 test code 작성 리소스를 줄이는 것이 가장 이상적이다.
  - 단위 테스트 작성 비용이 최소화 되어야 하고, 테스트하기 쉬워야 한다는 관점에서 볼 때 
- 제품 코드 수정 없이 문제를 해결하려면, 생성자/소멸자 가상함수를 hooking 하여 테스트를 위한 코드를 작성 할 수 있다.

- 위 방법은 foo 가 가상함수이기 때문에 가능한 방법이다.
  - 멤버 함수는 객체의 type 을 보고 수행되기 때문에 parent 의 함수가 수행됨
  - 가상함수는 참조 변수의 함수를 바로 호출하기 때문에 child 의 함수가 수행됨

- 위 경우를 보면 일반 함수보다 가상 함수가 테스트 하기 편하다는 장점을 확인 할 수 있다.

### 파라미터화 테스트 (Parameterized Test)
- test code 의 중복을 제거하기 위해 test code 에 for 문을 사용한 loop 를 추가하면 문제가 발생한다.
  - 테스트 코드에 제어구문이 들어가게 된다.
  - 에러 발생시 테스트 결과 산출물에 에러를 발생시킨 인자가 정확하게 표시되지 않을 수 있다.
- xUnit Test Framework 은 입력 데이터를 바꿔가며 반복 검사하는 데이터 중심의 테스트에서 테스트 코드 중복의 문제를 해결할 수 있는 기능을 제공

- 사용 방법
  1. `TestWithParam` 을 상속받는 명시적인 test suite class 선언
     - ex) `class stringTestSuite : public testing::TestWithParam<std::string> { };`
  2. `INSTANTIATE_TEST_SUITE_P` 매크로를 활용하여 data set 정의
     - `INSTANTIATE_TEST_SUITE_P(prefix, test_suite_class, data_set)`
       - prefix : 어떤 특성을 갖고있는지 표현하는 용도, string 형태 아니고 코드 형태로 원하는 문자 입력하면 됨
       - test_suite_class : data set 을 사용할 test suite class 이름
       - data_set : `testing::Values()` 함수로 표현된 데이터 셋
       - ex) 
          ```
          INSTANTIATE_TEST_SUITE_P(Prefix, TS, 
              testing::Values(
                "AAA",
                "BBB",
                "CCC"
              )
          );
          ```

  3. data set 을 이용하는 test case 를 정의한다.
     - `TEST_P` 매크로를 사용하여 test case 를 정의한다.
     - `GetParam()` 함수를 사용하면 이전에 정의한 data set 을 하나씩 불러온다.
     - 정의된 data set 갯수만큼 TEST_P 로 정의한 함수를 호출한다.
     - ex) 
        ```
        TEST_P(TS, TC) {
          const std::string str = GetParam();  // 정의된 data set 을 불러옴
          EXPECT_TRUE(foo(str));  // foo(str) 결과가 참인지 평가
        }
        ```
  - for 문을 사용 했을 때와 다르게 test 결과 산출물에 어떤 데이터에서 실패가 발생 했는지 명확히 표시된다.
    - 테스트 결과 예시
        ```
        [==========] Running 12 tests from 1 test suite.
        [----------] Global test environment set-up.
        [----------] 12 tests from prefix/test_suite_class
        [ RUN      ] prefix/test_suite_class.test_case/0
        [       OK ] prefix/test_suite_class.test_case/0 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/1
        [       OK ] prefix/test_suite_class.test_case/1 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/2
        [       OK ] prefix/test_suite_class.test_case/2 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/3
        [       OK ] prefix/test_suite_class.test_case/3 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/4
        [       OK ] prefix/test_suite_class.test_case/4 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/5
        [       OK ] prefix/test_suite_class.test_case/5 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/6
        [       OK ] prefix/test_suite_class.test_case/6 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/7
        [       OK ] prefix/test_suite_class.test_case/7 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/8
        [       OK ] prefix/test_suite_class.test_case/8 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/9
        [       OK ] prefix/test_suite_class.test_case/9 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/10
        test11.cpp:31: Failure
        Value of: IsPrime(num)
          Actual: false
        Expected: true

        [  FAILED  ] prefix/test_suite_class.test_case/10, where GetParam() = 4 (0 ms)
        [ RUN      ] prefix/test_suite_class.test_case/11
        test11.cpp:31: Failure
        Value of: IsPrime(num)
          Actual: false
        Expected: true
        ```

- `TEST_P` 로 정의된 test case 들은 파라미터만 다르게 설정하여 `TEST_F` 를 여러 개 만든 것과 동일하다. 
  - 파라미터를 순회하며 수행되는 test case 들 사이에도 `SetUp`, `TearDown` 함수가 호출된다.

- 사용자 정의 type을 사용할 수도 있다.
  ```
  struct InputType {
      int A;
      int B;
  }

  // test 결과 산출물에서 사용자 정의 type(struct)이 가독성 있는 형태로 출력하기 위한 연산자 재정의
  std::ostream& operator<<(std::ostream& os, const InputTypes& data)
  {
      return os << "(" << data.A << "," << data.B << ")";

      // C++ 20 부터 지원하는 형태
  #include <format>
      // return os << std::format("({},{})", data.A, data.B);
  }

  INITIATE_TEST_SUITE_P(prefix, TS,
      testing::Values(
          (1,1) (2,2) (3,3)
  ));

  TEST_P(TS, TC1) {
      const InputType& data = GetParam();
      EXPECT_TRUE(foo(data.A));
  }
  TEST_P(TS, TC2) {
      const InputType& data = GetParam();
      EXPECT_TRUE(foo(data.B));
  }
  ```
    - 사용자 정의 타입을 사용 할 때는 연산자 재정의를 해 줘야 테스트 결과 산출물에 원하는 형태로 출력이 가능하다.
  


- 둘 이상의 파라미터를 조합하여 사용하는 경우 `testing::Combine` 과 `testing::ValuesIn` 을 사용할 수 있다.
  - `testing::Combine` : 주어진 파라미터 (A,B,C...)으로 구성할 수 있는 모든 조합에 대해 data set 을 구성한다.
  - `testing::ValuesIn` : 배열을 파라미터로 받아 data set 으로 구성한다.
  ```
  // SUT 에서 정의된 타입
  enum Color {BLACK, WHITE, RED, ORANGE, BLUE}

  // 테스트에 사용될 데이터
  Color colors[] = {Color::BLACK, Color::WHITE};
  std::vector<std::string> str = {"black", "white"};

  // 튜플 형태 정의
  using InputType = std::tueple<std::string, Color, int>

  // data set 구성
  INITIATE_TEST_SUITE_P(prefix, TS,
      testing::Combine(
          testing::ValuesIn(colors),
          testing::ValuesIn(str),
          testing::Values(1, 2, 3)  // Values 를 섞어 구성할 수도 있다.
      )
  );

  TEST_P(TS, TC)
  {
      const InputType& data = GetParam();
      // 설정한 데이터 사용
      Color color = std::get<0>(data);
      std::string str = std::get<1>(data);
      int num = std::get<2>(data);
  }

  ```
- 한 Test Suite 에 대해 파라미터(`INITIATE_TEST_SUITE_P`) 를 여러 개 정의하면, 각 파라미터를 독립되게 이어서 진행한다. 

- 기타 파라미터 생성 함수
  - `testing::RANGE()` : 지정된 범위에 해당하는 숫자로 배열 구성
    - `testing::RANGE(1,100)` : 1~99까지의 수로 구성된 배열 생성
      - [1, 2, 3, .. , 99]
    - `testing::RANGE(1,100,2)` : 1~99까지 2씩 증가하는 수로 구성된 배열 생성
      - [1, 3, 5, .. , 99]


### Test Listener
- 테스트 과정에서 발생하는 이벤트 들에 대해 특정 작업을 수행해야 할 때, Listener 를 등록하여 처리할 수 있다.
- Google Test Framework 의 고유 기능으로, xUnit Test Framework 표준 아님
- Event Listener 생성 방법
  - `testing::TestEventListener` : 모든 event 들에 대해 가상함수로 선언된 인터페이스
    - 모든 event 에 대해서만 재정의를 해 주어야 선언 가능
  - `testing::EmptyTestEventListener` : 모든 event 들에 대해  override 형태로 empty 함수로 구현된 인터페이스
    - 필요한 event 에 대해서만 재정의를 해 주면 선언 가능
    ```
    class MyListener : public testing::EmptyTestEventListener {
    public:
        void OnTestSuiteStart(const TestSuite& /*test_suite*/) override
        {
            std::cout << "START << std::endl;
        }

        void OnTestSuiteEnd(const TestSuite& /*test_suite*/) override
        {
            std::cout << "END << std::endl;
        }
    }
    ``` 

- 정의된 Listener 들은 main 함수에서 등록한다.
  ```
  int main(int argc, char** argv)
  {
      testing::InitGoogleTest(&argc, argv);

      testing::TestEventListeners& litensers = testing::UnitTest::GetInstance()->listeners();
      litensers.Append(new MyListener);

      // google test framework 에 default 로 설정된 출력을 제거할 수도 있음
      // delete litensers.Release(litensers.default_result_printer());

      return RUN_ALL_TESTS();
  }
  ```

### Test Double (테스트 대역)
- 테스트 대상 코드가 다른 "협력 객체"에 따라 영향을 받을 수 있을 때, "협력 객체" 를 대체 하기 위한 테스트용 객체를 생성하고, 이를 "테스트 대역" (test double) 이라 한다.
- 테스트 대역의 역할 : 테스트 환경을 통제
- 테스트 대역 적용 조건 : 제품 코드가 태스트 대역을 적용 할 수 있는 설계
  - 테스트 대상 코드가 협력 객체와 "약한 결합" (느슨한 결합) 관계에 있어야 한다.
    - 강한 결합 : 구체적인 타입에 의존하여 객체를 참조하는 형태
    - 약한 결합 : 추상 타입에 의존하여 객체를 참조하는 형태 (abstract class / interface)

- ex) 원본 코드
  ```
  class FileSystem {
  public:
      bool IsValidFilename(const std::string& name)
      {
          // 현재의 파일 시스템에서 적합한 이름인지 확인합니다.
          return false;  // fasle 반환하는 경우 검증을 위한 코드
      }
  };

  class Logger {
  public:
      // 확장자를 제외한 파일명이 5글자 이상이어야 한다.
      // ex)
      //  file.log => file  => X
      // hello.log => hello => O
      bool IsValidLogFilename(const std::string& filename)
      {
          //--------- 테스트 대상 코드 영역
          size_t index = filename.find_last_of(".");
          std::string name = filename.substr(0, index);
          if (name.size() < 5) {
              return false;
          }
          //--------- 테스트 대상 코드 영역

          FileSystem fs;
          return fs.IsValidFilename(filename);  // 테스트 대상이 아니지만 테스트 결과에 영향을 끼치는 구문
      }
  };
  ```

- ex) SUT 코드를 약한 결합으로 변경하고 test double 적용
  1. SUT 코드에 협력 객체에 대한 인터페이스를 정의
     ```
      class IFileSystem {
      public:
          virtual ~IFileSystem() { }

          virtual bool IsValidFilename(const std::string& name) = 0;  // 순수 가상 함수로 정의
      };
     ```
  2. SUT 코드에서 협력 객체가 인터페이스를 사용하도록 변경
     ```
     class FileSystem : public IFileSystem {
     public:
         bool IsValidFilename(const std::string& name) override
         {
            // 현재의 파일 시스템에서 적합한 이름인지 확인합니다.
            return false;  // fasle 반환하는 경우 검증을 위한 코드
         }
     };
     ```
     
  3. test code 에서 Test double 용 class 생성
      ```
      class TestDoubleFileSystem : public IFileSystem {
      public:
          bool IsValidFilename(const std::string& name) override
          {
              return true;  // 무조건 true 반환하도록
          }
      };
      ```
  4. Dependency Injection (의존성 주입) 으로 협력객체를 test double 로 대체
     - class 내부에서 선언하지 않고, 외부에서 선언된 객체를 받아야 한다. 
       - 생성자 주입 : 협력 객체가 필수적일 때
       - method 주입 : 협력 객체가 필수적이지 않을 때
      ```
      TEST(LoggerTest, IsValidLogFilename_NameLongerThan5Chars_ReturnsTrue)
      {
          TestDoubleFileSystem td;  // 3번에서 정의한 class 사용
          Logger logger { &td };  // 의존성 주입. 외부에서 선언하고 Logger 에 전달
          std::string validFilename = "valid.log";  // 변수 이름에도 가독성 고려

          EXPECT_TRUE(logger.IsValidLogFilename(validFilename))
              << "확장자를 제외한 파일명이 5글자 이상 판단 실패";
      }
      TEST(LoggerTest, IsValidLogFilename_NameShorterThan5Chars_ReturnsFalse)
      {
          TestDoubleFileSystem td;
          Logger logger { &td };
          std::string invalidFilename = "bad.log";

          EXPECT_FALSE(logger.IsValidLogFilename(invalidFilename))
              << "확장자를 제외한 파일명이 5글자 미만 판단 실패";
      }

      // test case 에서 호출되는 IsValidFilename() 은 TestDoubleFileSystem 함수에서 정의된 함수가 호출되기 때문에 true 가 반환된다. 
      ```

#### Test Stub
- 목적 : 다른 Component로 부터의 받은 값(간접 입력)에 의존하는 로직을 독립적으로 검증이 필요할 때
- 방법 : 입력 값을 생성하는 Component 를 test double 로 교체한다.


- 예시 : 현재 시간의 값에 영향을 받는 Clock 이라는 class 에서 값을 받아 사용하는 Scheduler class 의 Alarm 함수 테스트를 위해, Clock 을 대체 할 test double class 를 생성
  ```
  class Time {
  public:
      virtual ~Time() { }

      virtual std::string GetCurrentTime() const = 0;
  };

  // 인터페이스 사용하여 구현되어 있어 test double 적용이 용이한 형태
  class Clock : public Time {
  public:
      std::string GetCurrentTime() const override
      {
          time_t rawTime;
          tm* timeInfo;
          char buffer[128];

          time(&rawTime);
          timeInfo = localtime(&rawTime);

          strftime(buffer, sizeof(buffer), "%H:%M", timeInfo);

          return std::string { buffer };
      }
  };

  class Scheduler {
      Time* time;

  public:
      Scheduler(Time* p)
          : time { p }
      {
      }

      int Alarm()
      {
          std::string current = time->GetCurrentTime();  // 다른 component 에서 받은 값에 의존적
          if (current == "00:00") {
              return 42;
          } else if (current == "10:00") {
              return 100;
          }

          return 0;
      }
  };
  ```
  - test stub pattern 을 적용하여 테스트의 독립성 확보
    ```
    // test double class 를 새로 정의
    class StubTime : public Time {
        std::string result;

    public:
        StubTime(const std::string& r) : result { r }
        {
        }

        std::string GetCurrentTime() const override
        {
            return result;
        }
    };

    TEST(SchedulerTest, Alarm_00_00)
    {
        // Clock clock;
        StubTime clock { "00:00" };  // Clock 객체 대신 StubTime 객체 사용
        Scheduler scheduler { &clock };

        int result = scheduler.Alarm();

        EXPECT_EQ(result, 42) << "00:00 일때";
    };

    TEST(SchedulerTest, Alarm_10_00)
    {
        // Clock clock;
        StubTime clock { "10:00" };
        Scheduler scheduler { &clock };

        int result = scheduler.Alarm();

        EXPECT_EQ(result, 100) << "10:00 일때";
    };
    ```
#### Fake Object
- 목적 : 협력 객체의 로직이 아직 미구현인 상태라 테스트가 불가능한 상황 해소
  - or 협력 객체가 사용하기 어려운 경우
  - or 협력 객체의 동작이 느린 경우
- 방법 : 동일한 기능을 제공하는 가벼운 test double 을 통해 검증을 수행한다.
  - Test Stub 과 비교했을 때, test stub은 logic이 없지만, fake object 는 가볍더라도 logic 이 포함된다.
- 예시 : database 기능을 대체할 수 있는 간이 class 를 선언
  ```
  // SUT에 정의된 사용자 정의 타입
  class User {
      std::string name;
      int age;

  public:
      User(const std::string& s, int n) : name { s }, age { n }

      std::string GetName() const { return name; }
      int GetAge() const { return age; }
  };
  // 데이터베이스 인터페이스
  class IDatabase {
  public:
      virtual ~IDatabase() { }

      virtual void SaveUser(const std::string& name, User* user) = 0;
      virtual User* LoadUser(const std::string& name) = 0;
  };

  // 데이터베이스(미구현) class 를 사용하는 class. 테스트 대상
  class Repository {
      IDatabase* database;

  public:
      Repository(IDatabase* p)
          : database { p }
      {
      }

      void Save(User* user)
      {
          //...
          database->SaveUser(user->GetName(), user);
          //...
      }

      User* Load(const std::string& name)
      {
          // ...
          return database->LoadUser(name);
      }
  };

  // 테스트를 위해 생성한 Fake class 
  class FakeDatebase : public IDatabase {
      std::map<std::string, User*> data;

  public:
      void SaveUser(const std::string& name, User* user) override
      {
          data[name] = user;
      }

      User* LoadUser(const std::string& name) override
      {
          return data[name];
      }
  };


  // 사용자 지정 타입의 비교를 위해 연산자 재정의
  bool operator==(const User& lhs, const User& rhs)
  {
      return lhs.GetName() == rhs.GetName() && lhs.GetAge() == rhs.GetAge();
  }
  // 사용자 지정 타입의 출력을 위해 연산자 재정의
  std::ostream& operator<<(std::ostream& os, const User& user)
  {
      retrurn os << "(" << user.GetName() << "," << user.GetAge() << ")";
  }

  // 테스트 수행
  TEST(RepositoryTest, Save)
  {
      FakeDatebase fake;  // Fake class 사용
      Repository repo { &fake };  // 의존성 주입
      std::string testName = "test_name";
      int testAge = 42;
      User expected { testName, testAge };

      repo.Save(&expected);
      User* actual = repo.Load(testName);

      ASSERT_NE(actual, nullptr);  // null pointer 로 인한 프로그램 에러 방지
      EXPECT_EQ(*actual, expected);
  }
  ```


#### Test Spy
- 목적: SUT의 함수를 동작 할 때 발생하는 부수 효과를 관찰할 수 없어서 테스트가 어려운 경우
  - 특정 함수의 동작 결과를 저장 해 두었다가 나중에 출력 할 수 있는 test double 구현
- 방법: 목격한 일을 기록 해 두었다가 이후 확인 할 수 있도록 만들어진 테스트 대역
  - 다른 component로 부터의 간접 출력을 저장하는 기능 존재
  - 저장된 간접 출력들로 합불을 판단판단 할 수 있는 기능 존재
- 예시: Logger 에서 호출되는 Write 함수는 결과를 확인 할 상태가 남지 않는다. DLoggerTarget 을 상속받는 test double 을 생성하여 Write 함수로 전달받은 내용을 저장하고, 나중에 확인 할 수 있도록 하는 로직을 추가한다.
  ```
  enum Level {
      INFO,
      WARN,
      ERROR
  };

  // 인터페이스
  class DLoggerTarget {
  public:
      virtual ~DLoggerTarget() { }

      virtual void Write(Level level, const std::string& message) = 0;
  };

  // 실제 구현체
  class FileTarget : public DLoggerTarget {
      // 전달된 내용을 파일에 기록합니다.
  };

  // 실제 구현체
  class NetworkTarget : public DLoggerTarget {
      // 전달된 내용을 네트워크로 전송합니다.
  };

  // 테스트 필요한 대상
  class DLogger {
      std::vector<DLoggerTarget*> targets;

  public:
      void AddTarget(DLoggerTarget* p) { targets.push_back(p); }

      void Write(Level level, const std::string& message)
      {
          for (auto e : targets) {
              e->Write(level, message); // 결과가 남지 않아 테스트 어려움
          }
      }
  };

  // test double 을 생성
  class SpyTarget : public DLoggerTarget {
      std::vector<std::string> history;  // 전달 된 string 을 vector 에 저장

      std::string Concat(Level level, const std::string& message) const
      {
          return message + std::to_string(level);  // 최종 결과를 이어붙여 반환
      }

  public:
      void Write(Level level, const std::string& message) override
      {
          // 목격한 일을 기록
          history.push_back(Concat(level, message));
      }

      // 동작 결과를 판단하는 기능
      bool IsReceived(Level level, const std::string& message) const
      {
          return std::find(std::begin(history), std::end(history), Concat(level, message))
              != std::end(history);
      }
  };

  // test code
  TEST(DLoggerTest, Write)
  {
      DLogger logger;
      SpyTarget t1, t2;
      logger.AddTarget(&t1);
      logger.AddTarget(&t2);

      logger.Write(INFO, "test_message1");
      logger.Write(WARN, "test_message2");

      EXPECT_TRUE(t1.IsReceived(INFO, "test_message1"));  // 테스트 결과 판단
      EXPECT_TRUE(t2.IsReceived(INFO, "test_message1"));
      EXPECT_TRUE(t1.IsReceived(WARN, "test_message2"));
      EXPECT_TRUE(t2.IsReceived(WARN, "test_message2"));
  }
  ```
- test code 가 SUT code 보다 더 많아지는 딜레마가 발생한다.


#### Mock Object
- 목적 : "상태기반 검증"이 아닌 "행위기반 검증"을 수행
  - 상태기반 검증 : SUT에 작용을 가한 후 내부 상태 변화를 확인하고 단언문을 통해 정상 동작 여부를 판단
  - 행위 기반 검증 : SUT 에 작용을 가한 후 함수 호출 여부, 호출 횟수, 호출 인자, 호출 순서 등의 정보를 통해 정상 동작 여부를 판단
- 방법 : Mock Framework 라는 별도의 framework 를 사용하여 구현
  - Google Mock 을 활용할 수 있다.
    - [Google Mock 사용 방법](./google-mock)
- Mock 을 사용한 검증은 초창기에는 별도의 테스트로 여겨졌으나, 현재는 단위테스트 수행시 기본적으로 수행하는 추세가 되었다.

- 사용 방법:
  - 모의 객체를 생성하고, `MOCK_METHOD` 매크로를 활용하여 테스트 할 함수를 설정한다.
    - `MOCK_METHOD{인자갯수}(method 이름, method 타입)` : MOCK_METHOD 사용 방법
    ```
    class MockDLoggerTarget : public DLoggerTarget {
    public:
        // void Write(Level level, const std::string& message)
        // 행위 기반 검증을 수행하고자 하는 메소드
        MOCK_METHOD2(Write, void(Level level, const std::string& message));  // mock 함수 생성
    };

    ``` 
  - `EXPECT_CALL` 매크로를 사용하여 함수가 수행 되어야 한다는 것을 미리 설정 해 둔다. 이후 `EXPECT_CALL` 로 설정 한 함수가 호출되지 않으면 에러가 발생한다.
    - `EXPECT_CALL(class 이름, 함수 호출구문)` 형태로 사용한다.
    - 주의 사항: `EXPECT_CALL` 구문이 `ASSERT_`, `EXPECT_` 와 같은 상태기반 검증의 단언문보다 먼저 수행되는 형태가 좋다.
    ```
    TEST(DLoggerTest, Write)
    {
        // Arrange
        DLogger logger;
        MockDLoggerTarget t1, t2;
        logger.AddTarget(&t1);
        logger.AddTarget(&t2);

        // Assert
        // 행위 기반 검증 단언문 먼저 설정
        EXPECT_CALL(t1, Write(INFO, "test_message1"));
        EXPECT_CALL(t1, Write(WARN, "test_message2"));
        EXPECT_CALL(t2, Write(INFO, "test_message1"));
        EXPECT_CALL(t2, Write(WARN, "test_message2"));

        // Act
        // 상태 기반 검증 단언문
        logger.Write(INFO, "test_message1");
        logger.Write(WARN, "test_message2");
    }
    ```

- 장점 : 행위 검증을 위한 Lobic 작성이 필요 없음

## Google Mock
- Google Mock 은 행위기반 검증만을 위한 tool 이 아니라, test double 을 위한 tool 로서, test stub, fake object, test spy 등을 google Mock 으로 구현 할 수도 있다.

### 설치
1. googletest 소스코드를 다운받으면 `googletest/googlemock/src/gmock-all.cc` 파일을 include 하여 사용 가능하다.
2. google mock 사용에 필요한 소스코드를 컴파일 한다.
   - `g++ -c ./googletest/googlemock/src/gmock-all.cc -I ./googletest/googlemock/include -I ./googletest/googlemock/ -I ./googletest/googletest/include/ -std=c++14 -O2` : gtest-all.o, gmock-all.o 컴파일
   - main 함수에서 `InitGoogleMock` 을 호출하도록 한다. 
     - `googletest/googlemock/src/gmock_main.cc` 파일에 있는 main을 활용할 수 있다.
     - `g++ -c -std=c++14 -O2 ./googletest/googlemock/src/gmock_main.cc -I ./googletest/googletest/include -I ./googletest/googlemock/include` : gmock-main.o 컴파일
3. 라이브러리 생성
   - `ar rcv libgtest.a gmock-all.o gtest-all.o gmock_main.o` : 컴파일 한 목적 파일로 libgtest.a 라이브러리를 생성한다. 
4. 소스코드에 헤더 파일을 include 한다.
   - `#include <gmock/gmock.h>`
   - gmock 만 include 하면 gtest 는 자동으로 include 된다.
5. 이후 소스코드 빌드할 떄 아래 스크립트를 사용한다.
   ```
   #!/bin/sh
   # file name : build.sh
   g++ $1 -I ./googletest/googletest/include/ -I ./googletest/googlemock/include/ -lgtest -L. -std=c++14 -pthread
   # -fsanitize=address  # 필요하다면 추가
   ```
   - ./build.sh FILE_NAME

### 사용
- Google Test 1.10 이후 `MOCK_METHOD{인자갯수}(method name, method type)` 형태는 `MOCK_METHOD(return type, method name, parameter, 한정자)` 형태로 변경됨
  - ex) 
    ```
    class MyClass {
    public:
        void myFunc(int A, std::string B, char* c) = 0; // 원본 가상함수

        virtual std::string func1() const = 0;  // 인자가 없는 형태
        virtual void func2() const noexcept = 0;  // 한정자가 여러개인 형태
        virtual std::pair<bool, int> func3() const = 0;  // 탬플릿 타입을 사용하는 함수
        virtual bool func4(std::map<std::string, int> a, bool b) const = 0;
    };

    class MockClass : public MyClass {
    public:
        // void myFunc(int A, std::string B, char* c) override  // 만들고 싶은 함수 형태
        MOCK_METHOD(void, myFunc, (int A, std::string B, char* c), (override))  // MOCK_METHOD 선언
        // 한정자도 2개 이상 있을 수 있기 때문에 괄호로 묶어준다.
            
        MOCK_METHOD(std::string, func1, (), (const, override));
        MOCK_METHOD(void, func2, (), (const, noexcept, override));
        MOCK_METHOD((std::pair<bool, int>), func3, (), (const, override));
        MOCK_METHOD(bool, func4, ((std::map<std::string, int>) a, bool b), (const, override));
    };
    ```
    - override 는 원본에는 없고, 쓰지 않아도 문법상 오류는 없지만, 추가 해 주어야 하는 한정자이다.
    - 주의사항1: 매크크로 함수의 특성상 ',' 로 인자를 구분하는데, 탬플릿 타입에 사용되는 ',' 때문에 파싱 오류가 나지 않도록, 탬플릿 타입은 괄호로 묶어주도록 주의한다. 

- SUT 에서 구현된 class 중, 순수 가상함수가 아닌 함수들은 행위기반 검증이 필요한 경우만 선택적으로 `MOCK_METHOD` 화 시켜주면 된다.
- 주의사항2: `MOCK_METHOD` 와 동일한 이름의 함수가 부모에 존재한다면, `MOCK_METHOD` 에 가려져서 mock class 에서 해당 함수의 호출이 불가능하다.
  - ex)
  ```
  class SUT{
  public:
      // 두 개의 버전이 존재
      virtual void func(int a) {}
      virtual void func() {}

  };

  class MockSUT : public SUT{
  public:
      MOCK_METHOD(void, func, (), (override));
      using SUT::func;
  };

  TEST(TS, TC)
  {
      MockSUT m;

      m.func(1);  // `using SUT::func` 구문 없으면 오류 발생. 'TEST' 구문 안에서 직접 호출시에만 문제 발생
      m.func();
  }
  ```

  - 탬플릿 기반 인터페이스/추상클래스 도 MOCK_METHOD 적용 가능
    - ex)
    ```
    template <typename T>
    class SUT {
    public:
        virtual ~SUT() { }

        virtual int func1() const { return 0; }
        virtual void func2(const T& data) = 0;
    };

    template <typename TYPE>
    class MockSUT : public SUT<TYPE> {
    public:
        MOCK_METHOD(int, func1, (), (const, override));
        MOCK_METHOD(void, func2, (const TYPE& data), (override));
    };
    ```


- 의존성 주입을 사용하면, 제품 코드를 사용하는 방식 그대로 테스트를 수행할 수 있다.
  ```
  // 인터페이스
  class IPacketStream {
  public:
      virtual ~IPacketStream() { }

      virtual void AppendPacket(Packet* newPacket) = 0;
      virtual const Packet* GetPacket(size_t packetNumber) const = 0;
  };
  
  // 협력객체 class
  class PacketStream : public IPacketStream {
  public:
      void AppendPacket(Packet* newPacket) override
      {
          std::cout << "AppendPacket" << std::endl;
      }

      const Packet* GetPacket(size_t packetNumber) const override
      {
          std::cout << "GetPacket: " << packetNumber << std::endl;
          return nullptr;
      }
  };

  // 인터페이스로 구현된 테스트 필요한 SUT 코드
  class PacketReader {
  public:
      void ReadPacket(IPacketStream* stream, size_t packetNumber)
      {
          // ...
          stream->AppendPacket(nullptr);
          stream->GetPacket(packetNumber);
      }
  };
  // 협력객체를 대체할 테스트용 Mock class
  class MockPacketStream : public IPacketStream {
  public:
      // void AppendPacket(Packet* newPacket) override
      MOCK_METHOD(void, AppendPacket, (Packet * newPacket), (override));

      // const Packet* GetPacket(size_t packetNumber) const override
      MOCK_METHOD(const Packet*, GetPacket, (size_t packetNumber), (const, override));
  };
  ```

- C++에서는 명시적 인터페이스 외 암묵적 인터페이스를 통해 의존성 주입 설계를 수행할 수 있다.
  - C++ 의 탬플릿 기능을 활용하면 인터페이스를 따로 정의하지 않고 그 기능을 대체 할 수 있다.
  ```
  class PacketReader {
  public:
      template <typename IPacketStream>  // 이 구문을 추가해 줌으로서 인터페이스를 구현한 것과 동일한 효과
      void ReadPacket(IPacketStream* stream, size_t packetNumber)
      {
          // ...
          stream->AppendPacket(nullptr);
          stream->GetPacket(packetNumber);
      }
  };

  ```
  - Policy Based Design (단위 전략) : 탬플릿 기반으로 정책을 컴파일 시간에 교체 가능
  - 장점 : 가상함수 기반이 아니기 때문에 inline 최적화가 가능하다.
  - 단점 : 실행 시간에 정책 교체가 불가능하다. C++에 한정하여 적용 가능하다.

- Mock 의 종류
  1. NaggyMock
     - Google Mock 의 기본 타입은 NaggyMock 이다.
     - `MOCK_METHOD` 를 생성하고, `EXPECT_CALL` 로 감시 처리 하지 않았지만 test case 수행 결과 해당 함수가 호출이 된다면 실행 결과에 warning 메시지를 출력시킨다. 실행 결과에는 영향을 주지는 않는다.
  2. NiceMock
     - `using testing::NiceMock` 구문을 추가하고 `NiceMock<MockSUT> mock` 으로 선언한다. 
     - NaggyMock 을 사용 할 때 warning 메시지를 띄우는 경우, `NiceMock` 을 사용하면 메시지가 출력되지 않는다.
     - 행위기반 검증이 아닌 다른 목적으로 사용하는 경우 `NiceMock` 을 사용할 수 있다.
  3. StrictMock
     - `using testing::StrictMock` 구문을 추가하고 `StrictMock<MockSUT> mock` 으로 선언한다. 
     - NaggyMock 을 사용 할 때 warning 메시지를 띄우는 case 에 error 를 발생시킨다. 
     - 테스트를 통과하는 기준이 높아져서 테스트 비용이 증가할 수 있으므로 주의해서 사용해야 한다. 

- Delegating
  - 주의사항3: `MOCK_METHOD` 로 만들어진 함수는 return 값이 달라지게 된다. (0을 반환)
  - Google Test Framework 에는 `MOCK_METHOD` 의 반환값을 제어할 수 있는 기능을 제공하며, 이를 Delegating 이라 한다.
  - `ON_CALL` 매크로를 활용하면 Delegating 설정을 할 수 있다.
    ```
      class SUT {
      public:
          void func(int a, int b) { return 10;}
      };

      class MockSUT : public SUT{
      public:
          MOCK_METHOD(void, func, (int a, int b), (override));
      };

      using testing::Return;
      TEST(TS, TC) {
          MockSUT m;

          ON_CALL(m, func(1, 2)).WillByDefault(Return(10));  // func(1, 2) 결과가 10 반환

          EXPECT_CALL(m, func(1, 2));


          m.func(1,2);  // 호출은 a, b, c 모두 사용
      }
    ```
    - 아래와 같은 방식으로도 사용 할 수 있다.
      - 원본 함수: `Add(int a, int b) { return a + b; }`
      - `ON_CALL(mock, Add(10, 20)).WillByDefault(Return(30));` : Add(10,20) 은 30 을 반환하도록 설정
      - `ON_CALL(mock, Add).WillByDefault(Return(30));` : Add 함수는 인자에 상관없이 30을 반환하도록 설정
      - `ON_CALL(mock, Add).WillByDefault(&add);` Add 함수는 add라고 정의된 함수의 동작을 따라서 반환값 반환(단, Add와 add 의 함수 형태는 동일)
        - `int add(int a, int b) { return a + b; }`
      - `ON_CALL(mock, Add).WillByDefault(Adder {});` : 구조체의 멤버 함수 사용
        - `struct Adder {int operator()(int a, int b) const { return a + b; }};`
      - `ON_CALL(mock, Add).WillByDefault([](int a, int b) { return a + b; });` : 람다 표현식으로 Add 의 반환값 설정

    - `ON_CALL` 명령은 test case에 작성해도 되지만, mock class 생성자에 선언해도 된다.
      ```
      // mock class 선언
      class MockDatabase : public IDatabase {
          std::map<std::string, User*> data;

      public:
          // 생성자 선언
          MockDatabase()
          {
              // 생성자에서 ON_CALL 설정, ON_CALL 구문 중복 방지
              ON_CALL(*this, SaveUser).WillByDefault([this](const std::string& name, User* user) {
                  data[name] = user;
              });
              ON_CALL(*this, LoadUser).WillByDefault([this](const std::string& name) {
                  return data[name];
              });
          }

          // void SaveUser(const std::string& name, User* user) override
          MOCK_METHOD(void, SaveUser, (const std::string& name, User* user), (override));

          // User* LoadUser(const std::string& name) override
          MOCK_METHOD(User*, LoadUser, (const std::string& name), (override));
      };
      ```
    
  - Delegating 기능을 사용하여 Test Stub, Fake Object, Test Spy 를 모두 구현할 수 있다.
  - EXPECT_CALL 과 ON_CALL 을 동시에 사용할 경우 EXPECT_CALL 만 사용해서 Delegation 을 사용 할 수 있다.
    - `WillOnce`, `WillRepeatedly` 구문을 추가하면 EXPECT_CALL 구문에 ON_CALL 내용을 적용 할 수 있다.
      - `WillOnce` 는 여러 번 호출 가능하며, queue 에 쌓이듯이 순서대로 적용된다. 
      - `WillOnce` 사용 횟수만큼 함수가 호출되지 않으면 테스트 결과는 실패로   판단된다. 
      - `WillOnce()` : 인자로 들어간 `ON_CALL` 구문을 지정된 함수가 호출 될 떄 한 번만 적용
      - `WillRepeatedly()` : 인자로 들어간 `ON_CALL` 구문을 함수 호출마다 적용
        - 한 번만 사용 가능
        - `WillOnce` 보다 나중에 사용 가능
    ```
    // case 1
    EXPECT_CALL(mock, func(10,20)).WillOnce(Return(30));  // 아래 두 구문을 한번에 표현 한 것이다.
    /*
        ON_CALL(mock, func(10,20)).WillByDefault(Return(30));
        EXPECT_CALL(mock, func(10,20));
    */
    mock.func(10,20); // 30 반환

    // case 2
    EXPECT_CALL(mock, func(10,20))
        .WillOnce(Return(30));
        .WillOnce(Return(40));
        .WillOnce(Return(50));
    // 아래 구문을 한 번에 표현 한 것이다.
    /*
        ON_CALL(mock, func(10,20)).WillByDefault(Return(30));
        EXPECT_CALL(mock, func(10,20)).Times(3);  // WillOnce 세번 사용
    */

    mock.func(10,20); // 30 반환
    mock.func(10,20); // 40 반환
    mock.func(10,20); // 50 반환

    // case 3
    EXPECT_CALL(mock, func(10,20))
        .WillOnce(Return(30));
        .WillOnce(Return(40));
        .WillRepeatedly(Return(50));
    // 아래 구문을 한 번에 표현 한 것이다.
    /*
        ON_CALL(mock, func(10,20)).WillByDefault(Return(30));
        EXPECT_CALL(mock, func(10,20)).Times(AtLeast(2));  // WillOnce 두번 사용 이후 willRepeatedly 사용
    */
    
    mock.func(10,20); // 30 반환
    mock.func(10,20); // 40 반환
    mock.func(10,20); // 50 반환
    mock.func(10,20); // 50 반환
    ```


1. 함수 호출 여부 판단
   - `EXPECT_CALL` 을 사용하여 호출 여부를 확인할 수 있다.
   - `EXPECT_CALL` 은 별도의 오류 메시지를 지정할 수 있는 기능을 제공하지 않는다.
   - 감시 대상 함수가 호출되기 전 설정이 되어 있어야 한다.
   - mock 객체가 파괴되는 시점에 `EXPECT_CALL` 로 감시를 선언한 함수들의 결과를 판단한다. 
     - 만약 mock 을 'new' 를 통해 생성했다면, 명시적으로 'delete' 를 해 줘야 정상 동작을 한다.
     - mock 을 지역변수로 선언한다면 함수 종료시 자동으로 해제되기 때문에 정상 동작 할 것이다.

2. 함수 호출 인자 판단
   - ex1) EXPECT_CALL(mock, func(1,2)) : func(1,2) 형태로 함수가 호출되어야 OK
   - ex2) EXPECT_CALL(mock, func) : 어떤 인자로든 func 함수가 호출 되기만 하면 OK
   - 특정 인자만 감시하려면 `Mock 간략화` 기능을 사용한다.
     - `Mock 간략화` : 함수의 특정 인자에 대해서만 검증을 수행하고 싶을 때 사용하는 방식
       ```
       class SUT{
       public:
           void func(int a, int b, int c) {}
       };

       class MockSUT : public SUT{
       public:
           // parent 함수 override
           void func(int a, int b, int c) override {
               func(int a); // MOCK_METHOD 로 생성한 함수 호출
           }

           MOCK_METHOD(void, func, (int a), (override));  // void func(int a) override {} 형태의 함수를 생성함

           // -> 
       };

       TEST(TS, TC) {
           MockSUT m;
           EXPECT_CALL(m, func(1));  // 인자 a 에 대해서만 검증
           m.func(1,2,3);  // 호출은 a, b, c 모두 사용
       }
       ```
   - 호출 인자에 조건을 설정하려면 `Matcher` 를 사용할 수 있다.
     ```
     using testing::Ge;
     using testing::Eq;
     using testing::Matcher;
     Matcher<int> arg0 = Ge(10); // 10보다 커야함
     Matcher<int> arg1 = Eq(20); // 20보다 작아야함
     EXPECT_CALL(mock, func(arg0, arg1));  // arg0은 10보다 작고, arg1은 20보다 커야 성공
     ```
     - 논리연산
       - `testing::Eq` : ==
       - `testing::Ne` : !=
       - `testing::Ge` : >=
       - `testing::Gt` : >
       - `testing::Le` : <=
       - `testing::Lt` : <
       - `testing::_` : 조건 없음(anything matcher)
       - Matcher의 논리적 긱준을 and/or 조건으로 묶어서 사용할 수 있다.
         ```
         using testing::Matcher;
         using testing::Gt;
         using testing::Lt;
         using testing::_;
         using testing::AllOf; // and
         using testing::AnyOf; // or

         MyMockClass mock;  // 필요한 mock class 정의 필요
         Matcher<int> arg0 = AllOf(Gt(10), Lt(20)); // 10 초과 && 20 미만
         Matcher<int> arg1 = AnyOf(Gt(20), Lt(10)); // 10 미만 || 20 초과
         EXPECT_CALL(mock, func(arg0, arg1, _ )).Times(3);

         mock.func(15,25, 128);
         mock.func(11,0, 256);
         mock.func(19,21, 512);
         ```
   - `Mock 간략화` 대신 anything matcher 를 사용화 할 수도 있다.
      ```
      using testing::_;
      EXPECT_CALL(mock, func(_, "arg", _)); // 첫 번째, 두 번쨰 인자 신경 안쓰고 두 번쨰 인자에 "arg" 문자열이 오는지 판단
      ```

   - Matcher 적용 심화
     - 다중 인자 Matcher 적용 방법
      ```
      using testing::ElementsAreArray;

      // 배열 형태로 구성
      Matcher<int> args[] = { Eq(1), Eq(2), Eq(3) }
      EXPECT_CALL(moc, func(ElementsAreArray(args)));

      // 단순 열거 형태로 사용
      using testing::ElementsAre;
      EXPECT_CALL(moc, func(ElementsAre(Eq(1), Eq(2), Eq(3))));

      // 인자 순서 상관없이 모든 조건이 매칭될 수 있는지 체크
      using testing::UnorderedElementsAre;
      EXPECT_CALL(moc, func(ElementsAre(Eq(1), Eq(2), Eq(3))));
      ```
      - `testing::HasSubstr` : 문자열 포함 여부 체크
      - `testing::ContainsRegex` : 정규표현식을 만족하는지 체크
      - [Matcher Document](https://google.github.io/googletest/reference/matchers.html)

3. 함수 호출 횟수 판단
   - `EXPECT_CALL(mock, func).Times(n)` : "mock" class 의 함수 'func' 가 'n'번 호출되어야 성공
     - Times를 지정하지 않은 경우에는 기본적으로 `.Times(1)` 이 생략된 형태
   - `EXPECT_CALL(mock, func).Times(AtLeast(n))` : "mock" class 의 함수 'func' 가 최소 n번 이상 호출되어야 성공
   - `EXPECT_CALL(mock, func).Times(AtMost(n))` : "mock" class 의 함수 'func' 가 최대 n번 이하 호출되어야 성공
   - `EXPECT_CALL(mock, func).Times(Between(n, m))` : "mock" class 의 함수 'func' 가 n 이상 m 이하 호출되어야 성공
     - `Cardinality` 개념을 적용하여 호출 횟수를 범위로 표현
     - `using testing::AtLeast;`, `using testing::AtMost;`, `using testing::Between;` 코드 추가 필요

4. 함수 호출 순서 판단
   - Google Mock 에서는 기본적으로 함수 호출 순서는 검증 대상에 포함되지 않는다.
   - `testing::InSequence` 객체를 활용하여 함수 호출 순서를 검증할 수 있다.
     - test code 에 InSequence 객체를 선언하면 해당 test case 에서는 모든 함수가 `EXPECT_CALL` 을 선언한 순서대로 호출되어야 테스트 결과가 성공으로 판단된다.
       ```
       Test(TS, TC) {
           InSequence seq;  // 선언하고, 사용하지 않으면 자동으로 모든 EXPECT_CALL 에 적용됨
           MyMock mock;

           EXPECT_CALL(mock, func1);
           EXPECT_CALL(mock, func2);
           EXPECT_CALL(mock, func3);
           // func1 -> func2 -> func3 순서대로 호출이 되어야 함

           mock.func1();
           mock.func3();  // 함수 호출 순서가 달라서 실패
           mock.func2();
       }
       ```
     - 특정 함수들 간의 순서만 확인하고 싶을 때 `EXPECT_CALL().InSequence()` 구문을 사용한다.
       ```
       Test(TS, TC) {
           InSequence seq1, seq2;  // 두 개의 순서 선언
           MyMock mock;

           // InSequence 구문으로 명시적으로 seq 객체들을 사용하면, 사용한 함수에만 sequence 적용됨
           EXPECT_CALL(mock, func1).InSequence(seq1, seq2);
           EXPECT_CALL(mock, func2).InSequence(seq1);
           EXPECT_CALL(mock, func3).InSequence(seq2);
           EXPECT_CALL(mock, func4)  // 순서에 상관없이 아무때나 호출되어도 되는 함수
           // func1 -> func2 순서 보장 필요
           // func1 -> func3 순서 보장 필요

           mock.func4();  // 순서 제약 없는 함수
           mock.func1();  // 순서 이상 없음
           mock.func3();  // 순서 이상 없음
           mock.func2();  // 순서 이상 없음
           mock.func4();  // 순서 제약 없는 함수
       }
       ```

- HamCrest Matcher
  - Google Mock 의 `Matcher` 는 HamCrest 라이브러리에 기반하며, 상태기반 검증에서 Matcher 를 활용할 수 있다.
  - `ASSERT_THAT`, `EXPECT_THAT` 매크로 함수는 인자로 matcher 구문을 적용하여 검증할 수 있다.
    ```
    EXPECT_THAT(myClass.getName(), testing::StartsWith("K")) << "name doesn't start with K"; // 함수 결과가 "K" 로 시작하는 string
    ```
  - [Matcher Document](https://google.github.io/googletest/reference/matchers.html)
