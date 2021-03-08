# matplotlib 한글처리
- matplotlib에 설정되있는 폰트가 한글을 지원하지 않기 때문에 그래프의 한글이 깨져 나온다.

## Solution
1. 설정파일을 변경
  - 한번망 하면 됨
2. 프로그램상에서 변경
  - 프로그램이 로딩 될때 마다 코드 실행
  - 전체 설정에서 변경하고 싶은 것을 재설정

## OS에 설치된 폰트명 조회
- 폰트 cache 파일을 삭제한다.
```python
import matplotlib as mpl
import matplotlib.font_manager as fm

# cache 파일 조회
# 다음 실행 결과로 나온 경로의 파일을 삭제
mpl.get_cachedir()

# 전체 폰트 조회
for f in fm.fontManager.ttflist:
    print(f.name, f.fname, sep=':::') # 폰트 이름, 폰트 파일경로
    print()
    
# 원하는 폰트명 찾기( 지금은 맑은고딕체)
[(f.name, f.fname) for f in fm.fontManager.ttflist if 'malg' in f.name.lower()]
# mac : AppleGothic
# 설정시 폰트 이름을 사용
```
# 1. 설정 파일변경 (이 친구는 패키지 다운받을 때, 환경 구축할 때 한번만 하면됨 ㅇㅇ)
- 한번만 하면 되므로 편리함

> - 설정파일 경로찾기 : `matplotlib.matplotlib_fname()` matplotlib 관련 전역 설정들을 찾아 바꿔준다.
- 폰트 관련 설정(설정시 `#`[주석] 을 지우고 수정)
> - font.family:Malgun Gothic
> - font.size:12
> - xtick.labelsize:12
> - ytick.labelsize:12 
> - axes.labelsize:12  
> - axes.titlesize : 20
> - axes.unicode_minus:False
```python
# matplotlibrc경로 찾기
import matplotlib as mpl

mpl.matplotlib_fname()

# 'C:\\Users\\user\\anaconda3\\lib\\site-packages\\matplotlib\\mpl-data\\matplotlibrc'
```
- 경로 끝에 `matplotlibrc`를 메모장으로 열어준다 바꿔준다.

##  Font색 변경
> - text.color : COLOR
> - axes.labelcolor : COLOR
> - xtick.color : COLOR
> - ytick.color : COLOR

# 2. 함수를 이용한 설정
- 이 친구는 매 순간 한번 씩 실행시켜줘야한다.
- `matplotlib.rcParam['설정'] = 값`으로 한다.
```python
import matplotlib as mpl
from matplotlib import font_manager as fm

# 한글 폰트 설정
font_name = fm.FontProperties(fname="c:/Windows/Fonts/malgun.ttf").get_name()
print(font_name)
# Malgun Gothic

# mpl.rcParams["font.family"] = "Malgun Gothic"
mpl.rcParams["font.family"] = font_name # 이거 꼭해야됨(폰트 설정)
mpl.rcParams["font.size"] = 15
mpl.rcParams['xtick.labelsize'] = 12
mpl.rcParams['ytick.labelsize'] = 12
mpl.rcParams['axes.labelsize'] = 15
# tick의 음수기호 '-' 가 깨지는 것 처리
mpl.rcParams['axes.unicode_minus'] = False # 이거 꼭해야됨( `-` 를 넣을지 말지)

# Font 색 변경!
COLOR = 'blue'
mpl.rcParams['text.color'] = COLOR
mpl.rcParams['axes.labelcolor'] = COLOR
mpl.rcParams['xtick.color'] = COLOR
mpl.rcParams['ytick.color'] = COLOR
```
