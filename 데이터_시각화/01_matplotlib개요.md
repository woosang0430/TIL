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
### .번외 그래프 배치해주는 메소드( plt.tight_layout())
- plt.show() 위에 한번만 해준다.
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

plt.tight_layout()
plt.show()
```
-![11](https://user-images.githubusercontent.com/77317312/110311856-b4d7b180-8047-11eb-84d2-133b629484c7.PNG)
- 하나의 subplt(axes)에 여러개의 그래프 그리기
```python
import matplotlib.pyplot as plt
plt.figure(figsize=(7,7))

# 그래프 그리기
plt.plot([1,2,3,4,5,6], [10,20,30,40,50,60], label='Line A') # 선그래프
plt.scatter([10,20,30,40,50,60], [1,2,3,4,5,6], label='Scatter') # 산점도
plt.plot([10,20,30,40,50,60], [10,20,30,40,50,60], label='Line B') # 선그래프

plt.legend() # 범례(lengend) 생성
plt.show()
```
## 3-2. figure와 axes(subplot) 객체를 이용해 그리기
- figure에 axes를 추가한 뒤 axes에 그래프 그리기
- axes 생성
 - `figure.add_subplot()` 메소드 이용
   - figure를 먼저 생성 후 axes 추가 생성
 - `pyplot.subplots()` 함수 이용
   - figure와 axes배열 동시 생성

### 3-2-1. figure.add_subplot() 메소드 이용
- figure객체에 axes를 추가하는 형태
- nrows(총행수), ncols(총열수), index(axes위치) 지정
```python
import matplotlib.pyplot as plt
# figure 객체 생성
fig = plt.figure(figsize=(5,5))

# figure에 axes(subplot) 추가
ax1 = fig.add_subplot(2,2,1)
ax2 = fig.add_subplot(1,2,2)
ax3 = fig.add_subplot(2,2,3)

ax1.text(.5, .5, 'ax1', fontsize=20)
ax1.set_title('ax1')
ax1.set_xlabel('X축')
ax1.set_ylabel('Y축')

ax2.text(.5, .5, 'ax2')
ax2.set_title('ax2')
ax2.set_xlabel('X축')
ax2.set_ylabel('Y축')

ax3.text(.5, .5, 'ax3')
ax3.set_title('ax3')
ax3.set_xlabel('X축')
ax3.set_ylabel('Y축')

plt.tight_layout()
plt.show()
```
### 3-3-3. pyplot.subplots()
- nrows, ncols로 axes개수와 위치 지정
- 반환 : figure와 axes(subplot)들을 담은 **ndarray**
```python
import matplotlib.pyplot as plt

fig, axes = plt.subplots(2,2, figsize(10,10)) # 행수, 열수 지정
fig.suptitle('Figure 제목', size=40) # 전체 타이틀

ax1, ax2, ax3, ax4 = axes.flatten()

ax1.scatter([1,2,1,2,6],[7,3,4,2,1])
ax1.set_title('[0,0]')

ax2.plot([1,2,3], [1,2,3], label='line1')
ax2.plot([3,2,1], [1,2,3], label='line2')
ax2.grid(True)
ax2.legend()

# axes[0,0].scatter([1,2,1,2,6],[7,3,4,2,1])
# axes[0,0].set_title('[0,0]')

for i , ax in enumerate([ax1, ax2, ax3, ax4], start=1):
    x, y = 0.5, 0.5
    if ax == ax1:
        x, y = 5, 5
    ax.text(x, y, f'ax{i}', fontsize=20)

plt.tight_layout()
plt.show()
```
# 4. 색상과 스타일
## 4-1. 색 지정
- color 또는 c 속성을 이용해 지정
1. 색상이름으로 지정
  - 색이름 또는 약자로 지정 가능    

| 문자열 | 약자 |
|-|-|
| `blue` | `b` |
| `green` | `g` |
| `red` | `r` |
| `cyan` | `c` |
| `magenta` | `m` |
| `yellow` | `y` |
| `black` | `k` |
| `white` | `w` |
2. HTML 컬러 문자열
- #RRGGBBAA
- red/green/blue/alpha(투명도)
3. 0~1 사이 실수로 흰색과 검은색 사이의 회색조 표시
- https://matplotlib.org/examples/color/named_colors.html
- https://htmlcolorcodes.com/
```python
import matplotlib.pyplot as plt

plt.figure(figsize=(5,5), facecolor='gray')
plt.plot([1,2,3], [10,20,30], color='r') # 색의 약어
plt.plot([1,2,3], [10,20,30], color='goldenrod') # 색이름
plt.plot([1,2,3], [10,20,30], color='#CF6AC8') # HTML color 코드
plt.plot([1,2,3], [10,20,30], color='#FF0000A0') # RRGGBBAA : AA - 투명도(0에 가까울 수록 투명한 것)
plt.plot([1,2,3], [10,20,30], color='0.9') # 0(검정) ~ 1(흰색) 실수 - 회색조

plt.show()
```
## 4-2. style
- Style: 그래프의 여러 시각효과들을 미리 설정해 놓은 것
- matplotlib는 다양한 스타일들을 미리 정의해 놓고 있다.
    - [스타일목록](https://matplotlib.org/gallery/style_sheets/style_sheets_reference.html)
    - `plt.style.use()` 함수 이용해 지정
    - 스타일 초기화
```python
import matplotlib as mpl
mpl.rcParams.update(mpl.rcParamsDefault)
```
- 사용 예시
```python
import numpy as np

x = np.linspace(1, 10, num=100)

# plt.style.use('dark_background')
# plt.style.use('ggplot')
plt.style.use('seaborn') # 나는 이거

plt.figure(figsize=(5,5))
plt.plot(x, x+3)
plt.plot(x, x+2)
plt.plot(x, x+1)
plt.plot(x, x)

plt.show()
```
