# 정돈된 데이터(Tidy data)
- 각 변수(데이터의 속성)는 열을 형성
- 각 관측값(하나의 데이터)은 행을 형성
- 각 관측 단위별(데이터 Entity)로 별도의 테이블(표)을 구성한다. => 단일 관측

## 변수, 관측값, 관측단위
- 변수 : Feature(특성), 컬럼
- 변수 이름 : 성별, 인종, 연봉, 직위 같은 레이블
- 변수 값
  - 관측 때마다 달라지는 값
  - 성 : 남성/여성
  - 인종 : 황인/흑인/백인
  - 연봉 : 3천만원, 4천만원 ...
- 단일 관측
  - 하나의 Entity, 하나의 데이터를 말한다. => **단일 관측 단위**
    - DataFrame(Pandas), Table(DB), 표(엑셀)로 표현된다.
  - 단일 관측 대상은 여러개의 속성들로 구성되며 그 속성을 변수, Feature, 컬럼이라 한다.
    - 단일 관측은 하나의 데이터에 대한 모든 변수값의 모음
    - 관측(관찰) 대상의 단위 => 하나의 데이터 => 변수들로 구성됨
  - ex) 종업원, 손님, 제품...
    - 종업원정보(근무시간같은)와 고객정보(구매 액수)를 같은 테이블에 병합하는 것은 단일 관측이라 할 수 없다. -> tidy data의 원칙에 위배
## 정돈되지 않은 데이터의 가장 흔한 형태
1. 열 이름이 변수 이름이 아니라 값인 경우
2. 열 이름에 복수 개의 변수가 저장된 경우
3. 변수가 행과 열에 모두 저장된 경우
4. 같은 테이블에 복수 형식의 관측단위가 저장된 경우
  - 하나의 테이블에 여러 데이터(관측단위)가 병합된 것
5. 단일 관측 단위가 복수 테이블에 저장된 경우
  - 하나의 데이터의 변수들이 여러 테이블에 나눠 저장된 경우

## 데이터를 정돈한다의 의미
- 단순히 데이터셋의 값을 바꾸거나 결측치를 채운다는 것만을 의미 하지 않음
- 데이터를 정돈하는 것은 데이터의 형태나 구조를 정돈 원칙에 맞게 변형시키는 것이다. -> **데이터가 올바른 형태로 주어진다면 분석이 쉬워진다.**

##  [Pandas의 정돈을 위한 메소드](https://pandas.pydata.org/pandas-docs/stable/user_guide/reshaping.html)
- `stack()`
- `melt()`
- `unstack()`
- `pivot()`
- `pivot_table()`
- 텍스트 분해를 위한 str accenssor
- 정돈된 데이터를 다듬는 메소드
  - `rename()`
  - `rename_axis()`
  - `reset_index()`
  - `set_index()`

# 1. stack()
- 컬럼명을 index(행명)으로 전환
  - 기존 index가 있으면 하위 레벨로 들어간다.(기존 것이 상위 레벨)
- 컬럼명을 컬럼의 값으로 전치시킬때도 사용
- 매개변수
  - `dropna=False` : stacking시 생성되는 NA(결측치)는 제거되지 않게 한다.(default: True => 제거)
```python
import numpy as np
import pandas as pd

state_fruit = pd.read_csv('data/state_fruit.csv', index_col=0)

# series로 변환
s1 = state_fruit.stack()

# Series를 DataFrame으로 변환
s1.to_frame()

# 인덱스를 value로 빼내고 컬럼명 변경
state_fruit_tidt = s1.reset_index() # 인덱스를 value로 빼기
state_fruit_tidt.values() = ['State', 'Fruit', 'Count'] # 컬럼명 빼기

s2 = s1.rename_axis(['STATE', 'FRUIT'], axis=0) # 각 축(index/columns)의 이름.
s2.reset_index(name='COUNT')

# 한번에 처리하기
state_fruit.stack().rename_axis(['state', 'fruit'], axis=0).reset_index(name='count')
```
# 2. unstack()
- stack() 반대로 index를 컬럼으로 변환한다.
- 매개 변수
  - level : multi_index일 경우 컬럼으로 만들 레벨을 지정. (default : -1로 가장 안쪽 index를 이동)
```python
# 멀티 인덱스로 만들기 level[0] = state, level[1] = fruit
s = state_fruit_tidy.set_index(['state', 'fruit'])

# s.unstack().rename_axis('', axis=0)
s.unstack() # 가장 안쪽 level의 index가 컬럼으로 변환
```

# 3. melt() - 컬럼명을 컬럼의 값으로 변환한다.
- stack()과 같이 컬럼 명을 단일 컬럼의 값으로 변환
- 변환할 컬럼들을 지정할 수 있어 stack()보다 더 유연
- 매개변수(`df.melt(id_vars=None, value_vars=None, var_name=None, value_name='value', col_level=None, ignore_index=True)`)
  - `id_vars` : 값으로 변환하지 않고 그대로 유지하고하 하는 컬럼열 리스트
    - 식별변수라고도 부름
  - `value_vars` : 단일 컬럼의 값으로 변경하고자 하는 컬럼명 리스트
    -  value_vars에 지정한 컬럼이 value가 되고 그 컬럼의 값들은 다른 컬럼으로 생성
    -  id_vars와 value_vars에 지정 안된 컬럼은 **제거**
    -  제거되지 않고 유지되길 바라는 컬럼은 **id_vars**로 지정
  - `var_name` : id_var로 단일열이 된 열의 이름 지정
  - `value_name` : value_vars에 지정된 열들의 값들이 변환된 컬럼의 이름
  > - melt한 경우 **index명은 무시** -> Rangeindex로 대체
  >     - index를 유지하려면 **reset_index**를 이용해 value로 뺀 뒤 ㄱㄱ
  > - stack은 열 이름을 index명으로 정돈(변경) 한다.
```python
import numpy as np
import pandas as pd

state_fruit.melt(id_vars=['state'], 
                 value_vars=['Apple', 'Orange', 'Banana'], 
                 var_name='Fruit', 
                 value_name='Count')
                 
# id_vars나 value_vars에 포함되지 않은 컬럼들은 제거된다.
state_fruit.melt(value_vars=['Apple', 'Orange']) 

 # value_vars를 생략하면 id_vars의 컬럼을 제외한 모든 컬럼들을 컬럼의 값으로 만든다.
state_fruit.melt(id_vars=['state'], 
                 var_name='Fruit', 
                 value_name='Count')

# id_vars, value_vars를 모두 생략하면 모든 컬럼들을 컬럼의 값으로 만든다.
state_fruit.melt() 
```

# 4. pivot - index, column, value가 될 컬럼들을 지정해 재구조화
- DataFrame 재구조화가 목적인데 melt된 것을 원상 복구 시킬 때도 사용할 수 있다.
- 매개변수(`df.pivot(index=None, columns=None, values-None)`)
  - **각 매개변수의 값은 단일 문자열로 컬럼명을 준다.**
  - `index` : 문자열(리스트안됨). 행이름으로 사용할 컬럼 -> 열이 index로 이동하는 형태
  - `columns` : 문자열(리스트안됨). 컬럼명으로 사용할 컬럼
    - index와 columns는 여러개 지정 X.
  - `values` : value에 올 컬럼명
```python
state_fruit_melt = state_fruit.melt(id_vars=['State'], 
                                 value_vars=['Apple', 'Orange', 'Banana'], 
                                 var_name='Fruit', 
                                 value_name='Count')

state_fruit_melt.pivot(index='State', columns='Fruit', values='Count')
```
