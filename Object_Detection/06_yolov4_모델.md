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
- `git clone https://github.com/AlexeyAB/darknet'
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
  - <path to .data file>
    - `.data` 파일경로 : .data파일은 train/test dataset 파일경로목록, .names 파일(클래스들 설정)등의 경로를 지정한 파일
  - <path to config>
    - `.config` 파일경로 : 모델구조, Train/Test 관련 설정파일
  - <path to weights>
    - 데이터를 학습시킨 weight 파일의 경로
  - <path to image>
    - 추론(Detection)할 image 파일 경로
  - <flag>
    - 실행 옵션
  - detect가 끝나면 결과를 'predictions.jpg'로 저장
  
## image detection
```python
  
```
