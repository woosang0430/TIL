# DataFrame(데이터 프레임)
- 표(테이블-행렬)를 다루는 Pandas 클래스
- 행 이름 : index, 열 이름 : column
  - 행, 열 이름은 명시적으로 지정 가능(지정하지 않는 경우 순번이 index, column의 명으로 사용한다.)

## 1. dataframe 생성
- `pd.DataFrame(data [, index=None, columns=None])
- `data`
  - Series, list, ndarray를 담은 2차원 배열 : 행단위
  - 열이름을 key로 컬럼의 값 value로 하는 딕션너리 : 열단위
- `index`
  - index명으로 사용할 값 배열로 설정
- `columns`(필수처럼 사용)
  - 컬럼명으로 사용할 값 배열로 설정

```python
import pandas as pd
import numpy as np

data_dict = {
  'id' : ['id-1', 'id-5', 'id-2', 'id-4', 'id-3'],
  'korea' : [100, 50, 70, 60, 90],
  'english' : [90, 80, 100, 50, 100]
}
grade = pd.DataFrame(data_dict)
print(grade)
#      id  korean  english
# 0  id-1     100       90
# 1  id-5      50       80
# 2  id-2      70      100
# 3  id-4      60       50
# 4  id-3      90      100
```
## 2. DataFrame 파일로 저장
- `DataFrame객체.to_csv(파일경로, sep=',', index=True, header=True, encoding)
  - 파일경로 : 저장할 파일경로(경로/파일명)
  - sep : 데이터 구분자
  - index, header : 인덱스 / 헤더 저장 여부(index는 거의 False로 저장)
  - encoding
    - 생략시 운영체제 기본 encoding 방식
- `DataFrame객체.to_excel(파일경로, index=True, header=True)`
  - 엑셀파일로 저장
## 2-1. 파일로 부터 데이터셋을 읽어와 생성하기
- `d.read_xxx() : xxx = 포맷

### csv 파일 등 텍스트 파일로 부터 읽어와 생성
- `pd.read_csv(파일경로, sep=',', header, index_col, na_values, encoding)`
- 파일경로 : 읽어올 파일의 경로
- `sep` : 데이터 구분자
- `header = 정수`
  - 열이름(컬럼이름)으로 사용할 행 지정
  - default : 첫번째 행
  - None 설정 : header(컬럼명)는 0부터 자동증가하는 값
- `index_col=정수, 컬럼명`
  - index명으로 사용할 열이름(문자열)이나 열의 순번(정수)을 지정
  - default = 0부터 자동증가하는 값
- `na_values`
  - 읽어올 데이터셋의 값 중 결측치로 처리할 문자열 지정
  - NA, N/A, 빈값 => 결측치로 자동 인식

## 3. 주요 메소드, 속성
- `d.T` : 행/열을 바꾼다.
- `d.head(정수)` / `d.tail(정수)` : 데이터 정수 행만큼 조회. default=5
- `d.shape`, `d.size` : 행렬의 수를 튜플로 리턴, 원소의 총 개수
- `d.columns` / `d.index` : 열의 이름 / index 이름을 조회 및 변경
- `d.describe()` : 요약 통계량 제공
  - 수치형 : 기술 통계 값
  - 범주형(문자열) : 고유 값 개수 등 빈도수관련 정보
  - 컬럼(열단위) 기준으로 계산
  - `include`나 `exclude` 매개변수로 특정 타입만 선택가능
- `d.info()` : 각 열 별 데이터 타입과 결측치 개수를 조회
- `d.isin([값리스트])` : 리스트의 in연산자와 비슷
- `count()` : 열별 결측치 제외한 원소 개수
- `min()`/`max()` : 최소값 / 최대값
- `sum()`/`mean()` : 합계 / 평균
- `median()`/`std()` : 중앙값 / 표준편차
- `var()`/`mode()` : 분산 / 최빈값
- `idxmin()`/`idxmax` : 최소/최대값의 인덱스
- `nunique()` : 열별 고유 값의 개수 조회
- `quantile(q=분위)` : 열별 분위수 계산. q생략 시 .5(중앙값)
- `isnull()`/`notnull()` : 열별 결측치 체크
- `fillna(변환값)` : 결측치를 한번에 특정 값으로 변환
- `dropna()` : 결측치가 있는 행/열 제거
- `sort_values(기준열 이름리스트, ascending=True)` : 전달한 열이름을 기준으로 정렬, (ascending : 정렬기준 default오름차순)
## 번외 데이터 프레임의 기본 정보 조회
- 데이터를 불러오고 데이터 읽어보기!
- csv 파일 읽기
- shape
- head() / tail()
- info()
- isnull().sum() => 컬럼별 null체크 (sum()을 한번 더 하면 총개수)
- index / columns
- describe() : 숫자형-기술통계값, 문자열-총개수, 유니크값, 최빈값

## 4. 컬럼이름 / 행이름 조회 및 변경
### 4-1. 컬럼이름/행이름 조회
### 4-2. 컬럼이름/행이름 변경
### 4-3. 컬럼이름/행이름 변경 관련 메소드

## 5. 행 / 열 삭제

## 6. 열 추가

## 7. 열별 값 조회
### 7-1. 열(컬럼) 조회
### 7-2. 다양한 열선택 기능을 제공하는 메소드들

## 8. 행 조회
### 8-1. loc : 행 이름으로 조회
### 8-2. iloc : 행 순번으로 조회

## 9. Boolean indexing을 이용한 조회
