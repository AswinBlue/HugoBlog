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
1. numpy
 - `data = np.loadtxt(FILE_NAME, delimiter=',')` : ,를 기준으로 데이터를 나누는 csv 파일을 읽어들임. 숫자 데이터를 읽을 때 사용
1. keras (tensorflow 설치시 자동성치된다)
`y_encoded = to_categorical(y_data)` : y_data 를 one-hot-encoding 하는 함수  (tensorflow.keras.utils.to_categorical)
1. pandas
 - `df = pd.read_csv(FILE_NAME)` : csv 파일을 읽어서 dataframe을 구성한다. 숫자 및 문자열 데이터를 읽을 때 사용 가능
1. sklearn
- 데이터 전처리
```
e = sklearn.preprocessing.LabelEncoder()
e.fit(data)  # data 에 들어있는 값 중 unique한 값을 뽑아(중복 제거) 특정 string에 번호를 매기는(indexing) 함수
data = e.transform(data)  # indexing 된 정보를 바탕으로 실제 data값을 index로 치환
```

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

- 오차의 합 = ∑ (예측값 - 정답)²
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

---

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

### 오차 역전파
- 은닉층에 있는 각각의 w와 b를 구하는 방법이다.
- 다층 퍼셉트론을 구성하면 각 layer마다 w와 b값이 구성되는데, 이때 오차를 구하기 위해 미분값을 구하는 것이 쉽지 않다.
  - 미분 안에 연결된 식이 많기 때문
  - layer의 개수는 변동될 수 있기 때문에 계산이 복잡하다

- 이 문제를 해결하기 위해 1980년도 오차 역전파 알고리즘이 발명된다. 이전에도 w와 b를 구할수는 있었지만, 구하는 방법에 대해 규칙성을 찾지는 못했다.

#### 오차 역전파 개요
- 최적화의 계산 방향이 output layer 에서 input layer 방향으로 진행된다. 이 떄문에 이 알고리즘을 back propagation 이라 부른다.
- 퍼셉트론에서 w와 b값을 찾기 위해 오차가 작아지는 방향으로(기울기가 0이 되는 방향으로) 업데이트 해 나갔는데, 다층 퍼셉트론에서는 다음 식으로 가중치를 변화시켜 나간다.
  - `W(t+1) = W * t - (∂오차) / (∂w)`: 새 가중치는 현 가중치에서 가중치에 대한 기울기를 뺀 값

#### 출력층 오차
- 다층 퍼셉트론의 각 노드는 (1)입력값을 이용해 가중합을 만들고, (2) 가중합을 활성화 함수를 적용해 출력하는 두 단계를 수행한다.
- 3개 layer를 가지는 형태를 표현하면 아래와 같다.
  - yh1, yh2 : hidden layer의 출력값
  - y_out1, y_out2 : output layer의 출력값, 예측값
```
0층               1층                                       2층
x1 (w11)→ [가중합1 -> 활성화함수1]  →    yh1 (w31)→ [가중합3 -> 활성화함수3]  → y_out1
 (w21)↘  ↗                              (w41)↘  ↗
 (w12)↗  ↘                              (w32)↗  ↘
x2 (w22)→ [가중합2 -> 활성화함수2]  →    yh2 (w42) → [가중합4 -> 활성화함수4]  → y_out2
```

- 오차 역전파는 y_out 값에서 반대로 진행하여 가중치 w를 업데이트 한다.
- `w31(t+1) = w31 * t - (∂오차 y_out)/(∂w31)` : 현재 weight에 미분값을 빼주면 다음 weight가 된다.
- 오차 y_out 안에는 여러개의 출력값이 존재할 수 있다. (output layer의 node 개수만큼)
- y_out 안의 각각의 예측값에 대한 오차는 MSE를 이용해 구한다.
  - output layer의 node가 n개라고 하면, k번째 오차는 다음과 같다. `오차_y_out_k = (y_target_k - y_out_k)² / n`

