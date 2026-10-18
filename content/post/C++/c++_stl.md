---
title: "C++ STL 핵심 컨테이너 및 알고리즘 완벽 가이드"
date: 2022-04-12 19:17:21+09:00
lastmod: 2026-10-18 18:00:00+09:00
description: "C++ 표준 템플릿 라이브러리(STL)의 핵심 자료구조인 map, unordered_map(hash map), priority_queue(heap), tuple의 기본 사용법과 stable_sort 정렬 알고리즘 활용법을 상세히 정리합니다."
slug: "cpp-stl-containers-and-algorithms"
categories:
  - "C++"
tags:
  - "c++"
  - "stl"
  - "data-structures"
  - "priority-queue"
  - "algorithms"
ShowToc: true
TocOpen: true
draft: false
---

## STL 핵심 자료구조

### std::map
`std::map`은 Key-Value 쌍으로 구성되는 트리 기반의 연관 컨테이너이다.
- 내부적으로 **레드-블랙 트리(Red-Black Tree)**로 구현되어 있어 검색, 삽입, 삭제의 시간 복잡도가 $O(\log n)$을 보장한다.
- Key의 중복을 허용하지 않으며 내부적으로 Key 기준 오름차순으로 항상 자동 정렬된다.

1. **헤더 선언**:
   ```cpp
   #include <map>
   ```

2. **컨테이너 생성**:
   ```cpp
   std::map<int, std::string> map1; // 기본 오름차순 정렬
   std::map<int, std::string, std::greater<int>> map2; // 내림차순 정렬
   ```

3. **원소 삽입**:
   ```cpp
   map1.insert({1, "Alpha"});
   map1[2] = "Beta"; // 대괄호 연산자를 통한 삽입 또는 갱신
   ```

4. **원소 삭제**:
   ```cpp
   map1.erase(map1.begin()); // 특정 반복자 위치 삭제
   map1.erase(1);            // 특정 Key 삭제
   map1.erase(map1.begin(), map1.end()); // 구간 삭제
   map1.clear();             // 전체 삭제
   ```

5. **원소 검색**:
   ```cpp
   auto res = map1.find(1);
   if (res != map1.end()) {
       int key = res->first;
       std::string value = res->second;
   }
   ```

6. **순회 (Iteration)**:
   ```cpp
   for (auto itr = map1.begin(); itr != map1.end(); ++itr) {
       std::cout << itr->first << " : " << itr->second << "\n";
   }
   ```

### std::unordered_map (해시 맵)
`std::unordered_map`은 **해시 테이블(Hash Table)**을 기반으로 구현된 컨테이너이다.
- 원소들이 정렬되지 않은 비순차적(Unordered) 구조를 가진다.
- 평균적인 탐색, 삽입, 삭제 시간 복잡도는 $O(1)$이며 해시 충돌 발생 시 최악의 경우 $O(n)$이 소요된다.

> [!NOTE]
> 과거 비표준 확장이었던 `<hash_map>` 대신 C++11 표준인 `<unordered_map>` 및 `std::unordered_map`을 사용하는 것이 표준 권장 사항이다.

1. **헤더 선언**:
   ```cpp
   #include <unordered_map>
   ```

2. **컨테이너 생성**:
   ```cpp
   std::unordered_map<int, float> h1;
   ```

3. **원소 삽입**:
   ```cpp
   h1.insert(std::make_pair(1, 2.0f));
   h1[2] = 3.5f;
   ```

4. **원소 검색**:
   ```cpp
   auto res = h1.find(1);
   if (res != h1.end()) {
       int key = res->first;
       float val = res->second;
   }
   ```

5. **순회 및 삭제**:
   ```cpp
   for (const auto& pair : h1) {
       std::cout << pair.first << " : " << pair.second << "\n";
   }

   h1.erase(1);    // 특정 키 삭제
   h1.clear();     // 전체 삭제
   ```

### std::priority_queue (힙)
우선순위 큐는 최대 힙(Max Heap) 또는 최소 힙(Min Heap)을 편리하게 구현할 수 있는 컨테이너 어댑터이다.

1. **헤더 선언**:
   ```cpp
   #include <queue>
   #include <vector>
   ```

2. **선언 방법**:
   - 최소 힙 (Min Heap): 작은 값이 우선
     ```cpp
     std::priority_queue<int, std::vector<int>, std::greater<int>> minHeap;
     ```
   - 최대 힙 (Max Heap): 큰 값이 우선 (기본값)
     ```cpp
     std::priority_queue<int, std::vector<int>, std::less<int>> maxHeap;
     ```
   > `greater`와 `less` 템플릿 인자의 정렬 순서가 일반적인 기준과 반대로 동작함에 유의한다 (`greater`가 최소 힙).

3. **주요 연산**:
   - `minHeap.push(val)`: 원소 삽입 ($O(\log n)$)
   - `minHeap.top()`: 최상단 원소 반환 ($O(1)$)
   - `minHeap.pop()`: 최상단 원소 제거 ($O(\log n)$)
   - `minHeap.size()`: 원소 개수 반환
   - `minHeap.empty()`: 큐가 비어있는지 검사

### std::tuple
서로 다른 데이터 타입을 하나로 묶어 다루는 고정 크기 튜플 자료구조이다.

1. **헤더 선언**:
   ```cpp
   #include <tuple>
   ```

2. **선언 및 요소 접근**:
   ```cpp
   std::tuple<int, std::string, double> tp = {1, "Code", 3.14};

   int id = std::get<0>(tp);
   std::string name = std::get<1>(tp);
   double value = std::get<2>(tp);
   ```

## STL 알고리즘

### std::stable_sort
동일한 비교 기준을 가진 원소들 사이에서 원래의 상대적인 순서가 보존되는 안정 정렬(Stable Sort) 함수이다.
- 내부적으로 머지 소트(Merge Sort) 기반으로 동작하며 시간 복잡도는 $O(n \log n)$이다.

```cpp
#include <algorithm>
#include <vector>

int v[10] = {5, 2, 8, 2, 9, 1, 7, 3, 5, 4};
int idx[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

// 1. 값 기준 내림차순 안정 정렬
std::stable_sort(v, v + 10, [](int a, int b) {
    return a > b;
});

// 2. 인덱스 배열을 활용한 간접 정렬 (v 배열의 값 기준 내림차순)
std::stable_sort(idx, idx + 10, [&v](int a, int b) {
    return v[a] > v[b];
});
```
