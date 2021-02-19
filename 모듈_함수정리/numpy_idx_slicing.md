## 맛보기
> indexing
> - ndarray[]
>     - 2차원 배열 : `ndarray[행idx, 열idx]`
>     - N차원 배열 : `ndarray[0축 idx, 1축 idx, .., n축 idx]`
> - 팬시(fancy) indexing # 한번에 여러개 조회
>     - `ndarray[[1,2,3,4,5]]`
>     - `ndarray[[0,3],[1,4]]`
> 
> slicing
> - `ndarray[start : stop : step]`
> - 다차원 배열 슬라이싱
> - `ndarray[0축 slicing, 1축 slicing, .., n축 slicing]`
> 
> - `ndarray.copy()` # 배열을 복사한 새로운 배열 생성
> 
> boolean indexing(많이쓰임)
> - `ndarray[boolean_list]` # True인 idx의 값 반환
> - `ndarray[ndarray > 10]` # ndarray의 10초과인 값의 idx값만 반환(특정조건을 만족하는 애들만!)
> 
> 넘파이 비교연산자
> - ndarray[(ndarray > 10) `&` (ndarray < 30)] # `and`
> - ndarray[(ndarray > 10) `|` (ndarray < 30)] # `or`
> - ndarray[`~`(ndarray > 50)] # `not`
> 
> np.where() - 조건절 같은 친구
> - `np.where(boolean 배열)` # True인 idx들 tuple안에 넣어 ndarray에 담아 반환
> - `np.where(ndarray > 50)` # 50 초과인 값들의 idx 조회
> - `np.where(ndarray > 50, "o", "x")` # 50초과인 값은 임의로 정의(True -> "o", False -> "x")
> 
> - `np.any(boolean 배열)` # True가 한개라도 있으면 True
> - `np.all(boolean 배열)` # False가 한개라도 있으면 False
> 
> 정렬 (default = 오름차순)
> - `np.sort()` # 정렬한 값 반환
>     - `np.sort(a)[::-1]` 내림차순
> 
> - `ndarray.sort()` # 배열 자체를 정렬
> 
> - `np.argsort()` # 정렬을 하긴하는데 원래의 idx를 반환
>     - `np.argsort(a)[::-1]` 내림차순

# 인덱싱과 슬라이싱을 이용한 배열의 원소 조회

# 1. 배열 인덱싱(indexing)
## 1. index
  - 배열내의 원소의 식별번호
  - 0 부터 시작
## 2. indexing
  - index를 이용해 원소 조회
    - []표기법 사용
## 3. 구문
  - `ndarray[index]`
  - 양수는 지정한 index의 값 조회
  - 음수는 뒤부터 조회
    - 마지막 index는 -1
  - 2차원배열의 경우
    - arr[행idx, 열idx]
    - 파이썬 리스트와 차이점 `(list[행][열])`
  - N차원 배열의 경우
    - `arr[0축 idx, 1축 idx, .., n축 idx]`
## 4. 팬시(fancy) 인덱싱
  - **여러개의 원소를 한번에 조회**할 경우 리스트에 담아 전달
  - 다차원 배열의 경우 각 축별로 list로 지정
  - `arr[[1,2,3,4,5]]`
    - 1차원 배열(vector) : 1, 2, 3, 4, 5번 idx의 원소들 한 번에 조회
- 사용예제
```python
import numpy as np

arr2 = [[1, 10, 7],
        [4, 2, 10],
        [10, 2, 8]]
print(arr2[[0, 2],[1, 2]]) # arr2[[0,1], [2,3]] => [0,2],[1,3]을 묶은 것이다.
# [10, 8]

arr2[[0, 2], [1, 2]] = 100, 80 # 튜플 대입 (값 변경)
print(arr2)
"""
[[  1 100   7]
 [  4   2  10]
 [ 10   2  80]]
 """
```
# 2. 슬라이싱
- 배열의 부분 집합을 하위배열로 조회 및 변경하는 방식
- `ndarray[start : stop : step]`
    - `start` : 시작 idx. default : 0
    - `stop` : 끝 idx. stop -1의 값 까지. default : 마지막 idx
    - `step` : 증감 간격. default : 1

## 2-1. 다차원 배열 슬라이싱
- 각 축에 slicing 문법 적용
- 2차원의 경우
    -  `arr[행 slicing, 열 slicing]` # arr[:3, :]
    -  `,`로 행과 열을 구분한 다중 슬라이싱 사용
-  다차원의 경우
    -  `arr[0축 slicing, 1축 slicing, ..., n축 slicing]`
-  slicing과 indexing 문법은 같이 사용 가능, 모든 축에 index를 지정할 필요 X

