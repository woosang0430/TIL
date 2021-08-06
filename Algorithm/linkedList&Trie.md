# LinkedList
- 각 노드가 데이터와 포인터를 가지고 한 줄로 연결되어 데이터를 저장하는 자료구조

```python
class Node():
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList():
    def __init__(self):
        self.head = None
        self.count = 0
    
    def appendleft(self, node):
        if self.head == None:
            self.head = node
            self.count = 1
        else:
            currHead = self.head
            self.head = node
            node.next = currHead
            self.count += 1
    
    def append(self, node):
        if self.head == None:
            self.head = node
            self.count = 1
        else:
            currNode = self.head
            while currNode.next:
                currNode = currNode.next
            currNode.next = node
            self.count += 1
    
    def insert(self, node, idx):
        if idx not in range(self.count):
            return -1
        elif idx == self.count:
            self.append(node)
        elif idx == 0:
            self.appendleft(node)
        else:
            currNode = self.head
            while idx:
                currNode = currNode.next
                idx -= 1
            tmp = currNode.next
            currNode.next = node
            node.next = tmp
            self.count += 1

    def delete(self, data):
        if self.head.data == data:
            self.head = self.head.next
            self.count -= 1
        else:
            first = self.head
            second = self.head.next
            while second != None:
                if second.data == data:
                    first.next = second.next
                    self.count -= 1
                    break
                else:
                    first = second
                    second = second.next

    def getCount(self):
        return self.count
```




















































