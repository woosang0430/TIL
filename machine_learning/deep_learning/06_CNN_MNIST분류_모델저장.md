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
# pred_class : 예측결과, y_test : 실제 정답
# 예측이 틀린 index를 조회
error_idx = np.where(pred_class!=y_test)[0]

# 틀린것 10개 확인하기
plt.figure(figsize=(15, 10))
for i in range(10):
  err = error_idx[i]
  plt.subplot(2,5,i+1)
  plt.imshow(test_image[i], cmap='gray')
  plt.title(f'label : {y_test[err]}, pred : {pred_class[err]}')
  plt.axis('off')

plt.tight_layout()
ply.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/115949002-ad436d80-a50c-11eb-875d-2330f4b694bc.png)

# 모델 저장
1. 학습이 끝난 모델의 파라미터만 저장
2. 모델 전체 저장
3. callback 함수를 이용해 학습시 가장 좋은 지표의 모델 저장

# 텐서플로 파일 타입
- checkpoint
  - 모델의 weight를 저장하기 위한 파일타입
  - 파라미터만 저장할 때
- SavedModel
  - 모델의 구조와 파라미터들을 모두 저장하는 형식
  - 모델 자체를 저장할 때

# 학습한 Weight(파라미터) 저장 및 불러오기
- 가중치를 저장하여 나중에 재학습 없이 학습된 가중치를 사용할 수 있다.
- 저장 : `model.save_weights('저장경로')`
- 불러오기 : `model.load_weights('불러올경로')`
  - 모델 구조는 새로 생성해야한다.
- 저장형식
  - Tensorflow Checkpoint(기본방식)
  - HDF5
    - `save_weights(저장경로, save_format='h5')
```python
# 콜랩에서 구글 드라이브 연결
from google.colab import drive
drive.mount('/content/drive')

# 저장할 경로 생성
import os
base_dir = '/content/drive/MyDrive/saved_models' # 모델/파라미터들을 저장할 root
weight_dir = os.path.join(base_dir, 'mnist', 'weights')

# 디렉토리 생성
if not os.path.isdir(weight_dir):
  os.makedirs(weight_dir, exist_ok=True)
  # exist_ok=False(기본값) : 이미 경로가 잇으면 예외 발생, True면 예외 발생 안시킴
  
# 저장할 디렉토리 + 파일명
weight_path = os.path.join(weight_dir, 'mnist_cnn_weights.ckpt')

# 모델의 가중치(weights) 저장
model.save_weights(weight_path)

# 모델 생성 및 불로오기
new_model1 = create_model()
new_model1.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
                   loss='sparse_categorical_crossentropy',
                   metrics=['accuracy'])

new_model1.evaluate(val_dataset)
## >>> [2.315847158432007, 0.08489999920129776]
# 학습을 하지 않은 모델

# 파일로 저장된 weight들을 생성된 모델에 저장
new_model1.load_weights(weight_path)

new_model1.evaluate(val_dataset)
## >>> [0.04063648730516434, 0.9908000230789185]
```
# HDF5형식으로 저장/불러오기
```python
weight_h5_dir = os.path.join(base_dir, 'mnist', 'weight_h5')
if not os.path.isdir(weight_h5_dir):
  os.makedirs(weight_h5_dir)
  
weight_h5_path = os.path.join(weight_h5_dir, 'mnist_cnn_weight.h5')
model.save_weights(weights_h5_path, save_format='h5')

new_model2 = create_model()
new_model2.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
                   loss='sparse_categorical_crossentropy',
                   metrics=['accuracy'])
              
new_model2.evaluate(val_dataset)
## >>> [2.317476511001587, 0.14839999377727509]
              
new_model2.load_weights(weight_h5_dir)
new_model2.evaluate(val_dataset)
## >>> [0.04063648730516434, 0.9908000230789185]
```
# 전체 모델 저장하고 불러오기
- 저장 : `model.save('저장할 디렉토리')`
- 불러오기 : `tf.keras.models.load_model('저장파일경로')`
- 저장 형식
  - Tensorflow SaveModel 형식(기본방식)
    - 모델 아키텍쳐 및 훈련 구성(옵티마이저, 손실, 및 메트릭 포함)은 saved_model.pb에 저장된다.
    - 파라미터는 variables/ 디렉토리에 저장된다.
    -  https://www.tensorflow.org/guide/saved_model?hl=ko#the_savedmodel_format_on_disk
  -  HDF5 형식
    - `save(저장할디렉토리, save_format='h5')` 로 지정한다.
```python
model_dir = os.path.join(base_dir, 'mnist', 'models', 'saved_model')
if nor os.path.isdir(model_dir):
  os.makedirs(model_dir, exist_ok=True)
  
