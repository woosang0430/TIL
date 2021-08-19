## 🥑🪓🥑 Disjoint-Set(분리 집합)
------

### 📒Define
----
- 중복되지 않는 부분집합들로 나눠진 원소들에 대한 정보를 저장/조작하는 자료구조
- 전체 집합이 있을 때 구성 원소들이 겹치지 않도록 분할하는데 사용함
- Set A의 모든 원소가 Set B에 포함되면 A는 B의 **부분집합**, B는 A의 **초월집합**
- Set A와 Set B의 공유 원소가 없을 때 **mutually disjoint**(서로 분리집합)
- 임의의 Set을 분할 --> 각 부분집합의 합이 원래의 Set이 되어야 하며 각 부분집합끼리는 mutually disjoint.

> #### ex) Set = 1,2,3,4 / A = 1,2 / B = 3,4 / C = 2,3,4 / D = 4
> - A + B는 Set의 분할
> - A + C | A + D는 분할이 아닙

### 🛠Method
-----
- `make-set(x)` : x를 유일한 원소로 하는 Set 생성
- `union(x, y)` : x가 속한 Set과 Y가 속한 Set을 병합
- `find(x)` : x가 속한 Set의 대푯값(Root Node value)을 반환

> - `A = {2, 3}`인 Disjoint Set이 있을 경우
>   - 맨 처음 들어간 원소 2가 **Root Node**
>   - 이 경우 `find(3)` 실행 시 **3이 들어간 Set의 Root Node** 값을 반환`(2)`
> - `B = {1, 4}`인 Disjoint Set이 있을 경우
>   - `A의 Root Node인 2`와 `B의 Root Node인 1`을 연결
>   - 이 경우 `find(4)` 실행 시 **A와 B의 결합된 루트노드 값** 반환

### 🎠Union
-----
- `union(x, y)`은 다음과 같은 과정들로 이루어짐
  - x가 속한 disjoint Set을 find로 찾음
  - y가 속한 Set을 find로 찾음
  - 찾은 두 Set을 합친다.

> - 1-1. union by size
>   - 임의의 두 disjoint Set을 합칠 때 원소수가 적은 set을 많은 set의 서브트리로 합치는 것이 효율적
>   - union에서 사용되는 find 연산의 효율성을 향상을 위해 사용
>   - O(1)
> - 1-2. union by height
>   - 임의의 두 disjoint Set을 합칠 때 트리의 높이가 작은 set을 높은 set의 서브트리로 합치는 것이 효율적
>   - O(1)

### 💻implement
---
```python
# 부모 노드의 값을 얻는 함수
def get_parent(parents, x):
  if parents[x] == x:
    return x
  # 압축 과정
  press = get_parent(parents, parents[x])
  parents[x] = press
  return press
  
# 두 부모 노드를 합치는 함수
def union_parent(parents, x1, x2, cnt):
  A = get_parent(parents, x1)
  B = get_parent(parents, x2)
  if a != b:
    parents[b] = a
    cnt[a] += cnt[b]
 
# 루트 찾기
def find_parent(x, parents):
  if parents[x] == x:
    return x
  return fnd_parent(parents[x], parents)
```
[출처](https://m.blog.naver.com/good5229/221819936100)
