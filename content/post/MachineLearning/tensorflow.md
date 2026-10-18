---
title: "TensorFlow 2.x 핵심 개념부터 CNN·RNN 딥러닝 모델 구현까지 총정리"
date: 2021-11-27T08:15:42+09:00
lastmod: 2021-11-27T08:15:42+09:00
description: "TensorFlow의 텐서 연산 기초부터 선형·로지스틱 회귀, 역전파 알고리즘, 경사 하강법 옵티마이저, 그리고 CNN과 RNN·LSTM 신경망 모델 설계까지 딥러닝 핵심 이론과 실습 코드를 완벽 정리합니다."
slug: "tensorflow-deep-learning-core-guide"
categories: ["MachineLearning"]
tags: ["tensorflow", "deep-learning", "machine-learning", "cnn", "rnn", "python"]
ShowToc: true
TocOpen: true
draft: false
---

# TensorFlow 딥러닝 완벽 가이드

TensorFlow는 구글에서 수치 연산과 머신러닝/딥러닝 연구 및 배포를 위해 개발한 오픈소스 라이브러리입니다.

## 기본 개념
- Node와 Edge로 구성된 Graph를 이용해 대규모 수치 연산을 수행합니다.
  - Node는 특정한 데이터가 입력되면 연산을 수행하거나, 형태를 변경하거나, 결과를 출력하는 연산 단위입니다.
  - Edge는 학습 데이터가 저장되는 다차원 배열(Tensor)이며, 연산 결과 데이터를 다음 Node로 방향성(Directed) 있게 전달합니다.
- [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml) 등에서 실습용 데이터셋을 내려받아 활용할 수 있습니다.

---

## 설치 및 개발 환경
1. Python 및 pip 설치
2. TensorFlow 설치:
   ```bash
   pip install tensorflow
   ```
   - Windows 환경에서 경로 길이 제한 문제로 파일 에러가 발생하는 경우, 레지스트리 편집기(`regedit`)에서 `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled` 값을 1로 설정합니다.

### 연관 모듈
- 함께 활용하면 생산성이 높아지는 핵심 라이브러리:
  1. `matplotlib`: 데이터 및 손실 그래프 시각화
  2. `numpy`: 수치 연산 및 배열 처리 (`np.loadtxt(FILE_NAME, delimiter=',')`)
  3. `keras`: 고수준 딥러닝 API (TensorFlow 2.x 내장, 원-핫 인코딩 `to_categorical` 등 지원)
  4. `pandas`: 데이터프레임 기반 입출력 (`pd.read_csv(FILE_NAME)`)
  5. `sklearn`: 데이터 전처리 및 인코딩
     ```python
     e = sklearn.preprocessing.LabelEncoder()
     e.fit(data)
     data = e.transform(data)
     ```

---

## 기본 문법 및 텐서 연산
1. 상수 선언:
   ```python
   val = tf.constant(value, dtype=None, shape=None, name='Const')
   ```
   - `dtype`: `tf.float32`, `tf.float64`, `tf.int32`, `tf.string`, `tf.bool` 등

2. 배열 생성:
   - `tf.range(5)` -> `[0, 1, 2, 3, 4]`
   - `tf.zeros([2, 3])` -> 2x3 영행렬
   - `tf.ones([2, 3])` -> 2x3 일행렬
   - `tf.fill([2, 3], 5)` -> 5로 채워진 2x3 행렬

3. 연산자:
   - 사칙 연산: `tf.add(x, y)`, `tf.subtract(x, y)`, `tf.multiply(x, y)`, `tf.divide(x, y)`
   - 비교 및 논리: `tf.equal(x, y)`, `tf.less(x, y)`, `tf.greater(x, y)`, `tf.logical_and(x, y)`
   - 축약 연산: `tf.reduce_sum(a, axis=0)`, `tf.reduce_mean(a, axis=1)`

4. 변수 선언 및 업데이트:
   - `var = tf.Variable(value, dtype=type)`
   - `var.assign(value)`: 새 값 대입
   - `var.assign_add(value)`: 덧셈 누적
   - `var.assign_sub(value)`: 뺄셈 누적
   - `tf.cast(var, dtype)`: 자료형 변환

5. 값 확인 및 난수:
   - `val.numpy()`: 텐서를 NumPy 배열로 변환
   - `tf.random.set_seed(1234)`: 난수 시드 고정
   - `tf.random.normal([2, 1], mean=0.0)`: 정규분포 난수 생성

---

## 심화 내용 및 핵심 수학

