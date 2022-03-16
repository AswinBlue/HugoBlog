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
   -> 특정 hash function에 대해서는(SHA256에 대해서도 최단기간 collision을 찾아내는 방법이 알려져 있다.) 가능하지만, 대부분은 그렇지 않다.

#### hash as message digest
- collision을 구하는 것이 매우 어렵기 때문에, H(x) = H(y)라면, x = y라고 확신해도 된다.
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

## Digital Signature
- Digital Signature 은 아래와 같은 속성을 지녀야 한다.
1) only you can sign, but anyone can verify : 본인만 사용 가능하며 본인임을 인증할 수 있어야 한다.
2) tied to a particular document : 서명과 인증할 대상이 분리 불가능해야 한다.
- digital signature의 API는 아래와 같을 것이다.
`(secret_key, public_key) := generateKeys(size_of_key)` : Key를 생성하는 함수.
  - randomize 되어있어야 한다.
`sig := sign(secret_key, message)` : 특정 message에 서명을 하는 함수
  - 마찬가지로 randomize가 잘 되어있어야 한다.
  - message의 길이가 너무 길면 처리하기 힘드므로, Hash function의 collision-free 특성을 이용해 message의 hash 값을 쓰도록 한다.
`isValid := verify(public_key, message, sig)` : public key와 message, sig의 조합으로 알맞은 서명인지 검증하는 함수

### Requirements for signature
- 위 API로 만든 signature의 조건으로는 아래 두가지가 있다.
1) public_key, sig, message로 message가 당신의 것임을 인증 가능
2) 다른 이가 당신의 public_key, sig를 이용해 다른 message′ 에 서명을 할 수 없어야 한다.
- secret_key 를 공개하지 않고, public key를 타인에게 공개한 후, 수 많은 message [m0, m1, m2, ...] 에 대해 서명을 한 결과 [sign(m0), sign(m1), sign(m2), ...]를 타인에게 주었을 때, 그 사람이 새로운 메시지 m′에 대한 서명 sign(m′)을 만들어 낼 확률은 극히 낮아야 한다.

\+ Hash pointer를 sign하면, hash pointer 뿐만 아니라, pointer가 가리키는 전체 구조를 sign하는 효과를 얻을 수 있다.
\+ bitcin은 ECDSA(Elliptic Curve Digital Signature Algorithm) 표준을 사용한다.


## Public Keys & Secret Keys
- public key는 개인을 식별할 수 있는 '식별자'이다. public key는 모두에게 공개되며, public key로 개개인을 구분할 수 있다.
- secret key는 public key로 특정 발언을 할 수 있는 '권한' 이다.
- public key 와 secret key는 pair로 존재하며, 'identity' (고유함)를 구성한다.
  - identity는 아무 때나, 몇개든 만들 수 있으며, 모든 identity를 관리하기위한 중앙 체제가 필요없다. (decentralized)
  - 다만, 랜덤 요소가 약하다면 다수의 public key와 message를 통해 secret key가 유출될 가능성이 있음에 주의한다.
- 이러한 속성 덕분에 bitcoin에서도 identity를 'address' 라는 용어로 사용한다.
- address 는 탈 중앙화로 동작하지만, 개인이 만든 address는 즉시 identity 속성을 갖지는 못한다.
  - address가 identity 속성을 갖게 하기 위해서는 다른 address들과 엮어야 하는데, observer가 주기적으로 이 동작을 수행하도록 해야한다.
  - address를 추적하면 address 명의로 수행한 행위들을 추출할 수 있는데, 이 내용으로 특정 개인을 추정할 수 있는 취약점이 있다.

## Cryptocurrency
- CryptoCurrency(이하 coin)에는 다음과 같은 조건이 필요하다.
1. public key, unique coin id 를 이용해 coin을 만들 수 있어야 한다.
 - A 가 unique coin id 를 인자로 coin을 만들고, 이를 public key로 sign하는 방식으로 coin을 생성한다.(`[pk_A, createCoin(unique_coin_id)]`)
2. coin은 다른 사람에게 전달 가능해야 한다.
 - A 가 B 에게 coin을 전달한다고 할 때, 만들어진 coin을 가리키는 거래내역 block을 생성한다. `[pk_A, pay_to(pk_B)] -> [pk_A, createCoin(unique_coin_id)]`
   - pay_to 블럭의 hash pointer가 createCoin 블럭을 가리킨다. 이러면 coin의 소유자가 A에서 B로 넘어간 것이다.
- 이후 B가 C로 coin을 전달하면 `[pk_B, pay_to(pk_C)] -> [pk_A, pay_to(pk_B)] -> [pk_A, createCoin(unique_coin_id)]` 형태가 될 것이다.

- 모든 chain을 따라가면 coin이 누구의 소유인지 확인 가능하다.

### double spending attack
- coin의 chain은 직렬로 이루어져야 한다. 만약 branch가 생겨나면 소유권이 꼬이게 된다.
- 아래와 같이 B가 특정 coin을 두번 이상 spend 하는 형태가 발생할 수 있다.
```
[pk_B, pay_to(pk_C)]    [pk_B, pay_to(pk_D)]
                ↓           ↓
              [pk_A, pay_to(pk_B)]
        ↓
[pk_A, createCoin(unique_coin_id)]
```
- 이러한 경우, 이 코인은 secure하지 않기 때문에 cryptoCurrency로서는 좋지 않다.


- double spending attack을 해소하려면 history를 관리하면 된다.
- history는 위에서 살펴본 block chain(hash pointer를 이용한 linked list) 형태로 구성한다.
  - 거래내역(transactions) 들을 content로 갖는 block들 생성하고, 이를 hash pointer로 연결한다. (보통 한 block 안에는 다수의 transaction들을 포함한다.)
  - 관리자가 root hash 및 block들을 public key로 인증하여 publish하면, history가 관리되어 안정성이 확보된다.
`H() -> ... -> [H(), transaction3] -> [H(), transaction2]  -> [H(), transaction1]`

- transaction들은 관리자에 의해 publish되어야 한다. (pk로 sign)
- transaction들은 다음과 같이 구성된다.
 1. create coin
   - value와 recipient를 설정한다.
   - 생성한 coin에 고유 id를 붙인다. (trainsaction Id + index로 조합)
 2. pay
   - consume -> create 작업을 수행한다.
   - consume은 coin id를 이용해 coin을 폐기하는 작업이다.
   - create 작업은 create coin과 동일하다.
   - 작업을 수행하기 전 다음 사항들을 validate 하고 수행한다.
    1) consume하는 coin이 valid한지 체크
    2) consume 하는 coin이 이미 consume되지 않았는지 체크(not double spend)
    3) consume 되는 양과 create 되는 양이 같은지 체크
    4) consume 되는 coin들은 각 owner에 의해 sign 되어있는지 체크
    - 모든 사항이 확인되면 관리자에 의해 publish된다.

-> double spending 문제는 해결했지만 centralization 문제가 발생한다. ('관리자' 가 중앙 체제에 해당)
