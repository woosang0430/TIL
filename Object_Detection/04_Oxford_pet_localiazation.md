# The Oxford-IIIT Pet Dataset
- https://www.robots.ox.ac.uk/~vgg/data/pets/
- 37개 카테고리의 개, 고양이 품종 데이터셋. 각 클래스 별로 대략 200여장의 이미지 제공
- 3686개 이미지에 대한 annotation 파일 제공
  - bounding box는 각 pet의 얼굴을 가리킨다.
```python
# library import
import  os

import re
import random
import xml.etree.ElementTree as et
from PIL import image

import cv2
import numpy as np
import tensorflow as tf
from tensorflow import keras

from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
```
## Oxford Pet Dataset
- 파일명
  - 품종명_번호.jpg
  - 대문자로 시작: 고양이, 소문자로 시작 : 개

#### 데이터셋 다운로드
```python
# !pip install gdown
import gdown
url = 'https://drive.google.com/uc?id=1gXqmWrxJqdp_luNKZmv81vY5cjFLuTdT'
fname = 'oxford_pet.zip'
gdown.download(url, fname, quiet=Fale)

## 압축 풀기
# unzip 압축파일 -d 저장할디렉토리
!unzip -q oxford_pet.zip -d oxford_pet

## 압축이 풀린 directory 확인
#!ls oxford_pet
!ls -al oxford_pet
```
## 경로 설정(base_dir 부터!...)
```python
base_dir = '/content/oxford_pet' # 데이터셋 기본
image_dir = os.path.join(base_dir, 'images') # image 디렉토리 경로
bbox_dir = os.path.join(base_dir, 'annotations', 'xmls') # annotation 파일경로

os.listdir(image_dir)
"""
['german_shorthaired_109.jpg',
 'leonberger_110.jpg',
 'Russian_Blue_20.jpg',
 'pug_73.jpg',
 'keeshond_196.jpg',
 ...]
"""

os.path.splitext('test.jpg')
## >>> ('test', '.jpg')
```
## 파일명 조회 및 특정 확장자의 리스트 생성
```python
# 이미지 파일명 조회 및 리스트 생성
image_files = [fname for fname in os.listdir(image_dir) if os.path.splitext(fname)[-1] == '.jpg'] # jpg파일명만 리스트 생성
print(len(image_files))
image_files[:3]
## >>> 7390
## >>> ['german_shorthaired_109.jpg', 'leonberger_110.jpg', 'Russian_Blue_20.jpg']

# annotation 파일 경로
# xml 파일명만 조회하여 리스트로 생성
bbox_files = [fname for fname in os.listdir(bbox_dir) if os.path.splitext(fname)[-1] == '.xml']
print(len(bbox_files))
bbox_files[:3]
## >>> 3686
## >>> ['boxer_178.xml', 'saint_bernard_123.xml', 'english_setter_142.xml']

# 이미지 파일 중 RGB가 아닌 이미지 파일과 그 파일에 대한 annotation파일 제거
remove_image_cnt = 0
for image_file in image_files:
  # 이미지파일과 그에 매핑되는 annotation 파일 경로 확인
  image_path = os.path.join(image_dir, image_file)
  bbox_file = os.path.splitext(image_file)[0] + '.xml'
  bbox_path = os.path.join(bbox_dir, bbox_file)
  
  image = image.open(image_path) # 이미지 파일 읽기
  image_mode = image.mode # 이미지 색공간을 string으로 반환
  if image_mode != 'RGB': # RGB가 아니면 파일 삭제
    image = np.asarray(image) # shape을 확인하지 않으면 필요없는 코드
    print(image_file, image_mode, image.shape)
    
    os.remove(image_path)
    remove_image_cnt += 1
    try:
      os.remove(bbox_path) # xml annotation 파일이 없는 경우 remove()에서 예외발생하므로 예외처리
      print(bbox_path)
    except FileNotFoundError:
      pass
remove_image_cnt
## >>> 12

# 삭제후 image, annotation 파일 목록 다시 만들기
image_files = [fname for fname in os.listdir(image_dir) if os.path.splitext(fname)[-1] == '.jpg']
bbox_files = [fname for fname in os.listdir(bbox_dir) if os.path.splitext(fname)[-1] == '.xml']

len(image_files), len(bbox_files)
## >>> (7378, 3685)
```
## class dictionary 생성
- 결과값을 확인하기 위한 dictionary
```python
# make class dictionary list
# Egyptian_Mau_139.jpg 품종_숫자.jpg
class_list = set() # 중복 제거를 위해
for image_file in image_files:
  file_name = os.path.split(image_file)[0] # 파일명 추출 Egyptian_Mau_139    .jpg
  class_name = re.sub('_\d+', '', file_name) # 품종_숫자 => _숫자 제거
  class_list.add(class_name)
class_list = list(class_list).sort()
print(len(class_list))
## >>> 37

# make list dictionary : class => index로 반환하는 것
class2idx = {cls:idx for idx, cls in enumerate(class_list)}
class_list[:5], class_list[-5:]
## >>> (['Abyssinian', 'Bengal', 'Birman', 'Bombay', 'British_Shorthair'],
## >>>  ['scottish_terrier',
## >>>   'shiba_inu',
## >>>   'staffordshire_bull_terrier',
## >>>   'wheaten_terrier',
## >>>   'yorkshire_terrier'])
```
## train/validation 데이터셋 만들기
### TFRecord 만들기
```python
IMG_SIZE = 224 # resize 크기
N_BBOX = len(bbox_files) # annotation 파일이 있는 데이터셋만 사용.  -> 전체 데이터 개수
N_TRAIN = 3000 # train set의 개수
N_VAL = N_BBOX - N_TRAIN # validation set의 개수

## TFRecord 저장할 directory 생성
tfr_dir = os.path.join(base_dir, 'tfrecord')
os.makedirs(tfr_dir, exist_ok=True)

tfr_train_dir = os.path.join(tfr_dir, 'oxford_train.tfr') # train set을 저장할 tfrecord 파일 경로
tfr_val_dir = os.path.join(tfr_dir, 'oxford_val.tfr') # validation set을 저장할 tfrecord 파일 경로

## TFRecord writer 생성
writer_train = tf.io.TFRecordWriter(tfr_train_dir)
writer_val = tf.io.TFRecordWriter(tfr_val_dir)

# The following functions can be used to convert a value to a type compatible with tf.Examplt
# 값을 Feature로 변환하는 함수
def _bytes_feature(value):
  """Returns a bytes_list from a string/ byte."""
  if isinstance(value, type(tf.constant(0))):
    value = value.numpy() # BytesList won't unpack a string from an EagerTensor
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value])
  
def _float_feature(value):
  """Returns a float_list from a float / double."""
  return tf.train.Feature(float_list=tf.train.FloatList(value=[value]))
  
def _int64_feature(value):
  """Returns a int64_list from a bool / enum / int / uint. """
  return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))
  
# train, validation 데이터셋의 index설정

# 데이터 섞기
shuffle_list = list(range(N_BBOX))
random.shuffle(shuffle_list)

# 분할 index
train_idx_list = shuffle_list[:N_TRAIN]
val_idx_list = shuffle_list[N_TRAIN:]

# Train TFRecord 생성
for idx in train_idx_list:
  bbox_file = bbox_files[idx]
  bbox_path = os.path.join(bbox_dir, bbox_file)
  
  # annotation(root tag) - size - width, height
  # annotation(root tag) - object - ...., bndbox - xmin, ymin, xmax, ymax
  tree = et.parse(bbox_path) # xml 파일 경로 tree 위치 : root tag
  width = float(tree.find('./size/width').text)  # .text = 태그 내의 내용을 문자열(string) 반환
  height = float(tree.find('./size/height').text)
  xmin = float(tree.find('./object/bndbox/xmin').text)
  ymin = float(tree.find('./object/bndbox/ymin').text)
  xmax = float(tree.find('./object/bndbox/xmax').text)
  ymax = float(tree.find('./object/bndbox/ymax').text)
  
  # X, Y center 좌표
  xc = (xmin + xmax) / 2.
  yc = (ymin + ymax) / 2.
  
  x = xc / width
  y = yc / height
  
  w = (xmax - xmin) / width
  h = (ymax - ymin) / height
  
  # 이미지 파일 조회
  file_name = os.path.splitext(bbox_file)[0]
  image_file = file_name + '.jpg' # 이미지 파일명
  image_path = os.path.join(image_dir, image_file) # 이미지 경로 + 이미지 파일명 -> 이미지 경로
  image = image.open(image_path) # 이미지 파일 읽기
  image = image.resize(IMG_SIZE, IMG_SIZE)) # (224, 224)로 resize
  bimage = image.tobytes() # 이미지를 bytes 타입으로 변환
  
  # 품종 라벨 -> LabelEncoding
  class_name = re.sub('_\d+', '', file_name)
  class_num = class2idx[class_name]
  
  # 개/고양이(이진분류) 라벨 -> LabelEncoding(개-소문자시작:0, 고양이-대문자 시작:1)
  if file_name[0].islower():
    bi_cls_num = 0
  else:
    bi_cls_num = 1
    
  # Example : 데이터 1개 -> 여러개 Feature들
  example = tf.train.Example(features=tf.train.Features(feature={
    'image' : _bytes_feature(bimage),
    'cls_num' : _int64_feature(class_num),
    'bi_cls_num' : _int64_feature(bi_cls_num),
    'x' : _float_feature(x),
    'y' : _float_feature(y),
    'w' : _float_feature(w),
    'h' : _float_feature(h)
  }))
  writer_train.write(example.SerialzeToString())
  
writer_train.close()

# ------------------------------------------------------------------------------

# Validation  TFRecord 생성
for idx in val_idx_list:
  bbox_file = bbox_files[idx]
  bbox_path = os.path.join(bbox_dir, bbox_file)
  
  tree = et.parse(bbox_path)
  width = float(tree.find('./size/width').text)
  height = float(tree.find('./size/height').text)
  xmin = float(tree.find('./object/bndbox/xmin').text)
  ymin = float(tree.find('./object/bndbox/ymin').text)
  xmax = float(tree.find('./object/bndbox/xmax').text)
  ymax = float(tree.find('./object/bndbox/ymax').text)
  
  xc = (xmin + xmax) / 2.
  yc = (ymin + ymax) / 2.
  
  x = xc / width
  y = yc / height
  
  w = (xmax - xmin) / width
  y = (ymax - ymin) / height
  
  file_name = os.path.splitext(bbox_file)[0]
  image_file = file_name + '.jpg'
  image_path = os.path.join(image_dir, image_file)
  image = image.open(image_path)
  image = image.resize((IMG_SIZE, IMG_SIZE))
  bimage = image.tobytes()
  
  class_name = re.sub('_\d+', '', file_name)
  class_num = class2idx[class_name]
  
  if file_name[0].islower():
    bi_cls_num = 0
  else:
    bi_cls_num = 1
    
  example = tf.train.Example(features=tf.train.Features(feature={
    'image' : _bytes_feature(bimage),
    'cls_num' : _int64_feature(class_num),
    'bi_cls_num' : _int64_feature(bi_cls_num),
    'x' : _float_feature(x),
    'y' : _float_feature(y),
    'w' : _float_feature(w),
    'h' : _float_feature(h)
  }))
  writer_val.write(eample.SerializeToString())
  
writer_val.close()
```
# Localization 모델 학습
```python
## Hyper Parameter
LEARNING_RATE = 0.0001
N_CLASS = len(class_list)
N_EPOCHS = 40
N_BATCHS = 40
IMG_SIZE = 224

steps_per_epoch = N_TRAIN//N_BATCHS
validation_steps = int(np.ceil(N_VAL / N_BATCHS))

print(steps_per_epoch, validation_steps)
## >>> 75 18
```
### TFRecord에 저장된 Dataset의 하나의 data를 parsing하는 함수
```python
def _parse_function(tfrecord_serialized):
  """
  [매개변수]
    tfrecord_serialized : parsing할 1개의 data
  [반환값]
    튜플(image, ground truth)
  """
  
  features={'image' : tf.io.FixedLenFeature([], tf.string),
            'cls_num' : tf.io.FixedLenFeature([], tf.int64),
            'bi_cls_num' : tf.io.FixedLenFeature([], tf.int64),
            'x' : tf.io.FixedLenFeature([], tf.float32),
            'y' : tf.io.FixedLenFeature([], tf.float32),
            'w' : tf.io.FixedLenFeature([], tf.float32),
            'h' : tf.io.FixedLenFeature([], tf.float32)
            }
            
  parsed_features = tf.io.parse_single_example(tfrecord_serialized, features)
  
  image = tf.io.decode_raw(parsed_features['image'], tf.uint8) # Feature(이미지 bytes) => image data(Tensor)로 변환
  image = tf.reshape(image, [IMG_SIZE, IMG_SIZE, 3]) # input_shape의 형태로 reshape
  image = tf.cast(image, tf.float32)/255.
  
  cls_label = tf.cast(parsed_features['cls_num'], tf.int64)
  bi_cls_label = tf.cast(parsed_features['bi_cls_num'], tf.int64)
  
  x = tf.cast(parsed_features['x'], tf.float32)
  y = tf.cast(parsed_features['y'], tf.float32)
  w = tf.cast(parsed_features['w'], tf.float32)
  h = tf.cast(parsed_features['h'], tf.float32)
  ground_truth = tf.stack([x, y, w, h], -1)
  
  return image, ground_truth # X, y로 나눠줘야한다. input과 output
  
## train dataset 만들기
train_dataset = tf.data.TFRecordDataset(tfr_train_dir)
train_dataset = train_dataset.map(_parse_function, num_parallel_calls=tf.data.experimental.AUTOTUNE)
# num_parallel_calls : 병렬처리를 이용해 변환 속도를 높인다.

train_dataset = train_dataset.shuffle(buffer_size=N_TRAIN).prefetch(tf.data.experimental.AUTOTUNE).batch(N_BATCH).repeat()
# prefetch(tf.data.experimental.AUTOTUNE) : 현재 batch 처리하면서 다음 batch 미리 준비해!(읽어오기)

## validation dataset 만들기
val_dataset = tf.data.TFRecordDataset(tfr_val_dir)
val_dataset = val_datset.map(_parse_function, num_parallel_calls=tf.data.experimental.AUTOTUNE)
val_dataset = val_dataset.batch(N_BATCH)
```
## Trainset의 데이터 읽어 bounding box 확인
```python
# _parse_function() 반환값 : image, ground_truth(x, y, w, h)
for image, gt in val_dataset.take(3): # 반복 3번 - 한번 반복할 때 마다 N번째 배치값 조회
  ```그림을 그리기 위해서 bbox의 왼쪽 위 꼭지점 좌표를 계산하고 xmin, ymin, w, h 각각을 image size에 맞게 scaling'''
  x = gt[:, 0]
  y = gt[:, 1]
  w = gt[:, 2]
  h = gt[:, 3]
  xmin = x[0].numpy() - w[0].numpy()/2.
  ymin = y[0].numpy() - h[0].numpy()/2.
  # 조회된 xmin, ymin, w, h는 0 ~ 1로 normalize된 값(이미지의 width, height에 대한 비율) => 원래 크기(값)으로 복원 x, w = 이미지의 width 곱하기, y, h = 이미지의 height 곱하기
  rect_x = int(xmin * IMG_SIZE)
  rect_y = int(ymin * IMG_SIZE)
  rect_w = int(w[0].numpy() * IMG_SIZE)
  rect_h = int(h[0].numpy() * IMG_SIZE)
  
  # Rectangle((xmin, ymin), box_width, box_height, fill=색을 채울지 여부, color)
  rect = Rectangle((rect_x, rect_y), rect_w, rect_h, fill=False, color='red')
  plt.axes().add_patch(rect)
  plt.imshow(image[0])
  plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/117962035-bc724a00-b359-11eb-9f76-c8e4e6b3d090.png)
- ...
## 모델 생성 및 학습
```python
from tensorflow.keras import optimizers
from tensorflow.keras.applications import ResNet101v2
from tensorflow.keras.layers import Conv2D, ReLU, MaxPooling2D, Dense, BatchNormalization, GlobalAveragePooling2D, Concatenate
from tensorflow import keras

def create_l_model():
  resnet101v2 = ResNet101v2(include_top=False, weights='imageNet', input_shape=(IMG_SIZE, IMG_SIZE, 3))
  model = keras.models.Sequentail()
  model.add(resnet101v2)
  model.add(GlobalAveragePooling2D()) # 채널(depth) 수가 많을때는 GlobalAveragePooling 사용
  model.add(Dense(256))
  model.add(BatchNormalization())
  model.add(ReLU())
  model.add(Dense(64))
  model.add(BatchNormalization())
  model.add(ReLU())
  
  # output layer(x, y, w, h) -> units를 4, 각각 출력값이 0 ~ 1 사이의 값으로 normalize되어있으므로 출력결과도 scale에 맞추기 위해 sigmoid 활성함수 사용
  # localization 문제(위치-좌표, 너비, 높이 예측) -> 회귀(Regression 문제)
  model.add(Dense(4, activation='sigmoid'))
  return model
  
model = create_model()

# 모델 컴파일
## learning rate scheduing
lr_schedule = keras.optimizers.schedules.ExponentialDecay(initial_learning_rate=LEARNING_RATE,
                                                          decay_steps=steps_per_epoch*10,
                                                          decay_rate=0.5,
                                                          staircase=True)
model.compile(optimizers.Adam(lr_schedule), loss='mse') # 회귀 문제이므로 Mean Squared Error
 
# 학습
filepath = r'/content/drive/MyDrive/save_models/oxford_pet_localization_resnet101v2_model'
mc_callback = keras.callbacks.ModelCheckpoint(filepath, 'val_loss', verbose=1, save_best_only=True)
es_callback = keras.callbacks.EarlyStopping(monitor='val_loss', patience=5, verbose=1)

history = model.fit(train_dataset,
                    steps_per_epoch = steps_per_epoch,
                    epochs=N_EPOCHS,
                    validation_data=val_dataset,
                    validation_steps=validation_steps,
                    callbacks=[mc_callback, es_callback])
```

## 확인
```python
# 미리 학습한 모델 다운로드
import gdown
url = 'https://drive.google.com/uc?id=1-2lbiHp3Sdffxkqlj4iGL9-recS6g697'
fname = 'oxford_pet_localization_resnet101.tar.gz'
gdown.download(url, fname, quiet=False)

# 리눅스 명령어
!mkdir models
!tar -zxvf oxford_pet_localization_resnet101.tar.gz -C models

# 저장된 모델 load
filepath = '/content/models/oxford_pet_localization_resnet101v2_model'
saved_model = keras.models.load_model(filepath)

saved_model.summary()
"""
Model: "sequential"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
resnet101v2 (Functional)     (None, 7, 7, 2048)        42626560  
_________________________________________________________________
global_average_pooling2d (Gl (None, 2048)              0         
_________________________________________________________________
dense (Dense)                (None, 256)               524544    
_________________________________________________________________
batch_normalization (BatchNo (None, 256)               1024      
_________________________________________________________________
re_lu (ReLU)                 (None, 256)               0         
_________________________________________________________________
dense_1 (Dense)              (None, 64)                16448     
_________________________________________________________________
batch_normalization_1 (Batch (None, 64)                256       
_________________________________________________________________
re_lu_1 (ReLU)               (None, 64)                0         
_________________________________________________________________
dense_2 (Dense)              (None, 4)                 260       
=================================================================
Total params: 43,169,092
Trainable params: 43,070,788
Non-trainable params: 98,304
_________________________________________________________________
"""
```
## Bounding Box 그리기
```python
# 예측한 bounding box와 ground truth box를 image에 같이 표시
# 정답은 빨간색 box, 예측은 파란색 box
idx = 0
num_imgs - validation_steps
for val_data, val_gt in val_dataset.take(num_imgs):
  
  x = val_gt[:,0]
  y = val_gt[:,1]
  w = val_gt[:,2]
  h = val_gt[:,3]
  
  xmin = x[idx].numpy() - (w[idx].numpy() / 2.)
  ymin = y[idx].numpy() - (h[idx].numpy() / 2.)
  
  rect_x = int(xmin * IMG_SIZE)
  rect_y = int(ymin * IMG_SIZE)
  rect_w = int(w[idx] * IMG_SIZE)
  rect_h = int(h[idx] * IMG_SIZE)
  
  rect = Rectangle((rect_x, rect_y), rect_w, rect_h, fill=False, color='red')
  plt.axes().add_patch(rect)
  
  prediction = saved_model.predict(val_data)
  pred_x = prediction[:, 0]
  pred_y = prediction[:, 1]
  pred_w = prediction[:, 2]
  pred_h = prediction[:, 3]
  pred_xmin = pred_x[idx] - (pred_w[idx]/2.)
  pred_ymin = pred_y[idx] - (pred_h[idx]/2.)
  pred_rect_x = int(pred_xmin * IMG_SIZE)
  pred_rect_y = int(pred_ymin * IMG_SIZE)
  pred_rect_w = int(pred_w[idx] * IMG_SIZE)
  pred_rect_h = int(pred_h[idx] * IMG_SIZE)
  
  pred_rect = Rectangle((pred_rect_x, pred_rect_y), pred_rect_w, pred_rect_h, fill=False, color='blue')
  plt.axes().add_patch(pred_rect)
  
  plt.imshow(val_data[idx])
  plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/117987889-db7ed500-b375-11eb-9439-879bbaa703ba.png)
- ...
## IoU 확인
```python
## Validation set의 IoU 계산
avg_iou = 0
num_imgs = validation_steps
# N_VAL = validation data 개수 % batch_size = 마지막 배치의 데이터 개수
res = N_VAL % N_BATCH


for i, (val_data, val_gt) in enumerate(val_datset.take(num_imgs)):

  # flag : True이면 마지막 배치의 데이터 iou퍼리, False이면 중간 배치들 데이터에 대한 iou처리
  flag = (i == validation_steps-1)
  # i : 현재 반복횟수 - 몇번째 배치에 대한 처리. (validation_steps-1) : 마지막 배치 순번
  
  # ground truth의 x, y, w, h 조회
  x = val_gt[:, 0]
  y = val_gt[:, 1]
  w = val_gt[:, 2]
  h = val_gt[:, 3]
  # predict
  prediction = saved_model.predict(val_data)
  # 예측 결과 : x, y, w, h
  pred_x = prediction[:, 0]
  pred_y = prediction[:, 1]
  pred_w = prediction[:, 2]
  pred_h = prediction[:, 3]
  for idx in range(N_BATCH):
    if flag: # True : 마지막 배치 처리
      if idx == res: # True : 마지막 배치의 모든 데이터에 대해 iou 계산이 끝났다.
        flag = False
        break
    
    # 1개 이미지에 대한 IoU값 계산
    xmin = int((x[idx].numpy() - w[idx].numpy()/2.) * IMG_SIZE)
    ymin = int((y[idx].numpy() - h[idx].numpy()/2.) * IMG_SIZE)
    xmax = int((x[idx].numpy() + w[idx].numpy()/2.) * IMG_SIZE)
    ymax = int((y[idx].numpy() + h[idx].numpy()/2.) * IMG_SIZE)
    
    pred_xmin = int((pred_x[idx] - pred_w[idx]/2.) * IMG_SIZE)
    pred_ymin = int((pred_y[idx] - pred_h[idx]/2.) * IMG_SIZE)
    pred_xmax = int((pred_x[idx] + pred_w[idx]/2.) * IMG_SIZE)
    pred_ymax = int((pred_y[idx] + pred_h[idx]/2.) * IMG_SIZE)
    
    # 두개 box가 겹치지 않은 경우
    if xmin > pred_xmax or xmax < pred_xmin:
      continue
    if ymin > pred_ymax or ymax < pred_ymin:
      continue
      
    gt_width = xmax-xmin
    gt_height = ymax-ymin
    pred_width = pred_xmax - pred_xmin
    pred_height = pred_ymax - pred_ymin
    
    # 교집합 영역의 width, height 구하기
    inter_width = np.min((xmax, pred_xmax)) - np.max((xmin, pred_xmin))
    inter_height = np.min((ymax, pred_ymax)) - np.max(ymin, pred_ymin))
    
    iou = (inter_width * inter_height)/((gt_width * gt_height) + _pred_width * pred_height) - (inter_width * inter_height))
    
    avg_iou += iou / N_VAL
    
print(avg_iou)
## >>> 0.7608909660148577
```




















