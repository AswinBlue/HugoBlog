+++
title = "Tensorflow"
date = 2021-11-27T08:15:42+09:00
lastmod = 2021-11-27T08:15:42+09:00
tags = ["tensorflow", "deep learning", "python",]
categories = ["dev",]
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

#Tensorflow
- TensorFlow는 구글에서 수치연산을 위해 만든 라이브러리이다.

## 기본 개념
- node와 edge로 구성된 graph를 이용해 수치 연산을 수행한다.
  - node들은 특정한 데이터가 들어오면 연산을 수행하거나, 형태를 변경하거나, 결과를 출력하는 역할을 한다.
  - edge는 학습데이터가 저장되는 다차원 배열이다.
  - edge는 node에서 계산된 데이터를 다음 node로 이동시킨다.
  - edge는 방향성이 있으며(directed), tensor라 불린다.

---

## 설치
1. python과 pip를 설치한다.
2. `pip install tensorflow` 명령을 수행한다.
 - window에서 'client_load_reporting_filter.h' 파일을 찾지 못해 설치를 못했다면, path 경로가 너무 길어서 발생하는 오류이다.
 - 실행에서 `regedit`을 실행하고, 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem' 레지스트리를 찾아 값을 1로 세팅해준다.

### 연관 모듈
- 함께 쓰면 효율이 좋은 모듈들
1. matplotlib
2. numpy
3. keras (tensorflow 설치시 자동성치된다)

---

## 기본 문법
1. 상수 선언  
  `val = tf.constant(value, dtype=None, shape=None, name='Conts', verify_shape=False)`
  - value = 값
  - dtype : 데이터 타입, ex) 'tf.float32', 'tf.float64', 'tf.int8'
    - float(32, 64), int(8, 16, 64),uint(8, 16), string, bool, complex(64, 128 : 복소수)
  - shape : 차원, value 형태에 따라 자동으로 설정 됨, ex) '[3,3]'
  - name : 상수의 이름
  - verify_shape : tensor의 shape를 바꿀수 있는지 여부

1. 배열 생성  
  - `arr = tf.range(5)`
  > output : `tf.Tensor : shape(5,), dtype=int32, numpy=([0, 1, 2, 3, 4], dtype=int32)`
  - 'tf.zeros([2,3])'
  > output : `[[0, 0, 0], [0, 0, 0]]`
  - 'tf.ones([2,3])'
  > output : `[[1, 1, 1], [1, 1, 1]]`
  - 'tf.fill([2,3], 5)'
  > output : `[[5, 5, 5], [5, 5, 5]]`

1. 연산자
  `tf.add(x,y)` : x + y  
  `tf.subtract(x,y)` : x - y  
  `tf.multiply(x,y)` : x * y  
  `tf.div(x,y)` : x / y  
  `tf.floordiv(x,y)` : x // y  
  `tf.mod(x,y)` : x % y  
  `tf.pow(x,y)` : x ** y  
  `tf.less(x,y)` : x < y  
  `tf.less_equal(x,y)` : x <= y  
  `tf.greater(x,y)` : x > y  
  `tf.greater_equal(x,y)` : x >= y  
  `tf.logical_and(x,y)` : x & y  
  `tf.logical_or(x,y)` : x | y  
  `tf.logical_xor(x,y)` : x ^ y  
  `tf.maximum(x,y)` : max(x,y)  
  `tf.reduce_sum(a)` : 배열 a에서 같은 index 위치의 값을 모두 더한 스칼라 값을 반환  
  `tf.reduce_mean(a)` : 배열 a에서 같은 index 위치의 값을 평균낸 스칼라 값을 반환  

  - x,y가 배열인 경우, 연산자는 같은 index에 위치한 값끼리 연산한다.  
  ex) `tf.add(x,y) = [(x[0] + y[0]), (x[1] + y[1]), (x[2] + y[2]), ...]`  
  - 'reduce' 가 들어간 연산은 axis 파라미터를 설정하여 어느 축을 기준으로 연산을 수행할지 설정 가능  
  ex)
  ```
  a = [[1,2,3],[4,5,6]]
  tf.reduce_sum(a, axis=0) = [5, 7, 9]
  tf.reduce_sum(a, axis=1) = [6, 15]
  ```

