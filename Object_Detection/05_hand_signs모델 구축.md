# Tensorflow Object Detection API
- Tensorflow Object Detection API는 TensorFlow를 이용해 Object Detection 모델을 train하고 deploy하는 것을 쉽게 도와주는 오픈 소스 프레임워크
- https://github.com/tensorflow/models/tree/master/research/object_detection
- Tutorial: https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/

# Custom(image) data 구하기고 labeling하기
- 참고하기
- https://github.com/yws1502/TIL/tree/main/%EB%8D%B0%EC%9D%B4%ED%84%B0%20%EC%88%98%EC%A7%91

## colab에서 진행
- google drive연결
```python
from google.colab import drive
drive.mount('/content/drive')
```

## 전단계
- 구글 드라이브 연결
- 상대경로로 할 것이므로 Process.ipynb있는 디렉토리로 이동
- workspace/images에 이미지 데이터셋 넣고 압축 풀기
```python
%cd /content/drive/MyDrive/object_detection/object_detection_workspace
## >>> /content/drive/MyDrive/object_detection/object_detection_workspace
%pwd
## >>> /content/drive/My Drive/object_detection/object_detection_workspace

# 이미지, annotation를 workspace/images directory로 이동
# 1. 압축풀기
!unzip hand_number_sign.zip -d /content/drive/MyDrive/object_detection/object_detection_workspace/work_space/images
```

# Tensorflow Object Detection 2 API 설치
1. clone
  - `!git clone https://github.com/tensorflow/models.git`
2. PYTHONPATH 환결설정에 models/research 추가
3. 필요 모듈 설치
  - `!apt-get install -qq protobuf-compiler python-pil python-lxml python-tk`
  - `!pip install -qq Cython contextlib2 pillow lxml matplotlib pycocotools`
4. proto 파일 컴파일
  - models/research 경로로 이동
    - `%cd models/research`
  - `!protoc object_detection/packages/tf2/setup.py .`
5. setup.py를 이용해 필요한 모듈 추가 설치
  - setup.py를 현재 디렉토리로 copy
    - `!cp object_detection/packages/tf2/setup.py .`
  - 설치
    - `!python -m pip install .`
  - 설치 확인 - 아래 스크립트 실행시 오류 없이 실행되면 설치 잘 된 것임
    - `!python object_detection/builders/model_builder_tf2_test.py`
6. 원래 디렉토리로 이동
  - `%cd ../..`

