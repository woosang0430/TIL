# NLTK 텍스트 정규화 기본 문법
## 1. 텍스트 토큰화
- 분석을 위해 문서를 작은 단위로 나누는 작업
- **Tokenizer**
  - 문장을 token으로 나눠주는 함수
  - NLTK 주요 tokenizer
    - `sent_tokenize()` : 문장단위로 나눠준다.
    - `word_tokenize()` : 단어단위로 나눠준다.
    - `regexp_tokenize()` : 토큰의 단위를 정규식으로 지정
    - 반환타입 : 토큰 하나 하나를 원소로 하는 list
```python
txt = '''Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
...'''
```
```python
import nltk

nltk.sent_tokenize(txt) # 매개변수 : 토큰화할 대상 문서(문자열)
nltk.word_tokenize(txt)
nltk.regp_tokenize(txt, '\w+') # '\w' => 0-9a-zA-Z가-힣_
```
## 2. stopword(불용어)
- 문장에서 필요없는 것들을 불용어라고 한다.(조사, 접미사, 접속사, 대명사 등)
- stopword 단어들을 list로 묶어서 관리
  - nltk가 언어별로 Stop word 제공
  - 실제 분석대상에 맞는 stop word를 만들어서 사용
  - `from nltk.corpus import stopwords`
## .번외
- `tokenize_text()` 함수 구현
  - 문장별 토큰화 시키는 함수 구현
  - 쉼표, 마침표등 구두점(punctuation)은 공백처리한다.
  - stopword를 제외
```python
def tokenize_text(doc):
  """
  하나의  문서를 받아서 토큰화하여 반환하는 함수.
  문장별로 단어리스트를 2차원 배열형태로 반환
  구두점/특수문자, 숫자, 불용어들은 모두 제거
  모두 소문자로 구성
  [매개변수]
    doc : 변환대상 문서
  [반환값]
    list : 2차원 형태의 리스트(문장, 단어)
  """
  # 받은 문장을 다 소문자로 변환
  text = doc.lower()
  
  # 문장단위로 토큰화
  sent_tokens = nltk.sent_tokenize(text)
  
  # stopwords 리스트 생성
  sw = stopwords.words('english')
  sw.extend(['although', 'unless']) # 불용어 추가
  
  result_list = [] # 최종결과를 담을 리스트
  # 문장별로 단어단위 토큰화
  
  for sent in sent_tokens:
  
    # 문장단위 토큰화 작업. 특수문자 / 숫자 제거
    tmp_words = nltk.regexp_tokenize(sent, '[a-zA-Z가-힣]+`)
    
    # 불용어 제거
    tmp_words = [word for word in tmp_words if word not in sw]
    
    # 넣기
    result_list.append(tmp_words)
  
  return result_list
```
## 3. 형태소 분석
- 형태소
  - 일정한 의미가 있는 가장 작은 말의 단위
- 형태소 분석을 위한 기법
  - 어간추출(`Stemming`)
  - 원형(기본형) 복원 (`Lemmatization`)
  - 품사부착 (`POS tagging - Part of speech`)

### 3-1. 어간 추출(Stemming)
- 목적
  - 같은 의미를 가지는 단어의 여러가지 활용이 있을 경우 다른 단어로 카운트 되는 문제점을 해결
    - ex) flower, flowers가 두 개의 단어로 카운트 되는 것을 flower로 통일한다.
- nltk의 주요 어간 추출 알고리즘
  - `Porter Stemmer`
  - `Lancaster Stemmer`
  - `Snowball Stemmer`
- 메소드
  - `stemmer객체.stem(단어)`
- stemming의 문제
  - 완벽하지 않다는 것이 문제
    - ex) new와 news는 다른 단어인데 둘다 new로 처리한다.
```python
from nltk import PorterStemmer, LancasterStemmer, SnowballStemmer

