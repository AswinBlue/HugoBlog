+++
title = "Algorithm"
date = 2022-04-24T18:16:23+09:00
lastmod = 2022-04-24T18:16:23+09:00
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

# Algorithm

## 그래프 탐색
### DFS
1. 용도 :
  - 경로가 있는지 확인할 때 사용 가능
2. 자로구조 :
  - stack
3. 방법 :
  - 시작 node를 stack에 넣는다.
  - stack이 모두 빌때까지 아래 동작을 반복한다.
  - stack의 top을 현재 node로 설정한다.
  - 현재 node를 'visited' 처리하고 stack에서 제거한다.
  - 다음으로 이동할 node가 있는지 확인한다.
  - 다음으로 이동할 node 'A'가 있다면, 현재 node에서 그다음에 탐색할 방향을 stack에 push하고, node 'A'도 stack에 push한다.
  - 더이상 갈 곳이 없으면 현재 node의 visited 처리를 복원한다.
  - 최종 목적지에 도달한 경우를 모아 결과값을 비교한다.
4. 예시 :


### BFS
1. 용도 :
  - 최단경로 탐색에 사용 가능
2. 자로구조 :
  - queue
3. 방법 :
  - 시작 node를 queue에 넣는다.
  - queue가 비거나 목적지에 도달할 때 까지 아래 동작을 반복한다.
  - queue의 front를 pop 하여 현재 node로 설정한다.
  - 현재 node에서 이동 가능한 node가 있는지 확인하고, 이동 가능하다면 모두 queue에 push한다.
  - queue에 push하면서 해당 경로는 'visited' 처리를 한다.
    - (주의) queue에 넣으면서 visited 처리를 하고, queue에 넣기전에 방문 여부를 판단해야 메모리 부족을 예방할 수 있다.

## Dynamic Programming

### 0 1 knapsack
1. 용도 :
  - 나눌수 없는 물건을 최대 무게 한도로 담고 싶을 때 사용
  - 최소 단위로 나눌 수 있다면 greedy를 사용하면 된다.
2. 자료구조:
  - 2d array
3. 방법:
  - 2차원 배열 D를 선언한다. 행은 최대한도 k를 뜻하며, 열은 1부터 n번째 물건을 판단했을 때 최선의 값을 의미한다.
  - 최대 한도를 0부터 K까지 늘려가고, 모든 물건을 순회하며 가치(v)와 무게(w)를 고려해 아래 식을 체크한다.
  - 한도가 k일때 n번째 인자에 대해 `D[k][n] = max(D[k - w[n]][n-1] + v[n], D[k - 1])[n-1]`
  - 만약 w[n] > k 라면 그냥 `D[k][n] = D[k - 1][n-1]`

  - 2차원배열 대신 1차원 배열을 사용하면, 이미 선택한 인자를 중복해서 선택하게 되므로 오답
  - 2차원 배열에서 첫 열과 첫 행의 값은 0으로 세팅해 주어야 한다. (아무것도 담지 않은/못한 상황)

4. 예시:

```
# https://www.acmicpc.net/submit/12865

if __name__ == '__main__':
    N, K = map(int, input().split())
    W = [0]
    V = [0]
    for i in range(N):
        w, v = map(int, input().split())
        W.append(w)
        V.append(v)

    result = [[0 for j in range(N+1)] for i in range(K+1)]
    # 배낭의 한계를 를 1부터 증가시켜가며 dynamic programming을 수행한다.
    for i in range(1, K+1):
        # 모든 물건에 대해 물건을 넣었을 때와 넣지 않았을 때를 확인한다.
        for j in range(1, N+1):
            if W[j] <= i:
                # 확인 결과 더 최선의 값을 도출한다.
                result[i][j] = max(result[i - W[j]][j-1] + V[j], result[i][j-1]) # 넣었을때 vs 넣지 않았을 때
            else:
                result[i][j] = result[i][j-1]
    print(result[K][N])
```

##
### minHeap + maxHeap
- maxHeap + minHeap 을 사용하여 '상위 n개의 데이터' 혹은 '중앙 값'을 구할 수 있다.
- 아래와 같이 top과 top이 마주보는 구조로 minHeap과 maxHeap을 사용한다.
```
/*
 * by using two heap(minH, maxH), always can get middle value at maxH.top()
 *
 *                     (maxH)                  (minH)
 *  input -> [ a1, a2, a3, ... an(top)] [ b1(top), b2, b3, .. bm]
 *                              ^
 *                         middle value
 */
```
```
https://www.acmicpc.net/problem/1655
```