```python
%pwd
## >>> /content/drive/MyDrive/object_detection/object_detection_workspace

# 1. tensorflow object detection api clone하기
!git clone https://github.com/tensorflow/models.git

# 2. PYTHONPATH 환경설정. 프로그램상에서 -> models/research 경로
# 로컬이면 환경변수로 잡자
import os
os.environ['PYTHONPATH'] += ':/content/drive/MyDrive/object_detection/object_detection_workspace/models/research'

# 3. 필요한 모듈/프로그램 설치
# 우분투 명령어(!apt-get install ...)
!apt-get install -qq protobuf-compiler python-pil python-lxml python-tk

!pip install -qq Cython contextlib2 pillow lxml matplotlib pycocotools
```
## 경로 설정
```python
# 4. proto 파일들 컴파일
# research 디렉토리로 이동
%cd models/research
## >>> /content/drive/My Drive/object_detection/object_detection_workspace/models/research
!protoc object_detections/protos/*.proto --python_out=.

# 5. setip.py 실행해서 TFOD API 설치
!cp object_detection/packages/tf2/setup.py .

!python -m pip install .

# 설치가 잘되었는지 확인
!python object_detection/builders/model_builder_tf2_test.py

# 경로 확인 후 base 디렉토리로 이동
%pwd
## >>> /content/drive/My Drive/object_detection/object_detection_workspace
```
## 경로 설정
```python
import os

BASE_PATH = 'workspace' # 작업시 생기는 파일들을 저장할 root 디렉토리.
SCRIPT_PATH = 'scripts' # utility python script들이 저장된 디렉토리.
TF_OD_API_PATH = 'models' # Tensorflow object detection api 설치 경로

IMAGE_PATH = os.path.join(BASE_PATH, 'images') # image data들, annotation파일들이 저장된 디렉토리

LABEL_MAP_PATH = os.path.join(BASE_PATH, 'labelmap') # Label map파일이 저장된  디렉토리
LABEL_MAP_FILE_PATH = os.path.join(LABEL_MAP_PATH, 'label+map.pbtxt') # LABEL map 파일 경로

TF_RECORD_PATH = os.path.join(BASE_PATH, 'tfrecord') # TFRecord파일들을 저장할 경로

MODEL_PATH = os.path.join(BASE_PATH, 'model') # pretrained 모델을 fine tuning한 모델. weight(ckpt), pipeline.config(설정파일)을 저장할 경로
CHECKPOINT_PATH = os.path.join(MODEL_PATH, 'checkpoint') # 학습도중 중간중간 저장되는 weight
EXPORT_MODEL_PATH = os.path.join(MODEL_PATH, 'expoert_model') # file tuning한 최종 모델을 저장할 경로
PIPELINE_CONFIG_PATH = os.path.join(MODEL_PATH, 'pipeline.config') # pipeline.config(설정파일)의 경로

PRE_TRAINED_MODEL_PATH = os.path.join(BASE_PATH, 'pre_trained_model') # 전이 학습 시킬 model을 저장할 경로
```
## Custom data 학습 시키기
### 다음 세가지 작업이 필요
1. Label Map 파일 생성
  - 분류 하고자 하는 object의 class와 그 class id를 pbtxt text 파일로 작성
  - `models\research\object_detection\data`
```python
item {
  id : 1
  name : 'aeroplane'
}

item {
  id : 2
  name : 'bicycle'
}
...
```
2. pipeline.config
  - Model을 학습, 검증하기 위해 필요한 설정을 하는 파일
  - `models\research\object_detection\samples\configs`
3. 학습/검증/테스트에 사용할 데이터셋을 TFRecord로 구성
  - 주요 데이터셋을 TFRecord로 생성하는 코드
  - `models\research\object_detecion\dataset_tools`

- **굵은 텍스트# 데이터셋 준비**
  - images에 있는  데이터들을 train/test 용으로 분리
```python
# make directory
train_dir = os.path.join(IMAGE_PATH, 'train') # train dataset 저장 경로
test_dir = os.path.join(IMAGE_PATH, 'test') # test dataset 저장 경로

os.makedirs(train_dir, exist_ok=True)
os.makedirs(test_dir, exist_ok=True)

# copy
file_list = os.listdir(IMAGE_PATH) # IMAGEPATH에 있는 파일/폴더명 조회
image_list = [fname for fname in file_list if os.path.splitext(fname)[-1]=='.jpg']
len(image_list)
## >>> 71

# shutil.copy(원본경로, 복사할 경로)
import shutil
import re

cnt = 0
current_label = None
train_len = 12
image_list.sort()

for image_name in image_list:
  ann_name = os.path.splitext(image_name)[0] + '.xml' # get annotation file name
  # label = re.sub('\-[a-z0-9]+', '', image_name)
  label = image_name.split('-')[0]
  if current_label != label:
    current_label = label
    cnt = 0
  # 복사작업
  image_path = os.path.join(IMAGE_PATH, image_name)
  ann_path = os.path.join(IMAGE_PATH, ann_name)
  train_path = os.path.join(IMAGE_PATH, 'train')
  test_path = os.path.join(IMAGE_PATH, 'test')
  # cnt가 train_len 보다 작으면 train 폴더에 copy 아니면 test폴더에 copy
  if cnt < train_len:
    shutil.copy(image_path, train_path) # image copy
    shutil.copy(ann_path, train_path) # annotation copy
  else:
    shutil.copy(image_path, test_path)
    shutil.copy(ann_path, test_path)
  cnt += 1
```
## Label Map 생성
  - text 에디터에서 직접 작성
  - File IO를 이용해 코드상에서 파일 작성