- 오차 역전파로, y_out1 값의 오차로 w31을 업데이트 해 보자.
1) 오차의 값은 `∂오차y_out / ∂w31` 이다.  
2) chain rule에 의해 `∂오차y_out / ∂w31 = (∂오차y_out / ∂y_out1) * (∂y_out1 / ∂가중합3) * (∂가중합3 / ∂w31)` 가 성립한다. 이 식의 우항을 각각 나누어 계산하여 보자.
2-1) `(∂오차y_out / ∂y_out1)`을 y_out1에 의해 편미분을 하면 y_out1과 관계없는 y_out2는 상수가 되어 사라진다. `y_out = y_out1 + y_out2 = (y_target1 - y_out1)² / 2 + (y_target2 - y_out2)² / 2` 이기때문에 최종 식은 `(∂오차y_out / ∂y_out1) = 1/2 * ∂(y_target1 - y_out1)² / ∂y_out1 = y_out1 - y_target1` 가 된다.
2-2) `(∂y_out1 / ∂가중합3)` 은 '활성화함수3'을 미분 해 주는것과 같다.  
  우리는 활성함수로 시그모이드를 사용했고, 시그모이드의 미분은 `∂σ(x) / ∂x = σ(x) * (1 - σ(x))` 이다.  
  따라서 `∂y_out1 / ∂가중합3 = y_out1 * (1 - y_out1)` 이 된다.
2-3) `가중합3 = w31 * yh1 + w41 * yh2 + 1(bias)` 형태인데, `(∂가중합3 / ∂w31)` 식에 첫 식을 대입하면 `(∂가중합3 / ∂w31 = yh1` 이 된다.  

