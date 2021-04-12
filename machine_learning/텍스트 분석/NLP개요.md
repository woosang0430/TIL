# NLP(Natural Language Processing) 자연어 처리
## 1. 자연어
- 사람이 사용하는 고유한 언어
- 인공언어의 반대 의미 ex) 프로그래밍 언어

## 2. 자연어 처리
- 사람이 사용하는 자연어를 컴퓨터가 사용할 수 있도록 처리하는 과정
- 자연어 처리 응용 분야
> - 번역 시스템
> - 문서요약
> - 감성분석
> - 대화형 시스템(챗봇)
> - 정보 검색 시스템
> - 텍스트 마이닝
> - 음성인식

## 3. 텍스트 분석 수행 프로세스
### 3-1. 텍스트 전처리
>  - **클렌징(cleansing)**
>    - 특수문자, 기호 필요없는 문자 제거
>    - 대소문자 변경
>  - **텍스트 토큰화**
>    - 분석의 최소단위로 나누는 작업
>    - 보통 단어단위나 글자단위로 나눈다.
>  - **어근 추출(Stemming/Lemmatization)**을 통한 텍스트 정규화 작업
### 3-2. Feature Vectorization
>  - 문자열 비정형 데이터인 텍스트를 숫자타입의 정형데이터로 만드는 작업
>  - BOW와 Word2Vec
### 3-3. 머신러닝 모델 수립, 학습, 예측, 평가

# NLTK
- Natural Language Toolkit
- https://www.nltk.org/
- 자연어 처리를 위한 파이썬 패키지
# NLTK 설치
- nltk 패키지 설치 pip 설치
`pip install nltk`
- NLTK 추가 패키지 설치
```python
import nltk

nltk.download() # 설치 GUI 프로그램 실행
nltk.download('패키지명')
```
## 1. NLTK 주요기능
- **말뭉치(corpus) 제공**
  - 언어 연구를 위해 텍스트를 컴퓨터가 읽을 수 있는 형태로 모아 놓은 언어 자료
- **텍스트 정규화를 위한 기능 제공**
  - 토큰 생성
  - 여러 언어의 stop word(불용어) 제공 -> 한글은 제공 X
  - 형태소 분석
    - 형태소 : 의미 있는 가장 작은 말의 단위
    - 형태소 분석
      - 말뭉치에서 의미있는 형태소들만 추출하는 것
    - 어간추출(Stemming)
    - 원형복원(Lemmatization)
    - 품사부착(POS tagging - Part of Speech)
- **분석기능을 제공해 주는 클래스**
  - Text
  - FreqDist
