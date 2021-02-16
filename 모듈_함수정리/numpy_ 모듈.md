# NUMPY
- 강력한 다차원 배열(array) 지원 
- 고성능 과학연산을 위한 패키지로 데이터 분석, 머신러닝등에 필수로 사용

### 넘파이의 데이터 구조
1. 스칼라(Scalar)
    - 하나의 숫자로 이루어진 데이터
2. 벡터(Vector)
    - 여러 개의 숫자들을 특정한 순서대로 모아 놓은 데이터 모음
    - 1D array
3. 행렬(Matrix)
    - 벡터들을 모아놓은 데이터 집합
    - 2D array
4. 텐서(Tensor)
    - 같은 크기의 행렬들(텐서들)을 모아놓은 데이터 집합
    - ND array
### 용어
1. 축(`axis`)
    - 값들의 나열 방향
    - 하나의 축(axis)는 하나의 범주(category)
2. 랭크(`rank`)
    - 데이터 집합에서 축의 개수
3. 형태/형상(`shape`)
    - 각 축(axis) 별 데이터 개수
4. 크기(`size`)
    - 배열내 원소의 총 개수
- 사진###############################################################
- [출처]https://www.oreilly.com/library/view/elegant-scipy/9781491922927/ch01.html

#### 넘파이 배열(ndarray)
- Vector에서 차원 : 원소의 개수
    - numpy에서 제공하는 N차원 배열 객체
    - 같은 타입의 값들만 가짐
    - C를 기반으로 만들어져 빠르고 메모리를 효율적으로 사용한다.
- 차원(dimension)
    - vector에서 차원 : 원소의 개수
    - 넘파이 배열에서 차원 : 축의 개수

# 배열 생성 함수
## 1. array(배열형태 객체 [, dtype])
  - 배열형태 객체가 가진 원소들로 구성된 numpy 배열 생성
      - 배열 형태의 객체 (array-like)
## 2. 데이터 타입
  - 원소들의 데이터 타입
  - 배열 생성시 `dtype` 속성을 이용해 데이터 타입 설정 가능
  - `ndarray.dtype` 속성을 이용해 조회
  - `ndarray.astype(데이터타입)`
      - 데이터타입 변환 메소드
      - 변환한 새로운 ndarray객체 반환
  - 타입 지정
      - 문자열로 지정
          - `'int'`, `'int64'`, `'float'`
      - numpy에 각 타입이 변수로 제공
          - `numpy.int`, `numpy.int64`, `numpy.float`
- 사진###############################################################
- 사용예제
```python
import numpy as np
l = [
    [1,2,3],
    [4,5,6]
]
a = np.array(l)
print(a7)
print(a7.ndim) # 차원수(rank) 확인
print(a7.shape) # 배열의 shape 확인 **많이 쓰임
print(a7.size) # 총 원소수, len() => 이랑 다르다.
"""
[[1 2 3]
 [4 5 6]]
2
(2, 3)
6
"""
```

## 3. zeros(shape, dtype)
- 영벡터(행렬) 생성 : 원소들을 0으로 채운 배열
    - shape : 형태(크기, 개수) 지정
    - dtype : 요소의 개수 지정
    - 많이 쓰인다.
- 사용 예제
```python
import numpy as np
z1 = np.zeros(10) # size가 10인 vector(1D array)
# defult = float
print(z1)
print(z1.shape)
"""
[0. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
(10,)
"""

z2 = np.zeros((3,5)) # 3 x 5 행렬 (2차원부터는 튜플, 리스트로 묶어주기)
print(z2)
print(z2.shape)
print(z2.dtype)
"""
(3, 5)
[[0. 0. 0. 0. 0.]
 [0. 0. 0. 0. 0.]
 [0. 0. 0. 0. 0.]]
float64
"""
```
## 4. ones(shape, dtype)
-  일벡터 생성 : 원소들을 1로 채운 배열
    - shape
## 5. full(shape, fill_value, dtype)

## 6. xxx_like(배열)

## 7. arange(start, stop, step, dtype)

## 8. linspace(start, stop, num=50, endpoint=True, retstep=False, dyrpe=None)

## 9. exe(N, M=None, k=0, dtype=<class 'float'>) / identity(N)


# 난수를 원소로 하는 ndarray 












