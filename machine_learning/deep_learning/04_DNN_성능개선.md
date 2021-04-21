# Deep Neural Networks 모델 성능 개선 기법들
## 과대적합(Overfitting)과 과소적합(Underfitting)
- **최적화(optimization)와 일반화(generalization)**
  - **최적화** : train data에서 최고의 성능을 얻으려고 모델을 조정하는 과정
  - **일반화** : 훈련된 모델이 처음 보는 데이터에서 얼마나 잘 수행되는지를 의미
- ![image](https://user-images.githubusercontent.com/77317312/115527185-cb6e5b00-a2cb-11eb-9b36-a6f1e159d1b7.png)
### 과대적합(overfitting)을 방지하기 위한 방법
- 더 많은 data를 수집
  - 모델이 복잡해도 학습 시킬 데이터가 충분히 많으면 괜찮다.
  - 이미지의 경우 크기를 줄이거나 회전 등을 이용해 데이터를 어느 정도 늘릴 수 있다.
- 모델을 간단하게 만든다.
  - 대부분 경우 데이터 수집이 쉽지가 않다. 그런 경우 모델을 간단하게 바꾼다.

## 1. DNN 모델 크기 변경
- 모델의 layer나 unit 수가 많을 수록 복잡한 모델(unit수는 보통 2의 배수 사용)
- 큰 모델에서 시작하여 layer나 unit수를 줄여가며 validation loss의 감소 추세를 관찰한다.
```python
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow import keras

# 하이퍼파라미터 설정
LEARING_RATE = 0.001
N_EPOCHS = 20
N_BATCHS = 100

# data loading and dataset 생성
(train_image, train_label), (test_image, test_label) = keras.datasets.mninst.load_data()
train_image.shape, test_image.shape
## >>> ((60000, 28, 28), (10000, 28, 28))

N_TRAIN = train_image.shape[0]
N_TEST = test_image.shape[0]
IMAGE_SIZE = 28
N_CLASS = 10

# 데이터 전처리
# 전처리 시 다른 변수명으로 할당하는 것이 좋다.
X_train = train_image/255.
X_test = test_image/255.

y_train = keras.utils.to_categorical(train_label)
y_test = keras.utils.to_categorical(test_label)

# create dataset
train_dataset = tf.data.Dataset.from_tensor_slices((X_train, y_train))\
                               .shuffle(N_TRAIN)\
                               .batch(N_BATCHS, drop_remainder=True)\
                               .repeat()
test_dataset = tf.data.Dataset.from_tensor_slices((X_test, y_test)).batch(N_BATCHS)

steps_per_epoch = N_TRAIN//N_BATCHS
validation_steps = int(np.ceil(N_TEST/N_BATCHS))

# 모델 생성
def create_model():
  model = keras.Sequential()
  model.add(keras.layers.Input((IMAGE_SIZE, IMAGE_SIZE))
  model.add(keras.layers.Flatten()
  # Hidden layer
  model.add(keras.layers.Dense(512, activation='relu'))
  model.add(keras.layers.Dense(512, activation='relu'))
  model.add(keras.layers.Dense(256, activation='relu'))
  model.add(keras.layers.Dense(256, activation='relu'))
  model.add(keras.layers.Dense(128, activation='relu'))
  model.add(keras.layers.Dense(128, activation='relu'))
  model.add(keras.layers.Dense(8, activation='relu'))
  # output layer
  model.add(keras.layers.Dense(N_CLASS, activation='softmax'))
  # model compile
  model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
                loss='categorical_crossentropy',
                metrics=['accuracy'])
  return model
  
model = create_model()

history = model.fit(train_dataset,
                    epochs=N_EPOCHS,
                    steps_per_epoch=steps_per_epoch,
                    validation_data=val_dataset,
                    validation_steps=validation_steps)
```
- ![image](https://user-images.githubusercontent.com/77317312/115539001-6f113880-a2d7-11eb-8003-68bb286eed51.png)

## 2. Dropout Layer 추가를 통한 Overfitting 규제
- Neural network를 위해 사용되는 regularization 기법 중에서 가장 효율적이고 널리 사용하는 방법
- Dropout Node : 학습시(fit) 일부 Unit(노드)를 빼고 진행한다.
- 매 반복(epochs) 마다 Random하게 선택된 Unit(노드)를 training 진행
  - 앙상블의 효과도 있다.
- 일반적으로 **dropout rate=0.2 ~ 0.5**를 지정
- test set에 대해서는 적용하지 않는다.
- ![image](https://user-images.githubusercontent.com/77317312/115528519-12a91b80-a2cd-11eb-88b3-b9c538957d69.png)

### Dropout 적용
- dropout layer는 적용하려는 layer 앞에 추가
- dropout 비율은 0 ~ 1 사이 실수로 지정하는데 보통 0.2 ~ 0.5 사이의 값을 지정
- dropout이 적용된 모델을 학습 시킬 때는 epoch수를 더 늘려준다.
```python

```


## 3. Batch Normalization(배치정규화) * 일반적으로 많이 사용됨
- 각 layer에서 출력된 값을 평균=0, 표준편차=1로 정규화 하여 **각 layer의 입력분포를 균일하게 만듬** == scaling
#### Internal Covariate Shift(내부 공변향 변화) 문제
- ![image](https://user-images.githubusercontent.com/77317312/115528824-57cd4d80-a2cd-11eb-8d2a-8d79fbcc2fd6.png)
- 내부 공변량 변화란 학습 과정에서 각 층을 통과할 때 마다 입력 데이터 분포가 달라지는 현상이다.
- 입력 데이터의 분포가 정규분포를 따르더라도 레이어를 통과하면서 그 분포가 바뀌어 성능이 떨어지는 문제가 발생한다.
- 각 레이어를 통과할 때 마다 분포를 정규분포로 정규화하여 성능을 올린다.
- ![image](https://user-images.githubusercontent.com/77317312/115529325-c4e0e300-a2cd-11eb-9bc2-232fd6fc93b0.png)
- **normalize 공식 기억하자**
- *r* : scaling 파라미터, *B* : shift 파라미터
  - 항상 일정한 분포로 나오는 것을 방지하기 위해 *r*와 *B*를 이용해 분포에 약간의 변화를 준다.
  - *r*와 *B*는 학습 과정에서 최적화 되는 값
- 일반적으로 활성함수 이전에 적용시킨다.
  - ![image](https://user-images.githubusercontent.com/77317312/115532348-aa5c3900-a2d0-11eb-9c28-3e0275a55d55.png)
- tanh => 활성함수

## 효과
- 랜덤하게 생성되는 초기 가중치에 대한 영향력을 줄일 수 있다.
- 학습하는 동안 과대적합에 대한 규제의 효과를 준다.
- Gradient Vanishing, Gradient exploding을 막아준다.
```python


```

## 4. Learning Rate Decay(학습율 조절)을 통한 성능향상
- ![image](https://user-images.githubusercontent.com/77317312/115532723-058e2b80-a2d1-11eb-8dc6-734539ea9f49.png)
- optimizer의 learning rate이 너무 크면 수혐을 못할 가능성이 있고 너무 작으면 local minima에서 못빠져 나와 수렴을 못할 수 있다.
- 학습율을 처음에는 크게 움직이다 일정 조건이 되면 learning rate을 낮춰서 점점 작게 움직이는 방법
  - 몇 에폭마다 일정량만큼 학습 속도를 줄인다. 보통 5 에폭마다 반으로 줄이거나 20 에폭마다 1/10씩 줄이기도 한다.(튜닝대상)
  - 보통 고정된 학습 속도로 검증오차를 살펴보다가, 검증오차가 개선되지 않을 때마다 학습 속도를 감소시키는 방법을 택한다.
```python


```

## 결론. Hyper Parameter tuning
- parameters
  - 모델이 학습하여 업데이트할 대상
    - weights **W**
    - Bias **b**
- Hyper parameters
  - 모형의 구조를 결정하거나 optimization 방법을 결정하는 변수들
  - **W, b**를 최종적으로 결정
    >    - Optimizer의 종류
    >    - learning rate(**a**)
    >    - Hidden layer의 수
    >    - Hidden unit의 수
    >    - Iteration의 수
    >    - Actication function의 종류 - 주로 relu
    >    - Minibatch size - **메모리가 허용하는 한 크게  주는게 좋다.**
    >    - Regularization - 과적합이 나는 경우
    >      - drop out등
- 다양한 조합의 hyper parameter를 시도해서 loss 함수가 빠르게 감소하는 hyper parameter를 찾아내는 시도가 필요
