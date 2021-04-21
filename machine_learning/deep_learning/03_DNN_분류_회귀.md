# 데이터셋 API
- 데이터 입력 파이프라인을 위한 패키지
- `tf.data` 패키지에서 제공
- `tf.data.Dataset` 추상클래스에서 상속된 여러가지 클래스 객체를 사용 또는 만들어 쓴다.

# 데이터 입력 파이프라인
##### 모델에 공급되는 데이터에 대한 전처리 작업과 공급을 담당
- 이미지 데이터의 경우
  - 분산 파일시스템으로 부터 이미지를 모으는 작업
  - 이미지에 노이즈를 주거나 변형하는 작업
  - 배치 학습을 위해 무작위로 데이터를 선택하여 배치데이터를 만드는 작업
- 텍스트 데이터 경우
  - 원문을 토큰화하는 작업
  - 임베딩하는 작업
  - 길이가 다른 데이터를 패딩하여 합치는 작업

# 데이터셋 API 사용 3단계
1. 데이터셋 생성
  - `from_tensor_slices()`, `from_generator()` 클래스 메소드, `tf.data.TFRecordDataset` 클래스를 사용해 메모리나 파일에 있는 데이터를 데이터 소스로 만든다.
  - `from_tensor_slices()` : 리스트, 넘파이배열, 텐서플로 자료형에서 데이터를 생성한다.
2. 데이터셋 변형 : `map()`, `filter()`, `batch()` 등 메소드를 이용해 데이터 소스를 변형
3. for 반복문에서 iterate를 통해 데이터셋 사용
# Dataset의 주요 메소드
- `map(함수)` : dataset의 각 원소들을 함수로 처리
- `shuffle(크기)` : dataset의 원소들의 순서를 섞는다.
>  - 섞는 공간의 크기가 데이터보다 크거나 같으면 완전 셔플
>  - 적으면 일부만 가져와서 섞기 때문에 완선 셔플 X
>  - 데이터가 너무 많으면 적게 주기도 한다.
- `batch(size)` : 반복시 제공할 데이터 수. 지정한 batch size만큼 data를 꺼내준다.
```python
import tensorflow as tf
import numpy as np

arr = np.range(9)

# 메모리에 ndarray로 저장된 데이터를 이용해 Dataset 객체 생성
dataset = tf.data.Dataset.from_tensor_slices(arr)

# 각각 원소 변환 작업을 Dataset 추가 - Dataset.map(변환함수)
dataset = dataset.map(lambda x: x**2)

# 2에 배수만 걸러내기
# dataset = dataset.filter(lambda x: x%2==0)
# 나중에 결과값이 너무 작게 나와 주석 이런것도 있다~~ 라는식으로 알자

# 값들을 섞는 작업
dataset = dataset.shuffle(9)

# 한번에 지정한 개수만큼 제공
dataset = dataset.batch(3)

# Dataset에서 제공되는 값들을 조회
for data in dataset:
  print(data)
# tf.Tensor([ 4 49 36], shape=(3,), dtype=int32)
# tf.Tensor([0 9 1], shape=(3,), dtype=int32)
# tf.Tensor([64 16 25], shape=(3,), dtype=int32)
```
```python
x = np.arange(10)
y = np.arange(10, 20)
x.shape, y.shape
## >> ((10,), (10,))

# 위의 작업 한번에
dataset = tf.data.Dataset.from_tensor_slices((x, y)).map(lambda x, y: (x**2, y**3)).shuffle(10).batch(4).repeat(4)
```

