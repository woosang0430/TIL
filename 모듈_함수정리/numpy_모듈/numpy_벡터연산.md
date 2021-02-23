# 벡터연산

## 1. 벡터화 - 벡터 연산
- 같은 형태(shape)의 배열(벡터, 행렬)간의 연산은 같은 index의 원소끼리 연산
    - **Element-wise(원소별) 연산** 이라고도 한다.
    - 배열간의 연산시 배열의 형태가 같아야 한다.
    - 배열의 형태가 다른 경우 Broadcast 조건에 맞으면 연산 가능

- 벡터, 행렬과 스칼라간 연산  / 벡터, 행렬의 연산
- ![1](https://user-images.githubusercontent.com/77317312/108821020-5e5a8400-7600-11eb-9784-828c163cb4d3.PNG)
- 사용예제
```python
import numpy as np
# 배열과 scalar 간의 연산
x = np.array([1,2,3])
print(x)
print(x+10)
print(x*10)
print(x>2)
print(10/x)
print(~(x>2)) # not : ~(비교연산)
print((x>1) & (x<5)) # (비교연산) `&` / `|`(비교연산) -- numpy/pandas : `&`, `|`, `~`
# [1 2 3]
# [11 12 13]
# [10 20 30]
# [False False  True]
# [ True False False]
# [10.          5.          3.33333333]
# [ True  True False]
# [False  True  True]

x = np.array([1,2,3])
z = np.array([1,2,3,4,5])
x + z # (3,) + (5,) => 다른 shape의 배열간에는 연산이 안됨
```
## 2. 내적(Dot product)
- `@` 연산자 또는 `numpy.dot(벡터/행렬, 벡터/행렬)` 함수 사용
### 2-1. 벡터간의 내적
- 같은 index의 원소끼리 곱한 뒤 결과를 모두 더한다.
- 벡터간의 내적의 결과는 scala가 된다.
- 조건
    - 두 벡터의 차원(원소릐 개수)가 같아햐 한다.
    - **앞 벡터**는 `행벡터` **뒤 벡터**는 `열벡터`
        - numpy에서는 vector끼리 연산시 **앞 벡터**는 `행벡터`, **뒤 벡터**는 `열벡터`로 인식해 처리한다.
- ![2](https://user-images.githubusercontent.com/77317312/108821058-6b777300-7600-11eb-8c1f-cf16b9138ba6.PNG)
- 사용예제
```python
import numpy as np

x = np.array([1,2,3])
y = np.array([4,5,6])
print(x @ y)
print(np.dot(x, y))
# 32
# 32

# 1차원 배열의 경우 동일한 shape의 배열끼리 연산가능
```
### 2-2. 행렬간의 내적
- **앞 행렬**의 `행`과 **뒤 행열**의 `열`간에 내적
- 행렬과 행렬을 내적하면 결과는 행렬이 나온다.
- 앞 행렬의 열수와 뒤 행렬의 행수가 같아야 한다. 
    - 조건 (n, m), (m, r) => (n, r)
    - (3 x 2) 와 (2 x 5) = (3 x 5)
    - (1 x 5) 와 (5 x 1) = (1 x 1)
- 사용예제
```python
가격 : 사과 = 2,000원, 귤 = 1,000원, 수박 = 10,000원   
A 구매자 : 사과 10개, 귤 5개, 수박 10개   
B 구매자 : 사과 5개, 귤 20개, 수박 10개   
C 구매자 : 사과 50개, 귤 10개, 수박 1개
총 금액?

import numpy as np

fruit_price = np.array([2000, 1000, 10000])
cnt = np.array([10,5,10])
total_price = np.dot(cnt, fruit_price)
print(total_price)
# 125000

l = [
    [10,5,10],
    [5,20,10],
    [50,10,1]
]
customers = np.array(l)
fruit_price = np.array([2000,1000,10000])
cust_total_price = np.dot(customers, fruit_price)
print(cust_total_price)
# [125000 130000 120000]

# 내적은 순서에 따라 결과값이 달라지므로 순서를 잘지키자 `ㄱ`자 꼭 기억하기
```

## 3. 범용함수(Ufunc, Univelsal function)
- 벡터화를 지원하는 넘파이 연산 함수들
        - 유니버셜 뜻이 **"전체에 영향을 미치는"이다. 그래서 이 함수는 배열의 원소 전체에 영향을 미치는 기능을 제공하는 함수
- 반복문을 사용해 연산하는 것 보다 유니버셜 함수를 사용하는 것이 더 빠르다.
- [참고] https://docs.scipy.org/doc/numpy-1.15.1/reference/ufuncs.html
```python
a = np.array([1,-1,-10,5])
print(np.abs(a)
# [ 1,  1, 10,  5]
```
### 3-1. 단항 범용함수(unary ufunc)
- 매개변수로 한개의 배열을 받는다.
- ![4](https://user-images.githubusercontent.com/77317312/108821103-7a5e2580-7600-11eb-8416-fd02278f7f9a.PNG)
```python
import numpy as np

a = np.array([10,100,1000])
print(np.sqrt(a))
# [ 3.16227766, 10.        , 31.6227766 ]

print(np.modf(b))
#(array([0.  , 0.7 , 0.34]), array([10.,  1., 25.]))
# 첫번째 배열 : 실수부 값
# 두번째 배열 : 정수부 값

# 넘파이에서 NaN -> np.nan : 변수
c = np.array([10, np.nan, 20, 30, np.nan])
print(c)
# [10. nan 20. 30. nan]
```
### 3-2. 이항 범용함수(binary ufunc)
- 매개변수로 두개의 배열을 받는다.
- ![5](https://user-images.githubusercontent.com/77317312/108821130-80ec9d00-7600-11eb-8a01-2fab9614f6fa.PNG)

```python
a = np.array([1,2,3])
b = np.array([10,20,30])
c = np.array([100,np.nan,-100])
print(a + b)
print(np.power(b, a))
print(b ** a)
# [11 22 33]
# [   10   400 27000]
# [   10   400 27000]

print(np.maximum(a,b))
print(np.minimum(a,b))
print(np.maximum(b,c))
# [10 20 30]
# [1 2 3]
# [100.  nan  30.]
```
## 4-1. 누적연산함수 - reduce()
- 최종 결과만 보여준다.
- 구문 : `np.이항범용함수이름.reduce(배열, axis=0)`
- 처리결과의 축의 개수(rank)는 하나 줄어 든다.
        - 1차원 -> scalar
        - 2차원 -> 1차원
        - 3차원 -> 2차원
        - n차원 -> n-1차원
```python
a = np.arange(1, 11)
print(np.subtract.reduce(a)
# -53

x = np.arange(1, 13).reshape(3,4)
print(np.add.reduce(x, axis=0))
# [15, 18, 21, 24] (수직으로 더하기)

print(np.add.reduce(x, axis=1))
# [10, 26, 42] (수평으로 더하기)

print(np.add.reduce(x, axis=None))
# 78 (전체 더하기)

#0번축 각 고객, 1번축 0 : 사과, 1 : 배, 2 : 귤
l = [
    [10,5,3],
    [20,10,2],
    [7,10,3],
    [20,20,3]
]
count = np.array(l)

# 사과(0), 배(1), 귤(2) 팔린 총 개수
print(np.add.reduce(count, axis=0))

# 고객별 몇개 샀는지
print(np.add.reduce(count, axis=1))

# 오늘 판 총 과일 개수
print(np.add.reduce(count, axis=None))

# [57 45 11]
# [18 32 20 43]
# 113
```
## 4-2. 누적연산함수 - accumulate()
- 모든 과정을 다 보여준다.
- 축의 개수는 피연산배열과 동일
- 구문 : `np.이항범용함수이름.accumulate(배열, axis=0)
```python
a = np.arange(1,5)
print(np.add.accumulate(a))
# [1,3,6]
```

## 5. 기술통계함수
- 통계 결과를 계산하는 함수(집계합수와 비슷)
- 호출시 두가지 방법
    >  a = np.array([1,2,3])
    > - `np.전용함수(a)`
    > - `a.전용함수()`
- 배열의 원소 중 누락된 값이 있을 경우 연산의 결과는 NaN 으로 나온다.
- 안전모드 함수
      - 배열내 누락된 값(NaN)을 무시하고 계산 (그냥의 함수에 nan이 포함된 배열을 넣으면 반환값이 nan 이 나온다.)
- [참고] https://docs.scipy.org/doc/numpy-1.15.1/reference/routines.statistics.html
- ![6](https://user-images.githubusercontent.com/77317312/108821153-877b1480-7600-11eb-83dd-56f429be9720.PNG)
```python
import numpy as np

a = np.arange(1, 11, dtype='float') # 1 ~ 10까지의 값
print(a)
# [ 1.  2.  3.  4.  5.  6.  7.  8.  9. 10.]

print(a.sum())
# 55

print(np.sum(a))
# 55

## 일반적인 평균과 가중평균(원소별로 가중치를 줘서 평균을 구한다.)
classes = ['국어', '수학', '영어', '미술']
grade = [80, 90, 70, 100]

m = np.mean(grade)
print(m)
# 85.0

# [10, 10, 20, 50] 각 과목의 가중치
weights = np.array([10,10,20,50])
a = np.average(grade, weights=weights)
print(a)
# 90
```
#### 번외 중앙값(median) 과 분위수
- 중앙값
    - `np.median(arr)`
    - 오름차순으로 정렬한 뒤 가운데 위치한 값
    - 배열내 원소들 중에 이상치(극단값)이 있을 경우 평균을 대신하여 대푯값으로 사용한다.
```python
a = np.array([1,2,3,4,5,100])

print(np.mean(a))
# 19.166666666666668

print(np.median(a)) # 배열이 짝수 경우 : 앞에값 + (뒤 - 앞) * 0.5
# 3.5

## a배열의 극단값이 존재하기 때문에 대푯값은 median으로 대체 한다.
```
- 분위수
    - `np.quantile(arr, q=None)`
    - 오름차순 정렬 후 특정 위치에 있는 값 조회
    - 4분위수**(많이사용)** : 정렬 후 4개로 쪼개는 것
    - 특정한 비율(분위)로 나눴을 때의 위치
    - `interpolation(보간)` : 짝수개일 경우 어떤 값을 반환
        - 앞의 값 : i, 뒤의 값 : j
        - `lower` : 작은값(앞의값) => i
        - `higher` : 큰값(뒤의값) => j
        - `midpoint` : 평균 - (i + j)/2
        - `linear` : i + (j - i) * 분위수 [default]
```python
a = np.array([1,2,3,4,5,100])

print(np.quantile(a, q=0.2)) # 오름차순으로 정렬 후 20%(0.2) 위치에 있는 값은?
# 2.0

print(np.quantile(a, q=0.5))
# 3.5

print(np.quantile(a, q=0.9))
# 52.5

print(np.quantile(a, q=[0.25, 0.5, 0.75]) # 한번에 여러 위치에 있는 값 조회 : 25%, 50%, 75% => 4분위수
# [2.25, 3.5 , 4.75]

print(np.quantile(a, q=.25, interpolation='lower'))
print(np.quantile(a, q=.25, interpolation='higher'))
print(np.quantile(a, q=.25, interpolation='midpoint'))
print(np.quantile(a, q=.25, interpolation='linear'))
# 2
# 3
# 2.5
# 2.25

x = np.arange(1, 13).reshape(4,3)
print(x.shape)
print(x)
# (4, 3)

# [[ 1  2  3]
#  [ 4  5  6]
#  [ 7  8  9]
#  [10 11 12]]

print(np.sum(x)) # 축(axis)을 지정하지 않으면 전체 합계.
# 78
print(np.mean(x))
# 6.5
print(np.max(x))
# 12
print(np.min(x))
# 1
# flatten() 후 index를 반환
print(np.argmax(x))
# 11
print(np.argmin(x))
# 0
print(np.sum(x))
# 78
print(np.sum(x, axis=0))
# [22 26 30]
print(np.sum(x, axis=1))
# [ 6 15 24 33]

print(np.sum(x, axis=1, keepdims=True)) # shape 유지
# [[ 6]
#  [15]
#  [24]
#  [33]]
```
#### 번외 2. boolean 연산을 이용한 처리
- `np.sum(배열에 대한 조건)` : 조건을 만족하는 원소의 개수
- `np.mean(배열에 대한 조건)` : 전체 중 조건을 만족하는 원소의 비율 0 ~ 1
```python
a = np.array([1,2,3,4,5,6,7,8,9,10]).reshape(2, 5)
print(a)
# [[ 1  2  3  4  5]
#  [ 6  7  8  9 10]]
np.mean(a>5) # 전체중 5 초과인 원소의 비율
# 0.5

np.any(a>5) # True가 하나라도 있냐? 5초과인 원소가 하나라도 있음?
# True

np.all(a>5) # 모두 True이냐? 모든 원소가 5초과인가?
# False
```
## 6. 브로드캐스팅
- 형태(shape)가 다른 배열 연산시 배열의 형태를 맞춰 연산이 가능하도록 도와준다.
- 조건
    > 1. 차원이 다른 경우
    >     - 차원을 맞춘다.(작은 차원의 앞쪽에 축(1개)을 늘린다.)
    > 
    > 2. 차원은 같은데 사이즈(축의 크기)가 다르다.(`작은 차원의 size가 1이여야 가능`)
    >     - 작은 크기가 1인 경우 작은 쪽을 큰쪽 크기에 맞춘다.
    - (2,3,3,4) + (3,4) => (2,3,3,4) + (1,1,3,4) =>
    - (2,3,3,4) + (1,1,3,4) => (2,3,3,4) + (2,3,3,4)
- ![7](https://user-images.githubusercontent.com/77317312/108821183-8fd34f80-7600-11eb-9f8c-f7e077e6a773.PNG)
```python
m = np.arange(2*2*3*4).reshape(2,2,3,4)
n = np.arange(3*4).reshape(3,4)

print(m.shape, n.shape)
# (2, 2, 3, 4) (3, 4)
print((m+n).shape)
# (2, 2, 3, 4)
```

















