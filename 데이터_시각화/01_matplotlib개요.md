# 시각화를 하는 이유
```python
import seaborm as sns
# seaborm 모듈의 기본으로 있는 데이터 셋
df = sns.load_dataset('anscombe')

# 객체.corr() 상관계수(양의 상관관계, 음의 상관관계)
df.set_index('dataset').loc['I'].corr()
df.set_index('dataset').loc['II'].corr()
df.set_index('dataset').loc['III'].corr()
df.set_index('dataset').loc['IV'].corr()
```
 ### 각 객체의 상관계수가 비슷한 것을 볼수 있음
- ![상관계수](https://user-images.githubusercontent.com/77317312/110294094-c19dda80-8032-11eb-859b-536b4cb478c4.PNG)
 ### 하지만 시각화를 한다면? 이 처럼 통계치로만으로 확인을 못할 변수가 생길수도 있다.
- ![그래프사진](https://user-images.githubusercontent.com/77317312/110293844-6cfa5f80-8032-11eb-97aa-274f9ec3752c.PNG)

# 1. [Matplotlib](https://matplotlib.org)
- 데이터의 시각화를 위한 파이썬 패키지
- 2차원 그래프를 위한 패키지이나 확장 API들을 이용해 3D 그래프등 다양한 형식의 시각화를 지원
- 파이썬 기반의 다른 시각화 패키지의 기본이된다.(Seabone, Pandas등)
## 1-1. 장점
- 동작하는 OS를 가리지 않음
- MATLAB과 유사한 사용자 인터페이스를 가짐
## 1-2. matplotlib 그래프 구성요소
- ![그래프](https://user-images.githubusercontent.com/77317312/110296834-20188800-8036-11eb-9e0f-1fa79d22cb6d.PNG)
### 용어 알아두기
- `figure` - 스케치북 생각
  - 전체 그래프가 위치할 기본 틀
  - https://matplotlib.org/api/_as_gen/matplotlib.pyplot.figure.html
- `axes(subplot)` - (스케치북 안에 몇등분해서 그림을 그릴지)
  - 하나의 그래프를 그리기 위한 공간
    - figure에 한개 이상의 axes(subplot)로 구성해서 각 axes에 그래프를 그린다.
  - https://matplotlib.org/api/axes_api.html
- `axis`
  - 축(x축, y축)
  - axis label(x, y) : 축의 레이블(설명)
- `ticks` : 축선의 표시
  - `Major tick`
  - `Minor tick`
- `title` : 그래프 제목
- `legend`(범례)
  - 하나의 axes내에 여러 그래프를 그린 경우 그것에 대한 설명

## 그래프 코드
```python
# `%` 쥬피터 노트북의 명령어 매직 커맨드 (지금은 default여서 생략가능)
# import 처럼 한번만 호출해도됨
%matplotlib inline

# `%maplotlib qt`이 명령어로 하면 결과를 팝업으로 보여줌
# 쥬피터에서는 많이 사용하지 않지만 다른 에디터를 사용할 때 사용한다.
% matplotlib qt

import matplotlib.pyplot as plt
import numpy as np

# 그래프 설정
fig = plt.figure(figsize=(15, 7), facecolor='gray;) # facecolor : figure의 배경색
axes1 = fig.add_subplot(1,2,1)
axes2 = fig.add_subplot(1,2,2)

axes1.plot([1,2,3,4,5], [10,20,30,40,50], label='line1')
axes1.plot([1,2,3,4,5], [50,40,30,20,10], label='line2')
axes2.scatter(np.random.randint(100, size=50), np.random.randint(100, 200, size=50), color='r')

# 그래프 꾸미기
fig.suptitile('Example of Plot', size=25, color='blue')
# size : 폰트크기, color : 글자색
axes1.set_title('PLOT 1', size=20)
axes2.set_title('PLOT 2', size=20)

axes1.set_xlabel('X축', size=15)
axes1.set_xlabel('Y축', size=15)
axes2.set_xlabel('가격1', size=15)
axes2.set_xlabel('가격2', size=15)

axes1.legend()
axes1.grid(True)

# 그래프 생성(위의 작업은 도면을 구성하는 일)
plt.show()
# 쥬피터에서는 생략을 해도되지만 그래도 습관적으로 넣자
```
- ![image](https://user-images.githubusercontent.com/77317312/110310752-3af2f880-8046-11eb-9fae-a5e088e6c93d.png)

# 2. 그래프 그리기
1. matplotlib.pyplot 모듈을 import
  - 2차원 그래프(axis가 두개인 그래프)를 그리기위한 함수를 제공하는 모듈
  - 주로 alias로 plt 사용
  - `import matplotlib.pyplot as plt`
2. 그래프를 그린다.
  - 2가지 방식
    - pyplot 모듈을 이용해 그린다.
    - `figure`과 `axes` 객체를 생성하여 그림
3. 그래프에 필요한 설정을 한다.
4. 화면을 그린다.
  - 지연 랜더링 메카니즘
  - 마지막에 `pyplot.show()` 호출 시 그래프를 그린다.
    - 주피터 노트북 맨 마지막 코드에 `;`를 붙이는 것으로 대체 가능
    - 
# 3. 그래프를 그리는 두가지 방식
- pyplot 모듈을 이용해 그리기
- figure와 axes객체를 생성하여 그리기

## 3-1. pyplot 모듈 이용해 그리기
- pyplot 모듈이 그래프 그리는 함수와 axes(subplot) 설정 관련 함수를 제공
```python
import matplotlib.pyplot as plt

# figure의 크기
plt.figure(figsize=(10, 5)) # 가로, 세로 크기(길이) - 단위 : inch

# subplot지정
plt.subplot(1, 2, 1) # 그래프를 그릴 axes(subplot)을 지정
# 그래프 그리기
plt.plot([1,2,3], [10,20,30])
# 추가 설정
plt.title('첫번째')

# 객체.subplot()지정시 섞이면 안됨

plt.subplot(1, 2, 2)
plt.plot([1,2,3], [10,20,30])
plt.title('두번째')

plt.show()
```
-![11](https://user-images.githubusercontent.com/77317312/110311856-b4d7b180-8047-11eb-84d2-133b629484c7.PNG)

## 3-2. figure와 axes(subplot) 객체를 이용해 그리기