# Stemming은 단어들을 알아서 소문자로 처리한 후 변환한다.
word = [
  'Working', 'works', 'worked',
  'painting', 'paints', 'painted',
  'happy', 'happier', 'happiest'
]
# 1. stemmer 객체 생성
# 2. stem(단어)을 호출해서 단어별로 어간추출 작업을 진행

ps = PorterStemmer()
print([ps.stem(word) for word in words])
## >>> ['work', 'work', 'work', 'paint', 'paint', 'paint', 'happi', 'happier', 'happiest']

ls = LancasterStemmer()
print([ls.stem(word) for word in words])
## >>> ['work', 'work', 'work', 'paint', 'paint', 'paint', 'happy', 'happy', 'happiest']

sbs = SnowballStemmer('english')
print([sbs.stem(word) for word in words])
## >>> ['work', 'work', 'work', 'paint', 'paint', 'paint', 'happi', 'happier', 'happiest']
```
### 3-2. 원형(기본형) 복원(Lemmatization)
- 단어의 기본형을 반환
  -  ex) am, is, are => be
- `WordNetLemmatizer객체.lemmatize(단어 [, pos=품사])`
- 이 친구는 따로 소문자를 변환 해줘야 한다.
- 파라미터
  - `pos`
  - pos 안에 넣을 값 = [n : 명사, a : 형용사, v : 동사, r : 부사]
```python
from nltk.stem import WordNetLemmatizer

words = ['is', 'are', 'am', 'has', 'had', 'have']
lemm = WordNetLemmatizer()
print([lemm.lemmatize(word, pos='v') for word in words])
## >>> ['be', 'be', 'be', 'have', 'have', 'have']
```
### 3-3. 품사부착 - POS Tagging(Part-Of-Speech Tagging)
- 형태소에 품사를 붙이는 작업
- NLTK는 펜 트리뱅크 태그세트(Penn Treebank Tagset) 이용
  - 명사 : N으로 시작(NN-일반 명사, NNP-고유명사)
  - 형용사 : J로 시작(JJ, JJR-비교급, JJS-최상급)
  - 동사 : V로 시작(VB-동사, VBP-현재형 동사)
  - 부사 : R로 시작(RB-부사)
  - `nltk.help.upenn_tagset(['키워드'])` : 도움말
- `pos_tag(단어_리스트)`
  - 단어와 품사를 튜플로 묶은 리스트 반환
```python
from nltk.tag import pos_tag
words = ['Book', 'book', 'car', 'go', 'Korea', 'have', 'good']
pos_tag(words)
## >>> [('Book', 'NNP'),
## >>>  ('book', 'NN'),
## >>>  ('car', 'NN'),
## >>>  ('go', 'VBP'),
## >>>  ('Korea', 'NNP'),
## >>>  ('have', 'VBP'),
## >>>  ('good', 'JJ')]
```
### txt 원형 복원
- 각 token에 품사를 부착
- 원형 복원 처리
```python
tokens = tokenize_text(txt)

# 2중 리스트를 리스트로 만들기
tokens = [w for word_list in tokens for w in word_list]

# 품사 부착
pos_taged_tokens = pos_tag(tokens)
pos_taged_tokens
## >>> [('beautiful', 'JJ'),
## >>>  ('better', 'JJR'),
## >>>  ('ugly', 'RB'),
## >>>  ('explicit', 'JJ'),
## >>>  ...]
```
### 펜 트리뱅크 태그셋의 품사를 pos_tag() 반환 형식) WordNetLemmatizer(원형복원 처리 객체)가 사용하는 품사 형식으로 변환하는 함수 정의
```python
def get_wordnet_postag(pos_tag):
  if pos_tag.startswith('J'):
    return 'a'
  if pos_tag.startswith('N'):
    return 'n'
  if pos_tag.startswith('V'):
    return 'v'
  if pos_tag.startswith('R'):
    return 'r'
  else:
    return None
