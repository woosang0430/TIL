# deque 함수
    - 인덱싱, 슬라이싱 등의 기능은 사용 불가
    - but 연속적으로 나열된 데이터의 시작 부분 or 끝부분에 데이터를 삽입 혹은 삭제하는데 효과적으로 사용된다.
    - 또한 deque는 스택이나 큐 자료구조의 대용으로 사용 될 수도 있다.
  
### deque 사용법
- 제거
    - `.popleft()` : 리스트의 첫 번째 원소 제거
    - `.pop()` : 리스트의 마지막 원소 제거
- 삽입
    - `.appendleft()` : 리스트 첫 번째 인덱스에 원소 삽입
    - `.append()` : 리스트 마지막 인덱스에 원소 삽입
#### 사용 예시
```python
from collections import deque

data = deque([2,3,4])
data.appendleft(1)
data.append(5)

print(data)
print(list(data)) # 리스트 자료형으로 변환
"""
결과값
deque([1,2,3,4,5])
[1,2,3,4,5]
"""
``` 

# Counter 함수
    - 등장 횟수를 세는 기능을 제공
    - iterable 객체가 주어졌을 때, 해당 객체 내부의 원소가 몇 번씩 등장했는지 알려준다.
  
#### 사용 예시
```python
from collections import Counter

counter = Counter(['red', 'blue', 'red', 'green','blue', 'blue'])

print(counter['blue'])  # 'blue'가 등장한 횟수 출력
print(counter['green']) # 'green'이 등장한 횟수 출력
print(dict(counter))    # dictionary로 변환

3
1
{'red': 2, 'blue': 3, 'green': 1}
```

- Counter를 이용한 연산
    - 산술/집합 연산이 가능하다.
    
- 사용 예제 (`+`, `-`)
```python
import collections

a = collections.Counter('aabbccdd')
b = collections.Counter('abbbce')

print(a)
print(b)
print(a+b)
print(a-b)
'''
결과값
Counter({'a': 2, 'b': 2, 'c': 2, 'd': 2})
Counter({'b': 3, 'a': 1, 'c': 1, 'e': 1})
Counter({'b': 5, 'a': 3, 'c': 3, 'd': 2, 'e': 1})
Counter({'d': 2, 'a': 1, 'c': 1})
'''
```
- 사용 예제(교집합(`&`) 과 합집합(`|`)
```python
import collections

a = collections.Counter('aabbccdd')
b = collections.Counter('aabbbce')

print(a & b)
print(a | b)
'''
결과
Counter({'b': 2, 'a': 2, 'c': 1})
Counter({'b': 3, 'c': 2, 'd': 2, 'a': 2, 'e': 1})
'''
```
