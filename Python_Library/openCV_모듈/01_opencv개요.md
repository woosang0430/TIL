# 교재용 파이썬 코드
- https://github.com/sunkyoo/opencv4cvml/tree/master/python


# Open CV 개요
- https://opencv.org/
- 튜토리얼 : https://docs.opencv.org/master/
- Open Source Computer Vision Library로 실시간 computer vision을 목적으로 개발

## OpenCV 설치
- `!pip install opencv-contrib-python`

## 이미지 읽기
- `cv2.imread(filename [, flag])` => ndarray로 반환
  - `filename` : 읽어들일 이미지 파일경로
  - `flag` : 읽기 모드
    - cv2.IMREAD_XXXX 상수를 이용
    - IMREAD_COLOR가 기본(BGR 모드)
      - matplotlib에서 출력시 rgb 모드로 변환해야함
  - `cv2.xxxx(소스이미지, ...)`
```python
import cv2
import numpy as np

# 이미지 읽기
lenna = cv2.imread('./images/lenna.bmp')

# 출력
cv2.imshow('lenna', lenna) # 'window이름', ndarray(이미지배열)
cv2.waitKey(0) # 키보드 입력을 기다린다. (0 : 입력될 때 까지 기다린다. 양수 : 밀리초)
cv2.destroyAllWindows() # 모든 창(window)를 종료
```
- 종료 조건 오타 나면 커널이 다운됨 오타 조심하자

## matplotlib으로 출력
- jupyter notebook내에 출력 가능
- opencv : 컬러 이미지 => **BGR**, matplotlib => **RGB**

## 색공간 변환
- `cv2.cvtColor(src, code)`
  - image의 color space를 변환
  - `src` : 변환시킬 이미지(ndarray)
  - `code`
    - 변환시킬 색공간 타입 지정
    - cv2.COLOR_XXX2YYY 형태의 상수 지정(XXX를 YYY로 변환)
      - `cv2.COLOR_BGR2GRAY` / `cv2.COLOR_GRAY2BGR` (BGR <-> GRAY)
      - `cv2.COLOR_BGR2RGB` / `cv2.COLOR_RGB2BGR` (BGR <-> RGB)
      - `cv2.COLOR_BGR2HSV` / `cv2.COLOR_HSV2BGR` (BGR <-> HSV)
      > - HSV -> Hue(색상, 색의 종류), Saturation(채도, 색의 선명도), Value(명도, 밝기) 