model.save(model_dir) # SavedModel 형식으로 저장시 디렉토리를 지정

# 불러오기
new_model3 = keras.models.load_model(model_dir)

new_model3.evaluate(val_dataset)
## >>> [0.04063648730516434, 0.9908000230789185]

# H5형식으로 저장/불러오기
model_h5_dir = os.path.join(base_dir, 'mnist', 'models', 'h5_model')
if not os.path.isdir(model_h5_dir):
  os.makedirs(model_h5_dir, exist_ok=True)
  
# h5 형식으로 저장할 떼 파일명까지 지정.
model_h5_path = os.path.join(model_h5_dir, 'mnist_cnn_model.h5')

new_model4 = keras.models.load_model(model_h5_path)
new_model4.evaluate(val_dataset)
## >>> [0.04063648730516434, 0.9908000230789185]
```
# Callback을 사용한 모델 저장 및 Early stopping
- callback은 학습하는 도중 특정 이벤트 발생 시 호출되는 다양한 함수를 제공하여 자동화 처리를 지원한다.
- 다양한 콜백 클래스가 제공
 - https://www.tensorflow.org/api_docs/python/tf/keras/callbacks
- `EarlyStopping` : Validation set에 대한 평가지표가 더 이상 개선되지 않을 떼 학습을 자동으로 멈춤
  - `monitor` : 모니터링할 평가지표 지정
  - `patience` : epoch 수 지정. validation 평가지표가 개선이 안되더라도 지정한 epoch만큼 반복한다. epoch만큼 반복 후 에도 개선이 안되면 중단
- `ModelCheckpoint` : 지정한 평가지표가 가장 좋을 뗴 모델과 weight를 저장하여 overfitting이 발생하기 전 model을 나중에 불러들여 사용할 수 있다.
  - `save_best_only=True` : monitoring 중인 measure를 기준으로 최적의 모형의 weight만 저장
- **callback 객체들을 리스트로 묶은 뒤 fit()의 callback 매개변수에 전달**
```python
model2 = create_model()
model2.compile(optimizer='adam',
               loss='sparse_categorical_crossentropy',
               metrics=['accuracy'])
               
callback_dir = os.path.join(base_dir, 'mnist', 'models', 'callback')
if not os.path.isdir(callback_dir):
  os.makedirs(callback_dir, exist_ok=True)
  
callback_path = os.path.join(callback_dir, 'saved_model_{epoch:02.d}.ckpt')
# {epoch:02d} - 포맷문자열. 몇번째 에폭때 저장인지

# ModelCheckpoint callback 생성
mc_callback = keras.callbacks.ModelCheckpoint(filepath=callback_path, # 학습 도중 모델/파라미터 저장할 경로
                                              save_weights_only=True, # True : 가중치만 저장, False(기본값) : 모델 + 가중치
                                              save_best_only=True, # True : 성능이 가장 좋았을 떼만 저장, False(기본값) : 매 순간 저장
                                              monitor='val_loss',
                                              verbose=1 # 로그 출력
                                              )

# EarlyStopping callback 생성
es_callback = keras.callbacks.EarlyStopping(monitor='val_loss',
                                            patience=5)

model2.fit(train_dataset,
           epochs=N_EPOCHS,
           steps_per_epoch=steps_per_epoch,
           validation_data=val_dataset,
           validation_steps=validation_steps,
           callback=[mc_callback, es_callback])
           
# 저장된 weight loading
new_model5 = create_model()
new_model5.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
                   loss='sparse_categorical_crossentropy',
                   metrics=['accuracy'])

# weight들이 저장된 디렉토리를 지정하면 마지막 에촉에서 저장된 weight를 불러온다.
best_weighs = tf.train.latest_checkpoint(callback_dir)
new_model5.load_weights(best_weights)

new_model5.evaluate(val_dataset)
## >>> [0.027323227375745773, 0.9927999973297119]
```
