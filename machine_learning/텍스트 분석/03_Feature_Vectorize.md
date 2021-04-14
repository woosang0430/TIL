# Feature Vectorization 개요
- 텍스트를 숫자형값의 정형데이터로 변환하는 것을 feature vectorization이라고 한다.

# BOW (Bag Of Words)
- 많이 나온 단어가 중요한 단어
- 문서내에 단어 빈도수에 기반하여 Vector화 하는 모델
- **DTM/TDM**(Document Term Matrix)
  - 행 : 문서, 열 : 단어 - DTM
  - 행 : 단어, 열 : 문서 - TDM
  - value : 개수
- **TF-IDF**(Term Frequency Inverse Document Frequency)
  - CountVectorize의 문제 : 문장 구조상 많이 나오는 단어들의 경우 카운트 값이 많이 나오게 되고 중요한 단어로 인식된다.(ex : 관사, 접속사, 주제어 등) 이 문제를 보완한 모델이 TF-IDF 모델
  - 개별 문서에 많이 나오는 단어가 높은 값을 가지도록 하되 동시에 여러 문서에 자주나오는 단어에는 페널티를 주는 방식

# DTM/TDM (Document Term Matrix)
- 문서 단어 행렬
  - 문서별로 각 단어가 나타난 횟수를 정리한 표
  - 컬럼 : 전체 문서에 나오는 모든 단어
  - 행 : 문서
  - 값 : 각 단어가 문서에 나온 횟수
- 단어 문서 행렬
  - 문서 단어 행렬의 컬럼과 행이 반되
- scikit-learn의 `CountVectorize` 이용

## 1. CountVectorizer
- 주요 생성자 매개변수
  - `stop_word` : stopword 지정
    - str : 'english' - 영문 불용어는 제공됨
    - list : stopword 리스트
  - `max_df` : 특정 횟수 이상나오는 것은 무시하도록 설정
  - `min_df` : 특정 횟수 이하로 나오는 것은 무시하도록 설정
  - `max_features` : 최대 token 수
  - `ngram_range` : n_gram 범위 지정
- 메소드
  - `fit(x)`
  - `transform(x)`
  - `fit_transform(x)`
- n_gram
- DTM는 문맥상에서 단어의 의미를 무시된다. 이것을 보완하는 것이 n_gram 기법이다.
- n개의 단어를 묶어서 feature로 구성
# TF-IDF (Term Frequency - Inverse Document Frequency)
- 개별 문서에 많이 나오는 단어가 높은 값을 가지도록 하되 동시에 여러 문서에 자주 나오는 단어에는 페널티를 주는 방식
- 어떤 문서에 특정 단어가 많이 나오면 그 단어는 해당 문서를 설명하는 중요한 단어일 수 있다. 그러나 그 단어가 다른 문서에도 많이 나온다면 언어 특성이나 주제상 많이 사용되는 단어 일 수 있다.
- 각 문서의 길이가 길고 문서개수가 많은 경우 Count 방식 보다 TF-IDF 방식이 더 좋은 예측 성능을 내는 경우가 많다.
#### 공식 
- TF(Term Frequency) : 해당 단어가 해당 문서에 몇번 나오는지를 나타내는 지표
- DF(Document Frequency) : 해당 단어가 몇개의 문서에 나오는지를 나타내는 지표
- IDF(Inverse Document Frequency) : DF에 역수
- ![image](https://user-images.githubusercontent.com/77317312/114712031-9b263a00-9d6a-11eb-9561-8c2e9a4f6ef5.png)

## 2. TfidVectorizer
- 주요 생성자 매개변수
  - `stop_word` : stopword 지정
    - str : 'english' - 영어 불용어는 제공됨
    - list : stopword 리스트
  - `max_df` : 특정 횟수 이상나오는 것은 무시하도록 설정
  - `min_df` : 특정 횟수 이하로 나오는 것은 무시하도록 설정
  - `max_features` : 최대 token 수
  - `ngram_range` : n_gram 범위 지정
- 메소드
  - `fit(x)`
  - `transform(x)`
  - `fit_transform(x)`
