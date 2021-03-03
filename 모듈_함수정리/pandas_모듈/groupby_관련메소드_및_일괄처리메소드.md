# 1. groupby 관련 메소드
## 1-1. filter()
- 특정 집계 조건을 만족하는 group의 행들만 조회
- `df.groupby('').filter(func, dropna=True, \*args, \*\*kwargs)`
- 매개변수
  - `func` : filtering 조건을 구현하는 함수 -- 간단한식은 람다식으로
    - 첫번째 매개변수로 Group으로 묶인 DataFrame을 받는다.
    - 함수는 bool값을 반환하도록한다.
  - `dropna=True`
    - 필터를 통과하지 못한 group의 DataFrame의 값들을 drop시킨다. 
    - False로 설정하면 NA처리하여 반환
  - `\*args`, `\*\*kwargs` : filter 함수의 매개변수에 전달할 전달인자값

```python
import numpy as np
impory pandas as pd
# cnt1 - 사과: 10대, 귤: 20대, 배: 단단위, 딸기 30이상
data = dict(fruits=['사과', '사과','사과', '사과','사과','귤','귤','귤','귤','귤','배','배','배','배','배','딸기','딸기','딸기','딸기','딸기']
            ,cnt1=[10, 12, 13, 11, 12, 21, 22, 27, 24, 26, 7, 7, 8, 3, 2, 30, 35, 37, 41, 28]
            ,cnt2=[100,  103, 107, 107,  101,  51,  57, 58,  57, 51,  9, 9,  5,  7,  7,  208, 217, 213, 206, 204]
           )
df = pd.DataFrame(data)
# 과일 중 cnt1의 평균이 20이상인 과일들만 보기(filter()함수)
def check_cnt1_mean(x):
  """
  [매개변수]
    x : DataFrame(Group별로 나눈 DataFrame)
  [반환값]
    bool : x['cnt1']의 평균이 20이상인지 여부
  """
  return x['cnt1'].mean() >= 20

df.groupby('fruits').filter(check_cnt1_mean)
# 람다를 이용한 간단하게 표현
df.groupby('fruits').filter(lambda x : x['cnt1'].mean() >= 20)

## 매개변수 있는 filter 함수
def check_mean(x, col, threshold):
    """
    [매개변수]
        x : DataFrame
        col : str 평균을 구할 컬럼명
        threshold : int 비교대상 값
    [반환값]
        bool : x[col]의 평균이 threshold 이상인지 확인
    """
    return x[col].mean() >= threshold

df.groupby('fruits').filter(check_mean, col='cnt1', threshold=20)
```
## 1-2. transform
- 함수에 의해 처리된 값(반환값)으로 원래 값들을 변경(tranform)해서 반환
- DataFrame에 Group 단위 통계량을 추가할 때 사용
- `DataFrameGroupBy.transform(func, \*args)`, `SeriesGroupBy.transgorm(func, \*args)`
  - `func` : 매개변수로 그룹별 Series를 받아 Series의 값들을 변환하여 (Series로) 반환하는 함수객체
    - DataFrameGroupBy은 모든 컬럼의 값들을 group별 Series로 전달
  - `\*args` : 함수에 전달할 추가 인자값이 있으면 매개변수 순서에 맞게 값을 전달한다.