```
### 텍스트 전처리 함수(단어토큰화, 불용어 제거, 원형 복원)
```python
from nltk.stem import WordNetLemmatizer
from nltk
def tokenize_text2(doc):
  # 소문자 변환
  text = doc.lower()
  # 문자단위 토큰화
  sent_tokens = sent_tokenize(text)
  
  # Stopwords 리스트 load
  sw = stopwords.words('english')
  sw.entend(['although', 'unless']) # stopword 추가.
  
  # WordnetLemmatization 객체 생성
  lemm = WordnetLemmatization()
  
  # 최종결과 저장 list
  result_list = []
  
  # 단어단위 토큰화
  for sent in sent_tokes:
    # 단어단위 토큰화
    word_tokens = nltk.regexp_tokenize(sent, r'[a-zA-Z]+')
    
    # 불용어 제거
    word_tokens = [word for word in word_tokens if word not in sw]
    
    # 원형 복원
    # 1. pos_tag
    word_tokens = pos_tag(word_tokens)
    
    # 2. wordnet이 사용하는 품사태그로 변환
    word_tokens = [(word, get_wordnet_postag(tag)) for word, tag in word_tokens if get_wordnet_postag(tag) != None]
    
    # 3. 원형복원
    word_tokens = [lemm.lemmatize(word, pos=tag) for word, tag in word_tokens]
    result_list.append(word_tokens)
    
  return result_list

tokenize_test2(txt)
## >>> [['beautiful', 'good', 'ugly'],
## >>>  ['explicit', 'well', 'implicit'],
## >>>  ['simple', 'well', 'complex'],
## >>>  ['complex', 'well', 'complicate'],
## >>> ...
```
## .번외 새로운 텍스트 파일 불러오기
```python
with open('news.txt', 'rt', encoding='utf-8') as f:
  news_text = f.read()
```
# 분석을 위한 클래스들
## 1. Text클래스
- 문서 분석에 유용한 여러 메소드 제공
- **토큰 리스트**을 입력해 객체생성 후 제공되는 메소드를 이용해 분석
- **생성**
  - Text(토큰리스트, [name=이름])
- **주요 메소드**
  - `count(단어)`
    - 매개변수로 전달한 단어의 빈도수
  - `plot(N)`
    - 빈도수 상위 N개 단어를 선그래프로 시각화
  - `dispersion_plot(단어리스트)`
    - 매개변수로 받은 단어들이 전체 말뭉치의 어느 부분에 나오는지 시각화
```python
news_tokens = tokenize_text2(news_text)

news_words = []
for word_list in news_tokens:
  news_words2.extend(word_list)
  
from nltk import Text
import matplotlib.pyplot as plt

# Text 객체 생성
news_text = Text(news_words, name='손흥민 뉴스')

# Text.count(단어) : 단어의 빈도수 조회
news_text.count('parent'), news_text.count('son')
## >>> (5, 45)

# 빈도수 상위 단어들에 대한 선그래프
plt.figure(figsize=(10, 6))
news_text.plot(20)

plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/114527637-2fb56d00-9c83-11eb-931b-4a34a54f32c3.png)
```python
# 특정 단어의 위치
plt.figure(figsize=(10, 6))
news_text.dispersion_plot(['son', 'korean', 'say', 'tottenham'])
plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/114527871-6be8cd80-9c83-11eb-9c24-5fcd12bd6e10.png)
## 2. FreqDist
- document에서 사용된 토큰(단어)의 사용빈도 데이터를 가지는 클래스
- **생성**
  - Text 객체의 `vocab()` 메소드로 조회
  - 생성자(initializer)에 토큰 list를 직접 넣어 생성가능
- **주요 메소드**
  - `B()` : 출연한 고유 단어의 개수
    - ['apple', 'apple'] -> 1
  - `N()` : 총 단어수
    - ['apple', 'apple'] ->2
  - `get(단어)` 또는 `FreqDist['단어']` : 특정 단어의 출연 빈도수
  - `freq(단어)` : 총 단어수 대비 특정단어의 출연비율
  - `most_common()` : 빈도수 순서로 정렬하여 리스트로 반환
## 3. wordcloud
- 단어의 빈도수를 시작화
- 많이 출연한 단어는 크게, 적게 출현한 단어는 작게 표현하여 핵심단어들을 쉽게 파악할 수 있게 한다.
- `pip install wordcloud`
- `conda install -c conda-forge wordcloud`
```python
# 한글처리를 위해서는 한글을 지원하는 폰트의 경로를 지정해야한다.
# 폰트 경로 조회
import matplotlib.font_manager as fm

