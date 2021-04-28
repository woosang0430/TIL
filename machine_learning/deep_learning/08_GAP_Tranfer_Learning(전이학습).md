# GlovalAveragePooling(GAP)
- feature map의 채널별로 평균값을 추출 1 x 1 x channel의 feature map을 생성
- `model.add(keras.layers.GlobalAveragePooling2D())`
- Feature Extraction layer에서 추출한 Feature map을 Classifier layer로 Flatten해서 전달하면 많은 연결노드와 파라미터가 샹송.
- GAP를 사용하면 노드와 파라미터의 개수를 효과적으로 줄일 수 있다.
- Feature map의 채널수가 많으면 GAP, 채널수가 적으면 Flatten
- ![image](https://user-images.githubusercontent.com/77317312/116216101-36fc7080-a783-11eb-978b-a5079422eb4e.png)
## colab 이미지 다운로드
```python
import gdown
url = 'https://drive.google.com/uc?id=1nBE3N2cXQGwD8JaD0JZ2LmFD-n3D5hVU'
fname = 'cats_and_dogs_small.zip'
gdown.download(url, fname, quiet=False)

!mkdir data

# 압축 풀기
!unzip -q ./cats_and_dogs_small.zip -d data/cats_and_dogs_small
```
- ![image](https://user-images.githubusercontent.com/77317312/116216325-77f48500-a783-11eb-9a87-c3ea50cb1a20.png)
## Transfer learning(전이학습)
- 큰 데이터 셋을 이용해 미리 학습된 pre-trained Model의 weight를 사용하여 현재 하려는 예측 문제에 활용
- **Convolution base(Feature Extraction 부분)만 활용**
  - Convolution base는 이미지에 나타나는 일반적인 특성을 파악하기 위한 부분이므로 재사용할 수 있다.
  - Classifier 부분은 학습하려는 데이터셋의 class들에 맞게 변경해야 하므로 재사용할 수 없다.
- Pretrained Convolution layer의 활용
  - Feature extraction
    - 학습시 학습되지 않고 Feature를 추출하는 역할만 한다.
  - Fine tuning
    - 학습시 Pretrained Convolution layer도 같이 학습해서 내 데이터셋에 맞춘다.

## Feature extraction
- 기존의 학습된 network에서 fully connected layer를 제외한 나머지 weight를 고정하고 새로운 목적에 맞는 fully connected layer를 추가하여 추가된 weight만 학습하는 방법
- `tensorflow.keras.applications` module이 지원하는 image classification models
- (https://www.tensorflow.org/api_docs/python/tf/keras/applications)
- **ImageNet**
  - 웹상에서 수집한 약 1500만장의 라벨링된 고해상도 이미지로 약 22,000개 카테고리로 구성된다.

## VGG16 모델
- ![image](https://user-images.githubusercontent.com/77317312/116217666-d1a97f00-a784-11eb-8ea0-7545abce365b.png)
- 단점 : 마지막 분류를 위해 Fully Connected layer 3개를 붙여 파라미터수가 많아진다.

## ResNet(Residual Networks)
- **Idea**
  - ![image](https://user-images.githubusercontent.com/77317312/116217989-0ddcdf80-a785-11eb-95c9-fda19e42c1eb.png)
  - 입력값을 그대로 출력하는 identity block을 사용하면 성능이 떨어지지 않는다.
  - 그럼 Convolution block을 identity block으로 만들면 최소한 성능은 떨어지지 않고 깇은 layer를 쌓을 수 있지 않을까?

- **Solution**
  - ![image](https://user-images.githubusercontent.com/77317312/116218243-4d0b3080-a785-11eb-8e9e-379ac05571c6.png)
  - 목표는 H(x)(레이어를 통과한 값)이 input인 x와 동일한 것으로 만들기 위해 F(x)를 0으로 만들기 위해 학습한다.
  - F(x)는 잔차가 된다. 그리고 잔차인 F(x)가 0이 되도록 학습하는 방식이므로 Residual Learning
  - 입력인 x를 직접 전달하는 것을 **shortcut connection** or **identity mapping** or **skip connection**이라 한다.
- **성능향상**
  - H(x) = F(x) + x 을 x에 대해 미분하면 최소한 1이므로 Gradient Vanishing문제를 극복
  - 잔차학습이라고 하지만 Residual block은 Convolution layer와 Activation layer로 구성되어 있기 때문에 이 layer를 통과한 Input으로 부터 Feature map을 추출하는 과정은 진행되며ㅑ 레이어가 깇으므로 더욱 풍부한 특성들을 추출하게 되어 성능이 향상된다.
- **ResNet 구조**
- ![image](https://user-images.githubusercontent.com/77317312/116219113-374a3b00-a786-11eb-9a3e-9e746ee0c1a0.png)
- 모든 Identity block은 두개의 3x3 conv layer로 구성
- 일정 레이어 수별로 filter의 개수를 두배로 증가시키며 stride를 2로 하여 downsampling함(Pooling은 시작과 마지막에만 적용)

# Pretrained Model 사용
- tensorflow.keras.applications 패키지를 통해 제공
- 모델이름이 클래스이름
  - VGG16, ResNet153등등
- 생성자 매개변수
  - `weights` : 모형의 학습된 weight. 기본값 = 'imagenet'
  - `include_top` : fully connected layer를 포함할지 여부. True 포함시킴, False 포함 안함
  - `input_shape` : 사용자가 입력할 이미지의 크기 shape. 3D 텐서로 지정(height, width, channel). 기본값(224,224,3)

```python
# 이미지 다운로드(구글 드라이브 연결)
import gdown
url = 'https://drive.google.com/uc?id=1nBE3N2cXQGwD8JaD0JZ2LmFD-n3D5hVU'
fname = 'cats_and_dogs_small.zip'
gdown.download(url, fname, quiet=False)

# 저장할 디렉토리 생성 및 압출 풀기
!mkdir data
!unzip -q ./cats_and_dogs_small.zip -d data/cats_and_dogs_small

# generator 함수 정의
from tensorflow.keras.preprocessing.image import ImageDataGenerator
def get_generator():
  '''
  train, validaion, test generator를 생성해서 반환.
  train generator는 image 변환 처리
  '''
  train_dir = './data/cats_and_dogs_small/train'
  validation_dir = './data/cats_and_dogs_small/validation'
  test_dir = './data/cats_and_dogs_small/test'
  train_datagen = ImageDataGenerator(rescale=1./255., 
                                     rotation_range=40,
                                     brightness_range=(0.7, 1.3),
                                     zoom_range=0.2,
                                     horizontal_flip=True)
  test_datagen = ImageDataGenerator(rescale=1./255.) # validation/test 에서 사용
  
  # generator 생성
  train_generator = train_datagen.flow_from_directory(train_dir,
                                                      target_size=(150,150),
                                                      batch_size=N_BATCHS,
                                                      class_mode='binary')
  val_generator = test_datagen.flow_from_directory(validation_dir,
                                                   target_size=(150, 150),
                                                   batch_size=N_BATCHS,
                                                   class_mode='binary')
  test_generator = test_datagen.flow_from_directory(test_dir,
                                                    target_size=(150, 150),
                                                    batch_size=N_BATCHS,
                                                    class_mode='binary')
                                                    
  return train_generator, val_generator, test_generator
```
# Feature extraction의 두가지 방법
1. 빠른 추출 방식
- 예측하려는 새로운 데이터를 **conv_base**에 입력하여 나온 출력값을 numpy 배열로 저장하고 이를 분류 모델의 입력값으로 사용 Convolution operation을 하지 않아도 되기 때문에 학습이 빠르다.

2. 받아온 특성 layer를 이용해 새로운 모델 구현하는 방식
- **conv_base** 이후 새로운 layer를 쌓아 확장한 뒤 전체 모델을 다시 학습. 모든 데이터가 convolution layer들을 통과해야 하기 때문에 학습이 느림. 단 conv_base의 가중치는 업데이트 되지 않도록 한다.

## 빠른 특성 추출방식
- `conv_base`의 predict메소드로 입력 이미지의 feature 추출
```python
# 하이퍼파라미터
LEARNING_RATE = 0.001
N_EPOCHS = 30
N_BATCHS = 100

import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.applications import VGG16, ResNet50V2
from tensorflow.keras.preprocessing.image import ImageDataGenerator

np.random.seed(1)
tf.random.set_seed(1)

conv_base = VGG16(weights='imagenet', include_top=False, input_shape=(150, 150, 3))



# convolution layer들을 통과한 featuremap 반환 함수 정의
def extract_featuremap(image_directory, sample_counts):
  '''
  매개변수로 받은 디렉토리의 이미지들을 Conv_base모델(VGG16)을 통과시켜 Featuremap들을 추출해 반환하는 함수
  [매개변수]
    image_directory : 이미지 데이터들이 있는 디렉토리
    sample_counts : 특성을 추출할 이미지의 개수 지정
  [반환값]
    tuple : (featuremap들, labels)
  '''
  conv_base = VGG16(weights='imagenet', include_top=False, input_shape=(150, 150, 3))
  # 결과를 담을 nadarray 생성
  return_features = np.zeros(shape=(sample_counts, 4, 4, 512)) # Featuremap 저장 conv_base의 마지막 output의 shape 지정
  return_labels = np.zeros(shape=(sample_counts, )) # labels들 저장
  
  datagen = ImageDataGenerator(rescale=1./255.)
  iterator = datagen.flow_from_directory(image_directory,
                                         target_size=(150, 150),
                                         batch_size=N_BATCHS,
                                         class_mode='binary')
  i = 0 # 반복횟수 저장 변수
  for input_batch, label_batch in iterator: # (image, label) * batch의 크기 만큼
    # input_batch를 conv_base에 넣어 feature map을 추출
    # 예측은 아니지만 model.predict() -> 모델의 layer들을 통과해 나온 출력결과를 반환
    fm = conv_base.predict(input_batch)
    
    return_featrues[i*N_BATCHS, (i+1)*N_BATCHS] = fm
    return_labels[i*N_BATCHS, (i+1)*N_BATCHS] = label_batch
    
    i+=1
    # 결과를 저장할 배열 시작 index가 sample_counts보다 크면 반복문 종로
    if i*N_BATCHS >= sample_counts:
      break
  
  return return_features, return_labels
  

train_dir = '/content/data/cats_and_dogs_small/train'
validation_dir = '/content/data/cats_and_dogs_small/validation'
test_dir = '/content/data/cats_and_dogs_small/test'

# featuremap 추출
train_features, train_labels = extract_featuremap(train_dir, 2000)
validation_features, validation_labels = extract_featuremap(validation_dir, 1000)
test_features, test_labels = extract_featuremap(test_dir, 1000)

# classification 모델 생성 함수
def create_model():
  model = keras.Sequential()
  
  model.add(layers.Input((4, 4, 512)))
  model.add(layers.GlobalAveragePooling2D())
  model.add(layers.Dense(256, activation='relu'))
  model.add(layers.Dense(1, activation='sofrmax'))
  
  return model

model = create_model()
model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARING_RATE),
              loss='binary_crossentropy',
              metrics=['accuracy'])
              
# 학습
N_EPOCHS = 30
history = model.fit(train_features, train_labels,
                    epochs=N_EPOCHS,
                    validation_data=(validation_features, validation_labels),
                    batch_size=N_BATCHS)

# 한개 이미지 추론
from tensorflow.keras.preprocessing.image import load_img, img_to_array

def predict_cat_dog(path, model, mode=False):
  class_name = ['고양이', '강아지']
  img = load_img(path, target_size=(150, 150, 3))
  sample = img_to_array(img)[np.newaxis, ...]
  sample = sample/255.
  
  if mode: # conv_base를 거치도록
    conv_base = VGG16(weights='imagenet', include_top=False, input_shape=(150, 150, 3))
    sample = conv_base.predict(sample)
    
  pred = model.predict(sample)
  pred_class = np.where(pred < 0.5, 0, 1)
  pred_class_name = class_name[pred_class[0,0]]
  
  return pred, pred_class, pred_class_name
  
predict_cat_dog('/content/cat.jpg', model, mode=True)
```

## pretrained Netword를 이용해 새로운 모델 구현 방식
- conv_base의 feature extraction 부분에 fully connected layer를 추가하여 모형 생성
- conv_base에서 가져온 부분은 학습을 하지 않고 weight를 고정
  - `layer.trainable=False`
```python
# 하이퍼파라미터 설정
LEARNING_RATE = 0.001
N_EPOCHS = 20
N_BATCHS = 100
IMAGE_SIZE = 150

import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

def create_model():
  conv_base = VGG16(weights='imagenet', include_top=False, input_shape=(IMAGE_SIZE, IMAGE_SIZE, 3))
  
  conv_base.trainable = False # 학습시 weight 최적화(update)를 하지 않도록 설정
  # => 모델 컴파일 전에 실행해야한다.
  
  model = keras.Sequential()
  model.add(conv_base)
  model.add(layers.GlobalAveragePooling2D())
  model.add(layers.Dense(256, activation='relu')
  
  # output
  model.add(layers.Dense(1, activation='sigmoid')
  
  return model
  
model = create_model()
model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
              loss='binary_crossentropy', metrics=['accuracy'])

train_iterator, validation_iterator, test_iterator = get_generators()

history = model.fit(train_iterator,
                    epochs=N_EPOCHS,
                    steps_per_epoch=len(train_iterator),
                    validation_data=validation_iterator,
                    validation_steps=len(validation_iterator))
```
