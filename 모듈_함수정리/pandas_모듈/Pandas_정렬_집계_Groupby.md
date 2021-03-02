# 1. Pandas 정렬
## 1-1. index명 / 컬럼명 순 정렬
- `sort_index(axis=0, ascending=True, inplace=False)`
  - `axis`
    - index명 기준 정렬(행) : 'index' 또는 0 (default)
    - column 명 기준 정렬(열) : 'columns' 또는 1
  - `ascending`
    - 정렬방식 오름차순으로 한다? 싫으면 False해
    - True(default) : 오름차순, False : 내림차순
  - `inplace`
    - 원본 바꿀래?! 바꾸고 싶으면 True해
    - default(안바꿀래) = False   (반환)
```python
import pandas as pd
import numpy as np

# index는 movie_title로 지정
movie_df = pd.read_csv('data/movie.csv', index_col='movie_title')

movie_df.sort_index(axis='columns')
movie_df.sort_index(axis=1)
# 컬럼을 기준으로 정렬

movie_df.sort_index()
movie_df.sort_index(axis='index')
movie_df.sort_index(axos=0)
# 인덱스를 기준으로 정렬
```
## 1-2. 컬럼 값 기준 정렬(values)
- `sort_values(by, ascending=True, inplace=False)`
  - `by`
    - 정렬하고 싶은 컬럼줘. 많으면 리스트로 묶어서
  - `ascending`(default = True)
    - 오름차순으로 정렬할께 싫으면 False ㄱㄱ
    - 많으면 리스트로 줘
  - `inplace`(default = False)
    - 원본 안바꾼다. 바꾸고 싶으면 True ㄱㄱ
```python
# duration으로 정렬하고 duration값이 값은 것 끼리는 imdb_score 값으로 정렬 (둘다 오름차순)
movie_df.sort_values(['duration', 'imdb_score'])

# duration : False, imdb_score : True(내림차순이 석여있으면 이렇게 지정하자)
movie_df.sort_values(['duration', 'imdb_score'], ascending=[False, True])
```

# 2. Pandas 집계
## 2-1. 기술통계함수를 이용한 데이터 집계
- 주요 기술 통계 함수
> - `sum()`	- 합계
> - `mean()` - 평균
> - `median()` - 중위수
> - `quantile()` - 분위수
> - `std()`	- 표준편차
> - `var()`	- 분산
> - `count()`	- 결측치를 제외한 원소 개수
> - `min()`	- 최소값
> - `max()`	- 최대값
> - `idxmax()` - 최대값 index
> - `idxmin()` - 최소값 index
> - `unique()` - 고유값
> - `nunique()`	- 고유값의 개수
- DataFrame에 적용할 겅우 컬럼별로 계산
- `sum()`, `max()`, `min()`, `unique()`, `nunique()`, `count()`는 문자열에 적용가능
  - 문자열 컬럼의 `min`/`max` index를 조회하려면 `np.argmax()`, `np.argmin()`을 사용\
- 기본적으로 결측치는 제외하고 처리(제외 안하려면 `skipna=False` 설정)
```python
import pandas as pd
import numpy as np

flights = pd.read_csv('data/flights.csv')
# 문자열 값을 제외 후 합산
flights.select_dtypes(exclude='object').sum()
```
## 2-2. 여러 통계치를 묶어 조회 혹은 통계별 다른 컬럼 조회
- `aggregate(func, axis=0, \*args, \*\*kwargs)` 또는 `agg(func, axis=0, \*args, \*\*kwargs)`
- 여러개 통계치 묶어 조회하고 싶지? 아니면 통계별 다른 컬럼 조회하고 싶지? 그럼 `agg` ~
- 판다스가 제공하는 집계 함수들이나 사용자 정의 집계함수를 DataFrame의 열 별로 처리해주는 함수
- **사용자 정의 집계함수를 사용하서나 열 별로 다른 집계를 할 때 사용**
- `func`
  - 집계 함수 지정
    - 문자열/문자열 리스트 : 집계함수 이름, 많으면 리스트로 묶어줘~ (판다스 제공 집계함수는 문자열로 함수명만)
    - 딕셔러니 : {집계할컬럼 : 집계함수}
    - 함수 객체 : 사용자 정의 함수의 경우 함수이름 전달
- `axis`
  - 컬럼 별 집계 : 0 또는 'index'
  - 행 별 집계 : 1 또는 'columns'
- `\*args`, `\*\*kwargs`
  - 함수에 전달할 매개변수
  - 집계함수는 첫 번째 매개변수로 Series를 받는다.
