# Keras를 사용한 개발 과정
1. 입력 텐서(X)와 출력 텐서(y)로 이뤄진 훈련 데이터를 정의
2. 입력과 출력을 연결하는 layer(층)으로 이뤄진 네트워크(모델)을 정의
>  - `Sequential` 방식 : 순서대로 쌓아올린 네트워크로 이뤄진 모델을 생성하는 방식
>  - `Functional` API 방식 : 다양한 구조의 네트워크로 이뤄진 모델을 생성하는 방식
>  - `Subclass` 방식 : 네트워크를 정의하는 클래스을 구현
3. 모델 컴파일
>  - 모델이 Train할 때 사용할 **손실함수(loss function)**, **최적화기법(Optimizer)**, 학습과정을 모니터링할 **평가지표(Metrics)** 를 설정
4. Training(훈련)
>  - 모델의 fit() 메소드에 훈련데이터를 넣어 train
- ![image](https://user-images.githubusercontent.com/77317312/114873001-cf1a6180-9e35-11eb-9ed7-ddc3385a4e39.png)

# MNIST 이미지 분류
```python
import tensorflow as tf
from tensorflow import keras

(X_train, y_train), (X_test, y_test) = keras.datasets.mnist.load_data()

import matplotlib.pyplot as plt

plt.figure(figsize=(15, 5))
for i in range(5):
  plt.subplot(1, 5, i+1)
  plt.imshow(X_train[i], cmap='gray')
  plt.title(y_train[i])
  plt.axis('off')

plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/114873577-5f58a680-9e36-11eb-9e8b-c5a9127fbe80.png)
# 신경망 구현
## network : 전체 모델 구조 만들기
```python
# 모델 생성
model = keras.Sequential()

# 층(layer)를 모델에 추가.
model.add(keras.layers.Input((28,28)))
model.add(keras.layers.Flatten())
model.add(keras.layers.Dense(256, activation='relu'))
model.add(keras.layers.Dense(128, activation='relu'))
model.add(keras.layers.Dense(10, activation='softmax'))

model.summary()
"""
Model: "sequential_1"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
flatten_1 (Flatten)          (None, 784)               0         
_________________________________________________________________
dense_3 (Dense)              (None, 256)               200960    
_________________________________________________________________
dense_4 (Dense)              (None, 128)               32896     
_________________________________________________________________
dense_5 (Dense)              (None, 10)                1290      
=================================================================
Total params: 235,146
Trainable params: 235,146
Non-trainable params: 0
_________________________________________________________________
"""
```
## 컴파일 단계
- 구축된 모델에 추가 설정 => 어떻게 학습할지에 대한 설정
- 손실함수
- Optimizer(최적화 함수)
- 평가지표
```python
model.compile(optimizer='adam', # Optimizer 등록
              loss='categorical_crossentropy', # loss Function 등록
              metrics=['accuracy']) # 평가지표 - training 도중에 validation 결과 확인
```
## 데이터 준비
- X : 0 ~ 1 사이의 값으로 정규화 시킨다.
- y : one hot encoding 처리, tensorflow.keras의 `to_categorical()` 함수 이용
```python
X_train = X_train/255.0
X_test = X_test/255.0

y_train = keras.utils.to_categorical(y_train)
y_test = keras.utils.to_categorical(y_test)
```
## 학습
- 하이퍼 파라미터
  - `epochs` => 전체 train dataset을 **epochs**에 준 만큼 학습
  - `batch_size` => 파라미터 업데이트(최적화)를 100개 마다 처리(train dataset을  batch_size만큼 잘라가며 학습)
```python
model.fit(X_train, y_train,
          epochs=10, # epochs : 전체 train dataset을 N 학습
          batch_size=100, # 파라미터 업데이드(최적화)를 100개 마다 처리
          validataion_split=0.2)
'''
Train on 48000 samples, validate on 12000 samples
Epoch 1/10
48000/48000 [==============================] - 2s 38us/sample - loss: 0.2858 - accuracy: 0.9168 - val_loss: 0.1580 - val_accuracy: 0.9528
Epoch 2/10
48000/48000 [==============================] - 1s 29us/sample - loss: 0.1092 - accuracy: 0.9665 - val_loss: 0.1009 - val_accuracy: 0.9698
Epoch 3/10
48000/48000 [==============================] - 1s 30us/sample - loss: 0.0717 - accuracy: 0.9782 - val_loss: 0.0857 - val_accuracy: 0.9739
Epoch 4/10
48000/48000 [==============================] - 1s 30us/sample - loss: 0.0505 - accuracy: 0.9847 - val_loss: 0.0914 - val_accuracy: 0.9735
Epoch 5/10
48000/48000 [==============================] - 1s 30us/sample - loss: 0.0358 - accuracy: 0.9895 - val_loss: 0.1042 - val_accuracy: 0.9709
Epoch 6/10
48000/48000 [==============================] - 1s 31us/sample - loss: 0.0277 - accuracy: 0.9910 - val_loss: 0.0844 - val_accuracy: 0.9772
Epoch 7/10
48000/48000 [==============================] - 1s 31us/sample - loss: 0.0228 - accuracy: 0.9925 - val_loss: 0.0938 - val_accuracy: 0.9752
Epoch 8/10
48000/48000 [==============================] - 1s 30us/sample - loss: 0.0180 - accuracy: 0.9943 - val_loss: 0.1055 - val_accuracy: 0.9740
Epoch 9/10
48000/48000 [==============================] - 2s 31us/sample - loss: 0.0179 - accuracy: 0.9937 - val_loss: 0.0912 - val_accuracy: 0.9774
Epoch 10/10
48000/48000 [==============================] - 1s 30us/sample - loss: 0.0121 - accuracy: 0.9961 - val_loss: 0.1048 - val_accuracy: 0.9766
'''

# 테스트셋 평가
test_loss, test_acc = model.evaluate(X_test, y_test)

print(test_loss)
print(test_acc)
0.09259257186052601
0.9777
```
## 추론 메소드
- `predict()`
  - 각 클래스 별 확률 반환
- ~~`predict_classes()`~~
  - 클래스(범주값) 반환
  - tensorflow 2.3 부터 deprecated 됨
- 이진 분류(binart classification)
  - `numpy.argmax(model.predict(x) > 0.5).astype('int32')
- 다중클래스 분류(multi-class classification)
  - `numpy.argmax(model.predict(x), axis=-1)`