1. 변수
  - tensorflow에서 변수는 node를 만들고, 그 안의 값을 참조하는 방식이다.

    `var = tf.Variable(value, dtype=type)`
    - value : 변수에 담을 값
    - dtype : 변수 타입
    - 2.x 버전에서는 위와같이 선언과 동시에 초기화가 가능하다.
  - node를 생성하고 var은 그 node의 주소를 가리킨다.

    `var.assign(value)`
  - var이 가리키는 node에 value 값을 적용

    `var.assign_add(value)`
  - var이 가리키는 node에 value 값을 더함

    `var.assign_add(value)`
  - var이 가리키는 node에 value 값을 뺌

    `tf.cast()`
  - 변수를 특정 값, 특정 형태로 치환해주는 함수

1. 출력  
  `val.numpy()` : 'val' tensor를 numpy 배열 형태로 출력

1. 비교
  `tf.equal()` : tensorflow 변수를 비교하는 함수

1. 랜덤
  `tf.random.set_seed()` : 정수를 이용해 랜덤값 시드 설정
  `tf.random.normal([2, 1], mean=0.0))` : 정규분포에 기반한 랜덤값, 인자로 행렬 shape와 평균이 들어간다.

---

## 심화 내용

### tensorflow와 행렬
- TensorFlow에서 배열은 행렬로 표현되며, 행렬은 shape라 불린다.
- 행렬 계산을 위한 함수를 제공한다.
`tf.matmul(a, b)` : 행렬의 내적(곱)
`tf.linalg.inv(a)` : 역행렬

1. Broadcasting
  - 행렬을 곱셈 혹은 덧셈을 하기 위해서는 shape에 대한 제약조건이 있고, tensorflow에서도 마찬가지다.
  - tensorflow에서는 행렬 연산에서 차원(shape)이 맞지 않을 때 행렬을 자동으로 늘려서(Stretch) 차원을 맞춰주는 Broadcasting기능이 있다.
    - 연산시 shape는 첫번째 피연산자를 기준으로 한다.
    - stretch 시 새로 생성된 공간에는 기존 내용을 복사하여 채워넣는다.
    - 단, 늘릴 수는 있지만, 줄일수는 없다.
  ex)
  a[4,3] + b[1,3] : 가능
  a[4,3] + b[1,5] : 불가능 (3 < 5 이므로, 5를 3으로 바꾸려면 축소해야함)
  a[4,1] + b[1,3] : 가능

### tensorflow 함수
- tensorflow 1.x 버전은 placeholder를 통해 입력을 받는 객체를 생성하고, 실행시 session을 통해 feed 값을 전달한다. 즉 명시적으로 입력 형태를 구성해야 했다.
- tensorflow는 2.x 버전부터 python 프로그램처럼 라이브러리를 사용할 수 있도록 연산에 함수를 제공하고 있다. 함수를 사용하면 placeholder를 생략하고 사용할 수 있다.
- tensorflow 함수는 파이썬 함수처럼 정의하여 사용 가능하며, 컴파일시 속도 향상을 원한다면 `@tf.function` 데코레이터를 적용하면 된다.  
ex)

```
@tf.function
def t_func(a,b):
    return tf.matmul(a,b)

x = [[4,5,6],[6,7,8]]  # tensorflow 변수가 아님
w = tf.Variable([2,5],[6,5],[17,10])
print(t_func(x,w))
# tensorflow 2.x 이후부터는 변수 x같은 값들도
# placeholder를 만들고 feed 값을 주는 복잡한 과정 없이
# tensorflow 함수를 이용해 연산 가능해졌다.
```

### tensorflow 미분
- gradient 계산에 미분이 많이 사용고, tensorflow는 미분 함수를 제공한다.
- `tape.gradient(y,x)` : 텐서 x에 대한 y의 미분값
- `tape.watch()` : 상수형 텐서를 변수형 텐서로 변환

ex)

