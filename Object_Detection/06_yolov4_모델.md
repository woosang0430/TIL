## 전작업
- colab GPU 설정
- 구글 드라이브 연동

```python
from google.colab import drive
drive.mount('/content/drive')

# root 디렉토리로 이동
%cd /content/drive/MyDrive/object_detection/yolov4_object_detection_workspace
## >>> /content/drive/MyDrive/object_detection/yolov4_object_detection_workspace
```

## Yolo V4 설치
### Github에서 clone
- `git clone https://github.com/AlexeyAB/darknet`
- yolo 공식 홈페이지 : https://pjreddie.com/darknet/yolo/
- yolo 공식 github : https://github.com/pjreddie/darknet
  - yolo 공식 github에서는 Linux 운영체제만 지원
- AlexeyAB
  - https://github.com/AlexeyAB/darknet
  - yolo 오리지널을 fork 해서 리눅스와 윈도우를 모두 지원하도록 구현
  - [Windows 설치](https://github.com/AlexeyAB/darknet#how-to-compile-on-windows-using-cmake)
```python
# clone
!git clone https://github.com/AlexeyAB/darknet.git
```
## make를 위해 구동환경 옵션 변경
- 다운받은 모델의 설치를 위해 make를 위한 구동환경 옵션을 변경
  - Makefile 파일의 내용을 변경
  - **make** : 리눅스상에서 C 컴파일을 쉽게 해주는 프로그램
  - **makefile** : make가 컴파일 하는 과정을 정의한 설정파일
- Makefile 설정 변경
- /content/drive/MyDrive/object_detection/yolov4_object_detection_workspace/darknet/Makefile

## make를 이용해 Yolo V4 설치
```python
GPU = 0
CUDNN = 0
CUDNN_HALF = 0
OPENCV = 0
```
- 위 네 개의 설정을 1로 변경

```python
# 컴파일 (darknet directory에서)
%cd darknet
## >>> /content/drive/My Drive/object_detection/yolov4_object_detection_workspace/darknet

!make
```
## Pretrained Yolo V4 Weights 다운로드
- YOLO v4는 [coco dataset](https://cocodataset.org/#home)의 80 class를 학습한 pretrained weight 제공.
  - `!wget -P workspace/pretrained_weight https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights`
  - url의 파일을 다운로드 받는 리눅스 명령어
    - wget -P <다운 받을 경로> url

## Yolo V4 Object Detection 실행
- teminal 환경에서 **darknet 명령어**를 이용해 실행

## darknet 명령어 옵션
- darknet 디렉토리 안에서
- `darknet detector test <path to .data file> <path to config> <path to weights> <path to image> <flags>`
  - \<path to .data file>
    - `.data 파일경로` : .data파일은 train/test dataset 파일경로목록, .names 파일(클래스들 설정)등의 경로를 지정한 파일
  - \<path to config>
    - `.config` 파일경로 : 모델구조, Train/Test 관련 설정파일
  - \<path to weights>
    - 데이터를 학습시킨 weight 파일의 경로
  - \<path to image>
    - 추론(Detection)할 image 파일 경로
  - \<flag>
    - 실행 옵션
  - detect가 끝나면 결과를 'predictions.jpg'로 저장

## image detection
```python
# 현재 경로 확인
%pwd
## >>> /content/drive/MyDrive/object_detection/yolov4_object_detection_workspace

# darknet으로 들어가기
%cd darknet

# darknet으로 들어가는것이 안될때(권한이 있어야됨)
!chmod 755 ./darknet
```
# 권한 관련
- 권한 확인 리눅스 명령어
  - `!ls -al darknet`
- 권한 관련된 것이 앞 부분에 나옴 
  - 처음 `-` => vkdlf, `d` => directory
  - 3개 소유권자 rw- => (읽기, 쓰기, 실행 권한 없음)
    - `-rw------- 1 root root 6558744 May 18 05:52 darknet`
  - 3개 소유권자 rwx => (읽기, 쓰기, 실행 권한 허용)
    - `-rwx------ 1 root root 6558744 May 18 05:52 darknet`

### 이미지 detection
```python
!./darknet detector test cfg/coco.data cfg/yolov4.cfg ../workspace/pretrained_weight/yolov4.weights  data/person.jpg
```
### 동영상 detection
```python
!./darknet detector demo cfg/coco.data cfg/yolov4.cfg  ../workspace/pretrained_weight/yolov4.weights   ../street.mp4   -dont_show -out_filename  ../street_result.avi
```
### detection 실행 옵션
#### Threshold Flag
- `thresh`
  - detection 결과의 confidence score의 threshold 설정
  - ex) -thresh 0.7 : 0.7이상의 confidence score인 것만 detection 결과로 나온다.
```python
!./darknet detector test cfg/coco.data cfg/yolov4.cfg ../workspace/pretrained_weight/yolov4.weights ../hiway.jpg -thresh 0.9
```
### 출력결과에 Bounding Box 좌표(coordinate) 출력
- `-ext_output`
```python
!./darknet detector test cfg/coco.data cfg/yolov4.cfg ../workspace/pretrained_weight/yolov4.weights ../hiway.jpg -thresh 0.7 -ext_output
```
### 추론 결과 이미지가 안나오도록 설정
- `-dont_show`
- colab에서는 이미지/영상 출력이 안되기 때문에 이 flag를 명시해준다.
```python
!./darknet detector test cfg/coco.data cfg/yolov4.cfg  ../workspace/pretrained_weight/yolov4.weights ../hiway.jpg -dont_show
```
### 결과 파일 저장
- `-out 파일명`
  - 파일명의 확장자를 `.json`으로 지정하면 json format으로 저장
```python
!./darknet detector test cfg/coco.data cfg/yolov4.cfg ../workspace/pretrained_weight/yolov4.weights ../hiway.jpg -out result.json -dont_show
```
### 한번에 여러 이미지 Detection
- text파일에 Detection할 이미지 경로 목록을 작성
  - 한줄에 한 파일씩 경로를 작성한다. (절대 경로로 작선하자)
  - darknet 명령문 뒤에 `< 파일경로`를 추가
```python
# detect할 이미지들의 경로를 text파일로 묶어 준비
file_list = [
  '/content/drive/MyDrive/object_detection/yolov4_object_detection_workspace/darknet/data/dog.jpg\n',
  '/content/drive/MyDrive/object_detection/yolov4_object_detection_workspace/darknet/data/eagle.jpg\n',
  '/content/drive/MyDrive/object_detection/yolov4_object_detection_workspace/darknet/data/person.jpg\n',
]

with open('data/image_list.txt', 'wt') as f:
  f.writelines(file_list)
  
## 명령
!./darknet detector test cfg/coco.data cfg/yolov4.cfg ../workspace/pretrained_weight/yolov4.weights -dont_show -ext_output -out result2.json < data/image_list.txt`
```

# Custom Dataset 학습
## 1. 준비
1. Custom Dataset준비
  - Image dataset과 Labeling한 annotation 파일 준비
2. .data, .names 파일 준비
3. train.txt와 validation.txt(test.txt) 파일 준비
4. .cfg(config)파일 준비
5. convolution layer를  위한 pretrained 모델 다운로드

## 2. 학습할 Custom dataset 이미지 준비와 Labeling
1. open image dataset(ms coco, pascal voc, open images dataset)을 이용해 image와 annotation 수집
  - open dataset의 경우 image와 annotation파일을 제공하므로 Labelling 작업이 용이
  - 그러나 Open dataset들마다 annotation 방식이 다르기 때문에 yolo annotation 방식에 맞게 변환하는 작업이 필요
2. 크롤링등을 이용해 직접 수집 후 labeling 작업
  - Labeling Tool을 이용해 수집한 이미지에 bounding box 작업
### Yolo Label 형식
- 이미지 데이터파일 별로 하나씩 작성하여 `.txt`로 저장한다.
- 한줄에 하나의 object에 대한 bounding box 정도 작성
- 형식
  - `<label> <bbox center x좌표> <bbox center y좌표> <bbox width> <bbox height>`
  - `0, 0.3310, 0.34562, 0.563254, 0.74562`
  - 공백을 구분자로 사용
  - 좌표(offset)들은 width, height에 대한 비율로 작성

```python
# 현재 경로 확인
%pwd
## >>> /content/drive/My Drive/object_detection/yolov4_object_detection_workspace/darknet

# 압축 풀기
!unzip -q ../lion_tiger.zip -d ../workspace/images/
```
## Train을 위한 설정파일 작성
### dataset 경로 목록 파일
- 학습/검증/평가할 때 사용할 이미지들의 경로를 작성한 파일을 작성
  - train/validation/test 데이터셋 별로 작성
    - ex) train.txt 파일에는 train dataset의 모든 이미지의 경로를 작성
  - 한줄에 한 개의 파일씩 경로를 작성
  - 경로는 절대경로, 상대경로 관계 X, 상대경로의 경우 학습을 실행한 디렉토리 기준으로 지정

```python
# --dictionary : dataset이 있는 디렉토리 경로
# --output : 생성할 파일 목록 파일의 경로(디렉토리/파일명)
!python ../scripts/make_file_list.py --directory ../workspace/images/train/ --output ../workspace/config/train_list.txt
!python ../scripts/make_file_list.py --directory ../workspace/images/test/ --output ../workspace/config/test_list.txt
!python ../scrips/make_file_list.py --directory ../workspace/images/val/ --output ../workspace/config/val_list.txt
```
## \<파일명> .names 파일 작성
- .name 파일
  - ex) obj.names
  - detection할 물체(object)들의 class들을 작성한 파일
  - class 이름을 한 줄에 하나씩 작성
```
lion
tiger
```
## 경로 저장한 변수 선언
```python
import os
BASE_PATH = 'workspace'

CONFIG_PATH = os.path.join(BASE_PATH, 'config')
NAMES_FILE_PATH = os.path.join(CONFIG_PATH, 'obj.names')
DATA_FILE_PATH = os.path.join(CONFIG_PATH, 'obj.data')
MODEL_CONFIG_FILE_PATH = os.path.join(CONFIG_PATH, 'yolov4.cfg')

TRAIN_LIST_FILE_PATH = os.path.join(CONFIG_PATH, 'train_list.txt')
VAL_LIST_FILE_PATH = os.path.join(CONFIG_PATH, 'val_list.txt')
TEST_LIST_FILE_PATH = os.path.join(CONFIG_PATH, 'test_list.txt')

WEIGHT_BACKUP_PATH = os.path.join(BASE_PATH, 'weight_backup') # 학습 결과 weight를 저장(backup)할 디렉토리 
PRETRAINED_WEIGHT_PATH = os.path.join(BASE_PATH, 'pretrained_weight', 'yolov4.conv.137') # 전이 학습에서 사용할 pretrained 가중치 경로

# root 경로에서 작업 ㄱㄱ
%cd /content/drive/MyDrive/object_detection/yolov4_object_detection_workspace

label_list = ['lion\n', 'tiger'] # label 번호순서에 맞춰서 지정
with open(NAMES_FILE_PATH, 'wt') as fw:
  fw.writelines(label_list)
```
## \<파일명> .data 파일 작성
- .data 파일
  - 학습할 데이터셋과 관련된 설정을 하는 파일
  - ex) obj.data
```
classes = 2
train = data/train.txt
valid = data/validation.txt
names = data/obj.names
backup = backup/
```
  - classes : 검출할 물체의 개수
  - train : train dataset의 이미지들 경로 목록 파일
  - valid : validation dataset의 이미지들 경로 목록파일
  - names : .names파일 경로
  - backup : 학습 중간 결과 weight들을 저장할 디렉토리

```python
data_dict = {
  'classes' : 2,
  'train' : TRAIN_LIST_FILE_PATH,
  'valid' : VAL_LIST_FILE_PATH,
  'names' : NAMES_FILE_PATH,
  'backup' : WEIGHT_BACKUP_PATH,
}

with open(DATA_FILE_PATH, 'wt') as fw:
  for key, val in data_dict.items():
    fw.write('{0} = {1}\n`.format(key, val))
```
## .cfg(config) 파일 준비
- 학습에 사용할 모델관련 설정파일
- cfg/yolov4.cfg 파일을 복사한 뒤 다음 항목들 수정
  - batch
  - subdivisions
    - mini-batch의 darknet 용어
    - GPU 메모리가 부족할 경우 subdivisions의 값을 낮게 잡아준다.
  - max_batches(19줄)
    - 반복횟수 iteration으로 위에서 지정한 batch를 몇번 반복할지 지정
    - 추천 설정 : class수 * 2000(2000 ~ 4000) + 200
  - steps(21줄)
    - 추천설정 : (80% of max_batches), (90% of max_batches)
  - [yolo] 검색(3군데) -- 마지막 부터 올라가면서 찾자
    - [yolo] 바로위의 [convolutional] 설정의 filters를 (class수 + 5)*3 으로 변경
    - [yolo] 설정중 classes : 클래수 개수로 변경
```python
# darknet/cfg/yolov4.cfg -> workspace/config로 복사한 뒤 수정
!cp darknet/cfg/yolov4.cfg workspace/config/yolov4.cfg
```
## Convolution layer를 위한 pretrained 모델 다운로드
- 전체 모델중 yolo v4의 Convolution Layer를 위한 미리 학습된 (pretrained) 가중치(weight)를  다운받아 train때 사용한다.
- https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137
```python
!wget -P workspace/pretrained_weight https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137
```
## Custom Data 학습하기
- 명령어
```
!./darknet detector train <path to .data> <path to custom config> <path to weights> -dont_show -map
```
  - \<path to .data file> : `.data` 파일경로
  - \<path to custom config> : `.config` 파일경로
  - \<path to weights> : pretrained weight 파일경로
  - `-dont_show`
    - 학습 진행 chart를 pop으로 보여주는데 colab에서는 이 chart를 볼 수 없어 보여주지 말라는 명령어
  - `-map`
    - Mean Average Precision을 평가 지표로 사용. mAP로 평가결과가 진행 chart에 출력된다.
  - 학습 100번의 iteration 마다 `.data`에 설정한 backup 경로에 yolov4_last.weight 파일로 학습된 weights를 저장한다.
    - 혹시 중간에 문제가 생겨 학습이 멈추면 이 가중치를 이용해 학습을 이어나가면 된다.
  - 학습이 완료되면 .data 설정파일에 지정한 backup 디렉토리에 yolov4_best.weights, yolov4_last.weights, yolov4_final.weights, yolov4_1000.weights, yolov4_2000.weights, ... 파일이 생성

```python
# 현재 경로 확인
%pwd
## >>> /content/drive/My Drive/object_detection/yolov4_object_detection_workspace

# 권한 설정
!chmod 755 ./darknet/darknet

# 경로 확인
print(DATA_FILE_PATH)
print(MODEL_CONFIG_FILE_PATH)
print(PRETRAINED_WEIGHT_PATH)
## >>> workspace/config/obj.data
## >>> workspace/config/yolov4.cfg
## >>> workspace/pretrained_weight/yolov4.conv.137

f'!./darknet/darknet detector train {DATA_FILE_PATH} {MODEL_CONFIG_FILE_PATH} {PRETRAINED_WEIGHT_PATH} -dont_show -map'
## >>> !./darknet/darknet detector train workspace/config/obj.data workspace/config/yolov4.cfg workspace/pretrained_weight/yolov4.conv.137 -dont_show -map

# 학습
!./darknet/darknet detector train workspace/config/obj.data workspace/config/yolov4.cfg workspace/pretrained_weight/yolov4.conv.137 -dont_show -map

# 추론
!./darknet/darknet detector test  workspace/config/obj.data workspace/config/yolov4.cfg workspace/weight_backup/yolov4_best.weights tiger.jpg -dont_show
```
