# MNIST CNN적용
```python
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

np.random.seed(1)
tf.random.set_seed(1)

# 하이퍼파라미터 설정
LEARNING_RATE = 0.001
N_EPOCHS = 20
N_BATCHS = 100
N_CLASS = 10

# 데이터 셋 로드
(train_image, train_labl), (test_image, test_label) = keras.datasets.mnist.load_data()
train_image.shape, test_image.shape
## >>> ((60000, 28, 28), (10000, 28, 28))

# 추가 변수 설정
N_TRAIN = train_image.shape[0]
N_TEST = test_image.shape[0]

# 전첯리 이미지 - 정규화
X_train = train_image/255.
X_train = X_train[..., np.newaxis]
X_test = test_image/255.
X_test = X_test[..., np,newaxis]
y_train, y_test = train_label, test_label

# dataset 구성
train_dataset = tf.data.Dataset.from_tensor_slices((X_train, y_train))\
                               .shuffle(N_TRAIN)\
                               .batch(N_BATCHS, drop_remainder=True)\
                               .repeat()
test_dataset = tf.data.Dataset.from_tensor_slices((X_test, y_test)).batch(N_BATCH)
```
## CNN 모델 구성
- convolution layer의 filter개수는 적은 개수에서 점점 늘려간다.
- ex) 32 -> 32 -> 64 -> 64 -> 128 ...
- input shape(입력 이미지의 size) : 3차원(height, width, channel)
```python
def create_model():
  model = keras.Sequential()
  # input (shape)
  model.add(layers.Input(28,28,1)))
  
  # Convolution layer : Conv20 -> MaxPool2D
  model.add(layers.Conv2D(filters=32, # filter의 개수
                          kernel_size=(3,3), # filter의 height, width, h/w가 같은 경우 정수로 가능
                          padding='same', # Padding 방식 : 'valid', 'same', - 대소문자 상관 x
                          strides=(1,1), # Stride 설정 : (상하, 좌우) 같은 경우 정수로 가능
                          activation='relu'))
  # Max Pooling layer => MaxPool 2D
  model.add(layers.MaxPool2D(pool_size=(2,2), # default : (2,2) 영역 height, width 크기 지정
                             strides=(2,2), # default : None -> Pool_size를 사용
                             padding='same')) # 'valid' - 뒤에 남는 것은 버린다.
  
  model.add(layers.Conv2D(filters=64,
                          kernel_size=3,
                          padding='same',
                          strides=1,
                          activation='relu'))
  model.add(layers.MaxPool2D(padding='same')) # pool_size, strides : default 값으로 설정
  
  # classification layer -> Fully Connected Layer
  # Conv 거친 Feature map은 3차원 배열 => Flatten() : 1차원 배열로 변환
  model.add(layers.Flatten())
  model.add(layers.Dense(256, activation='relu'))
  
  # output
  model.add(layers.Dense(N_CLASS, activation='softmax'))
  
  return model
  
model = create_model()
model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy']) # sparse_categorical_crossentropy : y가 ohe이 안된 경우

steps_per_epoch = N_TRAIN//N_BATCHS
validaion_steps = int(np.ceil(N_TEST/N_BATCHS))

model.fit(train_dataset,
          epochs=N_EPOCHS,
          steps_per_epoch=steps_per_epoch,
          validation_data=test_dataset,
          validation_steps=validation_steps)

model.evaluate(val_datset)
## >>> [0.04063648730516434, 0.9908000230789185]

# 새로운 데이터 추론
pred = model.predict(X_test[:10])
pred_class = np.argmax(pred, axis=-1)
pred_class, y_test[:10]
## >>> (array([7, 2, 1, 0, 4, 1, 4, 9, 5, 9]),
## >>>  array([7, 2, 1, 0, 4, 1, 4, 9, 5, 9], dtype=uint8))
```
## prediction error가 발생한 example 확인
```python
# pred_class : 예측결과, y_

```






























