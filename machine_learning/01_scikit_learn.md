> - ### 내장 데이터셋 가져오기
> - from `sklearn.datasets` import `load_xxx`

> - ### 결정트리 모델 import
> - from `sklearn.tree` import `DecisionTreeClassifier`

> - ### 데이터셋 분할
> - from `sklearn.model_selection` import `train_test_split`

> - ### 모델 평가
> - from `sklearn.metrics` import `accuracy_score` # 정확도 점수
> - from `sklearn.metrics` import `confusion_matrix` # 혼동행렬

# scikit-learn 내장 데이터셋 가져오기
- scikit-learn은 머신러닝 모델을 테스트 하기위한 데이터셋을 제공
- 패키지 : `sklearn.datasets`
- 함수 : `load_xxx()`
```python
# 내장 데이터셋 가져오기
from sklearn.datasets import load_iris
iris = load_iris()

# 딕셔너리로 묶어준다.
```

## 결정트리 모델을 이용해 머신러닝 구현
1. import 모델
2. 모델 생성
3. 모델 학습 시키기
  - 검증단계
4. 예측

```python
# 1. import
from sklearn.tree import DecisionTreeClassifier

# 2. 모델 생성
tree = DecisionTreeClassifier(random_state=1)

# 3. 모델을 학습(Train)
tree.fit(iris['data'], irsi['target']) # input_data(feature), output_data(label)
```
# 머신러닝 프로세스
- ![image](https://user-images.githubusercontent.com/77317312/111594808-de929480-880e-11eb-80c8-3171183bb893.png)

## 훈련데이터셋과 평가데이터 분할
- 위의 예는 우리가 만든 모델이 성능이 좋은 모델인지 나쁜 모델인지 알 수 없다.

## scikit-learn의 train_test_split() 함수 이용 iris 데이터셋 분할
```python
# DataSet을 Train dataset과 test dataset으로 분할해주는 함수
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier

# 데이터 셋 분할 input, output(target)
x_train, x_test, y_train, y_test = train_test_split(iris['data'], # input dataset
                                                    iris['target'], # output dataset
                                                    test_size = 0.2, # test_set의 비율(0 ~ 1). default : 0.25
                                                    stratify = iris['target'], # class들을 원본 데이터셋과 같은 비율로 나눠라
                                                    random_state=1) # random의 seed값 정의

# 모델 생성
tree = DecisionTreeClassifier()

# 모델 학습
tree.fit(x_train, y_train)

# 모델 평가
pred_train = tree.predict(x_train)
pred_test = tree.predict(x_test)

from sklearn.metrics import accuracy_score # 정확도 검증 함수

acc_train_score = accuracy_score(y_train, pred_train)
acc_test_score = accuracy_score(y_test, pred_test)

print('Train set accuracy :', acc_train_score)
print('Test set accuracy :', acc_test_score)

# Train Set 정확도 : 1.0
# Test Set 정확도 : 0.9666666666666667
```

## 혼동행렬(Confusion Marix)
- 예측 한 것이 실제 무엇이었는지를 표로 구성한 평가 지표
- 분류의 평가 지표로 사용
- axis = 0 : 실제, axis = 1 : 예측
```python
from sklearn.metrics import confusion_matrix

cm_train = confusion_matrix(y_train, pred_train)
cm_test = confusion_matrix(y_test, pred_test)

print(cm_train)
# array([[40,  0,  0],
#        [ 0, 40,  0],
#        [ 0,  0, 40]], dtype=int64)

print(cm_test)
# array([[10,  0,  0],
#        [ 0, 10,  0],
#        [ 0,  1,  9]], dtype=int64)
```
