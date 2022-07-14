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

## 순서 정렬
### minHeap + maxHeap
- maxHeap + minHeap 을 사용하여 '상위 n개의 데이터' 혹은 '중앙 값'을 구할 수 있다.
- 아래와 같이 top과 top이 마주보는 구조로 minHeap과 maxHeap을 사용한다.
```
https://www.acmicpc.net/problem/1655
/*
 * by using two heap(minH, maxH), always can get middle value at maxH.top()
 *
 *                     (maxH)                  (minH)
 *  input -> [ a1, a2, a3, ... an(top)] [ b1(top), b2, b3, .. bm]
 *                              ^
 *                         middle value
 */
```


## 규칙 찾기
- 정해진 공식을 대입하는것이 아닌, 문제에서 규칙을 찾아 해결하는 방식

1. 키보드 좌표계
   - 키보드 자판을 보면 행은 똑바르지만, 열은 살짝 어긋나있다. S를 보면 Q,W,E,A,D,Z,X,C 와 접해있다.
   - 한 버튼에서 다른 버튼까지 이동하는데 걸리는 시간을 계산한다 해 보자. Q에서 E까지는 2번, Q에서 D까지는 3번, Q에서 X까지는 3번에 걸쳐 이동할 수 있다.
   - 이러한 좌표에서 특정 문자를 입력하기 위해 각 자판을 이동하는데 걸리는 시간을 계산한다면?
   1. 통용되는 규칙을 찾아서 해결한 경우
       <details>
         <summary>Python Code</summary>
  
            def solve():
            	# 키보드 배열을 좌표평면으로 본다. 
            	# Q를 (0,2)로, W를 (2,2) E를 (4,2) ...
            	# A를 (1,1), S를 (3,1), D를 (5,1) ...
            	# Z를 (2,0), X를 (4,0), C를 (6,0) ...
            	# 이후 x좌표 거리를 2로 나누고 y좌표 거리를 더한 후, y 좌표의 거리를 2로 나눈 값을 빼주면 실제 이동 거리가 나온다. 
            	# 단, x좌표가 동일할 경우에는 예외로 y좌표 거리가 실제 이동 거리이다. 
            	# 이는 y좌표가 3 초과여도 적용되는 규칙이다.
            	# ex1) Q(0,2) -> C(6,0) = (6/2 + 2) - 2/2 = 4
            	# ex2) T(8,2) -> V(8,0) = (0 + 2) = 2		(예외)
            	# ex3) Q(0,2) -> T(8,2) = (8/2 + 0) - 0 = 4
            	coord = {}
            	key3 = ['Q','W','E','R','T','Y','U','I','O','P']
            	key2 = ['A','S','D','F','G','H','J','K','L']
            	key1 = ['Z','X','C','V','B','N','M']
            	
            	MOVING_TIME = 2
            	TYPING_TIME = 1
            	
            	for i in range(len(key3)):
            		coord[key3[i]] = (i * 2, 2)
            		
            	for i in range(len(key2)):
            		coord[key2[i]] = (i * 2 + 1, 1)
            		
            	for i in range(len(key1)):
            		coord[key1[i]] = (i * 2 + 2, 0)
            		
            	word = input()
            	
            	time = len(word) * TYPING_TIME  # time elapsed when typing
            	prev = None
            	# for all words, calculate distance
            	for w in word:
            		if prev is None:
            			prev = w
            			continue
            		
            		start = coord[prev]
            		end = coord[w]
            		# rule exception
            		if start[0] == end[0]:
            			time += abs(end[1] - start[1]) * MOVING_TIME
            			prev = w
            			continue
            		
            		# time eplased when moving
            		time += (abs(end[0] - start[0]) // 2 + abs(end[1] - start[1]) - abs(end[1] - start[1]) // 2) * MOVING_TIME
            		
            		# settings for next cycle
            		prev = w
            	print(time)
            			
            if __name__ == '__main__':
            	T = int(input())
            	for t in range(T):
            		solve()
       </details>
     
   1. 모든 case를 구분하여 해결한 경우
       <details>
         <summary>C++ Code</summary>
         
            #include <map>
            #include <iostream>
            #define DEBUG 0
            using namespace std;
            
            int main(void) {
            	// initialize keyboard array
            	map<char,pair<int,int>> qwerty;
            	
            	char row1[] = {'Q','W','E','R','T','Y','U','I','O','P'};
            	char row2[] = {'A','S','D','F','G','H','J','K','L'};
            	char row3[] = {'Z','X','C','V','B','N','M'};
            	
            	for (int i = 0; i < (int)sizeof(row1); i++) {
            		qwerty.insert(make_pair(row1[i], make_pair(0, i)));
            	}
            	for (int i = 0; i < (int)sizeof(row2); i++) {
            		qwerty.insert(make_pair(row2[i], make_pair(1, i)));
            	}
            	for (int i = 0; i < (int)sizeof(row3); i++) {
            		qwerty.insert(make_pair(row3[i], make_pair(2, i)));
            	}
            	
            #if DEBUG
            	for (int i = 0; i < (int)sizeof(row1); i++) {
            		cout << qwerty[row1[i]].first << " " << qwerty[row1[i]].second << " ";
            	}
            	cout << endl;
            	for (int i = 0; i < (int)sizeof(row2); i++) {
            		cout << qwerty[row2[i]].first << " " << qwerty[row2[i]].second << " ";
            	}
            	cout << endl;
            	for (int i = 0; i < (int)sizeof(row3); i++) {
            		cout << qwerty[row3[i]].first << " " << qwerty[row3[i]].second << " ";
            	}
            	cout << endl;
            #endif
            	
            	// get input
            	int T;
            	char txt[110];
            	cin >> T;
            	
            	for (int t = 0; t < T; t++) {
            		cin >> txt;
            	
            		// calculate result
            		int total_diff = 0;
            		int pre_row = qwerty[txt[0]].first;
            		int pre_col = qwerty[txt[0]].second;
            		int idx = 1;
            		
            		while(txt[idx]) {
            			int row = qwerty[txt[idx]].first;
            			int col = qwerty[txt[idx]].second;
            			
            			int diff_row = abs(row - pre_row);
            			int diff_col = abs(col - pre_col);
            			
            			// ↔ direction
            			if (diff_row == 0) {
            				total_diff += diff_col;
            			}
            			// ↕ direction
            			else if (diff_col == 0) {
            				total_diff += diff_row;
            			}
            			// ↙ direction
            			else if (col < pre_col && row > pre_row) {
            				total_diff += max(diff_row, diff_col);
            			}
            			// ↗ direction
            			else if (col > pre_col && row < pre_row) {
            				total_diff += max(diff_row, diff_col);
            			}
            			// ↘ direction
            			else if (col > pre_col && row > pre_row) {
            				total_diff += diff_row + diff_col;
            			}
            			// ↖ direction
            			else {
            				total_diff += diff_row + diff_col;
            			}
            # if DEBUG
            			cout << "row: " << row << " col: " << col
            				<< " diff_row: " << diff_row << " diff_col: " << diff_col
            				<< " idx: " << idx << " total_diff: " << total_diff << endl;
            # endif
            			++idx;
            			pre_row = row;
            			pre_col = col;
            		} // -> while
            		
            		// print result
            		cout << idx + total_diff * 2 << endl;
            	} // -> for
            } // -> main
       </details>