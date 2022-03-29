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

---

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

## Decentralization
- Crypto currency를 구성하기 위해서는 탈 중앙화가 이루어져야 한다.
- 앞서 보았듯이 거래 장부(transaction)를 관리하기 위해서는 이를 인증해 줄 주체가 필요했다. 이 주체를 분산시키는 것이 필요하다. (Distributed Consensus)

### Dsitributed Consensus
- 분산의 개념은 암호화 회폐 이전에 서버 동작에서도 논제가 되었다. 여러개의 서버가 병렬로 동작할 때, consistency를 유지하기 위해 distributed consensus protocol이 필요했다.
- 방법중 하나로 distributed key-value store 방식이 있는데, DNS, public key directory, stock trade 등 여러 방면에서 사용되고 있고, altcoin에도 사용되고 있다.

#### public consensus in crypto currency
- 암호화 화폐에서는 transaction가 모여 block을 이루고, 이를 모아 block chain을 만든다.
- block chain에 들어간 모든 block들은 consensus된 내용들이어야 한다.
- transaction 하나를 consensus 해도 괜찮지만, block 단위로 consensus하여 효율을 높인다.
- peer to peer 통신은 완벽하지 않기 때문에 여러개의 각기 다른 block들을 비교해야 한다.
- 비교한 block들 중 특정 block을 block chain 에 추가하면, 어떤 transaction은 빠질 수도 있는데, 이는 다음번 consensus때 까지 대기해야 한다.
  - Node간 충돌은 consensus protocol이 쉽지 않은 이유중 하나이다.
  - 모든 Node들이 연결되어 있지 않기 때문에 Node간 충돌은 불가피하다.
  - network latency 혹은 fault도 Node간 차이를 발생하는 원인이 된다.


- Byzantine general problems 는 consensus problem 중 하나이다. Fischer-Lynch-Paterson impossibility result 라는 이름의 증명은 하나의 fault만 존재해도 consensus는 불가능하다는 것을 증명한 내용이다.
- 그럼에도 불구하고 대표적인 consensus protocol들이 있다. 그중 하나는 Paxos 프로토콜이다.
  - Paxo 프로토콜은 inconsistent 한 상황은 절대 발생시키지 않지만, 특정한 상황이 되면 dead-lock 처럼 로직이 멈춰 더이상 동작하지 않는 상태가 발생할 수 있다.

- 현실 bitcoin에서는 이론에 비해 consensus가 더 잘 이루어지고 있다. 이론은 아직 실제 현상을 따라잡아 가는 형태이지만, 여전히 이론은 예상치 못한 공격에 대한 대응과 bitcoin 생태계에서의 확신을 주기 위한 존재로서 중요하다.

- 현실의 bitcoin에서는 어떤점이 다른가?  
  bitcoin에서는 insentive의 개념이 있다. 정직하게 활동한 참여자에게는 insentive를 줌으로써 시스템에 우호적으로 활동할 계기를 준다.
- 이는 bitcoin이 currency의 개념이기 때문에 가능하며, 이번의 모든 distributed consensus system 에서는 없었던 개념이다.
- insentive를 통해 bitcoin은 distributed consensus system를 근본적으로 해결하지 않았지만, 해결책을 찾은 셈이다.

- consensus system은 즉각적이지 않고, consensus를 수행하는데도 약 1시간 정도가 소요된다. 하지만 시간이 지날수록 transaction이 반영되지 않거나 잘못될 확률은 exponential하게 줄어들게 된다.


#### consensus without identity
- bitcoin에서는 persistent long term identities 없이 consensus가 이루어진다. 즉, node를 칭할 수 있는 identity가 없다.
- identity가 있다면 다음과 같은 이점이 있다.
  1) 실용성(pragmatic) : 프로토콜에서 id를 이용한 로직을 사용할 수 있다.
  2) 보안(security) : 특정 인물의 malicious한 행동을 tracking 가능하다.

