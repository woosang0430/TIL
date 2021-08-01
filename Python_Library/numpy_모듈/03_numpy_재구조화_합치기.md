## 한눈에 보기
> 배열 형태 변경
> - np.reshape(a, newshape) # 원하는 대로 지정해서 바꿔줄께
> - ndarray.reshape(newshape) 
> 
> 차원 늘리기
> - np.newaxis # 속성(변수)을 이용한 차원 늘리기
> 
> - numpy.expand_dims (배열, axis) # 매개변수로 받은 배열에 지정한 axis의 rank 확장
> 
> 차원 줄이기
> - np.squeeze(배열, axis=None) # 차원 줄이기
> - 배열객체.squeeze(axis=None)
> 
> - ndarray.flatten() # 1차원 배열로 바꿔는 친구
> 
> append / insert / delete
> - np.append(배열, 추가할값, axis=None) # 마지막 idx에 추가
> 
> - np.insert(배열, idx, 추가할값, axis=None) # 원하는 idx에 삽입
> 
> - np.delete(배열, 삭제할idx, axis=None) # 원하는 idx의 값 삭제
> 
> 배열 합치기
> - np.concatenate(합칠 배열리스트, axis=0)
> 
> - np.vstack(합칠배열리스트)
> 
> - np.hstack(합칠배열리스트)
> 
> 배열 분할 하기
> - np.split(배열, 분할기준, axis)
> 
> - np.vsplit(배열, 분할기준)
> 
> - np.hsplit(배열, 분할기준)

# 배열의 형태(shape) 변경

## 1. reshape()를 이용한 차원 변경 (만능 치트키)
- `numpy.reshape(arr, newshape)` 또는 `ndarray.reshape(newshape)`
    - `a` : 형태를 변경할 배열
    - `newshape` : 변경할 형태 설정
        - 원소의 개수를 유지하는 shape으로만 변환 가능
    - 원본 배열을 변경시키지 않는다.(shape을 바꾼 새로운 배열을 반환)
    - 변경하는 배열의 사이즈가 같아야한다.
```python
import numpy as np

a = np.arange(10)
# [0 1 2 3 4 5 6 7 8 9]

b = np.reshape(a, (2,5))
# [[0 1 2 3 4]
#  [5 6 7 8 9]]


f = np.arange(5*5*5).reshape(5,5,5)
g = np.arange(3*2*7).reshape(3,2,7)
print(f.shape)
print(g.shape)
#(5, 5, 5)
#(3, 2, 7)
```
## 2. 차원 늘리기(확장)
### 2-1. `numpy.newaxis` 속성을 이용한 차원 늘리기(변수)
- `np.newaxis` == 1 이라고 생각하자
- size가 1인 축(axis)를 늘릴 때 사용
    - 지정한 axis에 size 1인 축을 추가
- slicing에 사용하거나 indexing에 `...`과 같이 사용
    - slicing의 경우 원하는 위치의 축을 늘릴 수 있다.
    - index에 `...`과 사용하는 경우 첫 번쨰나 마지막 축을 늘릴때 사용
```python
import numpy as np

a = np.arange(1, 6)
print(a.shape)
# (5,)

a1 = a[np.newaxis, :]
print(a1.shape)
# (1, 5)

a2 = a[np.newaxis, :, np.newaxis]
print(a2.shape)
# (1, 5, 1)
```
### 2-2. indexing에 ...과 같이 사용
- `ndarray[..., np.newaxis]`
- 첫번째 축이나 마지막 축을 늘릴 때만 사용가능
```python
b = np.arange(6).reshape(2, 3)
print(b.shape)
# (2, 3)

b2 = b[..., np.newaxis]
print(b2.shape)
# (2, 3, 1)
```
### 2-3. numpy.expand_dims(배열, axis)
- 매개변수로 받은 배열에 지정한 axis의 rank를 확장한다.
```python
import numpy as np

a = np.arange(1, 6)
print(a.shape)
print(a)
# (5,)
# [1, 2, 3, 4, 5]

a1 = np.expand_dims(a, axis=1)
print(a1.shape)
print(a1)
# (5, 1)

# [[1],
#  [2],
#  [3],
#  [4],
#  [5]]
```
## 3. 차원 줄이기(축소)
### 3-1. numpy.squeeze(배열, axis=None), 배열객체.squeeze(axis=None)
- 배열에서 지정한 축(axis)을 제거하여 차원(rank)를 줄인다.
- **제거하려는 축의 size는 1이어야 한다.**
- 축을 지정하지 않으면 size가 1인 모든 축을 제거한다.
    - (3,1,2,1) -> (3,2)