```python
labels = [
  {'name' : 'one', 'id':1},
  {'name' : 'two', 'id':2},
  {'name' : 'three', 'id':3},
  {'name' : 'four', 'id':4},
  {'name' : 'five', 'id':5},
]

with open(LABEL_MAP_FILE_PATH, 'wt') as fw:
  for label in labels:
    fw.write('item {\n')
    fw.write("\tname:'{0}'\n".format(label['name'])
    fw.write("\tid:{0}\n".format(label['id']))
    fw.write("}\n")
```
## TFRecord 생성
  - scripts/generate_tfrecord.py
    - command line argument
      - `-x(--xml_dir)` : annotation file이 있는 경로
      - `-l(--labels_path)` : Label map 파일의 경로(파일명 포함)
      - `-o(--output_path)` : 생성된 tfrecord파일을 저장할 디렉토리
      - `-i(--image_dir)` : 이미지데이터가 있는 디렉토리(annotation과 동일한 위치에 있으면 생략가능)

```python
# train set
f"!python ./{SCRIPT_PATH}/generate_tfrecord.py -x {os.path.join(IMAGE_PATH, 'train')} -l {LABEL_MAP_FILE_PATH} -o {os.path.join(TF_RECORD_PATH, 'train.tfr')}"
## >>> !python ./scripts/generate_tfrecord.py -x workspace/images/train -l workspace/labelmap/label_map.pbtxt -o workspace/tfrecord/train.tfr

# test set
f"!python ./{SCRIPT_PATH}/generate_tfrecord.py -x {os.path.join(IMAGE_PATH, 'test')} -l {LABEL_MAP_FILE_PATH} -o {os.path.join(TF_RECORD_PATH, 'test.tfr')}"
## >>> !python ./scripts/generate_tfrecord.py -x workspace/images/test -l workspace/labelmap/label_map.pbtxt -o workspace/tfrecord/test.tfr

!python ./scripts/generate_tfrecord.py -x workspace/images/train -l workspace/labelmap/label_map.pbtxt -o workspace/tfrecord/train.tfr

!python ./scripts/generate_tfrecord.py -x workspace/images/test -l workspace/labelmap/label_map.pbtxt -o workspace/tfrecord/test.tfr
```
## pretrained model download
- Tensorflow object detectio API는 MS COCO 2017 dataset으로 미리 학습시킨 다양한 Object Detection 모델을 제공한다.
- tf2 detection Model Zoo:
  - https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf2_detection_zoo.md
- SSD MobileNet V2 FPNLite 320x320 다운로드
  - 성능은 떨어지지만 학습속도가 빠르가.

```python
# !wget 리눅스 명령어(터미널에서 다운 받을 때 사용)
!wget http://download.tensorflow.org/models/object_detection/tf2/20200711/ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8.tar.gz

!tar -zxvf ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8.tar.gz -C workspace/pre_trained_model/
```
## Pipeline.config 설정 변경
### pipeline.config 파일  개요
- Model을 학습, 검증하기 위해 필요한 설정을 하는 파일
- 구조
  - https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/configuring_jobs.md
  - model
    - 사용하는 모델에 대한 설정
    - class 개수
    - 입력이미지 size
    - anchor 설정
  - train_config
    - Train(학습)관련 설정
    - batch_size
      - 사용하는 GPU의 메모리 크기에 맞게 조절한다.
    - image augmentation관련 설정 등
    - optimizer관련 설정
    - 학습에 사용할 weight 파일의 경로
    - fine_tune_checkpoint_type:'detection'
  - train_input_reader
    - labelmap 파일 경로
    - train tfrecord 파일 경로
  - eval_config
    - evaluation(평가)을 위해 사용하는 metric 설정
  - eval_input_reader
    - labelmap 파일 경로
    - evaluation tfrecord파일 경로
