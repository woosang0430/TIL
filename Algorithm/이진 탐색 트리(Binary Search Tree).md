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
#### case.1 삭제할 Node가 Child Node를 두개 가지고 있는 경우(삭제할 Node가 Parent Node **왼쪽**에 있을 때)
1. case : **삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 삭제할 Node의 Parent Node가 가리키도록한다.**
2. case : 삭제할 Node의 왼쪽 자식 중, 가장 큰 값을 삭제할 Node의 Parent Node가 가리키도록 한다.
> - 쉽게 이해하기 위해 `삭제할 Node`를 `A`라는 변수에 담아 이해하자
'''
A = 삭제할 Node
A의 오른쪽 자식 중, 가장 작은 값을 A의 parent Node가 가리키도록한다.
'''
#### case.2로 코드 구현
- 3-1-1. 삭제할 Node가 Parent Node의 왼쪽에 있고, 삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 가진 Node의 Child Node가 없을 때
- 3-2-1. 삭제할 Node가 Parent Node의 왼쪽에 있고, 삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 가진 Node의 오른쪽에 Child Node가 있을 때
  - 가장 작은 값을 가진 Node의 Child Node가 왼쪽에 있을 경우는 없음.(because. 왼쪽 Node가 있다는 것은 해당 Node보다 더 작은 값을 가진 Node가 있다는 뜻이기 때문)

