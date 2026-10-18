---
title: "알고리즘 문제 해결 전략: 그래프 최단경로, 배낭 DP, 듀얼 힙과 규칙 탐색"
date: 2022-04-24T18:16:23+09:00
lastmod: 2022-04-24T18:16:23+09:00
description: "코딩 테스트와 기술 면접을 위한 핵심 알고리즘 가이드입니다. DFS/BFS, 다익스트라 최단 경로, 0-1 배낭 문제 동적 계획법(DP), 듀얼 힙을 이용한 중앙값 탐색 및 규칙 발견 기법을 정리합니다."
slug: "algorithm-shortest-path-knapsack-dp-dual-heap"
categories: ["Algorithm"]
tags: ["algorithm", "data-structures", "graph-search", "dynamic-programming", "shortest-path", "dijkstra"]
ShowToc: true
TocOpen: true
draft: false
---

# 알고리즘 문제 해결 전략 (Algorithm Guide)

코딩 테스트 및 실무 문제 해결에서 자주 사용되는 핵심 알고리즘과 최적화 기법을 정리합니다.

## 그래프 탐색과 최단 경로 (Shortest Path)

### 단일 출발지 단일 목적지 최단 경로 (Shortest Path)

- **DFS (깊이 우선 탐색)**:
  - **용도**: 경로의 유무 확인, 사이클 탐색, 백트래킹(완전 탐색)
  - **자료구조**: 재귀 호출(Call Stack) 또는 명시적 `Stack`
  - **원리**: 시작 노드를 스택에 넣고, 방문 가능한 인접 노드를 깊이 우선으로 탐색하며, 더 이상 방문할 수 없을 때 백트래킹하여 다른 분기를 탐색합니다.

- **BFS (너비 우선 탐색)**:
  - **용도**: 간선의 가중치가 동일한 그래프에서 최단 경로 탐색
  - **자료구조**: `Queue`
  - **원리**: 시작 노드를 큐에 넣고 인접 노드를 너비 순서대로 큐에 삽입합니다. 큐에 삽입할 때 즉시 방문(Visited) 처리를 해야 중복 방문 및 메모리 초과를 방지할 수 있습니다.

### 단일 출발지 전체 목적지 최단 경로 (SSSP)

- **다익스트라 (Dijkstra)**:
  - **용도**: 음의 가중치가 없는 그래프에서 단일 출발점으로부터 모든 노드까지의 최단 거리 계산
  - **자료구조**: 우선순위 큐(Min Heap), 최단 거리 테이블(`dist[]`)
  - **원리**:
    1. 출발 노드의 거리를 0으로, 나머지 노드를 무한대($\infty$)로 초기화합니다.
    2. 우선순위 큐에서 가장 최단 거리를 가진 노드 $M$을 꺼냅니다.
    3. $M$을 거쳐 인접 노드로 이동하는 경로가 기존 테이블 값보다 작으면 갱신하고 우선순위 큐에 삽입합니다.
    ```cpp
    for (const auto& edge : graph[M]) {
        if (dist[M] + edge.cost < dist[edge.dest]) {
            dist[edge.dest] = dist[M] + edge.cost;
            pq.push({dist[edge.dest], edge.dest});
        }
    }
    ```

- **벨만-포드 (Bellman-Ford)**:
  - **용도**: 간선 가중치가 음수인 경우를 포함하여 단일 출발점 최단 경로 계산 및 음수 사이클 존재 여부 판별
  - **시간 복잡도**: $O(V \cdot E)$
  - **원리**: 모든 간선에 대해 완화(Relaxation) 작업을 $V-1$번 반복 수행하며, $V$번째 수행 시에도 거리가 갱신된다면 음수 사이클이 존재함을 판단합니다.

### 모든 쌍 최단 경로 (All Pair Shortest Path)

- **플로이드-워셜 (Floyd-Warshall)**:
  - **용도**: 그래프의 모든 정점 쌍 $(i, j)$ 간의 최단 경로를 한 번에 계산
  - **자료구조**: 2차원 배열 $D[V][V]$
  - **원리**: 중간 경유 노드 $k$를 가장 바깥쪽 루프로 두고 3중 반복문으로 동적 계획법 수행:
    $$D[i][j] = \min(D[i][j], D[i][k] + D[k][j])$$