### Pretrain model의 pipeline.config 파일 copy
- pretrained 모델의 압축을 풀면 pipeline.config 파일이 있다.
- workspace\model 로 copy한다.
```python
f'!cp {os.path.join(PRE_TRAINED_MODEL_PATH, 'ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8', 'pipeline.config')} {PIPELINE_CONFIG_PATH}'
## >>> !cp workspace/pre_trained_model/ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8/pipeline.config workspace/model/pipeline.config

!cp workspace/pre_trained_model/ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8/pipeline.config workspace/model/pipeline.config
```
### pipeline.config 설정 변경
  - pipeline.config 내용 변경은 **파일을 직접 변경**할 수도 있고 **코드상에서 변경**할 수 있다.
- 필수 변경사항
  - class개수 변경
  - train 배치 사이즈 변경 - gpu 메모리 사양에 맞게 변경한다.
  - pretrained model 경로 설정
  - pretrained model이 어떤 종류의 모델인지 설정
  - train 관련 변경
    - labelmap 파일 경로 설정
    - train용 tfrecord 파일 경로 지정
  - evaluation 관련 변경
    - labelmap 파일 경로 설정
    - evaluation용 tfrecord 파일 경로 지정
```python
import tensorflow as tf
from object_detectoin.utils import config_util
from object_detection.protos import pipeline_pb2
from google.protobuf import text_format

# pipeline.config 파일 조회 및 출력 ___ 수정이앙은 상관 없음
config = config_util.get_configs_from_pipeline_file(PIPELINE_CONFIG_PATH) # pipeline.config파일 경로를 주면 딕셔너리로 읽어온다.
print(config)
"""
{'eval_config': metrics_set: "coco_detection_metrics"
 use_moving_averages: false,
 'eval_input_config': label_map_path: "PATH_TO_BE_CONFIGURED"
 shuffle: false
 num_epochs: 1
 tf_record_input_reader {
   input_path: "PATH_TO_BE_CONFIGURED"
 },
 'eval_input_configs': [label_map_path: "PATH_TO_BE_CONFIGURED"
 shuffle: false
 num_epochs: 1
 tf_record_input_reader {
   input_path: "PATH_TO_BE_CONFIGURED"
 }
 ],
 'model': ssd {
   num_classes: 90
   image_resizer {
     fixed_shape_resizer {
       height: 320
...
"""
# 특정 설정들 변경(수정)
# pipeline config 템플릿(설정 값이 없는 빈 템플릿) 생성
pipeline_config = pipeline_pb2.TrainEvalPipelineConfig()
pipeline_config  # 빈종이라 생각
## >>>

# 기존 pipeline.config의 설정을 읽어 template에 덮어쓴다.
with tf.io.gfile.GFile(PIPELINE_CONFIG_PATH, 'r') as fr:
  proto_str = fr.read()
  text_format.Merge(proto_str, pipeline_config) # 읽어온 str이 pipeline_config에 추가
  
# 항목별 수정
# class 개수 변경
pipeline_config.model.ssd.num_classes = 5

# batch_size 변경
pipeline_config.train_config.batch_size = 16

# pretrained model의 넣어줄 weight(가중치) 파일 경로 설정
pipeline_config.train_config.fine_tune_checkpoint = os.path.join(PRE_TRAINED_MODEL_PATH, 'ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8', 'checkpoint', 'ckpy-0')

# 어떤 작업을 위한 가중치인지 설정
pipeline_config.train_config.fine_tune_checkpoint_type = 'detection'

# train 입력 데이터 관련 설정
# labelmap파일 경로 설정
pipeline_config.train_input_reader.label_map_path = LABEL_MAP_FILE_PATH

# train용 tfrecord 파일 경로 => 리시트로 설정
pipeline_config.train_input_reader.tf_record_input_reader.input_path[:] = [os.path.join(TF_RECORD_PATH, 'train.tfr')]

# evaluation 설정
pipeline_config.eval_input_reader[0].label_map_path = LABEL_MAP_FILE_PATH
pipeline_config.eval_input_reader[0].tf_record_input_reader.input_path[:] = [os.path.join(TF_RECORD_PATH, 'test.tfr')]

# 변경사항을 파일에 저장
config_txt = text_format.MessageToString(pipeline_config) # pipeline_config의 설정들을 문자열(string)으로 변환

# 출력
with open(PIPELINE_CONFIG_PATH, 'w') as f:
  f.write(config_txt)
```
## Model 학습
- 다음 명령어를 실행한다.
- 시간이 오래 걸리므로 terminal에서 실행한다.
`python models/research/object_detection/model_main_tf2.py --model_dir=workspace/model/checkpoint --pipeline_config_path=workspace/model/pipeline.config --num_train_steps=3000`
### 옵션
- model_dir : 학습한 모델의 checkpoint 파일을 저장할 경로. (1000 step당 저장)
- pipeline_config_path : pipeline.config 파일 경로
- num_train_steps : 학습할 step 수
- `--model_dir=workspace/model/checkpoint`
  - 가중치 저장(1000 step마다 저장함)
