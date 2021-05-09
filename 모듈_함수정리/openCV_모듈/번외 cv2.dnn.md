# OpenCV DNN 모듈로 딥러닝 실행하기

## OpenCV DNN(Deep neural Network)모듈
- 미리 학습된 딥러닝 파일을 OpenCV DNN 모듈로 실행할 수 있음
- 순전파, 추론만 가능하며 **학습은 지원하지 않는다.**

## 1. 네트워크 불러오기 - `cv2.dnn.readNet`
- OpenCV로 딥러닝을 실행하기 위해서는 우선 **cv2.dnn_Net 클래스 객체를 생성**
- 객체 생성에는 **훈련된 가중치와 네트워크 구성을 저장하고 있는 파일** 필요
- `cv2.dnn.readNet(model, config=None, framework=None)` => retval
> - `model` : 훈련된 가중치를 저장하고 있는 이진 파일 이름
> - `config` : 네트워크 구성을 저장하고 있는 텍스트 파일 이름, config가 없는 경우도 많다
> - `framework` : 명시적인 딥러닝 프레임워크 이름
> - `reval` : cv2.dnn_Net 클래스 객체

| 딥러닝 프레임워크 | model 파일 확장가 | config 파일 확장자 | framework 문자열 |
| -- | -- | -- | -- |
| 카페 | .caffemodel | .prototxt | 'caffe' |
| 텐서플로우 | .pd | .pdtxt | 'tensorflow' |
| 토치 | .t7 or .net |    | 'torch' |
| 다크넷 | .weights | .cfg | 'darknet' |
| DLDT | .bin | .xml | 'dldt' |
| ONNX | .onnx |    | 'onnx' |


## 2. 네트워크 입력 블롭(blob) 만들기 - `cv2.dnn.blobFromImage`
- 입력 영상을 블롭(blob)객체로 만들어 추론을 진행해야함
- **주의할 점!!** 인자들을 입력할 때 **모델 파일이 어떻게 학습되었는지 파악하고 그에 맞게 입력**을 해줘야 함
- 여러 개의 영상을 추론할 때는 `cv2.dnn.blobFromImages`함수로 여러 개의 블롭 객체를 받아서 사용합니다. 뒤에 **S** 붙음
- `cv2.dnn.blobFromImage(image, scalefactor=None, size=None, mean=None, swapRB=None, crop=None, ddepth=None)` => retval
> - `image` : 입력영상
> - `scalefactor` : 입력 영상 픽셀 값에 곱할 값, default : 1
>   - 딥러닝 학습을 진행핼 때 입력 영상을 0~255 픽셀값을 이용했는지, 0~1로 정규화해서 이용했는지에 맞게 지정해줘여한다. 정규화하여 학습을 진행한 경우 1/255를 입력해줘야 한다.
> - `size` : 출력 영상의 크기. default : (0, 0)
>   - 학습할 떄 사용한 영상의 크기를 입력, 그 size로 resize 해주어 출력한다.
> - `mean` : 입력 영상 각 채널에서 뺄 평균 값. default : (0, 0, 0)
>   - 학습할 때 mean값을 빼 계산한 경우 그와 동일한 mean값을 지정
> - `swapRB` : R과 B 채널을 서로 바꿀 것인지를 결정하는 플래그. default : False
> - `crop` : 크롭(crop) 수행 여부. default : False
>   - 학습할 때 영상을 잘라서 학습하였으면 그와 동일하게 입력해야 한다.
> - `ddepth` : 출력 블롭의 깊이. CV_32F 또는 CV_8U. default : CV_32F
>   - 대부분 CV_32F를 사용
> - `retval` : 영상으로부터 구한 블롭 객체. numpy.ndarray. shape=(N, C, H, W). dtype=numpy.float32
>   - 반환값 shape의 N : 갯수, C : 채널 갯수, H,W : 영상 크기