- 그럼에도 불구하고 bitcoin에서 identity를 사용하지 않는 이유는 p2p system의 한계 때문이다.
  - p2p는 중앙 체제가 없기 때문에 인정받은 identity를 갖기 어렵다.
  - bitcoin 자체가 현실의 identity를 사용하는 것을 원하지 않는다. (특정 node에서 이루어지는 transaction들은 구분할 수 있지만, 그 node가 현실의 누구 것인지는 알 수 없다.)
  - 이러한 identity가 없는 특징 때문에 p2p network는 Sybil attack에 취약하다.
    - Sybil attack : 한 명이 가상의 node들을 다수로 만들어 마치 여러 사람인 것 처럼 보이게 하는 것.

##### weaker assumption
- node마다 identity를 부여하고, 이 부여받은 identity를 검증하는 작업은 매우 복잡하다.
- authenticated 된 identity를 부여하는 것 대신 랜덤한 token을 node에 부여한다.
- token으로 특정 node를 구분할 수 있으며, 특정 사용자가 여러 node들을 만드려 할 경우 해당 node들에 동일한 token을 부여하는 방식으로 Sybil attack을 방지할 수도 있다.

- implicit consensus : 매 round마다 random node가 선택되고, 이 node는 block chain에 들어갈 다음 block을 추천하는 방식.
  - 이 추천은 일방적이며, consensus 알고리즘이나 투표같은게 없다.  
  - 다른 node들은 implicitly 하게 이 block을 수락하거나 거절함으로써 malicious한 node의 행위를 막을 수 있다. implicitly 하다는 뜻은, 직접적으로 투표를 행하지는 않지만, 해당 block을 포함한 block chain을 사용하면 찬성하는 것이고, 그렇지 않다면 반대하는 것이다.
    - block chain에서 특정 block은 마지막 block의 hash를 가지고 있기에 가능하다.

- bitcoin에서 사용되는 consensus algorithm을 간단하게 살펴보면 아래와 같다.
  1) 신규 transaction은 모든 node들에 broadcast된다.   
  2) 각 node들은 transaction들을 모아 block을 구성한다.   
  3) 매 round마다 random node가 선출되고, 그 node에서 생성한 block을 broadcast한다.   
  4) 다른 node들은 (3)에서 전송된 block을 보고, valid(unspent, valid signature) 하다면 이를 수락한다.   
  5) Node들은 다음번 만드는 block에다 (3)에서 전송된 block의 hash를 집어넣음으로써 implicit하게 수락을 표현할 수 있다. (그렇지 않으면 거절을 표현한 것)

- 그렇다면 위 방식에 문제는 없을까?
  - signature 설정 방식이 견고하다면, transaction을 위조할 수 없기 때문에 타인의 coin을 강제로 탈취할 수 없다.
  - 특정 node가 valid 한 데이터를 계속 deny 하더라도, 해당 node가 다음 round에서 선택되지 않으면 transaction들은 정상적으로 올라가게 된다. 약간의 번거로움만 있을 뿐 전체 시스템에 치명적인 문제가 발생하지는 않는다.
  - node가 수행할 수 있는 악의적인 행위로는 'double spending attack' 이 있다.