- `--pipeline_config_path=workspace/model/pipelin.config`
  - 모델이 있는 경로
- `--num_train_steps=3000`
  - 학습할 step 수

```python
!python models/research/object_detection/model_main_tf2.py --model_dir=workspace/model/checkpoint --pipeline_config_path=workspace/model/pipeline.config --num_train_steps=20000
# 이후에 추가적으로 더 학습하고 싶으면 더 학습하고 싶은 만큼 num_train_steps를 정의해준 후 재실행
```
## 학습한 모델 추출(export)
- `models/research/object_detection/exporter_main_v2.py` 사용
- 옵션
  - `exporter_main_v2.py --helpshort || exporter_main_v2.py --helpfull`
  - input_type : input node type
    - image_tensor, encoded_image_string_tensor
  - train_checkpoint : 학습된 checkpoint 파일이 저장된 경로(folder/directory)
  - pipeline_config_path : pipeline.config 파일의 경로(파일명 포함)
  - output_directory : export된 모델을 저장할 경로
- 추출된 디렉토리 구조
``` 
output_dir
|-- checkpoint/
|-- saved_model/
|__ pipeline.config
```
  - checkpoint : custom data 학습한 checkpoint 파일들을 이 디렉토리로 복사
  - save_model : pipeline.config 설정에 맞춰 생성된 model
  - pipelin.config : pipeline.config 설정 파일
  - `!python models/research/object_detection/exporter_main_v2.py --input_type=image_tensor --trained_checkpoint_dir=workspace/model/checkpoint --pipeline_config_path=workspace/model/pipeline.config --output_directory=workspace/model.export_model`
```python
PIPELINE_CONFIG_PATH
## >>> workspace/model/pipeline.config

CHECKPOINT_PATH
## >>> workspace/model/checkpoint

# 현재 경로 확인
%pwd
## >>> /content/drive/My Drive/object_detection/object_detection_workspace

f'!python models/research/object_detecion/exporter_main_v2.py --input_type=image_tensor --trained_checkpoint_dir={CHECKPOINT_PATH} --pipeline_config_path={PIPELINE_CONFIG_PATH} --output_directory={EXPORT_MODEL_PATH}'
## >>> !python models/research/object_detection/exporter_main_v2.py --input_type=image_tensor --trained_checkpoint_dir=workspace/model/checkpoint --pipeline_config_path=workspace/model/pipeline.config --output_directory=workspace/model/export_model

!python models/research/object_detection/exporter_main_v2.py --input_type=image_tensor --trained_checkpoint_dir=workspace/model/checkpoint --pipeline_config_path=workspace/model/pipeline.config --output_directory=workspace/model/export_model
```
## Inference(추론)
### 사용 함수, 메소드
- `tf.convert_to_tensor(array_like, dtype)`
  - array_like를 Tensorflow Tensor 객체로 변환
  - `tf.convert_to_tensor([[1,2],[3,4]])`
