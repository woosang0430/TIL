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




### 6. 통계량
#### 6-1. 평균

#### 6-2. 중앙값

#### 6-3. 표준편차/분산

#### 6-4. 최빈값

#### 6-5. 분위수

### 7. 결측치

#### 7-1. 결측치 거리


### 8. 벡터화(연산)