3) (2)에서 구한 세 식을 합하면 `(y_out1 - y_target1) * (y_out1 * (1 - y_out1)) * (yh1)` 형태이다. 이때,  
  `y_out1 - y_target1` 은 출력값, `y_out1 * (1 - y_out1)` 은 활성화함수의 미분 값이다. 이를 활용하여 델타 식으로 표현하면  
  `w31(t + 1) = w31 * t - δ * y * yh1` 이 된다. (`δ * y = (y_out1 - y_target1) * (y_out1 * (1 - y_out1))`)

  #### 은닉층 오차
  - 위에서 w31을 구했고, 이제 w11을 구해보자
  - w31은 y_out1에만 영향을 주고, y_out2에는 영향을 주지 않았다. 하지만 w11은 y_out1과 y_out2에 모두 영향을 주어서 식의 복잡도가 높다.
  - 점화식을 표현하면 `w11(t+1) = w11 * t - (∂오차 y_out) / ∂w11` 가 된다.
    1) `(∂오차 y_out) / ∂w11 = (∂오차 y_out) / ∂yh1 * (∂yh1/∂가중합1) * (∂가중합1/∂w11)` 형태로 chain rule을 사용할 수 있다.  
    2) `(∂yh1/∂가중합1)` 은 activation 함수의 미분값이므로, `(∂yh1/∂가중합1) = yh1(1 - yh1)` 이 된다.
    3) 가중합을 w에 의해 미분하면 입력값이 된다. 따라서 `(∂가중합1/∂w11) = x1`  
    4) `(∂오차 y_out) / ∂yh1 = ∂(오차y_out1 + 오차y_out2)/∂yh1 = ∂오차y_out1/∂yh1 + ∂오차y_out2/∂yh1`  
    5-1) 4 식을 나눠서 계산해보자. 먼저  `∂오차y_out1/∂yh1 = ∂오차y_out1 / ∂가중합3 * ∂가중합3 / ∂yh1'  
    5-1-1) 이때 `∂가중합3 / ∂yh1 = ∂(w31 * yh1 + w32 * yh2)/∂yh1 = w31`  
    5-1-2) `∂오차y_out1 / ∂가중합 = (∂오차y_out1 / ∂y_out1) * (∂y_out1 / ∂가중합3) = ( y_out1 - y_target1) * w31  * (1-y_out1) * y_out1` (`∂오차y_out1 / ∂y_out1` 는 오차를 의미하고, `∂y_out1 / ∂가중합3` 는 활성함수의 미분값을 의미하기 때문)  
    5-1-3) 최종적으로 `∂오차y_out1 / ∂yh1 = (y_out1 - y_target1) * w31 * (1 - y_out1) * y_out1 = δy_out1 * w31` 형태로 델타식을 만들 수 있다.  
    5-2)  다음 `∂오차y_out2/∂yh1`도 5-1 에서 사용한 방식으로 계산하면 `∂오차y_out2/∂yh1 = δy_out2 * w41` 형태가 된다.  
    5-3) 위 값들로 4 에서 봤던 식을 구성하면  `(∂오차 y_out) / ∂yh1 = δy_out1 * w31 + δy_out2 * w41` 이 된다.  
    6) 2, 3, 5-3 에서 나온 값으로 1식을 재구성해보면 `(∂오차 y_out) / ∂w11 = (δy_out1 * w31 + δy_out2 * w41) * yh1(1 - yh1) * x1` 이다.

  - 출력층의 오차 업데이트 : `(y_out1 - y_target1) * y_out1 * (1 - y_out1) * yh1`
    - `(y_out1 - y_target1)` : 오차
  - 은닉층의 오차 업데이트 : `(y_out1 * w31 + y_out2 * w41) * yh1 * (1-yh1) * x1`
    - `(y_out1 * w31 + y_out2 * w41)` : hidden layer를 통해 출력값을 미분한 값
  - '출력층의 오차 업데이트'와 '은닉층의 오차 업데이트'는 공통적으로 `y_out(1 - y_out) * x` 의 형태(sigmoid function 미분 * 입력값)를 지니고 있다.

  - 은닉층의 가중치 업데이트를 델타식으로 표현하면  `w11(t+1) = w11 * t - δh * x1` 이다.
  - 델타식으로 표현하면 generic 한 형태로 식을 가져갈 수 있어 꼭 필요하다.

---

### 그래디언트 소실(gradient vanishing)
- 다층 퍼셉트론을 사용할 때, 층이 많을 수록 데이터 분석 능력이 높아지지만, 실제로는 분석 증가량이 미미하다. 이는 활성화 함수 때문이다.  
  - 가중치를 수정할 때, 오차 값을 미분한 값을 사용하였다.
  - 각 층의 activation function 으로 sigmoid를 사용했는데, sigmoid 함수는 미분시 최대치가 0.3 밖에 되지 않는다.
  - 층을 지날수록 activation function을 여러번 거치는데, sigmoid의 미분값을 여러번 거치게 되면 미분값이 중간에 0이 되어버리는 현상(vanishing gradient) 문제가 발생한다.
  - 층을 거쳐 갈수록 기울기가 사라져 가중치를 수정할 값이 소실되어 뒤쪽 layer는 더이상 학습이 되어지지 않는다.
- 그래디언트 소실 문제를 해결하기 위해 sigmoid를 대체할 다른 활성화함수들이 만들어 졌다.
  - 하이퍼볼릭 탄젠트 : 미분 최대값 1, 소실문제를 약화시킬 순 있지만 해결되진 않는다.
  - 렐루 : 0미만은 미분값 0, 0이상은 미분값 1. 많은 층을 사용할 때는 relu를 많이 사용한다.
  - 소프트플러스

#### xavier와  he 초기화
- 초기 w와 b 할당시 표준편차가 1이고, 평균이 0인 정규분포를 사용하였다.
- 이렇게 되면 node를 통과한 결과값이 0과 1에 치중되어 있는 형태를 볼 수 있다.
- 표준편차를 0.01을 주면 결과값이 0.5로 치중되게 된다. 이렇게 되면 layer를 몇개를 쓰던 layer가 하나인 경우와 동일한 효과가 나온다. 이를 표현력의 제한이라 한다.
- 이러한 문제점을 xavier 방법을 사용하면 해결할수 있다.
  - 가중치 초기화를 설정하는 방법으로, 결과값의 분포를 더 광범위하게 설정할 수 있게 하는 방법이다.
  - `√(2/n_in + n_out)` 형태로 최초 사용하는 분포를 만들게 되면 더 광범위한 형태로 만들 수 있다. (n_in : layer의 입력node 개수, n_out : layer의 출력node 개수)
  - 우리는 입력,출력 값이 같은 hidden layer를 사용하므로 `√(1/n)` 형태를 가진다.
- 단, xavier 방식은 좌우 대칭인 activation function 에서는 효과적이지만, relu와 같은 좌우 비대칭 형태의 activation function에서는 한쪽으로 치우친 결과값이 얻어진다.
- 이때는 '카밍 히'의 이름을 따서 he 초기값을 사용한다.
  - `√2/n` 의 정규분포 값을 사용한다. (분포 범위를 더 넓게 잡는다)

---

### 고속 옵티마이저
- 옵티마이저란 경사하강법을 뜻한다. 고속 옵티마이저란 경사 하강법을 더 효율적으로 하는 방법이다.
- 경사 하강법은 대체로 학습 속도와 정확도 문제를 갖고 있다. (learning rate 혹은 data에 의해 발생)
  - 경사 하강법은 업데이트 시마다 전체 데이터에 대해 미분을 계산하여야 하여 속도가 매우 느리다.
  - 학습률이 너무 크면 더이상 최적값으로 수렴하지 못하는 경우가 있다.
- 경사 하강법은 구현하기 쉽고 단순하다는 장점이 이 있지만, 비등방성 함수에서는 탐색 경로가 비효율적이다. (ex: `f(x,y) = 1/20x^2 + y^2` 와 같은 타원형 형태)
  - y축은 가파르지만, x축 변동은 거의 없다. 최적값은 (0,0) 이지만 미분으로 기울기 값을 구하면 (0,0) 이 아닌 다른 방향을 가리킬 확률이 매우 높다.
  - 정상적으로 도달하더라도 지그재그 형태로 비효율적인 방식으로 이동하게 된다.
- 경사 하강법은 무작정 기울어진 방향으로 진행하기 때문에 간단하지만 위와같은 문제점을 야기한다.
- 경사 하강법의 문제점을 개선해 주는 모델들로는 '모멘텀', 'adagrad', 'adam' 등이 있다.

#### 모멘텀
- 모멘텀 알고리즘은 물리 현상의 운동량에 착안하여 만들어 졌다.
- 이전 회차의 미분값 중 일정 비율을 반영하여 현재 weight 값 설정에 영향을 주도록 하여 더 빠르게 최적점을 찾을 수 있도록 하는 방식이다.
  - 기존에는 현재 미분값 * 학습률을 현재 w에 빼주었지만, 모멘텀에서는 (일정 비율) * (이전 미분값) - (학습률) * (현재 미분값) 을 현재 w에 더해준다.
  - 이 값은 `V(t) = γ*v(t-1) - η*∂오차/∂w(t)` 로 표현한다.
  - 즉, `W(t+1) = W(t) + V(t)` 와 같은 식이 된다.
  - 이전의 미분값을 일부 적용함으로써 현재 미분값을 상충하는 효과를 얻을 수 있다. 이를 통해 학습 속도를 높일 수 있다.

#### 네스테로프 모멘텀
- 네스테로프 모멘텀에서는 w를 업데이트 할 때 `γ*v(t-1) - η*∂오차/∂w(t)` 값 대신 `γ*v(t-1) - η*∂오차/∂(w(t) + γ*v(t-1))` 를 사용한다.
- 모멘텀 방법으로 이동될 방향을 미리 예측하여 해당 방향으로 한단계 미리 이동한 그래디언트 값을 사용함으로써 불필요한 이동을 줄일 수 있다. 속도는 그대로이지만 단계를 절약할 수 있다.

#### 아다그리드
- 학습률을 조절하여 효율을 높인 모멘텀이다.
- 아다그라드는 weight값이 업데이트 될 때 마다 점점 최적점을 찾아간다고 가정하고, 학습을 시킬때 마다 일정량의 learning rate를 떨어뜨린다.
- 학습률을 변화시키기 위해 G(t)값을 `G(t) = G(t-1) + [∂오차/∂w(t)]^2` 형태로 가져가며, 최종적으로 `W(t+1) = W(t) + η * (1/√G(t) + ε) * ∂오차/∂w(t)` 형태가 된다. (ε 는 0이 되는것을 방지하기 위해 더해주는 아주 작은 상수값)

#### RMSprop
- 아다그라드에서 G(t)는 무한히 커지게 되는 문제점이 있다.
- 이를 해결하기 위해 `G(t) = γ * G(t-1) + (1-γ) * [∂오차/∂w(t)]^2` 형태를 취한다.
- 'γ' 값을 이용해 G(t) 값을 조절할 수 있도록 하였다.

#### Adam
- RMSprop의 정확도, 모멘텀 방식의 속도 장점을 모두 취하는 방식이다.
- RMSprop의 G(t) 값과 모멘텀의 V(t) 값을 유사하게 구하여 사용한다.
  - `V(t) = γ_1 * G(t) + (1 - γ_1) * ∂오차/∂w(t)`
  - `G(t) = γ_2 * G(t) + (1 - γ_2) * [∂오차/∂w(t)]^2`
- V(t)와 G(t) 값을 조절하여 V'(t), G'(t) 를 만들어 W(t+1) 을 구한다.
  - `V'(t) = V(t) / (1-r_1^t)`
  - `G'(t) = G(t) / (1-r_2^t)`
  - `W(t+1) = W(t) - η * (G'(t) / √(V'(t) + ε))`

