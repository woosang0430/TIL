# 데이터프레임 합치기
- 두개 이상의 DataFrame을 합쳐 하나의 DataFramge으로 만든다.

## 1. concat() 이용
- 수직, 조인을 이용한 수평 결합 모두 지원
- 조인(수평결합)의 경우 full outer join과 inner join을 지원
  - **full outer join** default
  - 조인 기준 : index가 같은 행 끼리 합친다. (equi-join)
- `pd.concat(object[, keys=[list], axis=0, join='outer', ignore_index=False])`
  - 매개변수
    - `object` : 합칠 DataFrame들을 리스트로 전달
    - `keys=[]` : 합친 행들을 구분하기 위한 다중 인덱스 처리
    - `axis`
      - 0 또는 index : 수직결합
      - 1 또는 columns : 수평결합
    - `join`
      - 조인 방식 `outer`(default) 또는 `inner`

#### 조인(join)
- 여러 DataFrame에 흩어져 있는 정보 중 필요한 정보만 모아서 결합하기 위함
- 두개 이상의 DataFrame을 특정 컬럼(열)의 값이 같은 행 끼리 수평 결합하는 것
- inner join, left outer join, right outer join, full outer join

```python
# 데이터셋 읽기
# stocks_2016.csv, stocks_2017.csv, stocks_2018.csv : 년도별 보유 주식
# stocks_info.csv : 주식 정보
import numpy as np
impoty pandas as pd
txts = ['2016', '2017', '2018', 'info']
s_2016, s_2017, s_2018, s_info = [pd.read_csv(f'data/stocks_{i}.csv') for i in txts]

# 수직으로 합칠 때 index는 합치지 않기 | 개별 df의 index가ㅣ 순번일 경우
pd.concat([s_2016, s_2017, s_2018], ignore_index=True)

# keys를 지정하면 각각의 데이터프레임을 구별할 수 있도록 multi index로 index를 구성
pd.concat([s_2016, s_2017, s_2018], keys=[2016, 2017, 2018])

# Symbol을 기분으로 s_2017과 s_info 합치기(index명 통일 후 inner_join)
pd.concat([s_2017.set_index('Symbol'), s_info.set_index('Symbol')],
           axis=1,
           join='inner')
```
## 2. 조인을 통한 DataFrame 합치기
- `join()`
  - 2개 이상의 DataFrame을 조인할 때 사용
- `merge()`
  - 2개의 DataFrame의 조인만 지원

### 2-1. join()
- `dataframe객체.join(others, how='left', lsuffix='', rsuffix='', add_suffix='', how='left')`
- `df_A.join(df_b)`, `df_A.join([df_b, df_c, df_d])`
- 두개 이상 DataFrame 조인 가능
  - **조인 기준** : index가 같은 값인 행끼리 합친다.(equi-join)
  - 조인 기본 방식 : **left outer join**
- 매개변수
  - `isuffix`, `rsuffix`, `add_suffix`
    - 조인 대상 DataFrame에 같은 이름의 컬럼이 있으면 에러 발생
    - 같은 이름이 있는 경우 접미어를 지정해주는 친구들
  - `how`(left=default) : 조인방식 지정 친구
    - 'left', 'right'. 'outer', 'inner'
#### how는 항상 지정해주자
```python
import numpy as np
impoty pandas as pd
txts = ['2016', '2017', '2018', 'info']
s_2016, s_2017, s_2018, s_info = [pd.read_csv(f'data/stocks_{i}.csv') for i in txts]

# join(others) : others에 DataFrame들의 List를 전달하는 경우(여러개 조인) right join은 안된다.
s_2017.add_suffix('_2017').join([
    s_2016.add_suffix('_2016'),
    s_2018.add_suffix('_2018'),
    s_info.add_suffix('_info')
])#, how='right') # => right join은 두개를 조인할때만 가능
```
### 2-2. merge()
- `df_a.merge(df_b)`
- 두개의 DataFrame 조인만 가능
  - **조인기준** : 같은 컬럼명을 기준으로 equi-join 기본, 조인기준을 다양하게 정할 수 있다.
  - 조인 기본 방식 : **inner join**
##### how는 항상 지정해주자~~
- `dataframe.merge(합칠dataframe, how='inner', on=None, left_on=None, right_on=None, left_index=False, right_index=False)`
- 매개변수
  - `on` : 같은 컬럼명이 여러개 일 경우 join대상 컬럼을 선택
    - `on`은 컬럼이라고 생각해
  - `right_on`, `left_on` : 조인할 때 사용할 왼쪽, 오른쪽 dataframe의 컬럼명
  - `left_index`, `right_index` : 조인 할 때 index를 사용할 경우 True로 지정
    - 잘 조합해서 사용해봐 (`right_on`, `left_on` | `left_index`, `right_index`)
  - `how` : 조인 방식. 'left', 'right', 'outer', 'inner'.
  - `suffixes` : 두 DataFrame에 같은 이름의 컬럼명이 있을 경우 붙일 집미어를 리스트로 설정
    - 안하면 x, y로 한다~~~
```python
import numpy as np
impoty pandas as pd
txts = ['2016', '2017', '2018', 'info']
s_2016, s_2017, s_2018, s_info = [pd.read_csv(f'data/stocks_{i}.csv') for i in txts]

# 'Symbol'의 값이 같은거 끼리 합치기
s_2016.merges(s_2018, on='Symbol')

s_16.merge(s_18, on='Symbol', suffixes=['_2016', '_2018'])
```
