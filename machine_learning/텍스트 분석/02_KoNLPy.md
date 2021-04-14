# KoNLPy(코엔엘파이)
- 한국어 처리를 위한 파이썬 패키지
- http://KoNLPy.org/ko/latest/

# KoNLPy 설치
- java 실행환경 설치
- JPype1 설치
- koNLPy 설치

1. Java설치
- https://www.oracle.com/java/technologies/javase-downloads.html
- os에 맞게 다운로드
- 환경변수 설정
  - `JAVA_HOME` : 설치 경로 지정
  - `Path` : 설피경로\bin 경로 지정
2. JPype1 설치
- 파이썬에서 자바 모듈을 호출하기 위한 연동 패킺;
- 설치 : `pip install JPype1==0.7.0`
3. KoNLP 설치
- `pip install konlpy`

# KoNLPy 제공 말뭉치(corpus)
- kolaw : 대한민국 헌법 말뭉치
  - constitution.txt
- kobill : 대한민국 국회 의안(국회에서 심의하는 안건-법률, 예산등)
```python
from konlpy.corpus import kolaw, kobill

# corpus파일이름 조회
kolaw.fileids()
## >>> ['constitution.txt']

kobill.fileids()
## >>> ['1809890.txt',
## >>>  '1809891.txt',
## >>>  '1809892.txt',
## >>>  ...

constitution = kolaw.open('contitutuib.txt').read()
```
# 형태소 분석기/사전
- 형태소 사전을 내장하고 있으며 형태소 분석 함수들을 제공하는 모듈
## KoNLPy 제공 형태소 분석기
- `Komoran`(코모란) - 성능 좋고 속도가 빠름
  - https://github.com/shin285/KOMORAN
- `Open Korean Text` - 신조어를 처리 해줄 수 있다.
  - https://github.com/open-korean-text/open-korean-text

# 형태소 분석기 공통 메소드
- `morphs(string)` : 형태소 단위로 토큰화(tokenize)
- `nouns(string)` : 명사만 추출하여 토큰화(tokenize)
- `pos(string)` : 품사 부착
  - 형태소 분석기 마다 사용하는 품사태그가 다른다.
    - https://konlpy-ko.readthedocs.io/ko/v0.5.2/morph/
- `tagset` : 형태소 분석기가 사용하는 품사태그 설명하는 속성
```python
txt = '''지난해 한국 천주교 신자 수가 592만여 명으로 전년보다 0.1% 늘어나는데 그쳤다. 코로나19 여파로 70년 만에 최저치 증가율을 보인 것으로, 신자 증가세가 둔화하는 것뿐 아니라 신자의 고령화도 심화하고 있다.
13일 한국 천주교 주교회의가 발표한 ‘한국 천주교회 통계 2020’에 따르면 지난해 말 기준 전국 16개 교구가 집계한 신자 수는 592만 3300명으로 2019년 대비 0.1%(8631명) 증가했다. 이는 총 인구 5297만 4563명의 11.2%에 해당한다. 총 인구 대
...'''
from konlpy.tag import Okt
okt = Okt()

# 형태소 추출
morphs_tokens = okt.morphs(txt)

# 명사만 추출
nouns_tokens = okt.nouns(txt)

# 품사 부착
pos_tokens = okt.pos(txt)
pos_tokens = okt.pos(txt, join=True)

from konlpy.tag import Komoran()
kom = Komoran()

# 형태소 추출
tokens = kom.morphs(txt)

# 명사만 추출
nouns_tokens = kom.nouns(txt)

# 품사 부착
pos_tokens = kom.pos(txt)
```
# KoNLPy 형태소 분석기와 NLTK를 이용한 문서 분석
```python
from nltk import Text
from konlpy.corpus import kolaw
from konlpy.tag import Komoran

law = kolaw.open('constitution,txt').read()

# 명사만 추출
kom = Komoran()
nouns = kom.nouns(law)

# 1글자인 단어들은 제거
nouns = [word for word in nouns if len(word) > 1]

text = Text(nouns, name='헌법')

import matplotlib as mpl
mpl.rcParams['font.family']='malgun gothic'

import matplotlib.pyplot as plt
plt.figure(figsize=(7,6))
plt.title('헌법에 나온 명사 빈도수 상위 20개', fontsize=20)
text.plot(20)

plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/114696625-d2d7b680-9d57-11eb-8860-dbbf45f92f47.png)
```python
plt.figure(figsize=(15, 10))
text.dispersion_plot(['법률', '대통령', '국가', '국회', '헌법'])

plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/114696766-ff8bce00-9d57-11eb-98a3-4df939b98b62.png)
```python
# 매개변수로 전달한 단어가 나오는 라인(width 글자만큼)을 출력
text.concordance('국민', width=50, lines=10) # lines : 줄 제한

freq = text.vocab()
freq
## >>> FreqDist({'법률': 128, '대통령': 84, '국가': 70, '국회': 69, '국민': 67, '헌법': 55, '필요': 30, '기타': 26, '사항': 23, '법관': 22, ...})

# 각 단어가 몇번 사용됐는지
freq.most_common()
```
