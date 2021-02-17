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
- ![배열](https://user-images.githubusercontent.com/77317312/108067308-ecd08200-70a3-11eb-92ea-c18f758b6f7b.PNG)
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
          - 리스트, 튜플, 넘파이배열(ndarray), series
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
- ![넘파이 데이터 타입](https://user-images.githubusercontent.com/77317312/108067331-f528bd00-70a3-11eb-8b4b-03f1111e6cf4.PNG)
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
    - shape : 형태(크기, 개수)지정
    - dtype : 요소의 개수 지정
- 사용예시
```python
o2 = np.ones((5,5))
print(o2.shape)
print(o2)
"""
(5, 5)
[[1. 1. 1. 1. 1.]
 [1. 1. 1. 1. 1.]
 [1. 1. 1. 1. 1.]
 [1. 1. 1. 1. 1.]
 [1. 1. 1. 1. 1.]]
"""
```
## 5. full(shape, fill_value, dtype)
- 원소들을 원하는 값으로 채운 배열 생성
    - shape : 형태(크기, 개수) 지정
    - fill_value : 채울값
    - dtype : 요소의 타입
- 사용예제
```python
f2 = np.full((3,3), 7, np.float32)
print(f2.shape)
print(f2.dtype)
print(f2)
"""
(3, 3)
float32
[[7. 7. 7.]
 [7. 7. 7.]
 [7. 7. 7.]]
"""
```
## 6. zeros_like(배열) / ones_like(배열)
- 매개변수로 받은 배열(ndarray)과 같은 shape의 0 또는 1로 값을 채운 배열을 생성.
- 사용예제
```python
a = np.array([1,2,3,4,5])
a_1 = np.ones_like(a)
o_1 = np.zeros_like(a)
print(a.shape, a_1.shape, o_1.shape)
print(a_1, o_1)
"""
(5,) (5,) (5,)
[1 1 1 1 1] [0 0 0 0 0]
"""
```
## 7. arange(start, stop, step, dtype)
- start에서 stop 범위에서 step의 일정한 간격의 값들로 구성된 배열 리턴
    - `start` : 시작값(생략가능 - default:0)
    - `stop` : 범쥐의 끝값으로 포함되지 않는다.(기본값 없음 필수)
    - `step` : 간격(default:1)
    - `dtype` : 요소의 타입
    - 1차원 배열만 생성 가능
- 사용예제
```python
a1 = np.arange(10, 0, -1) # 감소 : 10 ~ 1, - 1씩 감소
a2 = np.arange(0, 1, 0.1) # 0 ~ 0.9, 0.1 씩
print(a1)
print(a2)
"""
[10  9  8  7  6  5  4  3  2  1]
[0.  0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]
"""
```
## 8. linspace(start, stop, num=50, endpoint=True, retstep=False, dyrpe=None)
- 시작과 끝을 균등하게 나눈 값들을 가지는 배열을 생성
    - `start` : 시작값
    - `stop` : 종료값
    - `num` : 나눌 개수. default : 50, 양수여야한다.
    - `endpoint` : stop을 포함시킬 것인지 여부, default : True
    - `restep` : 생성된 배열 샘플과 함께 간격(step)도 리턴할지 여부. True일 경우 간격도 리턴(sample, step) => 튜플로 받는다.
         - step이 궁금하니? 알려줄까?
    - `dtype` : 테이터 타입
- 사용예제
```python
a1 = np.linspace(1, 100, 10, retstep=True)
print(a3) # (배열, step) 반환
print(a3[0])
print(a3[1])
"""
(array([  1.,  12.,  23.,  34.,  45.,  56.,  67.,  78.,  89., 100.]), 11.0)
[  1.  12.  23.  34.  45.  56.  67.  78.  89. 100.]
11.0
"""
```
## 9. exe(N, M=None, k=0, dtype=<class 'float'>) / identity(N)
- 항등행렬 생성 단위 행렬 생성
    - `N` : 행수
    - `M` : 컬럼수
    - `k` : 대각선이 시작할 index(첫행의 index를 지정) default : 0
- 대각행렬
    - 행과 열이 같은 위치를 대각(diagnonal) 이라고 하며 그 대각에만 값이 있고 비대각은 0으로 채워진 행렬
- 항등행렬 / 단위행렬
    - 대각의 값이 1인 정방행렬로 *E*나 *I*로 표현한다.
    - 단위행렬은 행렬에서 곱셈의 항등원이다.
    - 행렬곱셉(내적)에 대해서 교환법칙이 성립
        - *A* * *E* = *A*
- 사용예제
```python
i = np.identity(3) # 3 x 3의 항등, 대각행렬
print(i.shape)
print(i)
"""
(3, 3)
[[1. 0. 0.]
 [0. 1. 0.]
 [0. 0. 1.]]
"""
e1 = np.exe(3, 5, k=2)
print(e1)
"""
[[0. 0. 1. 0. 0.]
 [0. 0. 0. 1. 0.]
 [0. 0. 0. 0. 1.]]
 """
```
# 난수를 원소로 하는 ndarray 
- numpy의 서브 패키지인 random 패키지에서 제공하는 함수들
- np.random.seed(정수) : 시드값 설정

## 1. np.random.seed(시드값)
- 난수 발생 알고리즘이 사용할 시작값(시드값)을 설정
- 시드값을 설정하면 항상 일정한 순서의 난수(ramdom value)가 발생한다.
    -  시드를 설정한 후 난수를 실행하면 나오는 값들은 다르지만 순서는 같게 나온다.
- 장점 1. 결과값을 통일할 수 있다.
- 장점 2. 주로 개발 단계에서 동일한 값으로 알고리즘의 효율성을 따지기 위해 사용된다

## 2. np.random.rand(axis0[, axis1, axis2, ...])
- 0 ~ 1 사이의 실수를 리턴
- 축의 크기는 순서대로 나열
- 참고 (https://numpy.org/doc/stable/reference/random/generated/numpy.random.rand.html?highlight=rand#numpy.random.rand)

- 1, 2번 사용 예제
```python
np.random.rand(3, 5) # (3, 5) | def a(*args) -> 이런 형태
# array([[0.4292001 , 0.11997324, 0.05944682, 0.21678008, 0.20406674],
       [0.03690671, 0.40853741, 0.45615629, 0.84850392, 0.10378825],
       [0.12525522, 0.60839887, 0.43394294, 0.067081  , 0.30711529]])
       
np.random.seed(10)
print(np.random.rand(5)) # (5,)
# [0.77132064 0.02075195 0.63364823 0.74880388 0.49850701]
```
#### 정규 분포 개념
- 종 모양의 분포가 나오면 정규 분포라고 한다. (중앙을 기준으로 해서 데칼코마니)
- 세상의 모든 값들이 정규 분포가 되는 건 아니다.
- 가운데가 제일 높은 값 = 평균
- 평균으로 부터 떨어진 값을 편차라고한다.
- 평균에서 멀어질수록 값이 작아진다.
- 평균에서 가까울수록 값이 커진다.
- ![정규분포 그래프](https://user-images.githubusercontent.com/77317312/108153809-39a56e80-711f-11eb-8fcb-8ad476dab4d4.PNG)
- 이런한 분포를 정규분포(=확률 분포)라고 한다.
- 정규분포는 평균 근처의 값이 많이 나온다.
- 1표준편차는 -1, +1 사이에 전체 68% 정도 확률.
- 2표준편차는 -2, +2 사이에 전체 95% 정도 확률.
- 정규편차(N) = (평균, 표준편차) #이런식으로 표현한다.

## 3. np.random.normal(loc=0.0, scale=1.0, size=None)
- 정규분포를 따르는 난수. 
- [참고]
- `loc` : 평균
- `scale` : 표준편차
- `loc`, `scale` 생략시 표준정규 분포를 따르는 난수를 제공
        - 표준정규분포 : 평균 : 0, 표준편차 : 1 인 분포
```python
import numpy as np
np.random.normal()
# 표준 정규 분포(평균:0, 표준편차:1)를 따르는 난수 반환. -2 ~ +2 사이의 값들(평균+-2*표준편차)이 많이 나오게 된다.
# 결과값 : 1.4916138335563238 난수임 seed지정 안하면 항상 다름

np.random.normal(loc=10, scale=5)
# 평균 10, 표준편차 5  N~(10, 5) : 0 ~ 20 10-2*5 ~ 10+2*5 범위(0~20)의 값들이 많이 나오게된다.
# 결과값 : 3.139206638541924 난수임 seed지정 안하면 항상 다름

np.random.normal(10, 5, size=(2, 5)) # shape : (2, 5)
# 결과값 : [[ 6.94662436  7.74264023  0.27757344 14.06193609  9.34735981]
 [10.93677257  7.39270594  2.6058245  17.83171476 12.86366209]]
```
## 번외 matplotlib.pyplot 맛보기
- 그래프를 시각화 하는 모듈
```python
import matplotlib.pyplot as plt
v = np.random.normal(50, 30, size=5000)
plt.figure(figsize=(7,7)) # 사이즈 지정
plt.hist(v, bins=30)
print(plt.show())
```
- 결과값
- ![정규분포 그래프](https://user-images.githubusercontent.com/77317312/108153809-39a56e80-711f-11eb-8fcb-8ad476dab4d4.PNG)

## 4. np.random.randint(low, high=None, size=None, dtype='l')

## 5. np.random.choice(a, size=None, replace=True, p=None)