---

## 동적 계획법 (Dynamic Programming)

### 0-1 배낭 문제 (0-1 Knapsack Problem)
- **용도**: 담을 수 있는 물건을 쪼갤 수 없을 때, 정해진 배낭의 최대 용량 $K$ 내에서 가치 $V$의 합을 극대화하는 조합을 구합니다. (물건을 쪼갤 수 있다면 그리디 분할 배낭 문제로 해결 가능)
- **자료구조**: 2차원 DP 테이블 $D[k][n]$ (행: 무게 한도 $0 \sim K$, 열: $1 \sim N$번째 물건)
- **점화식**:
  - $w_n \le k$ 인 경우: $D[k][n] = \max(D[k - w_n][n-1] + v_n, D[k][n-1])$
  - $w_n > k$ 인 경우: $D[k][n] = D[k][n-1]$

```python
# 백준 12865번 평범한 배낭 문제 풀이 예시
import sys

def knapsack():
    input = sys.stdin.read
    data = input().split()
    if not data:
        return
    N = int(data[0])
    K = int(data[1])
    
    W = [0]
    V = [0]
    idx = 2
    for _ in range(N):
        W.append(int(data[idx]))
        V.append(int(data[idx+1]))
        idx += 2

    dp = [[0] * (N + 1) for _ in range(K + 1)]

    for i in range(1, K + 1):
        for j in range(1, N + 1):
            if W[j] <= i:
                dp[i][j] = max(dp[i - W[j]][j - 1] + V[j], dp[i][j - 1])
            else:
                dp[i][j] = dp[i][j - 1]

    print(dp[K][N])

if __name__ == '__main__':
    knapsack()
```

---

## 순서 정렬과 힙 활용

### 듀얼 힙(MinHeap + MaxHeap)을 활용한 중앙값 실시간 탐색
- 수열이 실시간으로 입력될 때마다 $O(\log n)$으로 중간값(Median)을 유지하는 패턴입니다.
- **구조**:
  - `Max Heap`: 중간값 이하의 작은 값들을 보관 (Top이 중간값)
  - `Min Heap`: 중간값 이상의 큰 값들을 보관
  - 두 힙의 크기를 같거나 Max Heap이 1개 더 많도록 유지하며, Max Heap의 Top이 항상 전체의 중앙값이 되도록 조정합니다.
  ```
               (Max Heap)                  (Min Heap)
    입력 -> [ a1, a2, ... an(Top) ]   [ b1(Top), b2, ... bm ]
                           ^
                      중앙값 (Median)
  ```

---

## 문제 해결을 위한 규칙 찾기 (Pattern Finding)

정형화된 공식을 대입하기 어려운 문제는 상태 공간을 좌표평면으로 모델링하거나 대칭성 및 케이스를 체계화하여 규칙을 도출합니다.

### 1. 키보드 자판 좌표계 변환 문제
키보드 QWERTY 배열에서 각 키 사이의 이동 시간을 계산할 때, 자판의 행과 열 오프셋을 2차원 좌표 $(x, y)$로 정량화하여 거리를 수식으로 단순화합니다:
- Q:(0, 2), W:(2, 2) ... A:(1, 1), S:(3, 1) ... Z:(2, 0), X:(4, 0) ...
- 가로/세로 이동 규칙을 단순 좌표 차이 수식으로 환산하여 구현 복잡도를 획기적으로 낮춥니다.

### 2. 수의 곱을 최대화하는 숫자 배치 전략
주어진 숫자 카드들을 조합하여 두 개의 수를 만들고 이들의 곱이 최대가 되도록 하려면:
- 높은 자리수에 가장 큰 숫자들을 우선 배치합니다.
- 두 수의 자릿수 차이가 최소가 되어야 두 수의 곱이 극대화됩니다 ($12 \times 34 < 21 \times 43$).
- 자리수별로 교차하며 곱셈 기여도가 큰 쪽에 큰 숫자를 할당하는 그리디 전략을 적용합니다.