```
x1 = tf.Variable(tf.constant(1.0))  # 변수 선언
x2 = tf.Variable(tf.constant(2.0))  # 변수 선언
with tf.GradientTape() as tape:  # 미분을 위해 GradientTape 객체 생성
    y = tf.multiply(x1, x2)  # 미분할 함수값을 GradientTape 객체 안에서 정의
gradients = tape.gradient(y, [x1, x2])  # x1 미분값과 x2 미분값을 각각 반환
# y = x1 * x2
# x1 에 대한 미분값 : 2.0
# x2 에 대한 미분값 : 1.0
# gradients = [2.0, 1.0]

a = tf.constant(2.0)
gradients2 = tape.gradient(y,a)
# 상수로 미분하면 None 값이 된다.
# gradients2 = None

# 상수를 변수로 변환시켜 미분시킬 수 있다.
with tf.GradientTape() as tape:
    tape.watch(a)
    y = tf.multiply(x1, a)
gradients3 = tape.gradient(y,a)
# gradients3 = 1.0
```

### 선형 회귀
- '딥러닝'은 데이터를 통해 관계를 학습하고, 학습된 모델을 통해 데이터가 주어지면 예측값을 도출해 내는 기술이다.
- '딥러닝'의 가장 기본적인 계산 원리는 '션형 회귀'와 '로지스틱 회귀' 이다.

1. 선형회귀 : 데이터 분포를 통해 데이터들과 가장 근접한 선을 도출해내는 계산법  
1. 로지스틱 회귀 : 0과 1 둘 중 하나를 선택하는 계산법  
  - 판단의 근거를 마련할 때 사용
  - sigmoid 함수를 사용하여 확률값으로 사용

#### 선형 회귀 정의
- 종속변수 y와 한개 이상의 독립변수 x와의 선형 상관관계를 모델링하는 회귀분석 기법
  - 단순 선형회귀 : 하나의 변수에 기반하여 동작
  - 다중 선형 회귀 : 둘 이상의 변수에 기반하여 동작
- 선형 예측함수를 통해 회귀식을 모델링하고, 알려지지 않은 파라미터를 데이터로 추정
- 회귀식을 선형 모델이라고 한다.

- 값을 예측하기 위해 학습 데이터로 적합한 예측 모형을 개발한다.
- 종속변수 y와 이에 연관된 독립변수들 x1, x2... 에 대해 x와 y간의 관계를 정량화 할 수 있다.
- 일반적으로 최소제곱을 사용해 선형 회귀 모델을 구할 수 있다. (y = ax + b 형태)
  - 독립변수(x)가 증가하면 최소 제곱법으로 처리가 불가능하다.

- 딥러닝에서는 y = wx + b 형태로 표현하는데, w 는 weight, b는 bias 를 뜻한다.
  - weight : 가중치, 입력값 x의 영향도를 표현하는 상수
  - bias : 기준점, 판단의 근거가 되는 식의 기준점을 표현하는 상수

#### 오차방정식
- 선형 회귀에서 입력값이 여러개일 경우, 첫번째 입력으로 임의의 선을 그린다.
- 정답과 임의의 선이 맞는지 확인하고 평가한다 (오차 확인)
- 확인된 오차 값을 이용해 임의의 선을 수정한다.
- 즉,  y = ax + b 에서 (x,y)를 입력으로 받고 a,b를 추론한다. 이러한 계산 식을 오차방정식이라 한다.

- 오차의 합 = sum(예측값 - 정답)^2
- MSE : Mean Squared Error, 평균제곱오차 = (오차의 합) / n
- RMSE : Root Mean Squared Error, 평균 제곱근 오차 = root(편균제곱오차)

#### 경사 하강법
- 대표적인 '최적화 알고리즘'으로, 비용 함수를 최소화하기 위해 반복해서 파라미터를 조정해나가는 방식이다.
- `y = a*x` 방정식에서 x = [1,2,3] y = [1,2,3] 이라고 한다면 a값은 1이다.
이때 MSE 오차식과 x에 대해 그래프를 그리면 2차원 그래프가 나오게 된다. 이때 기울기가 0인 부분, 즉 꼭짓점의 x 값이 정답이 된다.
- 이러한 특성을 이용하여 다음과 같이 정답을 찾는 recursive한 전략을 취할 수 있다.  
  1) 임의의 값 x1에서 미분을 구한다.  
  2) 구해진 기울기의 반대 방향으로 이동하여 그래프와 겹쳐지는 부분의 x좌표를 x2라 한다.  
  3) 1~2 과정을 반복하면 점차 기울기가 줄어들고, 이를 충분히 수행하면 정답값에 수렴한다.  

