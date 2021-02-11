- 노드 == 도시, 간선 == 도로 라고 생각하기!
# DFS(depth-first-search)
- 깊이 우선 탐색이라 부른다.
- 그래프에서 깊은 부분을 우선적으로 탐색하는 알고리즘
- DFS는 stack자료구조를 이용하며 재귀함수를 같이쓰인다.
- DFS예제

```python
def dfs(graph, v, visited):
  # 현재 노드를 방문 처리
  visited[v] = True
  print(v, end=" ")
  # 현재 노드와 연결된 다른 노드를 재귀적으로 방문
  for i in graph[v]:
    if not visited[i]:
      dfs(graph, i, visited)
graph = [
    [],
    [2,3,8],
    [1,7],
    [1,4,5],
    [3,5],
    [3,4],
    [7],
    [2,6,8],
    [1,7]
]

# 각 노드가 방문된 정보를 리스트 자료형으로 표현
visited = [False] * len(graph)

# 정의된 DFS 함수 호출
dfs(graph, 1, visited)

# 결과값 : 1 2 7 6 8 3 4 5
```

# BFS(breadth first search)
- 너비 우선 탐색이라는 의미를 가진다.
- 가까운 노드부터 탐색하는 알고리즘
- collections 모듈의 deque 라이브러리는 사용
- 일반적인 경우 실제 수행 시간은 DFS보다 좋은 편이다.
- bfs 예제
```python
from collections import deque

def bfs(graph, start, visited):
  # 큐(Queue) 구현을 위해 deque 라이브러리 사용
  queue = deque([start])
  # 현재 노드를 방문 처리
  visited[start] = True
  # 큐가 빌 때까지 반복
  while queue:
    # 큐에서 하나의 원소를 뽑아 출력
    v = queue.poplift()
    print(v, end = " ")
    # 해당 원소와 연결된, 아직 방문하지 않은 원소들을 큐에 삽입
    for i in graph[v]:
      if not visited[i]:
        queue.append(i)
        visited[i] = True

# 각 노드가 연결된 정보를 리스트 자료형으로 표현(2차원 리스트)
graph = [
    [],
    [2,3,8],
    [1,7],
    [1,4,5],
    [3,5],
    [3,4],
    [7],
    [2,6,8],
    [1,7]
]

# 각 노드가 방문된 정보를 리스트 자료형으로 표현(1차원 리스트)
visited = [False] * len(graph)

bfs(graph, 1, visited)
# 결과값 : 1 2 3 8 7 4 5 6



```