- 이때까지 내용을 모두 분석해 보면 전반적으로 adam 옵티마이저가 좋은 성능을 내기는 한다.
- 하지만 항상 adam이 최적의 효율을 내지는 않는다. 이는 데이터 형태가 다르기 때문이다.
- 데이터 형태에 따라 취해지는 패턴과 오차 그래프의 모양이 다르기 때문이다.
- gradient descent, momentum, adagrid, adam, RMSprop 중 어느것이 효과가 좋은지 확인이 필요하다.

---

### 다중 분류
- 입력값을 기준으로 단순 0 또는 1을 판단하는게 아니라, 여러 class 중 하나로 분류하는 모델을 알아보자  
- 출력 node 개수를 분류되는 항목 개수로 설정한다.
- 활성화 함수를 적용하려면 Y값이 0과 1로 이루어져 있어야 한다. (100% 혹은 0%)
  - 출력 node가 하나라면 Y값은 0 또는 1이면 되지만, 2개 이상이라면 배열이 되어야 한다.
  - 1 => [1,0,0], 2 => [0,1,0], 3 => [0,0,1] 형태로 변형해서 사용해야 한다.  
  - 이렇게 Y값을 0 또는 1로만 이루어진 형태로 바꾸어주는 기법을 one-hot-encoding 이라 한다.
  - 텐서플로에서 `one_hot()` 함수를 지원한다.