- 하지만 오차 그래프의 폭이 좁은 경우, 위 방식을 수행하면 특정 값으로 수렴하지 않고 결과값이 발산한다.
- 이를 막기 위해 기울기를 100% 취하지 않고, '학습률' 이라는 상수를 곱해 일정 양만큼만 전략에 반영될 수 있게 한다.
- 학습률은 정해진 값이 아니고, 데이터에 따라 적합한 값이 달라지는 상수이다.
- 위 전략을 수정하여 다시 적용하면
 1) 임의의 값 x1에서 미분을 구하고, 학습률을 적용하여 값을 조정한다.   
 2) 구해진 값을 기울기로하여 이동할 때 그래프와 겹쳐지는 부분의 x좌표를 x2라 한다.  
 3) 1~2 과정을 반복하면 점차 기울기가 줄어들고, 이를 충분히 수행하면 정답값에 수렴한다.  

```
learning_rate = 0.1
with tf.GradleTape() as tape:
  hypothesis = W * x_data
  cost = tf.reduce_mean(tf.square)
```
---

### 로지스틱 회귀
- 선형회귀와 함께 대표적인 딥러닝 알고리즘이다.
- 독립변수의 선형 결합을 이용하여 사건 발생의 가능성을 예측하는데 사용되는 '통계 기법' 이다. (확률 계산)
- 로지스틱 회귀는 종속변수와 독립변수 간의 관계를 함수로 나타내어 향후 예측모델에서 사용하므로, 독립변수의 선형 결합으 종속변수를 설명한다는 관점에서 선형 회귀분석과 유사하다.
- 하지만, 로지스틱 회귀는 데이터의 결과가 특정 분류로 나뉘어 지기 때문에 classification 기법으로 볼 수 있다.

- 이진 분류 문제, 즉 0과 1 중 하나를 판별하는 문제는 로지스틱 회귀를 이용하여 풀 수 있다.
- step function 혹은 sigmoid를 사용하는데, 보통 0과 1 사이의 확률값을 표현할 수 있는 sigmoid를 사용한다.

#### 시그모이드
- 시그모이드 방정식은 아래와 같다.  
`y = 1 / (1 + e <sup>-x</sup>)`
- e는 자연상수이며, 자연상수를 사용하였기 때문에 확률값으로 사용 가능하다.
- sigmoid 함수에 선형 회귀 함수를 대입하면 아래와 같이 된다.  
`y = 1 / (1 + e <sup>(-wx+b)</sup>)`
- 이 함수에 경사하강법을 이용하여 w와 b를 찾아낼 수 있다.

- w값이 증가하면 sigmoid 함수는 step function에 유사하게 경사가 가팔라 진다.
- b값이 증가하면 그래프가 우측 방향으로 이동한다.


#### 오차함수
- 로지스틱 회귀는 target이 0 또는 1 두가지라는 점에서 선형 회귀와 다르다.
- 때문에 로지스틱 회귀는 오차함수도 두가지가 있다.
  - 정답이 0일 경우 -log(l-h) 그래프 형태이다.
  - 정답이 1일 경우 -log(h) 그래프 형태이다.
- 정답값 0 혹은 1을 대입하면 원하는 오차함수가 나오는 식을 binary cross entropy 라 하고, 그 식은 다음과 같다.   
 `Y = -(Y * LOG(H) + (1-Y)*LOG(1-H))`

- 로지스틱 회귀법을 tensorflow 함수로 구현하면 아래와 같다.

