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
