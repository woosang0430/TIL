# Pandas
- 표 형태의 데이터를 다루는데 특화된 모듈
- `Series` : 1차원 자료구조를 표현(행 or 열)
- `Dataframe` : 행렬의 표를 표현(행렬)
    - sql의 table이라 생각
    - np의 2차원 배열(행렬)이라 생각하자
#### 설치
- `pip install pandas`
- https://pandas.pydata.org/
- https://pandas.pydata.org/docs/

## Series
### 1. Series 생성
- 구문
  - `Series(배열형태 자료구조)`
  - 배열형태 자료구조 -> 리스트, 튜플, 넘파이 배열(ndarray)
- Series.shape : 시리즈의 형태
- Series.ndim : 차원
- Series.dtype : 데이터 타입
- Series.size : 원소의 총 개수
```python
import pandas as pd

nums = [10,20,30,40,50]
s1 = pd.Series(nums)
print(s1)
# 0    10
# 1    20
# 2    30
# 3    40
# 4    50
# 5    60
# 6    80
# dtype: int64

# index명 지정
s2 = pd.Series([70,100,90,80], index=['국어', '영어', '수학', '과학'])
print(s2)
# 국어     70
# 영어    100
# 수학     90
# 과학     80
# dtype: int64

# Series 조회
print(s2['국어'], s2[0], s2[-4], s2.iloc[-4])
# (70, 70, 70, 70)
```
### 2. Series 원소 접근
#### 2-1. indexing
- index 순번으로 조회
  - `Series[순번]`
  - `Series.iloc[순번]` -> 데이터프레임에서 많이 쓰임
- index 이름으로 조회
  - `Series[idx명]`
  - `Series.loc[idx명]` -> 데이터프레임에서 많이 쓰임
  - `Series.idx명` : idx명이 문자열일 경우 
  - idx명이 문자열이면 문자열`("")`로, 정수면 정수로 호출
      - ex) s['name'], s[2], s.loc['name']
- 팬시(fancy) 인덱싱
  - 여러 원소 조회 시 조회할 idx를 list로 전달
      - s[[1,2,3]]
```python
import pandas as pd

s1 = pd.Series([100,200,300])
s2 = pd.Series([100,200,300], index=['A','B','C'])

# 음수 index로 조회 - index 이름을 명시한 경우는 기본 indexer([])로 조회가능.
s2[-1], s2[-2]
# (300, 200)

# 음수 index로 조회 - index 이름을 명시하지 않은 경우는 iloc indexer을 사용
# s1[-1] 이 친구는 안됨
s1.iloc[-1]
# 300
```
#### 2-2. slicing
- Series[start index : end index : step]
    - start idx 생략 : 0번 부터
    - end idx
      - idx 순번일 경우 포함 X
      - idx 명의 경우 포함
    - end idx 생략 : 마지막 idx까지
    - step 생략 : 1씩 증가
- Slicing의 결과는 원본의 참조(view) 반환
    - slicing한 결과를 변경시 원본도 같이 변함
    - `series.copy()`
```python
# 시리즈(데이터프레임)의 index명 중복될 수 있다.
s8 = pd.Series(np.arange(5), index=['a','b','c','d','d'])
print(s8)
# a    0
# b    1
# c    2
# d    3
# d    4
# dtype: int32

s9 = pd.Series(np.arange(5), index=['k','r','c','d','s','d'])
print(s9['k':'d'])
# 중복된 값이 따로 떨어져 있으면 에러
```
### 3. Boolean 인덱싱
- Series의 indexing 연산자에 boolean 리스트를 넣으면 True인 index의 값들만 조회
- 다중 조건인 경우 반드시 `()`
  - 연산자 : `&`, `|`,  `~`

### 4. 주요 메소드, 속성
- `head([정수])`, `tail([정수])` : 원소를 정수개수 만큼 조회, default = 5
- `value_counts()` : 고유한 값의 빈도수 조회(DataFrame 지원 x) [normalize=True 지정시 상대 빈도수로 조회]
- `index` : index명 조회
- `shape` : 원소개수 조회
- `count` : 결측치(null)를 제외한 원소 개수
- `sort_values()` : 값 정렬, ascending=False : 내림차순
- `sort_index()` : index 정렬, ascending=False : 내림차순
    - **DataFrame**에서 axis=0는 index, axis=1은 columns 기준으로 정렬