- `detection_model.preprocess(image 4차원 ndarray)`
  - 전달받은 이미지를 model의 input shape에 맞게 resizing한다.
  - 반환값 : (resize된 image Tensor, 이미지의 shape)을 tuple로 반환
- `detection_model.predict(image tensor, image_shape tensor)`
  - 추론 / detection 메소드
  - 이미지와 image shape을 받아 detection한 결과를 딕셔너리로 반환
  - 반환 dictionary key
    - **preprocessed_inputs** : 입력 이미지 Tensor. preprocess()로 처리된 이미지
    - **feature_maps** : List, feature map들을 반환
    - **anchors** : 2D Tensor, normalize된 anchor box들의 좌표를 반환. 2-D float tensor: [num_anchors, 4]
    - **final_anchors** : 3D Tensor, batch당 anchors.(anchors에 batch가 포함된 것). [batch_siz, num_anchors, 4]
    - **box_encodings** : 3D float tensor. predict한 box들의 normalize된 좌표[batch_size, num_anchors, box_code_dimension]
    - **class_predictions_with_background** : 3D Tensor. 클래스 확률을 반환(logit). [batch_size, num_anchors, num_classes+1]
      - background 확률을 포함해서 num_classes+1개가 된다. (index 0 : background)
- `detection_model.postprocess(prediction_dict, shape)`
  - predict()가 예측한 결과에서 **Non_Maximum Suppression**을 실행해서 최종 Detection 결과를 반환한다.
    - predict()가 anchor별로 예측결과를 모아 주고 post-process는 최종 결과를 추출해서 반환
  - 반환 dictionary key
    - num_detections : Detect한 개수(bounding box 개수)
    - detection_boxes : [batch, max_detections, 4]. 후퍼리한 detection box
    - detection_scores : [batch, max_detections]. post-processed detection box들의 detection score들(detection score는 box안에 물체가 있을 확률값 - confidence score)
    - detection_classes : [batch, max_detections] tensor with classes for post-processed detection classes
    - raw_detection_boxes : [batch, total_detections, 4] Non-Maximum Suppression 하기 전의 감지된 box들
    - raw_detection_scores : [batch, total_detections, num_classes_with_background] raw detection box들의 class별 점수
    - detection_multiclass_scores : [batch, max_detections, num_classes_with_background] post-processed이후 남은 bounding box들의 class별 점수. LabelMap의 class에 background가 추가되어 계산된다.
    - detection_anchor_indices : [batch, max_detections] post-processed 이후 나온 anchor box의 index들

