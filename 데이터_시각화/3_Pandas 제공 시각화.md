# Pandas 시각화
- 판다스 자체적으로 matplotlib를 기반으로 한 시각화기능
- https://pandas.pydata.org/pandas-docs/stable/user_guide/visualization.html
## 1. plot
- kind 매개변수에 지정한 값에 따라 다양한 그래프를 그린다.
- kind : 그래프 종류
> - 'line' : line plot (default)
> - 'bar' : vertical bar plot
> - 'barh' : horizontal bar plot
> - 'hist' : histogram
> - 'box' : boxplot
> - 'kde' : Kernel Density Estimation plot(히스토그램을 선으로 표시한거라 생각)
> - 'pie' : pie plot
> - 'scatter' : scatter plot
```python
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
```
## 2. 막대그래프(bar)
```python
tips = pd.read_csv('data/tips.csg')

sm = tips['smoker'].value_counts()
sm.plot.bar(color=['black', 'gray'], rot=0) # rot의 default : 90
"""
두개의 분류 별 그리기
index를 1차 분류, columns를 2차 분류
"""
# 요일(day)-성별(sex) 손님의 총수(size)
# df의 index : ticks - 1차 그룹, columns : 각 ticks마다 나눠져 나옴 - 2차 그룹
tips.pivot_table(index='day', columns='sex', values='size', aggfunc='sum').plot.bar(figsize=(7,7), rot=0)

plt.show()
```
- ![111](https://user-images.githubusercontent.com/77317312/110886453-fe681b00-832b-11eb-864a-85b984e014e5.PNG)
## 3. 파이차트(pie)
```python
tips['days'].value_counts().plot.pie(figsize=(5,5), autopct='%.2f%%',
                                     fontsize=15, explode=[0,0,0.1,0])
plt.show()
```
- ![123](https://user-images.githubusercontent.com/77317312/110889304-39b91880-8331-11eb-92d9-393cba4db807.PNG)
## 4. 히스토그램, KDE(밀도그래프)
```python
tips['total_bill'].plot(kind='hist', figsize=(6,6), bins=20)
plt.show()

tips['total_bill'].plot.kde()
plt.show()
```
- ![55](https://user-images.githubusercontent.com/77317312/110889566-bba94180-8331-11eb-9b9c-f41547602724.PNG)
- ![44](https://user-images.githubusercontent.com/77317312/110889557-b64bf700-8331-11eb-9ac0-d48532ad26e9.PNG)
## 5. 상자그래프(Boxplot)
```python
tips[['total_bill', 'tip']].plot(kind='box', figsize=(5,5))
plt.show()

tips.plot(kind='box') # 정수형만 반환
plt.show()
```
- ![123](https://user-images.githubusercontent.com/77317312/110899939-4d6e7a00-8345-11eb-88e4-b63773484a0b.PNG)
- ![12](https://user-images.githubusercontent.com/77317312/110899966-565f4b80-8345-11eb-9a4d-ba18a8fc7def.PNG)

## 6. 산점도(scatter plot)
- DataFrame으로만 그린다.
```python
tips.plot(kind='scatter', x='total_bill', y='tip', figsize=(5,5)) # x, y에 올 컬럼명
plt.show()
```
- ![11](https://user-images.githubusercontent.com/77317312/110902786-c243b300-8349-11eb-887a-acec9df3d1b6.PNG)
## 번외. 파이썬의 날짜 / 시간 다루기
- `datetime` 모듈
  - `datetime` 클래스 - 날짜/시간
  - `date` : 날짜
  - `time` : 시간
- [날짜 포맷 문자열](https://docs.python.org/ko/3/library/datetime.html#strftime-strptime-behavior)
> - `import datetime`
> 
> - `datetime.datetime.now()` # 현재일시를 datetime객체로 반환
> - `datetime.datetime(2000, 4, 5)`
> - `datetime.datetime(2000, 4, 5, 15, 32, 5)`
> - `date.year`, `date.month`, `date.day`, `date.hour`, `date.minute`, `date.second`

> - ### datetime => 문자열
> - ### datetime.strftime('format문자열')
> - ### %Y : 4자리 년도, %M : 월, %d : 일, %H : 시간(24), %M : 분, %S : 처
> - ### 월 ~ 초 : 2자리
> - `data.strftime('%Y/%m/%d %h:%M:%S: %A')`

> - ### 문자열 -> datetime
> - `datetime.datetime.strptime('2020/10/20', '%Y/%m/%d')`
> - ## 판다에서 Datetime 사용
> - `dt` accessor : datetime 타입의 값들을 처리하는 기능을 제공

> || age | day |
> |-|-|-|
> | 0 | 57 | 1969-03-11 16:33:12.316075 |
> | 1 | 31 | 1993-03-11 16:33:12.316075 |
> | 2 | 59 | 1960-03-11 16:33:12.316075 |
> | .. | .. | .. |


> - `df['day'].dt.year` # 원소별로 날짜 / 시간에서 원하는 항목 추출
> - `df['day'].df.dayofweek`
> - ### day : 일, hour : 시간, minute : 분, second : 초
> - ### week : 주
> - ### dayofweek : 요일 (0 :월 ~ 6:일)
> - ### dayofyear
> - ### isocalender() - (년, 주차, 요일) - 1:월 ~ 7:일 => DataFrame
>
> - `df['day'].dt.isocalendar()` # dataframe으로 반환
> - `df['day'].dt.dayofweek()` # dataframe으로 반환
>
> - 응용
> - `pd.concat([df, df['day'].dt.isocalendar()], axis=1)`
> - ### df에 dt.isocalendar()결과 붙이기

> - ### datetime 타입의 index를  생성
> - ### pd.date_range(시작날짜, freq='변화규칙', periods='개수') # 규칙적으로 증가/감소 하는 datetime 값을 가지는 index를 생성
> - `pd.date_range('2000/1/1', freq='M', periods=5)` # 2000/1/1 부터 1개월씩 증가하는 날짜 5개 생성
> - ### freq - 간격을 지정 문자(Y : 년, M: 월, D: 일, H: 시간, T:분, S:초)
> - ### 접미어 : YS, MS, HS, TS : 첫번째날짜/시간, S생략 : 마지막 날짜
> - ### 접두어로 정수 : 간격 지정