## 3. 네트워크 입력 설정 - `cv2.dnn_Net.setInput`
- readNet으로 만든 객체에 .setInput 함수로 적용할 수 있다.
- name은 입력 에이어 이름을 지정할 수 있지만 보통 스킵
- scalefactor, mean은 블롭을 생설할 때 지정해주었이므로 default값 이용
- `cv2.dnn_setInput(blob, name=None, scalefactor=None, mean=None)` => None
>  - `blob` : 블롭(blob) 객체
>  - `name` : 입력 레이어 이름 
>  - `scalefactor` : 추가적으로 픽셀 값에 곱할 값
>  - `mean` : 추가적으러 픽셀 값에서 뺄 평균 값


## 4. 네트워크 순방향 실행(추론) - `cv2.dnn_Net.forward`
- 추론을 진행할 때 이용하는 함수
- 네트워크를 어떻게 생성했냐에 따라 출력을 여러 개 지정할 수 있다.(outputNames)
- `cv2.dnn_Net.forward(outputName=None)` -> retval
- `cv2.dnn_Net.forward(outputNames=None, outputBlobs=None)` => outputBlobs
> - `outputName` : 출력 레이어 이름
> - `retval` : 지정한 레이어의 출력 블롭. 네트워크마다 다르게 결정됨
> - `outputNames` : 출력 레이어 이름 리스트
> - `outputBlobs` : 지정한 레이어의 출력 블롭 리스트


## 5. 적용
- 손글씨 데이터
```python
import cv2
import numpy as np
import sys

oldx, oldy = -1, -1

# 그림을 그리기 위한 함수
def on_mouse(event, x, y, flags, _):
  global oldx, oldy
  
  if event == cv2.EVENT_LBUTTONDOWN:
    oldx, oldy = x, y
    
  elif event == cv2.EVENT_LBUTTONUP:
    oldx, oldy = -1, -1
  
  elif event == cv2.EVENT_MOUSEMOVE:
    if flags & cv2.EVENT_FLAG_LBUTTON:
      cv2.line(img, (oldx, oldy), (x, y), (255, 255, 255), 40, cv2.LINE_AA)
      oldx, oldy = x, y
      cv2.imshow('img', img)

# 영상의 위치 정규화
def norm_digit(img):
  # 무게 중심 좌표 추출
  m = cv2.moments(img)
  cx = m['m10'] / m['m00']
  cy = m['m01'] / m['m00']
  h, w = img.shape[:2]
  
  # affine 행렬 생성
  aff = np.array([[1, 0, w/2 - cx],
                  [0, 1, h/2 - cy], dtype=np.float32)
  
  # wapAffine을 이용해 기하학 변환
  dst = cv2.warpAffine(img, aff, (0,0))
  return dst
  
# 네트워크 불러오기
net = cv2.dnn.readNet('mnist_cnn.pd')

if net.empty():
  print('Network load failed')
  sys.exit()
  
# 그림을 그리기 위한 검은 영상 생성
img = np.zeros((400, 400), np.uint8)

cv2.imshow('img', img)
# 마우스 콜백 함수
cv2.setMouseCallback('img', on_mouse)

while True:
  c = cv2.waitKey()

  if c == 27:
    break
  elif c == ord(' '): # 스페이스바 입력
    # 그림을 그린 영상으로 blob객체 생성
    blob = cv2.dnn.blobFromImage(norm_digit(img), 1/255., (28., 28.))
    net.setInput(blob)
    prob = net.forward() # 확률값 출력, 확률의 최댓값이 인식한 클래스 의미
    
    # 최댓값과 최댓값의 클래스 검출
    _, maxVal, _, maxLoc = cv2.minMaxLoc(prob)
    digit = maxLoc[0] # [0]은 클래스, [1]은 확률
    
    print(f'{digit} (maxVal * 100:4.2f}%)')
    
    img.fill(0) # 0으로 채우기
    cv2.imshow('img', img)
    
cv2.destroyAllWindows()
```
참고[https://deep-learning-study.tistory.com/299]