### 텐서플로와 행렬 연산
- `tf.matmul(a, b)`: 행렬의 곱(내적)
- `tf.linalg.inv(a)`: 역행렬 연산
- **브로드캐스팅 (Broadcasting)**: 형상(Shape)이 다른 행렬 간 연산 시, 차원이 맞지 않는 축을 자동으로 복제 확장하여 연산을 가능하게 하는 메커니즘입니다.

### 텐서플로 함수 (@tf.function)
- TensorFlow 2.x에서는 Eager Execution(즉시 실행)이 기본이지만, `@tf.function` 데코레이터를 적용하면 파이썬 함수를 AutoGraph를 통해 고속 C++ 연산 그래프로 변환하여 실행 속도를 극대화합니다.
  ```python
  @tf.function
  def t_func(a, b):
      return tf.matmul(a, b)
  ```

### 자동 미분 (tf.GradientTape)
- 역전파 및 최적화에서 기울기(Gradient) 계산에 사용됩니다.
  ```python
  x1 = tf.Variable(tf.constant(1.0))
  x2 = tf.Variable(tf.constant(2.0))
  with tf.GradientTape() as tape:
      y = tf.multiply(x1, x2)
  gradients = tape.gradient(y, [x1, x2])
  # x1에 대한 미분값: 2.0, x2에 대한 미분값: 1.0
  ```

### 선형 회귀 (Linear Regression)
- **선형 회귀 정의**: 종속변수 $y$와 독립변수 $x$ 간의 선형 상관관계를 모델링하는 회귀분석 기법입니다 ($y = Wx + b$, $W$: 가중치, $b$: 편향).
- **오차방정식**: 실제값과 예측값의 차이를 측정합니다.
  - MSE (Mean Squared Error, 평균 제곱 오차): $\frac{1}{n}\sum (y_{pred} - y_{true})^2$
- **경사 하강법 (Gradient Descent)**: 비용 함수(Cost Function)의 미분 기울기를 계산하고, 학습률(Learning Rate, $\eta$)을 곱해 손실이 최소화되는 방향으로 가중치를 점진적으로 갱신합니다.
  ```python
  learning_rate = 0.1
  with tf.GradientTape() as tape:
      hypothesis = W * x_data + b
      cost = tf.reduce_mean(tf.square(hypothesis - y_data))
  W_grad, b_grad = tape.gradient(cost, [W, b])
  W.assign_sub(learning_rate * W_grad)
  b.assign_sub(learning_rate * b_grad)
  ```

### 로지스틱 회귀 (Logistic Regression)
- 독립변수의 선형 결합을 통해 0과 1 사이의 사건 발생 확률을 예측하는 분류(Classification) 기법입니다.
- **시그모이드 함수**: 출력값을 $(0, 1)$ 범위로 압축하는 비선형 활성화 함수입니다:
  $$y = \frac{1}{1 + e^{-(Wx + b)}}$$
- **로지스틱 오차함수 (Binary Cross Entropy)**:
  $$\text{Loss} = -[y \log(h) + (1 - y) \log(1 - h)]$$

```python
x_train = np.array([[1., 1.], [1., 2.], [2., 1.], [3., 2.], [3., 3.], [2., 3.]], dtype=np.float32)
y_train = np.array([[0.], [0.], [0.], [1.], [1.], [1.]], dtype=np.float32)

W = tf.Variable(tf.random.normal([2, 1]))
b = tf.Variable(tf.random.normal([1]))

def predict(X):
    z = tf.matmul(X, W) + b
    return 1 / (1 + tf.exp(-z))

learning_rate = 0.05
for i in range(2001):
    with tf.GradientTape() as tape:
        h = predict(x_train)
        cost = tf.reduce_mean(-tf.reduce_sum(y_train * tf.math.log(h) + (1 - y_train) * tf.math.log(1 - h)))
    W_grad, b_grad = tape.gradient(cost, [W, b])
    W.assign_sub(learning_rate * W_grad)
    b.assign_sub(learning_rate * b_grad)
```

### 퍼셉트론과 신경망
- 인간의 신경세포(Neuron) 동작을 모방하여 가중합과 활성화 함수를 결합한 최소 연산 단위입니다.
- **다층 퍼셉트론 (MLP)**: 단일 퍼셉트론으로 해결할 수 없는 비선형 문제(예: XOR 문제)를 해결하기 위해 입력층과 출력층 사이에 하나 이상의 은닉층(Hidden Layer)을 둔 신경망 구조입니다.

