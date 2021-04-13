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