- `isin([값리스트])` : `in` 연산자와 비슷
- 사진1 #####################################
### 5. 통계함수
- `count()` : 결츨치를 제외한 원소 개수
- `describe()` : 요약 통계량 제공
    - **수치형** : 기술 통계값
    - **범주형(문자열)** : 고유값 개수등 빈도수관련 정보
- 사진2 #########################################################
```python
import numpy as np
import pandas as pd

s1 = pd.Series([1,1,2,2,2,3,1,2,3,4,1])
print(s1.max(), s1.idxmax(), s1.min(), s1.idxmin())
# (4, 9, 1, 0)

s1.describe() # 숫자(int, float)
# count    11.0   결측치를 제외한 원소의 개수
# mean      2.0   평균 
# std       1.0   표준편차
# min       1.0   
# 25%       1.0   
# 50%       2.0   
# 75%       2.5   
# max       4.0   
# dtype: float64  

s2 = pd.Series(['가','나','가','다','가'])
# s2 : 문자열. unique : 고유값의 개수, top : 최빈값, feq : 최빈값이 몇개
s2.describe() # 빈도수 관련된 것 조회
# count     5
# unique    3
# top       가
# freq      3
# dtype: object
```
### 번외. 통계량
- 데이터셋의 데이터들의 특징을 하나의 숫자로 요약한 것
#### 번외-1. 평균
- 전체 데이터들의 합계를 총 개수로 나눈 통계량
- **이상치의 영향**을 많이 받지만 같이 고르게 분포되어 있으면 데이터셋의 `대표값`으로 사용한다.
#### 번외-2. 중앙값
- 분포된 값들을 작은 값 부터 순서대로 나열한 뒤 그 중앙에 위치한 값
- **이상치의 영향**을 받지 않아 평균 대신 데이터 셋의 `대표값`으로 사용된다.
#### 번외-3. 표준편차/분산
- 값들이 `흩어져있는 상태(분포)를 추정`하는 통계량(**분포된 값**이 **평균으로 부터 얼마나 떨어**져 있는지를 나타냄)
- 각 데이터가 평균으로 부터 얼마나 차이가 있는지를 **편차**하고 한다. `(평균 - 데이터)`
- `분산` : 편차 제곱의 합을 총 개수로 나눈 값
- `표준편차`
    - 분산의 제곱근
    - 분산은 **원래 값에 제곱**을 했으므로 다시 원래 단위로 계산한 값
#### 번외-4. 최빈값(mode)
- 데이터 셋에서 가장 많이 있는 값
#### 번외-5. 분위수(quantile)
- 데이터의 크기 순서에 따른 위치값
    - 데이터셋을 크기순으로 정렬 후 N등분했을 때 특정 위치에서의 값
    - N등분한 특정위치의 값들 통해 전체 데이터셋의 분포를 파악
    - 대표적인 분위수 : `4분위`, `10분위`, `100분위`