### 오차 역전파 (Backpropagation)
- 연쇄 법칙(Chain Rule)을 활용하여 출력층에서 계산된 오차를 입력층 방향으로 거꾸로 전파하며 각 은닉층의 가중치와 편향에 대한 미분값을 효율적으로 계산하는 알고리즘입니다.
- **출력층 오차 계산**: $\delta_{out} = (y_{out} - y_{target}) \cdot y_{out}(1 - y_{out})$
- **은닉층 오차 계산**: $\delta_{h} = (\sum \delta_{next} \cdot W_{next}) \cdot y_h(1 - y_h)$
- 가중치 갱신 공식: $W_{new} = W_{old} - \eta \cdot \delta \cdot x$

### 그래디언트 소실과 가중치 초기화
- Sigmoid 활성화 함수는 도함수의 최댓값이 0.25에 불과하여, 층이 깊어질수록 기울기가 0으로 수렴하는 기울기 소실(Vanishing Gradient) 문제가 발생합니다.
- 이를 해결하기 위해 ReLU, LeakyReLU 등의 활성화 함수를 사용합니다.
- **Xavier 및 He 초기화**:
  - Xavier(Glorot): 대칭형 함수(Sigmoid, Tanh)에 적합, 분산 $\frac{2}{n_{in} + n_{out}}$
  - He 초기화: 비대칭형 함수(ReLU)에 최적화, 분산 $\frac{2}{n_{in}}$

### 고속 옵티마이저 (Optimizer)
- 기본 경사 하강법의 느린 수렴 속도와 지역 최솟값(Local Minima) 정체 문제를 극복하기 위한 다양한 최적화 기법:
  - **모멘텀 (Momentum)**: 물리적 관성을 적용하여 과거 기울기 방향을 일정 비율 누적 ($V_t = \gamma V_{t-1} - \eta \nabla W$)
  - **네스테로프 모멘텀 (Nesterov Accelerated Gradient)**: 현재 위치가 아닌 관성으로 이동할 예상 위치에서의 기울기를 측정하여 불필요한 진동 억제
  - **Adagrad**: 매개변수별로 자주 갱신된 가중치는 작은 학습률을, 드물게 갱신된 가중치는 큰 학습률을 적용
  - **RMSprop**: Adagrad의 학습률 급감 문제를 지수 이동 평균(EMA)으로 보완
  - **Adam (Adaptive Moment Estimation)**: 모멘텀의 방향성과 RMSprop의 적응형 학습률 크기를 결합한 가장 대중적인 최적화 알고리즘

### 다중 분류와 활성화 함수
- 3개 이상의 클래스를 분류할 때 활용하는 구조:
  - **SoftMax**: 출력 노드의 로짓(Logit) 점수 벡터를 총합이 1이 되는 확률 분포로 정규화:
    $$y_k = \frac{e^{a_k}}{\sum_{i=1}^n e^{a_i}}$$
  - **Cross Entropy**: 실제 정답 원-핫 벡터와 예측 확률 분포 간의 차이를 측정하는 손실 함수:
    $$E = -\sum_{k} t_k \log(y_k)$$

### 과대적합 방지 및 규제 (Overfitting)
- 모델이 훈련 데이터에만 지나치게 맞춰져 새로운 테스트 데이터에서 일반화 성능이 떨어지는 현상입니다.
- **과대적합 방지 데이터 처리 기법**:
  - Train / Validation / Test 데이터셋 분리 (예: 7:1.5:1.5 또는 8:1:1)
  - 검증 손실(Validation Loss)이 반등하는 시점에 학습을 멈추는 조기 종료 (Early Stopping)
  - 드롭아웃(Dropout): 학습 단계마다 뉴런 중 일부를 무작위로 비활성화하여 특정 뉴런에 대한 의존도 분산
  - 데이터 증식(Data Augmentation): 회전, 반전, 크기 조절 등을 통한 데이터 다양성 확보
- **K-겹 교차 검증 (K-Fold Cross Validation)**: 전체 데이터를 K개 폴드로 균등 분할하고 K번 반복 검증하여 모델의 일반화 신뢰도를 극대화합니다.

```python
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from sklearn.model_selection import StratifiedKFold
import numpy as np
import pandas as pd

df = pd.read_csv('sonar.csv', header=None)
dataset = df.values
X = dataset[:, 0:60].astype(float)
Y = dataset[:, 60]

skf = StratifiedKFold(n_splits=10, shuffle=True, random_state=42)
accuracy_list = []

for train_idx, test_idx in skf.split(X, Y):
    model = Sequential([
        Dense(30, input_dim=60, activation='relu'),
        Dense(10, activation='relu'),
        Dense(1, activation='sigmoid')
    ])
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    model.fit(X[train_idx], Y[train_idx], epochs=100, batch_size=10, verbose=0)
    score = model.evaluate(X[test_idx], Y[test_idx], verbose=0)[1]
    accuracy_list.append(score)

print(f"평균 정확도: {np.mean(accuracy_list):.4f}")
```