- double spending attack
  - block chain의 block1을 base로 A가 B에게 coin을 넘겨준 transaction [b1 : A -> B] 이 있다고 하자
  - 이때, A가 악의적으로 A가 자신의 또다른 계정 A'에게 coin을 넘겨주었다는 거짓 transaction [b1 : A -> A'] 를 추가한다면, 정상적으로 수행된 [b1 : A -> B] transaction과 충돌이 발생한다. 즉, merge conflict가 발생하는 2개의 branch가 생성되는 것이다.
  - 이는 moral distinction을 요하기 때문에 기술적으로 어렵다. node들은 대체로 먼저 들어온 block을 수락하고, 더 긴 branch를 정당한 branch로 취급한다.
  - 조작된 transaction [b1: A -> A']이 든 block이 network 지연 등의 이슈로 인해 먼저 broadcast되고, 정당성을 확립하면 실제 transaction[b1 : A -> B] 는 orphan block이 되고, 네트워크에서 사라지게 된다.

- 0 confirmation transaction
  - double spending attack을 막기 위해, block chain에 내가 coin을 지불받는 transaction이 정상적으로 들어있는 것을 확인한 후 현실 세게에서 물건을 전달하는 방식
  - 다른 node가 올린 block에서 내 transaction이 정상적으로 적용되었는지 확인할 수 있다. 해당 block 뒤에 더 많은 block이 붙을 수록 'long term consensus chain' 이 될 확률이 높아진다.
  - double spending attack의 성공 확률은 confirmation의 횟수만큼 exponential 하게 줄어든다.   
  ```
  block chain의 형태가 아래와 같을 때,

  [block1] - [block2] - [block3] - [block4] - [block5]
  block3는 3 confirmation을 받은 상태이다.
  block4는 2 confirmation을 받은 상태이다.
  ```
  - 일반적인 bitcoin에서는 transaction이 정상적으로 이루어진 것을 판단하기 위해서 6 confirmation을 확인한다. 이는 시간과 확률의 trade-off 관계에서 성립된 수치이다.

#### honesty problematic
- 우리는 탈 중앙화를 위해 랜덤한 node에서 block을 받아 block chain에 적용하기로 했다. 하지만 모든 node가 honest 한지에 대해서는 보장할 수 없다.
- 각 node들은 현실 정보의 개인정보를 갖고있지 않기 때문에 block chain에 위해를 가하는(double spent 같은 공격) node를 처벌할 수 없다.
- 대신 올바른 block들을 만들어주는 node들에 대해 보상을 주는 방법은 가능하다. 이는 block chain으로 구성된 내용이 가치를 가지는 crypto currency 이기 때문에 가능하다.


### Incentive Algorithm
- bitcoin은 decentralize를 위해 기술적인 부분(distributed consensus)과 incentive aoglrithm 을 사용한다.

1. block reward
- block chain의 규칙에 따라, block을 생성하는 node는 특수한 coin-creation transaction을 추가할 수 있다.
- 이를 통해 coin을 생성하고, 그것을 자신의 계좌로 연결하여 수익을 얻을 수 있다.
- bitcoin에서 현재(14.08) coin 생성 양은 25 코인으로 고정되어 있는데, 이는 매 4년마다 절반으로 줄어든다. 최초에는 50코인이었다.
- coin-creation transaction은 다른 transaction과 마찬가지로 취급된다. transaction이 consensus chain에 들어가야 효력이 발생한다.
  - 즉, 자신의 coin-creation transaction이 든 block이 consensus chain에 포함되려면, 다른 node들이 agree 할 만한 block을 base로 하여 block을 연결하는게 유리하다.
  - 악의적인 node가 double-spending attack을 위해 길이가 긴 block-chain을 무시하고 임의의 block을 base로 하여 자신의 block을 연결한다면, 다른 node들은 그가 만든 block-chain을 reject 할 것이고, 그가 받는 보상은 무효화 될 것이다.
  - 이러한 방식으로 node들이 honest하게 동작하도록 유도한다.
- 새로운 bitcoin은 transaction시 발생하는 coin-creation transaction에 의해서만 생성되고, 현재 규칙이 계속 유지될 경우 2140에는 새로운 coin이 생성되지 않고 21 million 에서 수렴할 것이다.

1. transaction fee
- transaction을 생성하는 자는(거래를 하는 자) output value를 임의로 설정할 수 있다. (단, output value < input value)
- 해당 transactio을 최초로 block에 넣는 node는 input-output 의 차액을 가져갈 수 있다.
- transaction fee는 자발적이고, tip과 같은 느낌이지만, block reward가 점차 감소하는 시점에서 시스템을 유지하기 위해서는 필수적인 요소가 된다.


- 이러한 시스템에서도 아직 해결안된 문제는 남아있다.
1) 어떻게 random 한 node를 선택할 것인가  
2) 보상을 위해 과도한 경쟁(free-for-all)을 하는 현상을 어떻게 막을 것인가  
3) Sybil attack 의 방지(2번의 심화 형태)  
- 위 세가지 문제점은 모두 연관되어 있고, 하나의 방법으로 해결 가능하다.