# 1. 회귀 - Boston Housing Dataset
- 보스턴 주택가격 dataset은 다음과 같은 속성을 바탕으로 해당 타운 주택 가격의 중앙값을 예측하는 문제
> - CRIM: 범죄율
> - ZN: 25,000 평방피트당 주거지역 비율
> - INDUS: 비소매 상업지구 비율
> - CHAS: 찰스강에 인접해 있는지 여부(인접:1, 아니면:0)
> - NOX: 일산화질소 농도(단위: 0.1ppm)
> - RM: 주택당 방의 수
> - AGE: 1940년 이전에 건설된 주택의 비율
> - DIS: 5개의 보스턴 직업고용센터와의 거리(가중 평균)
> - RAD: 고속도로 접근성
> - TAX: 재산세율
> - PTRATIO: 학생/교사 비율
> - B: 흑인 비율
> - LSTAT: 하위 계층 비율
- 예측해야하는 것
> - MEDV : 타운의 주택가격 중앙값(단위 : 1,000달러)
```python
import numpy as np
import tensorflow as tf
from tensorflow as keras

# random seed
np.random.seed(1)
tf.random.set_seed(1)

# 데이터 셋 로딩
(X_train, y_train), (X_test, y_test) = keras.dataset.boston_housing_load_data()
X_train.shape, X_test.shape
## >>> ((404, 13), (102, 13))

# 하이퍼파라미터 값 설정
LEANRING_RATE = 0.001 # 학습률
N_EPOCHS = 200 # 에폭 횟수, 1 epoch 전체 데이터셋을 한번 사용한 것
N_BATCHS = 32 # batch_size. 32개 데이터셋 마다 파라미터(가중치)들 업데이트.

# 필요한 변수 정의
N_TRAIN = X_train.shape[0] # train set의 개수
N_TEST = X_test.shape[0] # test set의 개수
N_FEATURES = X_train.shape[1] # input data의 feature(컬럼) 개수

# Dataset 생성
# drop_remainder=True : 마지막에 batch size보다 제공할 데이터가 적으면 마지막꺼 버려라
# repeat() : 여러 epoch을 돌때마다 계속 데이터를 제공하게 하기 위해. repeat()를 지정하지 않으면 1 에폭 후 데이터를 제공하지 못한다.
train_dataset = tf.data.Dataset.from_tensor_slices((X_train, y_train)).shuffle(N_TRAIN).batch(N_BATCHS, drop_remainder=True).repeat()
val_dataset = tf.data.Dataset.from_tensor_slices((X_test, y_test)).batch(N_BATCHS)


# 모델 생성
def creat_model():
  model = keras.Sequential()
  model.add(keras.layers.Dense(units=16, activation='relu', input_shape=(N_FEATURES,)))
  model.add(keras.layers.Dense(units=8, activation='relu'))
  
  # output layer
  model.add(keras.layers.Dense(units=1)) # 회귀의 출력층 : units수는 1, activation 함수는 사용하지 않는다.
  
  # 모델 컴파일
  # optimizer의 하이퍼파라미터를 기본값으로 쓸 경우 문자열로 'adam'으로 선언하면됨
  model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=LEARING_RATE), loss='mse')
  # 회귀의 loss 함수 : mse
  
  return model
  
model = creat_model()
model.summary()
"""
Model: "sequential_4"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
dense_12 (Dense)             (None, 16)                224       
_________________________________________________________________
dense_13 (Dense)             (None, 8)                 136       
_________________________________________________________________
dense_14 (Dense)             (None, 1)                 9         
=================================================================
Total params: 369
Trainable params: 369
Non-trainable params: 0
_________________________________________________________________
"""
# 1 step : 한번 가중치를 업데이트
# 1 epoch : 전체 train 데이터를 한번 학습
steps_per_epoch = N_TRAIN//N_BATCHS
validation_steps = int(np.ceil(N_TEST/N_BATCHS)))

history = model.fit(train_dataset, # train dataset == (X_train, y_train)
                    epochs=N_EPOCHS,
                    steps_per_epoch=steps_per_epoch, # 1 에폭당 step 수
                    validation_data=test_dataset, # 검증 dataset 지정.
                    validation_steps=validation_steps)  

# epoch당 loss와 val_loss 변화에 대한 선그래프
import matplot.pyplot as plt

plt.figure(figsize=(10, 7))
plt.plot(range(1, N_EPOCHS+1), history.history['loss'], label='train loss')
plt.plot(range(1, N_EPOCHS+1), history.history['val_loss'], label='test loss')

plt.xlabel('epochs')
plt.ylabel('loss(MSE)')
plt.ylim(0, 90)
plt.legend()
plt.grid(True)
plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/115238605-d48aeb00-a158-11eb-8167-3f3f665981a5.png)
## 2. Classification - Fashion MNIST Dataset - 다중 분류
- 다중 분류의 loss 값
  - y를 one hot encoding 한 경우 : `categorical_crossentropy`
  - y를 one hot encoding 안한 경우 : `sparse_categorical_crossentropy`
```python
class_names = ['T-shirt/top', 'Trousers', 'Pullover', 'Dress', 'Coat', 'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

import numpy as np
import tensorflow as tf
from tensorflow import keras

np.random.seed(1)
tf.random.set_seed(1)

# 데이터 셋 읽기
(X_train, y_train), (X_test, y_test) = keras.datasets.fashion_mnist.load_data()
X_train.shape, X_test.shape
## >>> ((60000, 28, 28), (10000, 28, 28))

# 하이퍼파라미터 설정
LEARNING_RATE = 0.001
N_EPOCHS = 50
N_BATCHS = 100

N_CLASS = 10 # CLASS CATEGORY의 개수
N_TRAIN = X_train.shape[0]
N_TEST = X_test.shape[0]
IMAGE_SIZE = 28

# 데이터 전처리
# X(이미지) : 0 ~ 255 => 0 ~ 1
X_train = X_train/255.
X_test = X_test/255.

# y => one hot encoding
y_train = keras.utils.to_categorical(y_train)
y_test = keras.utils.to_categorical(y_test)

# Dataset
train_dataset = tf.data.Dataset.from_tensor_slices((X_train, y_train))\
                               .shuffle(N_TRAIN)\
                               .batch(N_BATCHS, drop_remainder=True)\
                               .repeat()
test_dataset = tf.data.Dataset.from_tensor_slices((X_test, y_test)).batch(N_BATCHS)

# 모델 구현
def create_model():
  model = keras.Sequential()
  
  # input layer
  model.add(keras.layers.Input((28,28))
  model.add(keras.layers.Flatten())
  
  # hidden layer
  model.add(keras.layers.Dense(256, activation='relu'))
  model.add(keras.layers.Dense(128, activation='relu'))
  model.add(keras.layers.Dense(64, activation='relu'))
  
  # output layer
  model.add(keras.layers.Dense(N_CLASS, activation='softmax'))
  
  # compile
  model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
                loss='categorical_crossentropy',
                metrics=['accuracy'])
  
  return model
  

model = create_model()
model.summary()
"""
Model: "sequential_5"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
flatten_4 (Flatten)          (None, 784)               0         
_________________________________________________________________
dense_18 (Dense)             (None, 256)               200960    
_________________________________________________________________
dense_19 (Dense)             (None, 128)               32896     
_________________________________________________________________
dense_20 (Dense)             (None, 64)                8256      
_________________________________________________________________
dense_21 (Dense)             (None, 10)                650       
=================================================================
Total params: 242,762
Trainable params: 242,762
Non-trainable params: 0
_________________________________________________________________
"""

# 학습, steps 계산
steps_per_epoch = N_TRAIN//N_BATCHS
validation_steps = int(np.ceil(N_TEST/N_BATCHS))

history = model.fit(train_dataset,
                    epochs=N_EPOCHS,
                    steps_per_epoch=steps_per_epoch,
                    validation_data=test_dataset,
                    validation_steps=validation_steps)
                    
# 평가
model.evaluate(test_dataset)

# 결과 시각화 메소드
def plot_result(history):
  import matplotlib.pyplot as plt
  plt.figure(figsize=(15,6))
  
  plt.subplot(1,2,1)
  plt.plot(range(1, N_EPOCHS+1), history['loss'], label='train_loss')
  plt.plot(range(1, N_EPOCHS+1), history['val_loss'], label='val_loss')
  plt.title('loss')
  plt.legend()
  
  plt.subplot(1,2,2)
  plt.plot(range(1, N_EPOCHS+1), history['accuracy'], label='train_accuracy')
  plt.plot(range(1, N_EPOCHS+1), history['accuracy'], label='val_accuracy')
  plt.title('accuracy')
  plt.legend()
  
  plt.tight_layout()
  plt.grid(True)
  plt.show()
  
plot_result(history)
```
- ![image](https://user-images.githubusercontent.com/77317312/115401683-a0313080-a225-11eb-9f83-51aa45a873bc.png)

## 3. IMDB 감성분석 - 이진분류
```python
# 데이터 로드
import pickle

with open('imdb_dataset/X_train.pkl', 'rb') as f:
  X_train = pickle.load(f)

with open('imdb_dataset/X_test.pkl', 'rb') as f:
  X_test = pickle.load(f)
  
with open('imdb_dataset/y_train.pkl', 'rb') as f:
  y_train = pickle.load(f)

with open('imdb_dataset/y_test.pkl', 'rb') as f:
  y_test = pickle.load(f)
  
# X -> 벡터화(숫자 변경)
from sklearn.feature_extraction.text import TfidfVectorizer
tfidf = TfidfVectorizer(max_features=10000)
tfidf.fit(X_train+X_test)

X_train_tfidf = tfidf.transform(X_train)
X_test_tfidf = tfidf.transform(X_test)

# 하이퍼파라미터 설정
LEARNING_RATE = 0.001
N_EPOCHS = 10
N_BATCHS = 250

N_TRAIN = X_train_tfidf.shape[0]
N_TEST = X_test_tfidf.shape[0]
N_FEATURE = X_train_tfidf.shape[1]

# dataset
train_dataset = tf.data.Dataset.from_tensor_slices((X_train_tfidf.toarray(), y_train))\
                               .shuffle(N_TRAIN)
                               .batch(N_BATCHS, drop_remainder=True)\
                               .repeat()
test_dataset = tf.data.Dataset.from_tensor_slices((X_test_tfidf.toarray(), y_test)).batch(N_BATCHS)

# 모델 생성
def create_model():
  model = keras.Sequential()
  # input layer
  model.add(keras.layers.Input((N_FEATURE,))
  
  # hidden layer
  model.add(keras.layers.Dense(512, activation='relu'))
  model.add(keras.layers.Dense(256, activation='relu'))
  model.add(keras.layers.Dense(256, activation='relu'))
  model.add(keras.layers.Dense(128, activation='relu'))
  
  # output layer
  model.add(keras.layers.Dense(1, activation='sigmoid'))
  
  # compile
  model.complie(optimizer=keras.optimizers.Adam(learing_rate=LEARING_RATE),
                loss='binary_crossentropy',
                metrics=['accuracy'])
  
  return model
  
model = create_model()
model.summary()
"""
Model: "sequential"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
dense (Dense)                (None, 512)               5120512   
_________________________________________________________________
dense_1 (Dense)              (None, 256)               131328    
_________________________________________________________________
dense_2 (Dense)              (None, 256)               65792     
_________________________________________________________________
dense_3 (Dense)              (None, 128)               32896     
_________________________________________________________________
dense_4 (Dense)              (None, 1)                 129       
=================================================================
Total params: 5,350,657
Trainable params: 5,350,657
Non-trainable params: 0
_________________________________________________________________
"""

steps_per_epoch = N_TRAIN//N_BATCHS
validation_steps = int(np.ceil(N_TEST/N_BATCHS))

# 학습
history = model.fit(train_dataset,
                    epoch=N_EPOCHS,
                    steps_per_epoch=steps_per_epoch,
                    validataion_data=test_dataset,
                    validataion_steps=validation_steps)

# 평가
model.evaluate(val_dataset)

# 결과 시각화
plot_result(history)
```
- ![image](https://user-images.githubusercontent.com/77317312/115404676-847b5980-a228-11eb-887c-273a84c30d76.png)