```python
import os
import cv2
import numpy as np
import matplotlib.pyplot as plt

import tensorflow as tf
from object_detection.utils import label_map_util, config_util
from object_detection.utils import visualization_utils as viz_utils
from object_detection.builders import model_builder

# 환경 변수가 잡혀 있는지 확인
os.environ['PYTHONPATH']
## >>> /env/python:/content/drive/MyDrive/object_detection/object_detection_workspace/models/research

# pipeline.config에 맞춰 추출한 모델을 바탕으로 모델 생성

# pipeline.config 조회
config = config_util.get_configs_from_pipeline_file(PIPELINE_CONFIG_PATH)

# pipeline.config의 모델 설정  정보를 넣어 모델 생성
detection_model = model_builder.build(model_config=config['model'], is_training=False)

# 모델에 학습시킨 checkpoint(weight)를 주입
ckpt = tf.compat.v2.train.Checkpoint(model=detection_model)
ckpt.restore(os.path.join(CHECKPOINT_PATH, 'ckpt-21')).expert_partical()
## >>> <tensorflow.python.training.tracking.util.CheckpointLoadStatus at 0x7fa9453e9d10>
```
### detection 실행 함수 정의
```python
# 선택 사항
# 순전파 처리 함수(추론하는 함수)에 @tf.function decorator를 선언하면 실행 속도가 빨라진다.
@tf.function
def detect_func(image):
  """
  [매개변수]
    object detection을 수행할 대상 image(tensor)를 받아 detection 처리
    1. preprocessinf(전처리) : resize,  normalization 작업
    2. detection(inference-추론)
    3. detection결과를 postprocessing : Non Maximum Suppression
    4. post processing한 결과 반환
  """
  # 1. preprocessing
  image, shapes = detection_model.preprocess(image)
  
  # 2. 추론
  predict_dict = detection_model.predict(image, shapes)
  
  # 3. post processing
  result = detection_model.postprocess(predict_dict, shapes_
  
  return result
  
LABEL_MAP_FILE_PATH
## >>> workspace/labelmap/label_map.pbtxt

category_index = label_map_util.create_category_index_from_labelmap(LABEL_MAP_FILE_PATH)
category_index
"""
{1: {'id': 1, 'name': 'one'},
 2: {'id': 2, 'name': 'two'},
 3: {'id': 3, 'name': 'three'},
 4: {'id': 4, 'name': 'four'},
 5: {'id': 5, 'name': 'five'}}
"""

# 추론할 이미지 읽기
file_name = 'one.jpg'
image_np = cv2.cvtColor(cv2.imread(file_name), cv2.COLOR_BGR2RGB)
type(image_np), image_np.dtype, image_np.shape
## >>> (numpy.ndarray, dtype('uint8'), (480, 640, 3))

# ndarray 이미지 -> Tensor 변환
input_tensor = tf.convert_to_tensor(image_np[np.newaxis, ...], dtype=tf.float32)
print(input_tensor.shape, input_tensor.dtype)
## >>> (1, 480, 640, 3) <dtype: 'float32'>

# 추론
post_detection = detect_func(input_tensor)

post_detection.keys()
## >>> dict_keys(['detection_boxes', 'detection_scores', 'detection_classes', 'num_detections', 'raw_detection_boxes', 'raw_detection_scores', 'detection_multiclass_scores', 'detection_anchor_indices'])

post_detection['num_detections']
## >>> <tf.Tensor: shape=(1,), dtype=float32, numpy=array([100.], dtype=float32)>

num_detections = int(post_detection.pop('num_detections')) # 빼내지 않으면 추후에 out of index error뜸

# 추론한 결과들을 num_detections 개수(detection한 물체의 개수)만큼의 값만 남긴다. 결과가 Tensor로 반환되는 것을 ndarray로 변환
detections = {key:value[0, :num_detections].numpy() for key value in post_detection.items()}

# 새로 구성한 결과 dictionary(detections)에 num_detections 값을 추가
detections['num_detections'] = num_detections

# detection_classes는 검출한 box의 class 값을 label encoding된 값으로 가진다. float32로 반환되는 것을 int로 변환 처리
detections['detection_classes'] = detections['detection_classes'].astype(np.int64)

detections['detection_scores'].shape
## >>> (100,)

MIN_CONF_THRESH = 0.5 # 물체가 있을 Confidence score가 0.5 이상인 bounding box만 나오도록한다.
image_np_with_detection = image_np.copy() # detection한 원본 이미지의 copy 생성
img = viz_utils.visualize_boxes_and_labels_on_image_array(
                image_np_with_detection, # 추론한 원본 이미지
                detections['detection_boxes'], # bounding box 좌표
                detections['detection_classes'] + 1,
                # bounding box내의 물체 index(class확률에서 0은 첫번째 label, label map의 id는 1부터 시작하기 때문에 +1 해준다.
                category_index,
                use_normalized_coordinates=True, # bounding box의 좌표들이 normalize되었는지 여부
                max_boxes_to_draw=100, # 최대 몇개 박스를 칠 것인지 (defaule : 20)
                min_score_thresh=MIN_CONF_THRESH, # Confidence score가 얼마 이상인 bounding box만 그린다.
```
