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
- `WordNetLemmatizer객체.lemmatize(단어 [, pos=품사])
- 이 친구는 따로 소문자를 변환 해줘야 한다.
- 파라미터
  - `pos= [n : 명사, a : 형용사, v : 동사, r : 부사]`
```python
from nltk.stem import WordNetLemmatizer

words = ['is', 'are', 'am', 'has', 'had', 'have']
lemm = WordNetLemmatizer()
print([lemm.lemmatize(word, pos='v') for word in words])
## >>> ['be', 'be', 'be', 'have', 'have', 'have']
```











