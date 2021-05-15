# 이미지 캡쳐를 이용한 데이터 수집
- OpenCV의 VideoCapture를 이용해 이미지 수집

```python
import cv2
import sys
import time
import uuid
import os

IMAGE_DIR = 'images'
if not os.path.isdir(IMAGE_DIR):
  os.mkdir(IMAGE_DIR)
  
labels = ['one', 'two', 'three', 'four', 'five']
n_images = 15 # 카테고리별로 몇장씩 만들지

cap = cv2.VideoCapture(0)

# 웹캠 이미지 사이즈 설정
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
if not cap.isOpend():
  print('fail connect webcam')
  sys.exit(1)
  
break_all = False # 중복 반복문을 빠져나오기 위한 bool 변ㄴ수
# label별로 반복하며 capture
for label in labels:
  print('{0} label capture'.format(label))
  time.sleep(2) # 2초 대기(준비시간)

  # 이미지 n_images 개수만큼 캡쳐
  # 한번 반복할 때 마ㅏ다 한장씩 캡쳐
  for image_num in range(n_images):
    ret, frame = cap.read()
    if not ret:
      print('fail capture')
      break
    frame = cv.flip(frame, 1)
    filename = '{0}-{1}.jpg'.format(label, str(uuid.uuid1()))
    file_path =  os.path.join(IMAGE_DIR, filename)
    # 화면에 출력
    cv2.imshow('wabcam', frame)
    # 캡쳐 이미지 파일로 저장
    cv2.imwrite(file_path, frame)
    print('{0}번째, '.format(image_num), end=' ')
    
    if cv2.waithKey(1000) == 27: # esc를 누르면 강제 종료. waitKey(2000 ->2초)
      print('강제 종료')
      break_all = True
      break
  if break_all: # 반복문 전체를 빠져 나오도록 설정
    break
  print()
  
# 종료
cap.release()
cv2.destroyAllWindows()
```
## 다른 방법
```python
import cv2

cap = cv2.VideoCapture(0)

if not cap.isOpened():
  print('Colud not open webcam')
  exit()
  
sample_num = 0
capture_num = 0
image_dir = 'images'
# loop through frames
while cap.isOpened():
  
  # read frame from webcam
  ret, frame = cap.read()
  sample_num += 1
  
  if not ret:
    break
  
  if sample_num % 8 == 0:
    capture_num += 1
    file_name = '{0}.jpg'.format(capture_num)
    file_path = os.path.join(image_dir, file_name)
    cv2.imwrite(file_path, frame)
    
  # display output
  cv2.imshow('webcam', frame)
  
  if cv2.waitKey(1) == ord('q'):
    break
    
cap.release()
cv2.destroyAllWindows()
```
