# ImageDataGenerator
- 데이터 전체가 순환되어 배치 생성을 끝없이 함
  - https://www.tensorflow.org/api_docs/python/tf/keras/preprocessing/image/ImageDataGenerator

## ImageDataGenerator()
- 매개변수 : 이미지 증식(augmentation) 관련 설정을 정의
  - **fill_mode** : 이미지 변환 후 남은 공백을 어떻게 채울 것인지 설정
    > - `nearest`(default) : 빈공간에 가장 가까운 pixel로 채우기
    > - `reflect` : 빈공간 근처 공간의 값을 거울로 반사되는 값으로 채우기
    > - `constant`*(많이씀)* : 지정한 값(`cval=`)으로 채움 default는  0
  
  - Normalization 설정
    > - `rescale`*(많이씀)* : 지정한 값을 각 픽셀에 곱한다.(rescale=1./255.)
    > - `featurewise_center=True` : channel의 평균을 pixel에서 빼서 평균 0으로 표준화(channel 별로 처리)
    > - `featurewise_std_normalization=True` : channel 별로 표준화한다. (평균 0, 표준편차 1)
  - 반전
    > - `horizontal_flip=True` : 좌우 반전, `vertical_flip=True` : 상하 반전
  - 회전
    > - `rotation_range_range=정수` : -정수 ~ 정수 범위로 랜덤 회전(지정한 정수의 음.양수 값사이에서 랜덤으로)
  - 이동
    > - `width_shift_ragne=실수` : 좌우이동, `height_shift_range=실수` : 상하 이동
    > - 실수값 : 이동범위지정. 0 ~ 1 이면 이미지 너비, 높이 기준 비율. 1이상이면 pixel
  - Zoom
    > - `zoom_range` : 실수 또는 [lower, upper]
        - 실수 : [1-실수값, 1+실수값]
        - 1미만이면 확대, 1초과면  축소
  - shear(전단변환) : 평행사변형 형태로 변환
    > - `shear_range` : 실수 - 각도 지정
  - 명암(brightness)
    > - `brightness_range` : 실수값 2개를 가지는 튜플이나 리스트. 명암 범위
    > - 1이 원본, 0에 가까우면 어둡도 1보다 크면 밝아진다.
- flow 메소드들
  - ImageDataGenerator에 Image Data를 batch 단위로 공급하는 Iterator 생성

# ImageDataGenerator에 dataset을 제공하는 메소드
## flow_from_directory()
- 학습시 파일 경로에 저장된 디렉토리로 부터 이미지를 읽어와 변형 처리 후 모델(네트워크)에 제공하는 iterator 생성
- 주요 매개변수
  - `directory` : 이미지 저장 경로 (이미지는 지정한 디렉토리내에 클래스 별로 디렉토리가 나눠져 저장되어 있야한다.)
  - ![image](https://user-images.githubusercontent.com/77317312/116054834-11099a00-a6b7-11eb-83c4-e3216d5d6764.png)
  - 이런 형식으로 디렉토리를 생성해야한다.
  - `target_size` : 이미지 크기. 지정한 크기로 resize한다. 기본값 : (256,256)
  - `color_mode` : 'grayscale', 'rgb'(default), 'rgba' 중에 하나를 지정
  - `class_mode` : 분류 종류 지정
    > - 'binary'
    > - 'category' : label이 onehotencoding인 경우
    > - 'sparse' : label이 label encoding인 경우
    > - 'None'(default) : 하위디렉토리로 추론
  - `batch_size` : 미니배치 사이즈 지정(default : 32)
- 반환값
  - `DirectoryIteratot` : batch size만큼 image와 label을 제공하는 Generator
- 지정한 directory의 구조
- ![image](https://user-images.githubusercontent.com/77317312/116055517-c0467100-a6b7-11eb-8404-6fd07e38b557.png)
- 디렉토리 별 class 지정
- class 조회 : `DirectoryIterator객체.class_indices.keys()`

## flow_from_dataframe()
- 읽어올 파일의 경로와 label을 DataFrame으로 생성한 뒤 그것을 이용해 파일을 loading한다.
- dataframe
  - `DataFrame` : image 데이터의 절대경로와 label을 저장한 DataFrame 객체
  - `x_col` : image경로 컬럼명
  - `y_col` : label 컬럼명
  - `target_size` : 이미지 크기. 지정한 크기로 resize한다. 기본값 : (256,256)
  - `color_mode` : 'grayscale', 'rgb'(default), 'rgba' 중에 하나를 지정
  - `class_mode` : 분류 종류 지정
    > - 'binary'
    > - 'category' : label이 onehotencoding인 경우
    > - 'sparse' : label이 label encoding인 경우
    > - 'None'(default) : 하위디렉토리로 추론
  - `batch_size` : 미니배치 사이즈 지정(default : 32)

## flow()
- ndarray 타입의 이미지를 받아 처리
- 주요 매개변수
  - x : input data. 4차원 배열(크기, height, width, channel)
  - y : labels
  - batch_size : 미니 배치 크기(default : 32)

## 모델(네트워크)에서 fit() 호출하기 전까지는 preprocessing과 data loading이 실행되지 않는다.
## 흐름
- ![image](https://user-images.githubusercontent.com/77317312/116056587-e91b3600-a6b8-11eb-9188-4b11fcca3718.png)
