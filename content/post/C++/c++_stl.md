+++
title = "C++_stl"
date = 2022-04-12T19:17:21+09:00
lastmod = 2022-04-12T19:17:21+09:00
tags = []
categories = []
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

# C++ STL

## 자료구조

### map
- key-value 쌍으로 이루어진 tree형태의 자료구조
- 중복을 허용하지 않음
- C++에서는 red black tree로 구현되어 삽입,삭제가 O(log n) 안에 이루어진다.
- 내부적으로 key를 기준으로 오름차순으로 자료를 정렬한다.

1. 헤더 :  `#include <map>`

1. 선언 : `map<int, int> map1;`
  - 내림차순으로 선언 : `map <int, int, greater> map2`

1. 삽입 :
 - insert : `map1.insert({"key",VALUE})`
 - [] : `map1["key"] = VALUE`

1. 삭제 :
  - 특정 index : `map1.erase(map1.begin()+2)`
  - 특정 key : `map1.erase(KEY)`
  - 구간 : `map1.erase(map1.begin(), map1.end())`
  - 전체 : `map1.clear()`

1. 검색 :
  ```
  map<int, int>::Iterator res;

  if ((res = map1.find(KEY)) != m.end()) {
    res -> first; // key
    res -> second; // value
  }
  ```

1. 반복문 :
  ```
  for (auto itr = map1.begin(); itr != map1.end(); itr++) {
    itr->first // key
    itr->second // value
  }
  ```


### hash map
- hash table을 이용한 자료구조
- 정렬이 필요없는 비순차적 구조
-

1. 헤더 : `#include<hash_map>`

1. 선언 : `hash_map<int, float> h1`

1. 삽입 :
  - insert 구문 : `h1.insert(hash_map<int, float>::value_type(1,2.0f))`
  - [] 구문 : `h1[1] = 2.0f`

1. 검색 :
  ```
  hash_map<int, float>::Iterator res;
  if ((res = h1.find(10)) != h1.end()) {
    res->first;  // key
    res->second;  // value
  }
  ```

1. 반복문
  ```
  for (auto itr = h1.begin(); itr != h1.end(); itr++) {
    itr->first;  // key
    itr->second;  // value
  }
  ```

1. 삭제 :
  - 특정 index : `h1.erase(h1.begin())`
  - 특정 key : `h1.erase(1)`
  - 구간 : `h1.erase(h1.begin(), h1.end())`
  - 전체 : `h1.clear()`

### Heap
1. 헤더: `#include<queue>`
1. 선언:
  - min queue : `priority_queue<int, vector<int>, greater<int>> Heap`
  - max queue : `priority_queue<int, vector<int>, less<int>> Heap`
  - greater, less가 반대로 되어있음에 주의한다.

1. 활용:
  - `Heap.push()` : 삽입
  - `Heap.top()` : 가장 작은/큰 값
  - `Heap.pop()` : top 값을 삭제
  - `Heap.size()` : 인자 개수
  - `Heap.empty()` : size가 1 이상이면 false, 아니면 true


### Tueple
- `std::tueple<TYPE1, TYPE2>` : 두 자료형을 쌍으로 묶어서 tueple 자료형으로 구성
- `std::get<0>(tp)` : 튜플 타입 'tp' 에서 첫번쨰 요소(TYPE1) 가져옴
- `std::get<1>(tp)` : 튜플 타입 'tp' 에서 두번쨰 요소(TYPE2) 가져옴

## 정렬

### stable_sort
- 오름차순 혹은 내림차순으로 정렬하되, 같은 값의 경우 기존의 순서를 유지하는 정렬방식
```
int v[10];
int idx[10];
// 오름차순 정렬
stable_sort(idx, idx + 10, [](int a, int b){return a > b;});
// index를 이용한 정렬
stable_sort(idx, idx + 10, [&v](int a, int b){return v[a] > v[b];});
```