- ![image](https://user-images.githubusercontent.com/77317312/116856034-5b4dc680-ac35-11eb-9922-c486e10ab3a5.png)

```python
import matplotlib.pyplot as plt
lenna_rgb = cv2.cvtColor(lenna, cv2.COLOR_BGR2RGB)

plt.figure(figsize=(5, 5))
# plt.imshow(lenna[:, :, ::-1]) # BGR  => RGB
plt.imshow(lenna_rgb)
plt.axis('off')
plt.show()
```
- ![image](https://user-images.githubusercontent.com/77317312/116855605-a2878780-ac34-11eb-8ac7-ee0d30008aa7.png)
## 채널 확인
- 채널별로 나눠 이미지 출력
```python
# blue = lenna[:, :, 0]
# green = lenna[:, :, 1]
# red = lenna[:, :, 2]
blue, green, red = cv2.split(lenna) # 채널별 분리

blue.shape, green.shape, red.shape
## >>> ((512, 512), (512, 512), (512, 512))

plt.figure(figsize=(6,6))
plt.subplot(2, 2, 1)
plt.title('original', fontsize=20)
plt.imshow(lenna_rgb, cmap='gray')
plt.axis('off')

plt.subplot(2, 2, 2)
plt.title('blue', fontsize=20)
plt.imshow(blue, cmap='gray')
plt.axis('off')

plt.subplot(2, 2, 3)
plt.title('green', fontsize=20)
plt.imshow(green, cmap='gray')
plt.axis('off')

plt.subplot(2, 2, 4)
plt.title('red', fontsize=20)
plt.imshow(red, cmap='gray')
plt.axis('off')

plt.tight_layout()
plt.show()
```
![image](https://user-images.githubusercontent.com/77317312/116873363-85fa4800-ac52-11eb-9711-8c457f066c9c.png)

## cv2에서 이미지 출력
- `cv2.imshow(winname, mat)`
  - 창을 띄워 이미지 출력
  - `winname` : 창 이름
    - 창이름이 같으면 같은 창에 띄운다.
  - `mat` : 출력할 이미지(ndarray) ==> 타입이 uint8 이여야 정상 출력된다.
- `cv2.imwrite(filename, img)` -> bool반환
  - 이미지 파일로 저장
  - `filename` : 저장할 파일 경로
  - `img` : 저장할 이미지(ndarray)
```python
cv2.imshow('img', lenna)
print(cv2.waitKey(0)) # 반환 값이 키보드의 고유값

cv2.imshow('img2', lenna_rgb)
cv2.waitKey(0)

cv2.destroyAllWindows()
## >>> 키보드 입력 고유 번호
ord('q'), ord('a') # ord() -> 문자를 10진수 정수로 변환
## >>> (113, 97)
# ord는 아니지만 esc키는 27로 표현

# 특정 키를 클릭했을 때 종료
cv2.imshow('img', lenna)
while True:
  if cv2.waitKey(0) == ord('q'):
    break
cv2.destroyAllWindows()

# 파일로 저장
import os
if not os.path.isdir('output'):
  os.mkdir('output')
  
cv2.imwrite('./output/lenna_gray.jpg', lenna_gray) # 있는 디렉토리에 저장해야 한다.
# 저장 성공 : True 반환, 저장 실패 : False 반환
## >>> True
```
## 동영상 읽기
- VideoCapture 클래스 사용
  - 객체 생성
    - VideoCapture('동영상파일 경로') : 동영상 파일
    - VideoCapture(웹캠 ID) : 웹캠 (보통 0)
- VideoCapture의 주요 메소드
  - `isOpened()` : bool반환
    - 입력 대상과 연결되었는지 여부 반환
  - `read()` : (bool, img)반환
    - Frame 이미지로 읽기
    - 반환값
      - bool : 읽었는지 여부
      - img : 읽은 이미지(ndarray)
#### 웹캠
```python
import cv2

# VideoCapture(정수) : 웹캠 연동
cap = cv2.VideoCapture(0)
# 연동 성공 여부 확인
if cap.isOpened() == False:
  print('웹캠 연결 실패')
  exit(1) # 프로그램 실행 종료 1 => 비정상 종료 0 => 정상 종료
  
while True:
  # 웹캠으로 부터 영상이미지(frame)을 읽기
  ret, img = cap.read() # ret : booolean, img : ndarray => 이미지
  if not ret:
    print('이미지 캡쳐 실패')
    break
  # 캡쳐한 이미지를 화면에 출력
  img = cv2.flip(img, 1) # 1 : 수평반전, 0 : 수직반전, -1 : 수평 + 수직반전
  cv2.imshow('Frame', img)
  
  if cv2.waitKey(1) == ord('q'): q를 입력받으면 웹캠 이미지 읽기(capture) 종료
    break

cap.release() # 웹캠연결 종료
cv2.destroyAllWindows() # 출력창 종료
```
#### 동영상
- FPS(Frame Per Second) : 초당 프레임 수 - 1초에 이미지를 몇장 보여주는가?
```python
import cv2

# VideoCapture('동영상파일 경로') : 동영상파일 연동 웹캠 연동
cap = cv2.VideoCapture('images/wave.mp4')

# 연동 성공여부 확인
if not cap.isOpened():
  print('영상과 연결 실패')
  exit(1) # 프로그램 실행 종료 1 => 비정상 종료, 0 => 정상 종료
  
FPS = cap.get(cv2.CAP_PROP_FPS) # 영상의 fps 값을 조회 30 : 1초에 30프레임 출력
delay_time = int(np.round(1000/FPS)) # 1000밀리초(1초)/FPS

cnt = 1
while True:
  ret, img = cap.read() # ret : boolean, img : ndarray -> 이미지
  if not ret:
    print('이미지 캡쳐 실패')
    break
  # 캡쳐한 이미지를 화면에 출력
  cv2.imshow('Frame', img)
  # 캡쳐한 이미지 파일로 저장
  cv2.imwrite('test/output_{}.jpg'.format(cnt), img)'
  cnt += 1
  if cv2.waitKey(0) == ord('q'):
    break

cap.release() # 웹캠연결 종료
cv2.destroyAllWindows() # 출력창 종료
```
## 동영상 저장
- capture(read)한 이미지 프레임을 연속적으로 저장하면 동영상 저장이 된다.
- VideoWriter 객체를 이용해 저장
  - `VideoWriter(filename, codec, fps, size)`
    - `filename` : 저장경로
    - `codec` : `cv2.VideoWriter_fourcc()` 사용
      - ![image](https://user-images.githubusercontent.com/77317312/116871643-8d6c2200-ac4f-11eb-822b-3c86675c0a24.png)
    - `fps` : FPS(Frame Per Second) - 초당 몇 프레임인지 지정
    - `size` : 저장할 frame 크기로 원본 동영상이나 웹캠의 width, height 순서로 넣는다.
  - `VideoWriter().write(img)`
    - Frame 저장
```python
# 웹캠
import cv2

cap = cv2.VideoCapture(0) # 웹캠 연결
if not cap.isOpened():
  print('웹캠 연결실패')
  exit(1)
  
# Frame(이미지) 한장을 캡쳐 - 웹캠의 width, height 조회
ret, img = cap.read()
if not ret:
  print('캡쳐 실패')
  exit(1)
  
height, width = img.shape[0], img.shape[1]
fps = cap.get(cv2.CAP_PROP_FPS)
codec = cv2.VideoWriter_fourcc(*'MJPG')

# Video Writer 생성
writer = cv2.VideoWriter('output/webcam_output.avi', codec, fps, (width, height))
if not writer.isOpened():
  print('동영상파일로 출력할 수 없습니다.')
  exit(1)

while True:
  ret, img = cap.read()
  if not ret:
    print('캡쳐 실패')
    break
  
  img = cv2.flip(img, 1)
  writer.write(img)
  cv2.imshow('frame', img)
  
  if cv2.waitKet(1) == ord('q'):
    print('종료')
    break

cap.release() # 웹캠 연결 종료
writer.release() # 출력 연결 종료
cv2.destroyAllWindows() # 출력 화면 종료
```