#### softMax
- classification 문제를 풀 때 점수 벡터를 클래스 별 확률로 변환하기 위해 사용하는 함수이다.
- 각 점수 벡터에 지수를 취한 후 정규화 상수로 나누어 총합이 1이 되도록 계산한다.  
  - exponential을 취하는 이유는 값이 클 수록 훨씬 더 높은 점수를 갖게 하기 위함이다.
  - `y_k = exp(a_k) / ∑<i=1,n> exp(a_i)`
- softMax는 exponential을 사용하기 때문에 큰 값의 나눗셈을 수행해야 하여 overflow가 발생하기 쉽다.
- 수식을 개선하여 다음과 같이 사용한다. (keras에서도 개선된 수식을 사용함)  
```
y_k = exp(a_k) / ∑<i=1,n> exp(a_i)
    = C * exp(a_k) / C * ∑<i=1,n> exp(a_i)
    = exp(a_k + log C) / ∑<i=1,n> exp(a_i + log C)
    = exp(a_k + C') / ∑<i=1,n> exp(a_i + C')
```

#### Cross Entropy
- softmax 에서 사용하는 오차방정식
- cross entrpoy는 서로 다른 두 값의 확률 차이를 나타낼 수 있다.
- `E = - ∑<k> t_k * log y_k` 형태를 가진다.
  - ex) 정답이 [0, 1] 이고, 결과가 [1, 0] 인 경우, `E = 0 * log1 + 1 * log0 = ∞`
  - ex) 정답이 [0, 1] 이고, 결과가 [0, 1] 인 경우, `E = 1 * log1 + 0 * log0 = 0`

---

### 오버피팅
- 훈련 데이터에 지나치게 적응하여 훈련 그 외의 데이터에 대해서는 제대로 평가를 하지 못하는 경우를 일컫는다.
- 학습 데이터를 통해 경향성만 추출해 내는 것이 가장 바람직한 학습 목표이다.
- 오버피팅은 모든 데이터를 모으지 못하면 발생할 수 있다. (훈련 데이터가 적을 때)  
  - 한쪽으로 편향된 데이터를 학습에 사용하거나, 노이즈를 일으키는 데이터를 사용한 경우에 발생할 수 있다.
- 은닉층이 너무 많거나 각 층의 노드 수가 많아 변수가 복잡해지면 발생할 수 있다.
- 테스트 셋과 학습 셋이 중복될 때 생기기도 한다.


#### 데이터 처리 방법
- 오버피팅을 줄이기 위해서 데이터를 조작하는 방법을 사용할 수 있다.

1. 학습 데이터셋과 테스트 데이터셋을 구분해서 사용한다.
- 학습 : 테스트 를 7:3 또는 8:2 정도로 사용하는 것이 일반적이다.