### 이미지 데이터 모델링과 CNN
- 완전 연결 신경망(FCNN)은 2차원/3차원 이미지 데이터를 1차원으로 평탄화하여 공간적 기하 정보를 손실합니다.
- **CNN과 FCNN 비교**:
  - CNN은 커널(필터)을 이용한 국소 영역 합성곱을 통해 인접 픽셀 간의 공간 상관관계를 유지합니다.
  - 가중치 공유(Weight Sharing) 덕분에 학습해야 할 파라미터 수가 대폭 감소합니다.
- **CNN 핵심 이론**:
  - **합성곱 (Convolution)**: 필터를 입력 데이터 위에서 일정 보폭(Stride)으로 슬라이딩하며 요소별 곱합을 계산하여 Feature Map 생성
  - **패딩 (Padding)**: 출력 크기를 보존하고 외곽 정보 유실을 방지하기 위해 가장자리에 0을 채우는 기법 (Same vs Valid)
  - **풀링 (Pooling)**: Max-Pooling 등을 통해 공간 크기를 다운샘플링하여 연산량을 줄이고 위치 변화에 대한 불변성(Invariance) 확보

```python
from tensorflow.keras.datasets import mnist
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.utils import to_categorical

(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train = x_train.reshape(-1, 28, 28, 1).astype('float32') / 255.0
x_test = x_test.reshape(-1, 28, 28, 1).astype('float32') / 255.0
y_train = to_categorical(y_train, 10)
y_test = to_categorical(y_test, 10)

model = Sequential([
    Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=(28, 28, 1)),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Dropout(0.25),
    Flatten(),
    Dense(128, activation='relu'),
    Dropout(0.5),
    Dense(10, activation='softmax')
])

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
model.fit(x_train, y_train, validation_data=(x_test, y_test), epochs=10, batch_size=128)
```

### 시계열 데이터 모델링과 RNN·LSTM
- **순환 신경망 (RNN, Recurrent Neural Network)**: 이전 시점의 은닉 상태(Hidden State, $h_{t-1}$)를 다음 시점의 연산에 전달하여 순차적(Sequential) 시계열 데이터를 학습합니다.
- **LSTM (Long Short-Term Memory)**: RNN의 장기 의존성(Long-Term Dependency) 결함과 기울기 소실 문제를 극복하기 위해 설계된 신경망입니다.
- **LSTM Gate 메커니즘**:
  - **Forget Gate ($f_t$)**: 이전 Cell State에서 버릴 정보를 결정 ($f_t = \sigma(W_f \cdot [h_{t-1}, x_t] + b_f)$)
  - **Input Gate ($i_t$)**: 새 입력 정보 중 Cell State에 저장할 정보를 결정 ($i_t = \sigma(W_i \cdot [h_{t-1}, x_t] + b_i)$)
  - **Cell State 갱신**: $C_t = f_t \cdot C_{t-1} + i_t \cdot \tanh(W_c \cdot [h_{t-1}, x_t] + b_c)$
  - **Output Gate ($o_t$)**: 최종 은닉 상태($h_t$)로 출력할 정보를 결정 ($h_t = o_t \cdot \tanh(C_t)$)

---

## Keras 모델 구축 및 최적화

### 모델 정의 방법
1. `Sequential API`: 단일 입력-단일 출력의 순차적 레이어 스택 구성 시 적합
2. `Functional API`: 다중 입력/출력, 잔차 연결(Residual Connection) 등 복잡한 비순환 유향 그래프(DAG) 설계 시 활용
3. `Subclassing API`: `tf.keras.Model`을 상속받아 `call()` 메서드를 오버라이드하여 동적 루프 및 사용자 정의 레이어 구현

### Keras Sequential API 활용
- 모델 구축부터 평가까지의 표준 워크플로우:
  ```python
  from tensorflow.keras.models import Sequential
  from tensorflow.keras.layers import Dense

  # 1. 모델 정의
  model = Sequential([
      Dense(64, activation='relu', input_shape=(32,)),
      Dense(32, activation='relu'),
      Dense(1, activation='sigmoid')
  ])

  # 2. 컴파일 (손실 함수, 최적화 알고리즘, 평가 지표 설정)
  model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

  # 3. 훈련 (Epochs, Batch Size, Validation Split 지정)
  history = model.fit(x_train, y_train, epochs=50, batch_size=32, validation_split=0.2)

  # 4. 평가 및 예측
  test_loss, test_acc = model.evaluate(x_test, y_test)
  predictions = model.predict(x_test)
  ```