- tranform()함수를 groupby()와 사용하면 컬럼의 각 원소들을 자신이 속한 그룹의 통계량으로 변환된 데이터셋을 생성할 수 있다.
- 컬럼의 값과 통계값을 비교해서 보거나 결측치 처리들에 사용할 수 있다.
> `df.groupby('fruits').transform(lambda x : x.max() - x.min())`
#### 원본에 통계치 붙여서 비교
```python
import numpy as np
impory pandas as pd
# cnt1 - 사과: 10대, 귤: 20대, 배: 단단위, 딸기 30이상
data = dict(fruits=['사과', '사과','사과', '사과','사과','귤','귤','귤','귤','귤','배','배','배','배','배','딸기','딸기','딸기','딸기','딸기']
            ,cnt1=[10, 12, 13, 11, 12, 21, 22, 27, 24, 26, 7, 7, 8, 3, 2, 30, 35, 37, 41, 28]
            ,cnt2=[100,  103, 107, 107,  101,  51,  57, 58,  57, 51,  9, 9,  5,  7,  7,  208, 217, 213, 206, 204]
           )
df = pd.DataFrame(data)

df.groupby('fruits').transform(lambda x : x.max() - x.min())

# 그룹별 평균을 transform을 이용해 조회
cnt1_group_mean = df.groupby('fruits')['cnt1'].transform('mean')
cnt2_group_mean = df.groupby('fruits')['cnt2'].transform('mean')

# 조회한 값 원래의 Dataframe에 추가하기
df.insert(2, 'cnt1_mean', cnt1_group_mean)
df['cnt2_mean'] = cnt2_group_mean
```
#### 결측치 처리
- 결측치(NA) 처리 -대체(평균, 중앙값, 최빈값(범주형경우)) or 제거(행, 열)
- 결측치 변경(대체) : `series.fillnba(대체할 값)`
- 대체값 : scalar - 동일한 값으로 대체
- 대체값 : 배열형태(리스트, 시리즈, ndarray) - NA의 index와 동일한 index에 있는 값으로 대체
```python
import numpy as np
impory pandas as pd
# cnt1 - 사과: 10대, 귤: 20대, 배: 단단위, 딸기 30이상
data = dict(fruits=['사과', '사과','사과', '사과','사과','귤','귤','귤','귤','귤','배','배','배','배','배','딸기','딸기','딸기','딸기','딸기']
            ,cnt1=[10, 12, 13, 11, 12, 21, 22, 27, 24, 26, 7, 7, 8, 3, 2, 30, 35, 37, 41, 28]
            ,cnt2=[100,  103, 107, 107,  101,  51,  57, 58,  57, 51,  9, 9,  5,  7,  7,  208, 217, 213, 206, 204]
           )
df = pd.DataFrame(data)

cnt2_mean = df.groupby('fruits')['cnt2'].transform('mean')
df['cnt2'] = np.round(df['cnt2'].fillna(cnt2_mean), 2)
```
# 2. 일괄처리 메소드

## 2-1. pivot_table()
- 분류별 집계(group으로 묶어 집계)를 처리하는 함수
- 역할은 groupby()를 이용한 집계와 같다. 약간 업그레이드 버전
> - pivot() 함수와 역할이 다르다.
> - pivot() 은 index와 column의 형태를 바꾸는 reshape 함수
- `DataFrame.pivot_table(values=None, index=None, columns=None[, aggfunc='mean', fill_value=None, margins=False, dropna=True, margins_name='ALL'])
- 매개변수
  - `index`
    - 문자열 또는 리스트, index로 올 컬럼들 => groupby였으면 묶었을 컬럼
  - `columns`
    - 문자열 또는 리스트, column으로 올 컬럼들 => groupby였으면 묶었을 컬럼
    - (index/columns가 묶여 groupby에 묶을 컬럼들이 된다.)
  - `values`
    - 집계할 대상 컬럼
  - `aggfunc`
    - 집계함수 지정, 함수, 함수이름문자열, 함수리스트, dict : 집계할 함수
    - default : 평균(mean)
  - `fill_value`, `dropna`
    - `fill_value` : 집계시 결측치를 채울 값
    - `dropna` : 컬럼 전체값이 NA인 경우 그 컬럼 제거
  - `margins`/`margins_name`
    - `margins` : 총집계결과를 만들지 여부
    - `margins_name' : margin의 이름 문자열로 지정 (생략시 ALL)
#### 1개의 컬럼을 grouping 해서 집계
- 항공사별 비행시간의 평균
- 사용컬럼
  - grouping할 컬럼
    - AIRLINE: 항공사
  - 집계대상컬럼
    - AIR_TIME
- 집계: mean
```python
import pandas as pd
flights = pd.read_csv('data/flights.csv')

flights.groupby('AIRLINE')['AIR_TIME'].mean()
flights.pivot_table(values='AIR_TIME', index='AIRLINE', aggfunc='mean')
```
#### 2개의 컬럼을 grouping 해서 집계
- 항공사/출발공항코드 별 취소 총수 (1이 취소이므로 합계를 구한다.)
- 사용컬럼
  - grouping할 컬럼
    - AIRLINE: 항공사
    - ORG_AIR: 출발 공항코드
  - 집계대상컬럼
    - CANCELLED: 취소여부 - 1:취소, 0: 취소안됨