1. 학습 데이터를 '학습' 데이터와 '검증' 데이터로 나눈다.
- 학습 데이터를 이용하여 모델을 학습시킨다.
- 학습을 시키면서 중간중간 검증 데이터를 이용하여 학습된 모델을 검증한다.
- 데이터를 학습시킬수록 '학습' 데이터에 대한 오차는 점점 줄어들지만, '검증' 데이터에 대한 오차는 일정 구간이 되면 증가하게 된다.
- '검증' 데이터 오차가 증가하는 시점이 over-fitting이 시작되는 구간이므로 학습을 중단한다.
- '검증' 데이터는 학습에 사용되지 않고, 검증에만 사용됨에 주의한다.

1. Dropout 규제 방법
- 제프리 힌튼이 2012년에 제안한 방법
- 매 훈련 step에서 일정 node를 훈련에서 무시하는 방법이다.
ex) node = {n1, n2, n3, n4} 가 있다면, step 1에서는 n1, n2만 있는 것 처럼 동작하고, step 2에서는 n3, n4만 있는 것 처럼 동작하고 ...

1. 데이터를 증식한다.
- 관련 데이터를 모두 수집하는것이 최선이지만, 현실적으로 불가능하다.
- 대신 데이터를 증식하는 방법을 사용한다. 데이터 증식이란, 실제와 같은 훈련 데이터를 생성한다.
  - 데이터 증식은 인공적으로 만든 샘플과 실제 데이터를 구분할 수 없어야 한다.
  - 백색소음(white noise)를 추가하는 것은 도움이 되지 않는다. 의미있는 학습 데이터가 필요하다.
- 데이터 증식은 이미지 데이터를 처리할 때 매우 유용하다. 이미지는 확대, 축소, 이동, 회전, 반전 등을 통해 하나의 이미지로 여러 데이터를 만들 수 있다.


#### K겹 교차 검증의 이해
- 데이터 셋을 학습용과 테스트용으로 나누었을 경우, 테스트에 사용되는 데이터는 극히 일부밖에 되지 않는다
- 데이터 셋을 k등분 하여, 테스트 셋과 학습 셋을 돌려가며 사용하는 방법을 k겹 교차검증이라 한다.
  - 전체 데이터를 5개로 나누었다 가정하고, 나눈 데이터의 덩어리를 각각 d1, d2, d3, d4, d5라 하자
  - 이때 d1을 테스트 데이터로 사용, 나머지를 훈련 데이터로 사용한 경우 결과를 R1이라 하자
  - d2를 테스트 데이터로 사용, 나머지를 훈련 데이터를 사용한 경우 결과를 R2라 하자
  - d3, d4, d5도 마찬가지로 하여 R3, R4, R5를 도출해 낸다.
  - R1~R5를 모두 합치면 최종 결과가 나온다.
  - 데이터를 5등분 했으므로, 위 방법은 5겹 교차검증이 된다.  

```
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import StratifiedKFold

import numpy
import pandas as pd
import tensorflow as tf

numpy.random.seed(777)
tf.random.set_seed(777)

df = pd.read_csv('sonar.csv', header=None)

dataset = df.values
x_data = dataset[:,0:60].astype(float)
y_data = dataset[:,60]

# y_data를 one-hot 으로 처리해 준다.

e = LabelEncoder()
e.fit(y_data)
y_data = e.transform(y_data)

# k-fold 알고리즘을 사용할 객체를 형성한다.
# n_splits : 10등분하여 사용할 것이다.
# shuffle : 섞어서 사용할 수 있도록 허용
# random_state : shuffle 사용시 사용할 랜덤한 seed 값

n_fold = 10
skf = StratifiedKFold(n_splits=n_fold, shuffle=True, random_state=48)

accuracy = []

# skf.split() 함수를 통해 x_data와 y_data를 k-fold 알고리즘에 맞게 분해하여 반환한다.
# for문을 통해 데이터를 반복하여 학습을 수행한다.
for train, test in skf.split(x_data, y_data):
    # 모델을 구성한다.
    # 활성함수로 sigmoid, 오차함수로 binary-binary_crossentropy를 사용할 것이다.
    model = Sequential()
    model.add(Dense(30, input_dim=60, activation='relu'))
    model.add(Dense(10, activation='relu'))
    model.add(Dense(1, activation='sigmoid'))
    model.compile(loss='binary_crossentropy',
                  optimizer='adam',
                  metrics=['accuracy'])
    model.fit(x_data[train], y_data[train], epochs=100, batch_size=5)
    k_accuracy = "%.3f" % (model.evaluate(x_data[test], y_data[test])[1])
    accuracy.append(k_accuracy)

print("\n %.f fold accuracy:" % n_fold, accuracy)
# 결과값은 데이터에 따라 달라질 수 있다. 학습에 사용된 데이터가 편향되어 있는 경우 평가 결과가 떨어지는 모습을 볼 수 있다.
# k-fold 알고리즘을 사용하면 이러한 경우를 예방할 수 있다.
```