- 사용예제
```python
import numpy as np

a = np.arange(30).reshape(6,5) # 6 x 5 배열 생성
print(a)
print(a[1:5, 1:4])
"""
[[ 0  1  2  3  4]
 [ 5  6  7  8  9]
 [10 11 12 13 14]
 [15 16 17 18 19]
 [20 21 22 23 24]
 [25 26 27 28 29]]
 
 [ 6,  7,  8],
 [11, 12, 13],
 [16, 17, 18],
 [21, 22, 23]]
"""
print(a[::-1, ::-1])
print(np.filp(a, axis=0))
"""
[[29, 28, 27, 26, 25],
 [24, 23, 22, 21, 20],
 [19, 18, 17, 16, 15],
 [14, 13, 12, 11, 10],
 [ 9,  8,  7,  6,  5],
 [ 4,  3,  2,  1,  0]]

[[29, 28, 27, 26, 25],
 [24, 23, 22, 21, 20],
 [19, 18, 17, 16, 15],
 [14, 13, 12, 11, 10],
 [ 9,  8,  7,  6,  5],
 [ 4,  3,  2,  1,  0]]
"""
```
# 2-2. ndarray.copy()
- 슬라이싱으로 조회한 배열의 값을 바꾸면 원본 배열도 바뀐다.
- 따라서 원본의 배열을 바꾸지 않으려면 `.copy()`를 이용하여 복사한다.
- `ndarray.copy()`
    - 배열을 복사한 새로운 배열 생성
    - 복사 후 처리하면 원본은 바뀌지 않음
- 리시트와 배열은 성격이 다르므로 주의!!

# 3. boolean indexing(많이 사용됨)
- index 연산자에 Boolean 배열을 넣으면 True인 index의 **값**만 조회(False는 조회 안함)
- ndarray내의 원소 중에서 원하는 **조건의 값들만** 조회할 때 사용
- 사용예제
```python
a = np.array([1,2,3,4,5])
a[[False, True, False, True, False]] # True인 값 반환
# array([2,4])

ndarray[ndarray >= 50]  # 조건에 맞는 친구 True만 조회
# arr의 원소 중 50이상인 값들만 조회
```

# 3-1. 넘파이 비교연산자
- 파이썬 비교 연산자 `and`, `or`, `not`은 사용 안됨
- `&` : and
- `|` : or
- `~` : not
- 피연산자들을 ( )로 묶어야 한다.
```python
ndarray[(ndarray >= 20) & (ndarray <= 30)]
# 20 ~ 30
```

# 3-2. np.where() - 조건절 같은 친구
- `np.where(boolean 배열) - True인 index를 반환
- boolean연산과 같이 쓰면 틀정 조건을 만족하는 원소의 idx조회
- `np.where(boolean 배열, True를 대체할 값, False를 대체할 값)`
    - True와 False를 다른 값으로 변경한다.
```python
import numpy as np

# 랜덤으로 0과 1의 수를 받고 0이면 여자 1이면 남자로 표현
gender = np.random.choice([0,1], size = 5)
np.where(gender, "남자", "여자") # 정수에서 은 False

arr = [
    [1,10,7],
    [4,2,10],
    [10,2,8]
]
arr = np.array(arr)
r = np.where(arr2 >= 5)
print(r)
# (array([0, 0, 1, 2, 2], dtype=int64), array([1, 2, 2, 0, 2], dtype=int64))
# 해석 5이상인 값의 인덱스 (0,1), (0,2), (1,2), (2,0), (2,2)
```
# 3-3. np.any(boolean 배열), np.all(boolean 배열)
- `np.any(boolean 배열)`
    - 배열에 True가 하나라도 있으면 True 반환
- `np.all(boolean 배열)`
    - 배열에 False가 하나라도 있으면 False 반환
- `np.sum(ndarray > 50)` # 50초과인 값의 개수는?
    - 특정 조건을 만족하는 값들의 개수를 알아야할때
    - boolean배열 -> True : 1, False : 0으로 처리 후 계산하기 때문

# 4. 정렬
- `np.sort(arr)` / `ndarray.sort()` : arr을 정렬
    - `np.sort(arr)` : 정렬한 결과를 새로운 배열을 반환 (`sorted()`와 비슷)
    - `ndarray.sort()` : 원본 배열을 정렬
- `np.argsort(arr)` : 정렬 후 index만을 반환
- 오름차순정렬만 지원. 내림차순을 할 경우 정렬 후 `.reverese()` or `slicing[::-1]`
- 정렬의 기준 축(axis)으로 설정 가능
```python
np.sort(arr, axis=0) # 0축 기준으로 정렬
np.sort(arr, axis=1) # 1축 기준으로 정렬
```
