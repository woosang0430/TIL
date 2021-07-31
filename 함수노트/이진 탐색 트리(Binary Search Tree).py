# 트리(Tree) 구조
- 트리 : Node와 Brach를 사용해 사이클을 이루지 않도록 구성한 데이터 구조

### 용어 정리
- `Node` : 트리에서 데이터를 저장하는 기본요소(데이터와 다른 연결된 노드에 대한 Branch 정보 포함)
- `Root Node` : 트리의 최상단 노드
- `Level` : 최상위 노드를 Level 0으로 하였을 때, 하위 Branch로 연결된 노드의 깊이를 나타냄
- `Parent Node` : 어떤 노드의 다음 레벨에 연결된 노드
- `Child Node` : 어떤 노드의 상위 레벨에 연결된 노드
- `Leaf Node(Terminal Node)` : Child Node가 하나도 없는 노드
- `Sibling (Brother Node)` : 동일한 Parent Node를 가진 노드
- `Depth` : 트리에서 Node가 가질 수 있는 최대 Level

![image](https://user-images.githubusercontent.com/77317312/127736380-63e3b6db-aae7-4377-b855-e9d012a43b01.png)

# Binary Search Tree 구현하기
> - **트리(Tree)**는 `Node`와 `Branch`를 이용해 사이클을 이루지 않도록 구성한 데이터 구조이다.
> - 주로 최대 Branch 갯수가 2개인 **이진 트리(Binary Tree)**를 많이 사용한다.

## 이진 탐색 트리(BST, Binary Search Tree)
- 이진 트리인 동시에 왼쪽 자식 노드는 해당 노드보다 작은 값
- 오른쪽 자식 노드는 해당 노드보다 큰 값을 가지는 특징을 지닌다.
- 데이터 검색 속도가 빠르다는 장점을 갖는다.
- 주로 탐색(검색) 알고리즘 구현을 위해 많이 사용됨

## 이진 탐색 트리 삭제
- 매우 복잡하므로, 경우를 나눠 이해하는 것이 좋음

### 1. Leaf Node 삭제
- 삭제할 Node의 Parent Node가 삭제할 Node를 가리키지 않도록 한다.

### 2. Child Node가 하나인 Node삭제
- 삭제할 Node의 Parent Node가 삭제할 Node의 Child Node를 가리키도록 한다.

### 3. Child Node가 두 개인 Node 삭제
- **삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 삭제할 Node의 Parent Node가 가리키도록한다.**
- 삭제할 Node의 왼쪽 자식 중, 가장 큰 값을 삭제할 Node의 Parent Node가 가리키도록한다.


### 파이썬 객체지향 프로그래밍으로 링크드 리스트 구현
```python
class Node:
  def __init__(self, value):
    self.value = value
    self.left = None
    self.right = None

class NodeMgmt:
  def __init__(self, head):
    self.head = head
    
  def insert(self, value):
    self.current_node = self.head
    while True:
      if value < self.current_node.value:
        if self.current_node.left != Node:
          self.current_node = self.current_node.left
        else:
          self.current_node = Node(value)
          break
  
  def search(self, value):
    self.current_node = self.head
    while self.current_node:
      if self.current_node.value == value:
        return True
      elif value < self.current_node.value:
        self.current_node = self.current_node.left
      else:
        self.current_node = self.current_node.right
    return False
  
  def delete(self, value): # 함수 내 삭제할 Node의 데이터인 value를 입력으로 받음
    searched = False # 삭제할 Node가 있는지 판단하는 변수 선언
    self.current_node = self.head
    self.parent = self.head
    
    while self.current_node:
      if self.current_node.value == value:
        searched = True
        break
      elif value < self.current_node.value:
        self.parent = self.current_node
        self.current_node = self.current_node.left
      else:
        self.parent = self.current_node
        self.current_node = self.current_node.right
    
    return searched
```





















[참고](https://www.fun-coding.org/Chapter10-bst.html)
