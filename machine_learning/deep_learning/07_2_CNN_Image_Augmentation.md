# CNN small datasets 학습
- Data가 많지 않아 CNN 학습에 어려움이 있을 때 사용 가능한 방법
  - `Data augmentation` 활용
    - 이미지의 색, 각도 등을 약간씩 변형하여 data의 수를 늘림
  - `Pre-trained network` 활용
    - 매우 큰 데이터셋으로 미리 training한 모델의 파리마터를 가져와서 풀어야할 문제에 맞게 모델을 재보정해서 사용하는 것
    - 미리 다양한 데이터를 가지고 학습된 모델을 사용하므로 적은 데이터에도 좋은 성능을 낼 수 있다.

- **gdown패키지** : 구글 드라이브의 공유파일 다운로드 패키지
- `pip install gdown==3.3.1`

```python
# 이미지 다운로드
# 공유파일_ID : https://drive.google.com/uc?id=
import gdown

url = 'https://drive.google.com/uc?id=1nBE3N2cXQGwD8JaD0JZ2LmFD-n3D5hVU'
fname = 'cats_and_dogs_small.zip'

gdown.download(url, fname, quiet=False) # url, 저장할 경로

# 리눅스 명령어로 디렉토리 생성
# %ls -al
# !ls -al
!mkdir data

# 위에 생성한 디렉토리에 압출 풀기 -q => 로그남기지 말아라, -d => 압축을 풀을 디렉토리 지정
!unzip -q cats_and_dogs_small.zip -d data/cats_and_dogs_small
```
# Build a network
- input : 150 x 150 픽셀의 RGB layer
- output : cat or dog
- ImageDataGenerator를 이용해 파일시스템에 저장된 이미지데이터셋을 학습시킨다.
```python
import tensorflow as tf
import numpy as np
from tensorflow import keras
from tensorflow.keras import layers

np.random.seed(1)
tf.random.set_seed(1)

# 하이퍼파라미터 설정
LEARNING_RATE = 0.001
DROPOUT_RATE = 0.5
N_EPOCHS = 50
N_BATCHS = 20
IMAGE_SIZE = 150

# 모델 생성 함수 정의
def create_model():
  model = keras.Sequential()
  # input
  model.add(layers.Input((IMAGE_SIZE, IMAGE_SIZE, 3))
  
  # Feature Extraction
  model.add(layers.Conv2D(filters=64, kernel_size=3, padding='same', activation='relu')
  model.add(layers.MaxPool2D(padding='same'))
  
  model.add(layers.Conv2D(filters=128, kernel_size=3, padding='same', activation='relu')
  model.add(layers.MaxPool2D(padding='same'))
  
  model.add(layers.Conv2D(filters=256, kernel_size=3, padding='same', activation='relu')
  model.add(layers.MaxPool2D(padding='same'))
  
  # Classification
  model.add(layers.Flatten())
  model.add(layers.Dropout(DROPOUT_RATE))
  model.add(layers.Dense(512, activation='relu'))
  
  # output
  model.add(layers.Dense(1, activation='sigmoid'))
  
  retrun model
  
model = create_model()
model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
              loss='binary_crossentropy',
              metrics=['accuracy'])
model.summary()
"""
Model: "sequential"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
conv2d (Conv2D)              (None, 150, 150, 64)      1792      
_________________________________________________________________
max_pooling2d (MaxPooling2D) (None, 75, 75, 64)        0         
_________________________________________________________________
conv2d_1 (Conv2D)            (None, 75, 75, 128)       73856     
_________________________________________________________________
max_pooling2d_1 (MaxPooling2 (None, 38, 38, 128)       0         
_________________________________________________________________
conv2d_2 (Conv2D)            (None, 38, 38, 256)       295168    
_________________________________________________________________
max_pooling2d_2 (MaxPooling2 (None, 19, 19, 256)       0         
_________________________________________________________________
flatten (Flatten)            (None, 92416)             0         
_________________________________________________________________
dropout (Dropout)            (None, 92416)             0         
_________________________________________________________________
dense (Dense)                (None, 512)               47317504  
_________________________________________________________________
dense_1 (Dense)              (None, 1)                 513       
=================================================================
Total params: 47,688,833
Trainable params: 47,688,833
Non-trainable params: 0
_________________________________________________________________
"""
```
# Using data augmentation
- 학습 이미지의 수가 적어 overfitting이 발생할 가능성을 줄이기 위해 기존 훈련 데이터로 부터 이미지 변환을 통해 이미지를 늘리는 작업
- train_set에만 적용, validation, test set은 적용 X
```python
# ImageDataGenerator 생성 => Augmentation. 입력  pipline
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import matplotlib.pyplot as plt

train_dir = '/content/data/cats_and_dogs_small/train'
validation_dir = '/content/data/cats_and_dogs_small/validation'
test_dir = '/content/data/cats_and_dogs_small/test'

train_datagen = ImageDataGenerator(rescale=1./255.,
                                   rotation_range=40,
                                   width_shift_range=0.1,
                                   height_shift_range=0.1,
                                   zoom_range=0.2,
                                   horizontal_flip=True,
                                   brightness_range=(0.7, 1.3),
                                   fill_mode='constant')
# validation, test set 용
test_datagen = ImageDataGenerator(rescale=1./255.)

train_iterator = train_datagen.flow_from_directory(train_dir,
                                                   target_size=(IMAGE_SIZE, IMAGE_SIZE),
                                                   class_mode='binary',
                                                   batch_size=N_BATCHS)
validation_iterator = test_datagen.flow_from_directory(validation_dir,
                                                      target_size=(IMAGE_SIZE, IMAGE_SIZE),
                                                      class_mode='binary',
                                                      batch_size=N_BATCHS)
test_iterator = test_datagen.flow_from_directory(test_dir,
                                                 target_size=(IMAGE_SIZE, IMAGE_SIZE),
                                                 class_mode='binary',
                                                 batch_size=N_BATCHS)
```
# 이미지 확인
- augmentation 후에는 이미지를 확인하는 습관을 갖자
- 변형이 심하게 되어 라벨과 상관없는 이미지가 있을 수 있기때문
```python
# 이미지 확인
batch_image = train_iteratot.next()
batch_image[0].shape # batch_image[0] : image, batch_image[1] : labels
## >>> ((20, 150, 150, 3),)

plt.figure(figsize=(30, 15))
for i in range(20):
  plt.subplot(4, 5, i+1)
  img = batch_image[0][i].astype('uint8')
  plt.imshow(img)
  plt.axis('off')

plt.tight_layout()
plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/116214862-18e24080-a782-11eb-843f-522ba75c35d4.png)
# 학습
```python
model.fit(train_iterator,
          epochs=N_EPOCHS,
          steps_per_epoch=len(train_iterator),
          validation_data=validation_iterator,
          validation_steps=len(validation_iterator))
```