```python
import numpy as np

a = np.arange(12).reshape(1,2,1,2,3,1)
print(a.shape)
# (1, 2, 1, 2, 3, 1)

b = np.squeeze(a)
print(b.shape)
# (2, 2, 3)

c = np.squeeze(a, axis=2) # size가 1이 아닌 축은 제거가 안됨.
print(c.shape)
# (1, 2, 2, 3, 1)
```
### 3-2. 배열객체.flatten()
- 다차원 배열을 1차원으로 만든다.
```python
import numpy as np

#(2,3) -> (6,) / (2,2,2,3) -> (24, )
a = np.arange(20).reshape(2,2,5)
print(a.shape)
# (2, 2, 5)

a2 = a.flatten()
print(a2.shape)
# (20,)
```
## 4. .append() / .insert() / .delete()
-  축(axis)  지정하는것을 유의해야 한다.
-  원본은 바뀌지 않고 새로운 배열로 반환
### 4-1. numpy.append(배열, 추가할 값, axis=None)
- `배열`의 마지막 index에 `추가할 값`을 추가
- `axis` : 축 지정
    - `None`(default) : flatten 한 뒤 추가한다.
```python
import numpy as np

# 1차원 배열 append
a = np.array([1,2,3])

a1 = np.append(a, 100) # 1개의 값 추가
print(a1) 
# [  1,   2,   3, 100]

a2 = np.append(a, [200,300,400]) # 한번에 여러개의 값 추가
print(a2)
# [  1,   2,   3, 200, 300, 400]

# 다차원 배열 append
l = [
    [1,1],
    [2,2],
    [3,3]
]

b = np.array(l)
print(b)
# [[1 1]
#  [2 2]
#  [3 3]]

b1 = np.append(b, [[4,4]], axis=0)
print(b1)
# [[1 1]
#  [2 2]
#  [3 3]
#  [4 4]]

b2 = np.append(b, , [[4],[4],[4]]axis=1)
print(b2)
# [[1 1 4]
#  [2 2 4]
#  [3 3 4]]

print(np.append(b, [10,20])) # 다차원배열에서 axis 생략 : flatten() 이후 append()
# [ 1,  1,  2,  2,  3,  3, 10, 20]
```
### 4-2. numpy.insert(배열, index, 추가할 값, axis=None)
- `배열`의 `index`에 `추가할 값`을 추가
- `axis` : 축 지정
    - `None`(default) : flatten 한 뒤 삽입한다.
```python
import numpy as np

# 1차원
a = np.array([1,2,3])

a1 = np.insert(a, 2, 20) # idx 2에 20 삽입
print(a1)
# [  1,   2, 200,   3]

# 다차원
b = np.array([[1,1],[2,2],[3,3]])

b1 = np.insert(b, 0, [4,4], axis=0)
print(b1)
# [[4 4]
#  [1 1]
#  [2 2]
#  [3 3]]

b2 = np.insert(b, 0, [4,4,4], axis=1))
# [[4 1 1]
#  [4 2 2]
#  [4 3 3]]

print(np.insert(b, 1, 10) # axit 생략, flatten() 이후 insert()
# [  1, 100,   1,   2,   3]
```
### 번외 append()와 insert() 조금의 차이가 있다.
```python
print(np.append(b, [[10],[20],[30]], axis=1)
# [[ 1,  1, 10],
#  [ 2,  2, 20],
#  [ 3,  3, 30]]
print(np.insert(b, 2, [10,20,30], axis=1)
##print(np.insert(b, 2, [[10],[20],[30]], axis=1) 이것도 
# [[ 1,  1, 10],
#  [ 2,  2, 20],
#  [ 3,  3, 30]]
```

### 4-3. numpy.delete(배열, 삭제할index, axis=None)
- `배열`의 `삭제할 index`의 값들을 삭제한다.
- `삭제할 index`는 index or slice
- `axis` : 축 지정
    - `None`(default) : flatten 한 뒤 삭제한다.
```python
# 1차원
a = np.arange(10)
print(a)
# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

a1 = np.delete(a, 0)
print(a1)
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

a2 = np.delete(a, [2,5,6])
print(a2)
# [0, 1, 3, 4, 7, 8, 9]

# slicing을 이용해서 삭제 가능
# slicing을 함수의 매개변수로 전달할 경우 np._s[slicing]
print(np.delete(a, a[::2]))
print(np.delete(a, np.s_[::2]))
# [1 3 5 7 9]
# [1 3 5 7 9]

# 다차원
b = np.arange(9).reshape(3,3)
print(b)
# [[0, 1, 2],
#  [3, 4, 5],
#  [6, 7, 8]]
b1 = np.delete(b, [0,1], axis=0)
print(b1)
# [[6, 7, 8]]
b2 = np.delete(b, [0,1], axis=1)
print(b2)
# [[2],
#  [5],
#  [8]]
print(np.delete(b, 0)) # axis생략 : flatten()후에 delete()
# [1, 2, 3, 4, 5, 6, 7, 8]
```
## 5. 배열 합치기
> a : (3,2), b : (3,5) : axis=1 (3, 7)
> a : (4,2), b : (4,2) : axis=0 (8,2), axis=1 (4,4)
> a : (2,3,5), b : (3,1,5) : xxx # 3차원인 경우 rank의 값이 한개만 달라야한다.
> a : (2,3,5), b : (7,3,5) : axis=0 (9,3,7)