- 집계: sum
```python
flights.pivot(values='CANCELLED', index='AIRLINE', columns='ORG_AIR', aggfunc='sum')
```
#### 3개 이상의 컬럼을 grouping해서 집계
- 항공사/월/출발공항코드 별 취소 총수
- 사용컬럼
  - grouping할 컬럼
      - AIRLINE:항공사
      - MONTH:월
      - ORG_AIR: 출발지 공항
  - 집계 대상컬럼
      - CANCELLED: 취소여부
- 집계 : sum
```python
flights.pivot(values='CANCELLED', index=['AIRLINE', 'MONTH'], columns='ORG_AIR', aggfunc='sum)
```
#### 3개 이상의 컬럼을 gruping해서 집계2
- 항공사/월/출발공항코드 별 최대/최소 연착시간
- 사용컬럼
  - grouping할 컬럼  
    - AIRLINE:항공사
    - MONTH:월
    - ORG_AIR: 출발지 공항
  - 집계 대상컬럼
    - ARR_DELAY: 연착시간
- 집계 : min, max
```python
flights.pivot(values='ARR_DELAY', index=['AIRLINE', 'MONTH'], columns='ORG_AIR', aggfunc=['min', 'max'])
```

## 2-2. apply() - Series, DataFrame의 데이터 일괄 처리#############많이 사용함!!!
- 데이터프레임의 행들과 열들 또는 Series의 원소들에 공통된 처리를 할 때 apply 함수를 이용하면 반복문을 사용하지 않고 일광 처리 가능
- `DataFrame.apply(함수, axis=0, args=())
  - 인수로 행이나 열을 받는 함수룰 apply 메서드의 인수로 넣으면 데이터프레임의 행이나 열들을 하나씩 함수에 전달
  - 매개변수
    - `함수` : DataFrame의 행들 또는 열들을 전달할 함수
    - `axis` : 0행을 전달, 1열을 전달(default=0) G : 0이 행이다.
    - `args` : 행/열 이외에 전달할 매개변수를 위치기반(순서대로) 튜플로 전달
- `Series.apply(함수, args=())
  - 인수로 Series의 원소들을 전달할 함수
  - 매개변수
    - `함수` : Series의 원소들을 전달할 함수
    - `args` : 원소 이외에 전달할 매개변수를 위치기반(순서대로) 튜플로 전달
```python
df.apply(lambda x : x.mean())
df['NO4'] = df['NO4'].apply(lambda x : f'{x}원')
```
## 2-3. cut()/qcut() - 연속형(실수)을 범주형으로 변환
- `cut()` : 지정 값 기준으로 구간을 나눠 그룹으로 묶음
  - `pd.cut(x, bins, right=True, labels=None)`
  - 매개변수
    - `x` : 나눌 대상. 1차원 배열형태의 자료구조
    - `bins` : 나누는 기준값(구간경계)을 리스트로 전달
    - `right` : 구간경계의 오른쪽(True)을 포함할지 왼쪽(False)을 포함할지
    - `labels` : 각 구간의 label을 리스트로 전달
- `qcut()` : 데이터를 오름차순으로 정렬 뒤 지정 개수만큼의 구간으로 나눈다.
  - `pd.qcut(x, q, labels)`
  - 매개변수
    - `x` : 나눌 대상. 1차원 배열형태의 자료구조
    - `q` : 나눌 개수
- 결과값의 괄호
  - `()` 포함 X
  - `[]` 포함 O
```python
import numpy as np
impoty pandas as pd

ages = pd.Series(np.random.randint(50, size=30))
bins = [-1, 10, 20, 30, 40, 51]
age_cate = pd.cut(ages, bins=bins, right=False)
print(age_cate.value_counts().sort_index())
# [-1, 10)    7
# [10, 20)    6
# [20, 30)    3
# [30, 40)    7
# [40, 51)    7
# dtype: int64

pd.qcut(ages, 3, labels=['범주1', '범주2', '범주3'])
```












