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

# 폰트등 환경 설정
## 1. 설정 파일변경 (이 친구는 패키지 다운받을 때, 환경 구축할 때 한번만 하면됨 ㅇㅇ)