## 모델
- 딥 러닝을 위한 신경망 구조를 모델이라 한다

### 모델 정의 방법과 최적화
- x 데이터는 attribute, y 데이터는 class라 칭한다.

1. 입력층, 은닉층, 출력층 구성
- 아래 내용들은 일반적인 경우에 해당하는 경우이므로, 실제 모델 정의시에는 직접 확인해볼 필요가 있다.
1) 데이터에 맞게 입력층의 node 개수를 결정한다.  
2) 얕은 신경망보다 심층 신경망이 효율적인 파라미터를 구성한다. (하나씩 layer를 늘려가 본다.)  
3) 은닉층의 노드 개수를 입력 노드 개수보다 많이 편성한다. (무조건은 아니므로 확인 필요)  
4) 결정할 수 있는 데이터를 조금씩 줄여 깔때기 모양으로 은닉층을 설정하는게 좋다. (갈수록 node 개수를 줄여감)  
5) 첫 은닉층의 노드 개수는 과대적합(over fitting)이 시작되기 전까지 뉴런 수를 점진적으로 늘리는 것이 좋다.  
6) 은닉층이 많아질수록 ReLU 함수를 사용하는것이 좋다.(vanishing 현상 방지)  
7) 출력층의 활성화 함수를 결정하고, 출력층의 활성화 함수에 따라 오차함수도 결정한다.   
- 둘중 하나를 선택한다면 sigmoid 함수와 binary_crossentropy 를 사용한다.  

1. 다중분류 모델링
1) 데이터의 속성에 맞게 입력 node의 수 구성  
2) 문자열로 된 class 값을 indexing 하고, one-hot-encoding으로 값을 변형해준다.  
3) class의 개수에 맞게 출력층 node 개수를 설정한다.  
4) 활성화 함수 및 오차방정식으로 softMax와 categorical cross-entropy를 적용한다.  

### 생성 방법
1. tensorflow.keras.Sequential : Sequential 함수를 이용하는 방법
2. functional approach : 직접 함수를 구성하는 방법
3. tensorflow.keras.Model : Model 클래스를 상속하고 재정의하여 사용하는 방법

#### Keras.Sequential
- keras를 이용해서 sequential 모델을 생성하는 방법
- `model = Sequential()` : sequential 한 layer 형태를 가진 모델을 생성
- `model.add(Dense(units =2, activation='sigmoid', input_dim = 2))` : layer 추가
  - node 수가 2개
  - activation function이 sigmoid
  - 입력값이 2차원 형태
  - input 인자는 첫번 째 hidden layer에만 사용해 주면 된다.
- `model.compile(loss='binary_crossentropy', optimizer='sgd', metrics=['accuracy'])` : model 객체를 어떤 형태로 학습시킬지 정의
  - binary_crossentropy 를 loss function으로 설정
  - optimizer로 sdz 설정
  - 실행될 때 마다 loss 값과 accuracy 값을 출력으로 보여줌
- `model.fit(x_train, y_train, epochs=50000, batch_size = 10)` : model에 training 실행
  - x_train, y_train : 학습용 x, y 데이터  
  - epochs : 학습 데이터를 통해 반복 학습시킬 횟수  
  - batch_size : 입력 데이터를 몇 묶음 단위로 전달할지 설정, 하나씩 학습하는 것 보다 학습률 출렁임이 더 안정적이다.  
- `model.layers[0].get_weights()[0]` :
  - model.layers 는 입력 layer을 0번째 index로 하여 특정 layer를 반환  
  - get_weights() 는 해당 layer의 [weight, bias] 를 담고 있는 배열을 반환
- `model.predict(x_predict)` : 학습된 모델에 x_predict 값을 넣을 시 특정 y 값을 추정하여 반환하는 함수
- `model.evaluate(x_data, y_data)` : 학습된 모델에 입력값(x_data)과 정답(y_data) 를 전달받아 [loss, accuracy] 를 반환하는 함수
