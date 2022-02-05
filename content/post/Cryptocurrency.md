+++
title = "Cryptocurrency"
date = 2022-02-02T13:22:27+09:00
lastmod = 2022-02-02T13:22:27+09:00
tags = ["cryptograph", "cryptocurrency", "bitcoin",]
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

# Cryptocurrency

## Cryptographic Hash function
 - hash function은 아래와 같은 속성을 갖는다.
 1. 모든 크기의 String을 input 으로 받는다.
 2. 정해진 크기의 output을 생성한다. (bitcoin에서는 256bit)
 3. 적당한 시간 안에 계산이 가능하다. (계산 시간이 너무 길지 않다)

 - cryptographic hash function은 아래와 같은 security 속성을 추가로 갖는다.

   1. collision-free
   2. hiding
   3. puzzle-friendly

### 속성1. collision-free
- x != y 라면, H(x) = H(y) 인 경우를 찾을 수 없어야 한다.
- 이 말은 collision 이 존재하지 않는다는 뜻은 아니다. num(possible_input) > num(possible_outputs) 이다.
- '찾을 수 없다' 라는 말은, collision이 존재하지만, hahs function의 결과를 예측할 수 없다는 뜻이다.
  - 실제로, 2^130 개의 무작위 수를 선택하여 hash function을 돌렸을 때, 99.8%의 확률로 충돌이 발생한다.
  - 하지만 이 수치는 천문학적으로 크기 때문에 걱정할 필요가 없다. (collision을 발견할 확률은 인류가 만든 최고의 컴퓨터로 우주 생성시부터 계산을 해도, 2초뒤 지구에 운석이 떨어질 확률만큼 낮다.)
  - collision을 쉽게 구하는 방법이 있는가?
   -> 특정 hash function에 대해서는 가능하지만, 대부분은 그렇지 않다.

#### hash as message digest
- collisio n을 구하는 것이 매우 어렵기 때문에, H(x) = H(y)라면, x = y라고 확신해도 된다.
- 즉, hash를 이용해 데이터 전송/비교에 드는 비용을 절감 가능하다. (전체 message 대신 hash만 비교)

### 속성2. hiding
- H(x)를 갖고 x를 유추할 수 없다.
- hiding 속성을 가지려면 아래와 같은 방법을 사용한다.
 - high min-entropy 를 가진 무작위 상수 'r'을 x와 조합(concatenate)하여 hash function의 input에 넣으면 hiding 속성을 갖게 된다. (`H(r|x)`)
  - high min-entropy 란 넓고 고르게 퍼져있음을 뜻한다. 즉, 넓은 선택범위 안에서 특정 값이 특출나게 여려번 중복해서 뽑히지 않는다는 뜻이다. (no particular value is chosen with more than negligible probability)

#### commitment
- 편지를 동봉하듯 데이터가 가지고 있는 내용을 공개하지 않고 데이터를 공개하는 것
- commitment를 위해 제공하는 commitment API 는 다음과 같이 동작한다.
  - `(commitment, key) = commit(msg)` msg를 동봉하고, 그 결과로 commitment와 key를 생성한다. commitment는 봉투에 해당하고, key는 열쇠에 해당한다.
    - commit은 hash function으로 다음과 같이 구성된다. `commit(msg) = (H(key | msg), key)` 즉, `(commitment, key) = H(key|msg), key` 이다.
  - `match = verify(commitment, key, msg)` commitment, key, msg 세가지를 이용해 msg가 올바른지 검증한다.

- commitment는 두 가지 security property를 갖는다.
 - hiding : commitment만으로 msg를 파악할 수 없다.
 - binding : `msg1 != msg2` 라면, `verify(commit(msg1),msg2) != false` 이다.

### 속성3. puzzle-friendly
- 임의의 'k'가 high min-entropy 속성을 갖고 있다면, `H(k|x) = y` 를 만족시키는 x를 찾을 수 없다.
- 즉, 특정 값 y가 나오도록 x를 임의로 조작할 수 없다는 뜻이다.

---

앞서 말한 hash function으로는 여러가지 종류들이 있다. 그중 SHA-256에 대해 살펴보자.

### SHA-256
- 동작 방법은 아래와 같다.
  - message를 512bit씩 잘라서, 256bit의 데이터'IV'와 함께 hashing 연산 'C'을 수행한다.
  - 위 결과와 다음 256bit 메시지를 다시 'C'연산시킨다.
  - 이를 메시지 끝까지 반복한다. 마지막 메시지가 256bit가 되지 않는다면 (10*|length) 로 이루어진 padding을 집어넣어 연산한다.
- collision-free를 만족하기 때문에 'C' 연산 각각도 collision-free이다.

## Hash Pointer
- data structure의 hash와 동일하게, hash pointer는 특정 데이터를 가리키는 pointer이다.
- 다만, 데이터는 info와 cryptographic hash를 포함한다.
- hash pointer를 이용하면 데이터와, 데이터의 변경여부를 확인할 수 있다.
- hash pointer를 이용하여 다양한 data structure를 구성할 수 있다.
  - hash pointer를 이용해 linked list를 구성하면 흔히 block chain이라 불리는 구조가 형성된다.
  - linked-list의 block 하나가 '주소 + 데이터' 로 이루어져 있는데, block chain 에서는 '주소' 부분이 이전 block의 hash값(hash + data 의 hash값)으로 구성되어 있다.
  ex) `H(root) - B1[data1, H(B2)] - B2[data2, H(B3)] - B3[data3, H(B4)] ...`
  - hash값을 이용하여 다음 데이터가 수정이 이루어졌는지 확인 가능하다. (tamper-evident)
    - data3을 수정하면 H(B3)값과 B2의 H()값이 일치하지 않게 된다.
    - B2의 H()값을 수정하면 이번에는 H(B2)와 B1의 H()값이 일치하지 않는다.
    - 연쇄적으로 B2, B1, root까지 수정하면 다시 모든 hash값이 맞아 떨어지게 된다.
  - 가장 최초의 block을 'genesis block'이라 부른다.
- hash pointer로 binary tree를 구성할 수도 있다. (Merkle tree)
  - tree의 leaf node에는 data가 들어가고, 이후 root node 포함 모든 node들은 left&right 자식 node들의 hash값을 갖게 된다.
  - 데이터가 변경되면, 부모 node의 hash값이 연쇄적으로 어긋나게 되고, 최종적으로 root node의 hash값 R과 달라지게 된다. (H(root) 값을 기억하면 데이터 변경을 감지할 수 있게 된다.)
  - 데이터 검증을 위해 모든 block들을 사용해야 했던 기존 block chain과 다르게, Merkle tree는 O(log n) 개의 node만으로도 데이터 무결성을 증명할 수 있다.
  - 검증 시간 및 검색, 정렬 시간이 직렬 데이터 구조보다 절감된다.
- hash pointer는 cycle이 없는 모든 pointer-based data structure에 사용 가능하다.