```
# 6 by 2 형태의 x 데이터 학습값
x_train = np.array([[1., 1.],
                   [1., 2.],
                   [2., 1.],
                   [3., 2.],
                   [3., 3.],
                   [2., 3.]],
                   dtype=np.float32)
# 6 by 1 형태의 y 데이터 학습값
y_train = np.array([[0.],
                   [0.],
                   [0.],
                   [1.],
                   [1.],
                   [1.]],
                   dtype=np.float32)

# 이 학습값을 이용해 W와 b를 찾아본다.


# 랜덤값을 위한 설정
tf.random.set_seed(12345)
# W와 b의 초기값을 랜덤하게 설정, x값이 [6, 2] 이므로 W 형태를 [2, 1] 로 해야 y 값인 [6, 1] 에 맞게 matmul이 가능하다.
W = tf.Variable(tf.random.normal([2, 1], mean=0.0))
b = tf.Variable(tf.random.normal([1], mean=0.0))

print('weights: \n', W.numpy(), '\n\nbias: \n', b.numpy())

# x값을 sigmoid 함수에 대입하여 y값을 반환하는 함수
# x값의 shape가 [,2] 형태이므로 z = -(w1*x1 + w2*x2 + b) 가 된다.
def predict(X):
    z = tf.matmul(X, W) + b
    hypothesis = 1 / (1 + tf.exp(-z))
    return hypothesis

# 반복 학습
for i in range(2001):
    with tf.GradientTape() as tape:
        hypothesis = predict(x_train)
        # cost : binary cross entropy 식으로 loss 값을 계산
        cost = tf.reduce_mean(-tf.reduce_sum(y_train*tf.math.log(hypothesis) + (1-y_train)*tf.math.log(1-hypothesis)))

        # w와 b로 편미분하여 오차값 계산
        W_grad, b_grad = tape.gradient(cost, [W, b])

        # 오차값에 learning rate를 적용한 결과값으로 w와 b를 재설정
        W.assign_sub(learning_rate * W_grad)
        b.assign_sub(learning_rate * b_grad)

# 계산된 w,b를 사용하여 x, y에 대해 정상적으로 예측값이 나오는지 확인
def acc(hypo, label):
    # 0.5 이상이면 0, 이하이면 1의 확률이 더 높으므로, 0.5를 기준으로 0 또는 1로 치환해 준다.
    predicted = tf.cast(hypo > 0.5, dtype=tf.float32)
    # 정확도 = 계산값과 정답을 비교하여 맞으면 1점, 틀리면 0점으로 판단한 후 전체 점수를 평균 낸 값
    accuracy = tf.reduce_mean(tf.cast(tf.equal(predicted, label), dtype=tf.float32))
    return accuracy

# 결과 계산
accuracy = acc(predict(x_train), y_train).numpy()
```

### 퍼셉트론
- 퍼셉트론은 뉴럴 네트워크의 기본이 되는 개념으로, 인간의 신경망을 본따 프랑크 로젠블라트가 1957년에 고안한 알고리즘이다.
- 인간의 신경망은 외부 자극을 입력으로 받아 뉴런을 타고 신호가 전달된다. 뉴런과 뉴런 사이의 시냅스에서 신호를 전달하려면 역치값을 넘겨야 신호가 전달된다.
- 퍼셉트론은 입력을 받아 가중합(w1*x1 + w2+x2 + ... + wi*xi+ b)을 취하고, 활성화 함수(sigmoid)를 거쳐 출력값을 생성한다.

#### 다층 퍼셉트론
- 한 개의 퍼셉트론은 여러 문제를 해결할수 있다.
  - 좌표 평면에서 선 하나로 그룹을 구분지을 수 있는 경우에 해당한다.
  - 대표적인 모델로는 AND모델, OR 모델이 있다.
- 하지만 단일 퍼셉트론으로 풀지 못하는 문제도 존재한다.
  - XOR 모델이 대표적이다. 선 하나를 그어서 그룹을 분류할 수 없다.

- XOR 모델은 OR 퍼셉트론과 NAND 퍼셉트론을 1차적으로 수행하고, 두 수행에 대한 결과를 AND 연산하면 구할 수 있다. 이를 그래프로 표현하면 아래와 같다.

```
0층     1층     2층
x1   →   s1  ↘  
   ↘ ↗         y
   ↗ ↘         
x2   →   s2  ↗  
```
- 다중 퍼셉트론은 여러 layer를 두고 연산을 한다는 의미이며, layer가 증가하면 더 많이 분석된다는 뜻.
- 0층(가장 처음)은 input layer, 2층(가장 마지막)은 output layer, 그 사이의 layer는 hidden layer라 칭한다.
- hidden layer를 많이 만들면 대체로 데이터를 많이 분석하여 더 좋은 결과를 낼 수 있다고 할 수 있다.





## 모델
- 딥 러닝을 위한 신경망 구조를 모델이라 한다

### 생성 방법
1. tensorflow.keras.Sequential : Sequential 함수를 이용하는 방법
2. functional approach : 직접 함수를 구성하는 방법
3. tensorflow.keras.Model : Model 클래스를 상속하고 재정의하여 사용하는 방법