![image](https://user-images.githubusercontent.com/77317312/127776348-4e079c47-f25d-4878-90fb-be351fb0cd2f.png)

#### case.2 삭제할 Node가 Child Node를 두개 가지고 있는 경우(삭제할 Node가 Parent Node **오른쪽**에 있을 때)
1. case : **삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 삭제할 Node의 Parent Node가 가리키도록한다.**
2. case : 삭제할 Node의 왼쪽 자식 중, 가장 큰 값을 삭제할 Node의 Parent Node가 가리키도록 한다.

- 3-2-1. 삭제할 Node가 Parent Node의 왼쪽에 있고, 삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 가진 Node의 Child Node가 없을 때
- 3-2-2. 삭제할 Node가 Parent Node의 왼쪽에 있고, 삭제할 Node의 오른쪽 자식 중, 가장 작은 값을 가진 Node의 오른쪽에 Child Node가 있을 때
  - 가장 작은 값을 가진 Node의 Child Node가 왼쪽에 있을 경우는 없음.(because. 왼쪽 Node가 있다는 것은 해당 Node보다 더 작은 값을 가진 Node가 있다는 뜻)

![image](https://user-images.githubusercontent.com/77317312/127777283-bb151a4c-e4f3-4228-92ce-03dbc06b47b1.png)


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
      # 삭제할 노드 탐색
      if self.current_node.value == value:
        searched = True
        break
      elif value < self.current_node.value:
        self.parent = self.current_node
        self.current_node = self.current_node.left
      else:
        self.parent = self.current_node
        self.current_node = self.current_node.right
    
    # 삭제할 Node가 없는 경우 처리
    if searched == False: # delete할 Node가 없으면, False 리턴 후 함수 종료
      return False
# 이 라인에 오면, self.current_node가 삭제할 Node, self.parent는 삭제할 Node의 parent Node인 상태가 된다.

    # 삭제할 Node가 Leaf Node인 경우
    if self.current_node.left == None and self.current_node.right == None:
      if value < self.parent.value:
        self.parent.left = None
      else:
        self.parent.right = None
    
    # 삭제할 Node가 Child Node를 한 개 가지고 있는 경우
    if self.current_node.left != None and self.current_node.right == None:
      if value < self.parent_node.value:
        self.parent_node.left = self.current_node.left
      else:
        self.parent_node.right = self.current_node.left
    elif self.current_node.left == None and self.current_node.right != None:
      if value < self.parent_node.value:
        self.parent_node.left = self.current_node.right
      else:
        self.parent_node.right = self.parent_node.right
        
    # 삭제할 Node가 Child Node를 두 개 가지고 있는 경우(삭제할 Node가 Parent Node 왼쪽에 있을 때)
    # self.current_node가 삭제할 Node, self.parent는 삭제할 Node의 Parent Node인 상태가 됨
    if self.current_node.left != None and self.current_node.right != None:
      # 삭제할 Node가 Parent Node 왼쪽에 있는 경우
      if value < self.parent.value:
        self.change_node = self.current_node.right
        self.change_node_parent = self.current_node.right
        
        while self.change_node.left != None:
          self.change_node_parent = self.change_node
          self.change_node = self.current_node.left
        
        self.change_node_parent.left = None
        if self.change_node.right != None:
          self.change_node_parent.left = self.change_node.right
        else:
          self.change_node_parent.left = None
        
        self.parent.left = self.change_node
        self.change_node.right = self.change_node_parent
        self.change_node.left = self.current_node.left
      # 삭제할 Node가 Parent Node 오른쪽에 있는 경우
      else:
        self.change_node = self.current_node.right
        self.change_node_parent = self.current_node.right
        
        while self.change_node != None:
          self.change_node_parent = self.change_node
          self.change_node = self.current_node.left
        
        self.change_node_parent.left = None
        if self.change_node.right = != None:
          self.change_node_parent.left = self.current_node.right
        else:
          self.change_node_parent.left = None
          
        self.parent.left = self.change_node
        self.change_node.right = self.change_node_parent
        self.change_node.left = self.current_node.left
```

#### REVIEW
```python
class Node():
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

class BST():
    def __init__(self, head):
        self.head = head
        self.count = {}
    
    def search(self, value):
        self.current_node = self.head
        while self.current_node != None:
            if self.current_node.value == value:
                return True
            elif value < self.current_node.value:
                self.current_node = self.current_node.left
            else:
                self.current_node = self.current_node.right
        return False
    
    def insert(self, value):
        self.current_node = self.head
        while True:
            if value < self.current_node.value:
                if self.current_node.left != None:
                    self.current_node = self.current_node.left
                else:
                    self.current_node.left = Node(value)
                    break
            elif self.current_node.value < value:
                if self.current_node.right != None:
                    self.current_node = self.current_node.right
                else:
                    self.current_node.right = Node(value)
                    break
            else:
                key = self.current_node.value
                if self.count.get(key) == None:
                    self.count[key] = 0
                else:
                    self.count[key] += 1

    def delete(self, value):
        searched = False
        self.current_node = self.head
        self.parent = self.head

        while self.current_node != None:
            if self.current_node.value == value:
                searched = True
                break
            elif value < self.current_node.value:
                self.parent = self.current_node
                self.current_node = self.current_node.left
            else:
                self.parent = self.current_node
                self.current_node = self.current_node.right

        if searched == False:
            return False
        
        # case1
        if self.current_node.left == None and self.current_node.right == None:
            if value < self.parent.value:
                self.parent.left = None
            else:
                self.parent.right = None

        # case2
        elif self.current_node.left != None and self.current_node.right == None:
            if value < self.parent.value:
                self.parent.left = self.current_node.left
            else:
                self.parent.right = self.current_node.left
        elif self.current_node.left == None and self.current_node.right != None:
            if value < self.parent.value:
                self.parent.left = self.current_node.right
            else:
                self.parent.right = self.current_node.right

        # case3
        elif self.current_node.left != None and self.current_node.right != None:
            if value < self.current_node.value:
                self.change_node = self.current_node.right
                self.change_node_parent = self.current_node.right

                while self.change_node != None:
                    self.chage_node_parent = self.change_node
                    self.chage_node = self.change_node.left

                if self.chage_node.right != None:
                    self.change_node_parent.left = self.chage_node.right
                else:
                    self.change_node_parent.left = None

                self.parent.left = self.change_node
                self.change_node.left = self.current_node.left
                self.change_node.right = self.change_node_parent
            else:
                self.change_node = self.current_node.right
                self.change_node_parent = self.current_node.right

                while self.change_node != None:
                    self.change_node_parent = self.change_node
                    self.change_node = self.change_node.left

                if self.change_node.right != None:
                    self.change_node_parent.left = self.change_node.right
                else:
                    self.change_node_parent.left = None
                
                self.parent.right = self.change_node
                self.change_node.left = self.current_node.left
                self.change_node.right = self.change_node_parent

        return True

# test
if __name__ == '__main__':
    import random

    bst_nums = set()
    while len(bst_nums) != 100:
        bst_nums.add(random.randint(0, 999))

    head = Node(500)
    binary_tree = NodeMgmt(head)
    for num in bst_nums:
        binary_tree.insert(num)

    # for num in bst_nums:
    #     if binary_tree.search(num) == False:
    #         print('search failed', num)

    delete_nums = set()
    bst_nums = list(bst_nums)
    while len(delete_nums) != 10:
        delete_nums.add(bst_nums[random.randint(0, 99)])

    for del_num in delete_nums:
        if binary_tree.delete(del_num) == False:
            print('search faild', delete_nums,  del_num)
```


[참고](https://www.fun-coding.org/Chapter10-bst.html)