```python
import numpy as np
import pandas as pd

# 평균, 합계
flights.agg(['mean', 'sum'])

# 합계, 평균, null을 제외한 수, 중앙값 (문자열은 무시)
flights.select_dtype('object').agg(['sum', 'mean', 'count', 'median'])

filghts['ARR_DELAY'].quantile(q=[.25, .75])
filghts['ARR_DELAY'].agg('quantile', q=[.25, .75])
```
# 3. Pandas GROUPBY
## 3-1. groupby
- 특정 열을 기준으로 데이터셋을 묶음
- ~~~ 별 집계를 할 때 사용
- 구문
  - `df.groupby('묶을 기준컬럼')['집계할 컬럼'].집계함수()`
    - 집계할 컬럼은 Fancy indexing 으로 지정
  - `집계함수`
    - 기술통계 함수들
    - `agg()`/ `aggregate()`
      - 여러 다른 집계함수 호출 시
      - 사용자정의 집계함수 호출 시
      - 컬럼별 다른 집계함수 호출 시
#### - 마지막 집계함수를 직접 호출하는 것을 많이씀
#### - 한번에 여러개의 집계함수를 호풀 할 경우 agg([list]) 사용
#### - 열별로 다른 집계를 하는 경우 dict를 사용
```python
import numpy as np
import pandas as pd

flights = pd.read_csv('data/flights.csv')

# AIRLINE 별 각 컬럼의 평균
flights.groupby('AIRLINE').mean()

# AIRLINE 별 AIR_TIME의 평균
flights.groupby('AIRLINE')['AIR_TIME'].mean()

# AIRLINE 별 ARR_DELAY, DEP_DELAY, AIR_TIME의 평균과 표준편차
flights.groupby('AIRLINE')[['ARR_DELAY', 'DEP_DELAY', 'AIR_TIME']].agg(['mean', 'std])

# 컬럼별 다른 통계량 조회 AIRLINE 별 DEP_DELAY는 평균, 표준편차, ARR_DELAY는 최소, 최대값, AIR_TIME은 None을 제외한 횟수
flights.groupby('AIRLINE').agg({'DEP_DELAY' : ['mean', 'std'],
                                'ARR_DELAY' : ['min', 'max'],
                                'ARR_TIME' : 'count'})
```
## 3-2. 복수열 기준 그룹핑
- 두개 이상의 열을 그룹으로 묶을 수 있다.
- groupby의 매개변수에 그룹으로 묶을 컬럼들의 이름을 리스트로 전달
```python
# AIRLINE으로 묶고 MONTH로 묶은 각각의 DEP_DELAY, ARR_DELAY의 평균값
flights.groupby(['AIRLINE', 'MONTH'])[['DEP_DELAY', 'ARR_DELAY']].mean()
```
## 3-3. 집계 후 특정 조건의 항목만 조회
- SQL의 having 절
- 집계 후 boolean indexing으로 having절 처리
```python
# 항공사별 취소한 횟수가 50건 이상인 것만 조회
result = flights.groupby('AIRLINE')['CANCELLED'].sum()
result[result>=50]
```
## 3-4. 사용자 정의 집계함수 만들어 적용
### - 사용자 정의 집계 함수 정의
- 매개변수
  1. **Series** 또는 **DataFrame**을 받을 매개변수(필수)
  2. 필요한 값을 받을 매개변수를 선언(선택)
### - **agg()**를 사용해 사용자 정의 집계 함수 호출
- `Series.agg(func=None, axis=0, \*args, \*\*kwargs)`
- `SeriesGroupBy.agg(func=None, \*args, \*\*kwargs)`
  - axis 지정안함
  - 사용자 함수에 Series를 group 별로 전달
- `DataFrame.agg(func=None, axis=0, \*args, \*\*kwargs)` 
- `DataFrameGroupBy.agg(func=None, \*args, \*\*kwargs)`
  - axis 지정안함
  - 사용자 함수에 Series를 group별로 전달
- \*args, \*\*kwargs는 사용자 정의 함수에 선언한 매개변수가 있을 경우 전달할 값을 전달
```python
# max와 min 값의 차이를 반환하는 사용자정의 집계함수
def max_min_diff(x):
    """
    max와 min갑스이 차이를 반환하는 사용자정의 집계함수
    [매개변수]
        x : 통계량을 구할 Series
    [반환값]
        max()-min()
        Series x의 타입이 object(문자열)이면 None을 반환
    """
    if x.dtype == 'object':
        return None
    
    return x.max() - x.min()

flights['ARR_DELAY'].agg(['max', 'min', max_min_diff]) #사용자정의 집계함수 객체를 매개변수로 전달.
```