#### Proof of work
- 직접 random 한 node를 선택하는 대신, resource(computing power) 의 비율로 다음 node가 선택되게 하는 방법이다.
- 즉, 각 node들이 각각의 computing power을 이용해 서로 경쟁하도록 하는 것이다.
- 이러한 경쟁 방법을 Hash puzzle이라 부른다.
  - block을 [nonce, previous hash, {Tx1, Tx2, ...}] 형태로 구성하도록 한다.
  - nonce를 포함한 전체 block을 hash 로 취했을 때, 결과값 중 target space(일반적으로 1% 이하의 매우 작은 영역)가 특정한 값이 나오도록 해야한다. (target 값보다 작은 값이 되도록)
  - hash function이 충분히 secure 하다면, nonce를 찾으려면 random한 nonce 값을 넣으며 계산을 시도해야 하며, 일반적으로 많은 computing power가 필요할 것이다.

- 이를 통해 단순히 node의 숫자를 늘려서 다음 block을 선택할 기회를 얻을 확률을 높일 수 없게 되었다.
- 또한 누군가가 랜덤한 block을 선출하는 것이 아닌, 경쟁과 확률을 통해 자연적으로 선출될 수 있도록 하였다.

##### Proof of work의 속성
1. Difficult to compute
- hash puzzle을 푸는데는 현재(14.8) 기준 block당 약 10^20 hash를 계산해야 한다. (target space의 크기가 1/10^20 이란 의미)
- 일반적인 PC로는 감당할 수 없고, 많은 양의 computing power을 사용하여야 하는 작업이다.
- 이렇게 nonce 값을 찾는 것을 흔히 bitcoin mining이라 하는 과정이다.

1. parameterizable cost
- target space의 범위를 고정된 %로 취하는 것이 아닌, 가변적인 값으로 설정한다.
- p2p 에 연결된 모든 node들은 자동적으로 매 2주마다 target space를 재 설정하도록 동작한다.
- target space의 값은 hash puzzle을 푸는데 걸리는 시간이 약 10분이 되도록 하는 것을 목표로 한다.
  - block 간의 간격이 10분이 되는 이유는, 너무 빨리 block이 갱신되면 한 block에 여러 transaction(현재기준 약 수백개)을 담아 효율적으로 운영할 수 없게 된다.
  - latency는 기술적으로는 더 낮게 설정할 수도 있지만, 모두의 동의 하에 하한값을 설정하여 작동한다.
- 특정 node가 다음 block을 설정하게 될 확률은, 전체 node들의 computing power에서 그 node가 갖고 있는 computing power 의 비율에 비례한다.

- 결과적으로, 다량의 computing power을 가지고 mining을 하고 있는 사람들은 대부분이 honest하고, 다음 block 선택을 경쟁적으로 수행하기 때문에 적어도 50% 이상의 확률로 block이 honest node에서 선택되었음을 보장할 수 있다.

- nonce는 확률적으로 밖에 도출될 수 없다. 이는 discrete probability process로, Bernoulii trial 이다.
  - nonce를 찾는 과정은 Bernoulii trial을 연속적으로 수행하는 poisson process에 속한다.
  - 전 network에서 누군가가 nonce를 찾는데 걸리는 시간을 확률 밀도함수(probability density)로 표현하면 exponential distribution을 이룬다. (0에 수렴하도록 감소하는 지수 함수)

1. Trivial to verify
- 특정 node가 hash puzzle을 해결하여 올린 block을 다른 node에서 쉽게 검증할 수 있어야 한다.
 - `H(block) < target`, block의 모든 값을 hash 계산한 결과가 target 보다 작은지 확인