[(f.name, f.fname) for f in fm.fontManager.ttflist if 'malg', in f.name.lower()]
## >>> [('Malgun Gothic', 'C:\\Windows\\Fonts\\malgunsl.ttf'),
## >>>  ('Malgun Gothic', 'C:\\Windows\\Fonts\\malgun.ttf'),
## >>>  ('Malgun Gothic', 'C:\\Windows\\Fonts\\malgunbd.ttf')]
  
font_path = 'C:\\Windows\\Fonts\\malgun.ttf'
from wordcloud import WordCloud
# 설정
wc = WordCloud(font_path=font_path,
               max_words=100, # 최대 나오는 단어의 개수
               prefer_horizontal=0.7, # 가로쓰기 비율
               relative_scaling=0.5, # 0 ~ 1 사이의 실수. 1에 가까울수록 빈도수가 많은 단어와 적은 단어의 크기 차이를 크게 한다.
               min_font_size=1,
               max_font_size=50m # 가장 작은 폰트크기 ~ 가장 큰 폰트크기 지정
               )
# WordCloud객체에 데이터 넣기
word_cloud = wc.generate_from_frequencies(freq) # 딕셔너리 형태

# 파일로 저장
word_cloud.to_file('word_cloud.png')

# matplotlib으로 출력
plt.figure(figsize=(10,10))
plt.imshow(word_cloud)
plt.axis('off')
plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/114530781-3c879000-9c86-11eb-87d5-e3a888484ff3.png)
## 4. scikit-learn의 CountVectorizer를 이용해 TDM만들기
- **TDM**
  - Term-Document-Matrix
  - 문서안에서 문서를 구성하는 단어들이 몇번 나왔는지를 표현하는 행렬
- TDM 행렬 반환
  - 컬럼 : 문서
  - 행 : 고유단어
  - Value : 개수
- 학습 : fit(raw document)
  - raw document - 문장을 원소로 가지는 1차원 배열형태 문서
  - 전체 문장들(corpus)에서 고유단어들을 찾아낸 뒤 index를 붙인다.
- 변환 : transform(raw document)
  - 문장별(원소) 단어 count
- CountVectorizer 주요 속성, 메소드
  - cv.vocabulary_
    - 단어-index 반환(딕셔너리)
  - get_feature_names()
    - index순서대로 단어들 반환
```python
docs = [
  'This is the first document. I write this document',
  'I like apple. I read document'
]
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer()
cv.fit(docs)

cv.vovabulary_
## >>> {'this': 7,
## >>>  'is': 3,
## >>>  'the': 6,
## >>>  'first': 2,
## >>>  ...

dtm = cv.transform(docs)
dtm.toarray()
## >>> array([[0, 2, 1, 1, 0, 0, 1, 2, 1],
## >>>        [1, 1, 0, 0, 1, 1, 0, 0, 0]], dtype=int64)

cv.get_feature_names()
## >>> ['apple', 'document', 'first', 'is', 'like', 'read', 'the', 'this', 'write']

import pandas as pd
pd.DataFrame(dtm.toarray(), columns=cv.get_feature_names())
```
- ![image](https://user-images.githubusercontent.com/77317312/114532356-bb30fd00-9c87-11eb-9b8e-abad1d98fe83.png)