- 데이터의 분포를 파악할 때 사용
- 이상치 중 극단값들을 찾을 때 사용(**4분위수**)
- 사진3
> ```python
> IQR = InterQuartile Range
> if 극단적으로 작은 값 < Q1 - IQR * 1.5:
>    return 극단적으로 작은값이다.
>    
> elif 극단적으로 큰 값 > Q3 + IQR * 1.5:
>    return 극단적으로 큰값이다.
> ```   
> - [상자수염그래프] https://ko.wikipedia.org/wiki/%EC%83%81%EC%9E%90_%EC%88%98%EC%97%BC_%EA%B7%B8%EB%A6%BC
```python
import pandas as pd
import numpy as np

# 분위수
arr = pd.Series(np.arange(1, 11))

# 10분위 중 1분위
print(arr.quantile(q=0.1))
# 1.9

# 중앙값
print(arr.quantile(q=0.5))
# 5.5

# 4분위
print(arr.quantile(q=[.25, .5, .75])
# 0.25    3.25
# 0.50    5.50
# 0.75    7.75
# dtype: float64

Q1, Q2, Q3 = arr.quantile(q=[.25, .5, .75])
print(Q1, Q2, Q3)
# 3.25 5.5 7.75

# 극단치 생성 arr의 첫번째 원소값 1000으로 변경
arr[0] = 1000
print(arr.quantile(q=[.25, .5, .75]))
# 0.25    4.25
# 0.50    6.50
# 0.75    8.75
# dtype: float64

IQR = Q3 - Q1
param = 1.5 # 사용자 임의 기준값
s_range = Q1 - IQR * param
e_range = Q3 + IQR * param

print('IQR : ', IQR)
print('극단치(작은쪽) 범위 : ', s_range)
print('극단치(큰쪽) 범위 : ', e_range)
# IQR :  4.5
# 극단치(작은쪽) 범위 :  -3.5
# 극단치(큰쪽) 범위 :  14.5
-3.5 < arr < 14.5 -> 정상값, 이 범위를 넘어가면 극단치
```
### 6. 결측치
- 판다스에서 결측치
    - `None`, `numpy.nan`, `numpy.NAN`
- 결측치 확인
    - Numpy 
        - `np.isnan(배열)`
    - Series
        - `Series객체.isnull()`
        - `Series.notnull()`
    - DataFrame
        - `DataFrame객체.isnull()`, `DataFrame객체.isna()`
        - `DataFrame객체.notnull()`, `DataFraeme객체.notna()`
```python
s = pd.Series([10, 20, np.nan, 30, np.nan, 40])
s.isnull() # 원소별 체크
# 0    False
# 1    False
# 2     True
# 3    False
# 4     True
# 5    False
# dtype: bool
```
#### 6-1. 결측치 처리
- 제거
    - `dropna()`
- 다른값으로 대체(주로 평균 or 중앙값 or 최빈값으로 대체)
    - `fillna()`
    - N/A가 의미하는 것이 있을 수도 있으므로
```python
import numpy as np
import pandas as pd

s = pd.Series([10, 20, np.nan, 30, np.nan, 40])

s.dropna(inplace=True) # inplace=True : 원본을 변환
print(s)
# 0    10.0
# 1    20.0
# 3    30.0
# 5    40.0
# dtype: float64

# 평균으로 대체 
s.fillna(s.mean())
# 중앙값으로 대체
s.fillna(s.median())
# 최빈값으로 대체 보통 범주형(문자열)을 처리할 때 주로 사용
# s.fillna(s.mode()[0])

# 판다스의 기술통계함수는 NA값을 무시하고 계산하는 것이 default.
s.sum(), s.mean(), s.max(), s.min(), s.median()
# (100.0, 25.0, 40.0, 10.0, 25.0)

s.sum(skipna=False), s.mean(skipna=False)
# (nan, nan)
```
### 7. 벡터화(연산)
- Numpy 배열과 마찬가지로 Series 객체간의 연산을 하면 Series 내의 원소 별 연산을 한다.
```python
import numpy as np
import pandas as pd

np.random.seed(1)
x = pd.Series([10,20,30,40,50])
y = pd.Series(np.random.randint(2,4,5))
print(x)
print(y)
# 0    10
# 1    20
# 2    30
# 3    40
# 4    50
# dtype: int64
# 0    3
# 1    3
# 2    2
# 3    2
# 4    3
# dtype: int32

# series간 연산 
print(x + y)
 0    13
 1    23
 2    32
 3    42
 4    53
 dtype: int64
 
print(x > y)
 0    True
 1    True
 2    True
 3    True
 4    True
 dtype: bool
print(x / y)
# 0     3.333333
# 1     6.666667
# 2    15.000000
# 3    20.000000
# 4    16.666667
# dtype: float64

# 반올림
print(np.round(x/y, 2))
# 0     3.33
# 1     6.67
# 2    15.00
# 3    20.00
# 4    16.67
# dtype: float64
```
