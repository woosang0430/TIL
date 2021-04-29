# Functional API
- Sequential 모델은 각 layer들의 입력과 출력이 하나라고 가정 그리고 각각의 layer들을 차례로 쌓는 구성
- 함수형 API를 사용하면 **다중입력, 다중출력, 그래프 형태**의 다양한 형태의 모델을 유연하게 구성할 수 있다.
- 함수호출 처럼 layer를 이요하여 텐서를  입력 받고 출력하는 형식으로 모델을 구현

## Sequential, Functional API
```python
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, models

# Sequential
seq_model = keras.Sequential()
seq_model.add(layers.Input(shape=(32,32,3)))
seq_model.add(layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu'))
seq_model.add(layers.Flatten())
seq_model.add(layers.Dense(units=256, activation='relu'))
seq_model.add(layers.Dense(units=10, activation='softmax')
seq_model.summary()
"""
Model: "sequential"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
conv2d (Conv2D)              (None, 32, 32, 64)        1792      
_________________________________________________________________
flatten (Flatten)            (None, 65536)             0         
_________________________________________________________________
dense (Dense)                (None, 256)               16777472  
_________________________________________________________________
output_layer (Dense)         (None, 10)                2570      
=================================================================
Total params: 16,781,834
Trainable params: 16,781,834
Non-trainable params: 0
_________________________________________________________________
"""

# Functional
input_tensor = layers.Input(shape=(32,32,3))
conv_tensor = layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu')(input_tensor)
pool_tensor = layers.MaxPool2D(padding='same')(conv_tensor)

flatten_tensor = layers.Flatten()(pool_tensor)
dense_tensor = layers.Dense(256, activation='relu')(flatten_tensor)
dense_tensor2 = layers.Dense(128)(dense_tensor)
bn_tensor = layers.BatchNormalization()(dense_tensor2)
relu_tensor = layers.ReLU()(bn_tensor)

output_tensor = layers.Dense(10, activation='softmax')(relu_tensor)

fn_model = models.Model(input_tensor, output_tensor)
"""
Model: "model_2"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
input_8 (InputLayer)         [(None, 32, 32, 3)]       0         
_________________________________________________________________
conv2d_7 (Conv2D)            (None, 32, 32, 64)        1792      
_________________________________________________________________
max_pooling2d (MaxPooling2D) (None, 16, 16, 64)        0         
_________________________________________________________________
flatten_5 (Flatten)          (None, 16384)             0         
_________________________________________________________________
dense_10 (Dense)             (None, 256)               4194560   
_________________________________________________________________
dense_11 (Dense)             (None, 128)               32896     
_________________________________________________________________
batch_normalization_2 (Batch (None, 128)               512       
_________________________________________________________________
re_lu_1 (ReLU)               (None, 128)               0         
_________________________________________________________________
dense_12 (Dense)             (None, 10)                1290      
=================================================================
Total params: 4,231,050
Trainable params: 4,230,794
Non-trainable params: 256
_________________________________________________________________
"""
```
## 레이어를 합치는 함수
- `concatenate(list, axis=-1)`
  - list : 합칠 레이어들을 리스트에 묶어 전달
  - axis : 합칠 기준축. (기본값 : -1 == 마지막 축기준)
- `add(list)`, `substract(list)`, `multiply(list)`
  - 같은 index의 값들을 계산하여 하나의 레이어로 만든다.
  - list : 합칠 레이어들을 리스트에 묶어 전달
```python
# Residual block
input_tensor = layers.Input(shape=(32,32,3))
x = layers.Conv2D(64, kernel_size=3, padding='same', activation='relu')(input_tensor)
x1 = layers.Conv2D(64, kernel_size=3, padding='same')(x)
b1 = layers.BatchNormalization()(x1)
add1 = layers.add([x, b1])
r = layers.ReLU()(add1)

r_block_model = models.Model(input_tensor, r)
keras.utils.plot_model(r_block_model)
```
- ![image](https://user-images.githubusercontent.com/77317312/116529917-67294800-a918-11eb-88a9-bc41ff510a7d.png)

## 다중 출력 모델
- 가정
  - iris 데이터셋에서 꽃받침의 너비와 높이로 꽃잎의 너비, 높이, 꽃 종류를 예측하는 모델
  - 출력결과가 3개
- X : 꽃받침 너비, 높이
- y : 꽃잎 너비, 높이, 꽃 종류
```python
from sklearn.datasets import load_iris

iris = load_iris()
X, y = iris['data'], iris['target']
X.shape, y.shape
## >>> ((150, 4), (150,))

# 꽃잎의 너비, 높이, 품종으로 y값 나누기
y1 = X[:, 2]
y2 = X[:, 3]
y3 = y

X = X[:, :2]
X.shpae, y1.shape, y2.shape, y3.shape
## >>> ((150, 2), (150,), (150,), (150,))

import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, models

input_tensor = layers.Input(shape=(2, ))
x = layers.Dense(units=16, activation='relu')(input_tensor)
x = layers.Dense(units=8, activation='relu')(x)

output1 = layers.Dense(1, name='petal_width_output')(x)
output2 = layers.Dense(1, name='petal_length_output')(x)
output3 = layers.Dense(3, activation='softmax', name='species_output')(x)

model = models.Model(input_tensor, [output1, output2, output3])
keras.utils.plot_model(model, show_shapes=True)
```
- ![image](https://user-images.githubusercontent.com/77317312/116530984-9ee4bf80-a919-11eb-8671-827ae10aac22.png)
```python
# compile
model.compile(optimizer='adam', loss=['mse', 'mse', 'sparse_categorical_crossentropy'])

# 학습 및 검증
history = model.fit(X, [y1, y2, y3],
                    epochs=100,
                    validation_split=0.1)
## >>> output 생략
# 시각화 
import matplotlib.pyplot as plt
plt.figure(figsize=(6,4))

plt.plot(history.history['loss'], label='train_loss')
plt.plot(history.history['val_loss'], label='val_loss')

plt.legend()
plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/116531497-321df500-a91a-11eb-986f-8d4fca2527c6.png)

## 다중 입력 모델
- 가정 
  - iris 꽃 데이터 + 꽃의 사진을 입력해 꽃의 종류 예측
- X : 꽃 데이터, 꽃 사진
- y : 꽃 종류
```python
iris_info_tensor = layers.Input(shape=(4, ))
x1 = layers.Dense(32, activation='relu')(iris_info_tensor)
x1 = layers.Dense(16, activation='relu')(x1)

iris_img_tensor = layers.Input(shape=(16, 16, 1))
x2 = layers.Conv2D(filters=32, kernel_size=3, padding='same', activation='relu')(iris_img_tensor)
x2 = layers.Conv2D(filters=32, kernel_size=3, padding='same', activation='relu')(x2)
x2 = layers.MaxPool2D(padding='same')(x2)

x3 = layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu')(x2)
x3 = layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu')(x3)
x3 = layers.GlobalAveragePooling2D()(x3)

# 합치기
x4 = layers.concatenate([x1, x3])
x5 = layers.Dropout(rate=0.2)(x4)
output_tensor = layers.Dense(3, activation='softmax')(x5)

model = models.Model([iris_info_tensor, iris_img_tensor], output_tensor)
keras.utils.plot_model(model)
```
- ![image](https://user-images.githubusercontent.com/77317312/116532587-5dedaa80-a91b-11eb-80b7-c45901d7ff81.png)
