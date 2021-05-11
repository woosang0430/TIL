# The Oxford-IIIT Pet Dataset
- https://www.robots.ox.ac.uk/~vgg/data/pets/
- 37개 카테고리의 개, 고양이 품종 데이터셋. 각 클래스 별로 대략 200여장의 이미지 제공
- 3686개 이미지에 대한 annotation 파일 제공
  - bounding box는 각 pet의 얼굴을 가리킨다.
```python
# library import
import os

import re
import random
import xml.etree.ElementTree as et
from PIL import Image

import cv2
import numpy as np
import tensorflow as tf
from tensorflow import keras

from sklearn.model_selection import train_test_split
from matplotlib.patches import Rectangle
```
# Oxford Pet Dataset
- 파일명
  - 품종명_변호.jpg
  - 고양이 : 대문자로 시작, 개 : 소문자로 시작
  - 

### 데이터셋 다운로드
```python
!pip install gdown

import gdown
url = 'https://drive.google.com/uc?id=1gXqmWrxJqdp_luNKZmv81vY5cjFLuTdT'
fname = 'oxford_pet.zip'
gdown.download(url, fname, quiet=False)
# 구글 드라이브에 있는 zip파일을 불러오고 zip을 푸는 과정


# 리눅스 명령어
## 압축 풀기
!unzip -q oxford_pet.zip -d oxford_pet
## 압축이 풀린 directory 확인
!ls oxford_pet


# 경로 설정
base_dir = '/content/oxford_pet' # 데이터셋 기본경로
image_dir = os.path.join(base_dir, 'images') # image 디렉토리 경로
bbox_dir = os.paht.join(base_dir, 'annotations', 'xmls') # annotation 파일경로

# 이미지 파일명 조회
image_files = [fname for fname in os.listdir(image_dir) if os.path.splitext(fname)[-1] == '.jpg']

# annotation 파일 경로
bbox_files = [fname for fname in os.listdir(bbox_dir) if os.path.splitext(fname)[-1] == '.xml']

# 이미지 파일중 RGB가 아닌 이미지 파일과 그 파일에 대한 annotation 파일 제거
remove_image_cnt = 0
for image_file in image_files:
  image_path = os.path.join(image_dir, image_file)
  bbox_file = os.path.splitext(image_file[0]+'.xml'
  bbox_path = os.path.join(bbox_dir, bbox_file)
  
  image = Image.open(image_path)
  image_mode = image.mode
  if image_mode != 'RGB':
    image = np.aasarray(image)
    print(image_file, image_mode, image.shape)
    
    os.remove(image_path)
    remove_image_cnt += 1
    try:
      os.remove(bbox_path)
      print(bbox_path)
    except FileNotFoundError:
      pass
      
# 삭제 후 image, annotation 파일 목록 다시 만들기
image_files = [fname for fname in os.listdir(image_dir) if os.path.splitext(fname)[-1] == '.jpg']
bbox_files = [fname for fname in os.listdir(bbox_dir) if os.path.splitext(fname)[-1] == '.xml']
```
#### class dictionary 생성
```python
# 클래스 딕셔너리 리스트로 만들기
class_list = set()
for image_file in image_files:
  file_name = os.path.splitext(image)[0]
  class_name = re.sub('_\d+', '', filename)
  class_list.add(class_name)
class_list = list(class_list)
class_list.sort()

# 리스트 딕셔러니로 만들기 : class -> index로 반환하는 것
class2dix = {cls:idx for idx, cls in enumerate(class_list)}
```

# train/validation 데이터셋 만들기
- TFRecord 만들기
```python
IMG_SIZE = 224
N_BBOX = len(bbox_files)
N_TRAIN = 3000
N_VAL = N_BBOX - N_TRAIN

# TFRecord 저장할 directory 생성
tfr_dir = os.path.join(base_dir, 'tfrecord')
os.makedirs(tfr_dir, exist_ok=True)

tfr_train_dir = os.path.join(tfr_dir, 'oxford_train.tfr')
tfr_test_dir = os.path.join(tfr_dir, 'oxford_val.tfr')

# TFRecord writer 생성
writer_train = tf.io.TFRecordWriter(tfr_train_dir)
writer_val = tf.io.TFRecordWriter(tfr_val_dir)

# the following functions can be used to convert a value to a type compatible with tf.Example.

def _bytest_feature(value):
  """Returns a bytes_list from a string/byte."""
  if isinstance(value, type(tf.constant(0))):
    value = value.numpy() # BytesList won't unpack a string from an EagerTensor.
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

```