### 5-1. np.concatenate(합칠 배열리스트, axis=0)
- 여러 배열을 **축의 개수(rank)**를 유지하며 합친다.
- `axis` : 축지정
    - 지정된 축을 기준으로 합친다.
    - default : 0
- 합치는 배열의 축의 개수(rank)는 같아야 한다.
    - 같은 차원끼리 합칠 수 있다.
- axis속성으로 **지정한 축 이외의 축의 크기가 같아**야 한다.
- 결과의 축의 개수(rank)는 대상 배열의 rank와 같다.
    - 1차원 끼리 합치면 1차원 결과가 나옴
- 2차원끼리, 3차원끼리, n차원끼리
```python
import numpy as np

x = np.arange(6).reshape(2,3)
y = np.arange(10, 16).reshape(2,3)
z = np.arange(20, 26).reshape(2,3)
print(x.shape, y.shape, z.shape)
# (2, 3) (2, 3) (2, 3)

r = np.concatenate([x,y], axis=0)
print(r.shape)
# (4, 3)
```
### 5-2. vstack(합칠배열리스트) # 2차원 배열 전용!
- 수직으로 쌓는다.
- `concatenate()`의 axis=0와 동일
- 합칠 배열들의 열수가 같아야 한다.
```python
import numpy as np

x = np.arange(6).reshape(2,3)
y = np.arange(10, 16).reshape(2,3)
z = np.arange(20, 26).reshape(2,3)

# np.vstack([x,w]) # 1번축의 개수가 같아야 한다.
print(x.shape, y.shape, z.shape)
# (2, 3) (2, 3) (2, 3)

print(np.vstack([x,y,z]).shape)
# (6, 3)
```

### 5-3. hstack(합칠배열리스트) # 2차원 배열 전용!
- 수평으로 쌓는다.
- `concatenate()`의 axis=1와 동일
- 합칠 배열들의 행 수가 같아야 한다.
```python
import numpy as np

x = np.arange(6).reshape(2,3)
y = np.arange(10, 16).reshape(2,3)
z = np.arange(20, 26).reshape(2,3)

# np.hstack([x,r]) # 0번축의 개수가 같아야한다.
print(np.hstack([x,y,z]).shape)
# (2, 9)
```
## 6. 배열 나누기
### 6-1. split(배열, 분할기준, axis)
- 지정한 축 기준 배열 나눈다.
- 반환값 : 분할한 ndarray를 가진 리스트로 리턴
- `배열` : 분할한 배열
- `분할기준`
    - 정수 : 지정 개수만큼 분할
    - 리스트 : 분할 기준 idx들
- `axis(축)`
    - 분할할 기준 축을 지정. axis=0 (default)
    - 2D의 경우 axis=0 -> 행 기준 분할, axis=1 -> 열 기준 분할
- 정수로 분할할 경우 사이즈를 정수로 나눴을 때 나머지가 0이 되어야 한다.
- 사용예제
```python
import numpy as np

a = np.arange(10)
# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

r = np.split(a, 2) # a를 2개로 분할
print(r[0])
print(r[1])
# [0 1 2 3 4]
# [5 6 7 8 9]

r = np.split(a, [2,6]) # a를 2와 6을 기준으로 분할
print(r[0])
print(r[1])
print(r[2])
"""
[0, 1]
[2, 3, 4, 5]
[6, 7, 8, 9]
"""
```
### 6-2. vsplit(배열, 분할기준)
- 행 기준 분할
- `split()`의 axis=0과 동일
- 분할기준
    - 정수 : 지정 개수만큼 분할
    - 리스트 : 분할 기준 idx들
- **주의** : 분할기준을 정수(개수)로 할 경우 분할후 원소수가 같아야 한다.
- 사용예제
```python
import numpy as np

c = np.arange(64).reshape(8,8)
print(c.shap)
# (8,8)

# vsplit() => split(axis=0) # 수직
r = np.vsplit(c, 4)
print(r[0].shape, r[1].shape, r[2].shape, r[3].shape)
#(2, 8) (2, 8) (2, 8) (2, 8)

r = np.vsplit(c, [3,6])
print(r[0].shape, r[1].shape, r[2].shape)
(3, 8) (3, 8) (2, 8)
```
### 6-3. hsplit(배열, 분할기준)
- 열 기준 분할
- `split()`의 axis=0과 동일
- 분할기준
    - 정수 : 지정 개수만큼 분할
    - 리스트 : 분할 기준 idx들
- **주의** : 분할기준을 정수(개수)로 할 경우 분할후 원소수가 같아야 한다.
- 사용예제
```python
import numpy as np

c = np.arange(64).reshape(8,8)
print(c.shap)
# (8,8)

# hsplit() => split(axis=1) # 수평
r = np.hsplit(c, 4)
print(r[0].shape, r[1].shape, r[2].shape, r[3].shape)
# (8, 2) (8, 2) (8, 2) (8, 2)

r = np.hsplit(c, [2,5])
print(r[0].shape, r[1].shape, r[2].shape)
# (8, 2) (8, 3) (8, 3)
```
