# 사진 종류에 따라 오류가 뜨거나 어색한 이미지가 있다..
- 수정할 부분 있음

```python
import dlib, os, cv2
import numpy as np
import imutils
from math import atan2, degrees

# face detector과 landmart predictor 정의
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor('models/shape_predictor_68_face_landmarks.dat')
```

- 투명한 이미지를 읽을 때는 `cv2.IMREAD_UNCHANGED`를 지정해줘야 alpha채널까지 읽어온다.
```python
mask = cv2.imread('images/black_mask2.png', cv2.IMREAD_UNCHANGED)
```

## image overlay 해주는 함수 정의
- 아직 수정할 부분이 있음
- cv2.bitwise_XXX() 공부하기
- 비트 연산 공부하기
```python
def overlay_transparent(background_img, img_to_overlay_t, x, y, overlay_size=None):
  # 원본 보존을 위해 copy
  bg_img = background_img.copy()
  # convert 3 channels to 4 channels
  if bg_img.shape[2] == 3:
    bg_img = cv2.cvtColor(bg_img, cv2.COLOR_BGR2BGRA)
    
  if overlay_size:
    img_to_overlay_t = cv2.resize(img_to_overlay_t.copy(), overlay_size)
    
  b, g, r, a = cv2.split(img_to_overlay_t)
  
  mask = cv2.medianBlur(a, 5)
  
  h, w, _ = img_to_overlay_t.shape
  
  roi = bg_img[int(y - h / 2) : int(y + h / 2), int(x - w / 2) : int(x + w / 2)]
  
  img1_bg = cv2.bitwise_and(rot.copy(), roi.copy(), mask=cv2.bitwise_not(mask))
  img2_bg = cv2.bitwise_and(img_to_overlay_t, img_to_overlay_t, mask=mask)
  
  bg_img[int(y - h / 2) : int(y + h / 2), int(x - w / 2) : int(x + w / 2)] = cv2.add(img1_bg, img2_bg)
  # convert 4 channels to channels
  bg_img = cv2.cvtColor(bg_img, cv2.COLOR_BGRA2BGR)
  
  return bg_img
```
## 기준점에 맞춰 이미지 회전
- 수학 공부하자
```python
def angle_between(p1, p2):
  xDiff = p2[0] - p1[0]
  yDiff = p2[1] - p1[1]
  return degrees(atan2(yDiff, xDiff))
```

### image overlay
```python
경로 지정
base_path = r'C:\Users\yws15\mask_overlay_with_opencv'
image_path = os.path.join(base_path, 'images')
face_path = os.path.join(image_path, 'with_mask')

for idx, face in enumerate(os.listdir(face_path)):
  img = cv2.imread(os.path.join(face_path, face))
  
  # 원본 파일 변경 안하기
  ori = img.copy()
  
  # detect faces
  faces = detector(img)
  
  if not faces:
    continue
    
  face = faces[0]
  
  # 얼굴 특징점 추출 <- img와 얼굴 영역이 파라미터로 쓰임
  dlib_shape = predictor(img, face) # dlib_shape을 리턴 받음
  
  # 68개의 점 x, y를 array로 shape_2d에 저장
  shape_2d = np.array([[p.x, p.y] for p in dlib_shape.parts()])
  
  # shape_2d의 49, 55 저장
  left_x, left_y = shape_2d[48]
  right_x, right_y = shape_2d[54]
  mask_x, mask_y = shape_2d[51]
  
  # 특징점을 구한 이유! 좌상단, 우하단을 구해 얼굴의 사이즈 & 중심을 구함
  # compute center of face
  top_left = np.min(shape_2d, axis=0)
  bottom_right = np.max(shape_2d, axis=0)
  
  # 중심 구하기, 소숫점일 수 있으니 정수로 변환
  center_x, center_y = np.mean(shape_2d, axis=0).astype(np.int64)
  
  # 얼굴 크기만큼 resize(overlay)
  face_size = int(max(bottom_right - top_left) * 1.8)
  
  # 마스크 각도
  angle = -angle_between((left_x, left_y), (right_x, right_y))
  M = cv2.getRotationMatrix2D((mask.shape[1] / 2, mask/shape[0] / 2), angle, 1)
  rotate_mask = cv2.warpAffine(mask, M, (mask.shape[1], mask.shape[0]))
  
  # overlay_transparent의 역할은 이미지를 center_x, center_y를 중심으로 놓고 이미지 붙이기
  try:
    result = overlay_transparent(ori, rotate_mask, mask_x, mask_y, overlay_size=(face_size, face_size))
  except:
    print('안됬음')
    continue
  # 사진 사이즈가 맞지 않아 오류가 나면 무시하기
  
  # pt1 좌상단 face.left(), face.top()
  # pt2 우하단 face.right(), face.bottom()
  img = cv2.rectanfle(img, pt1=(face.left(), face.top()), pt2=(face.right(), face.bottom()), color=(255, 255, 255), thickness=2, lineType=cv2.LINE_AA)
  
  for s in shape_2d: # 얼굴 특징점 68개
    cv2.circle(img, center=tuple(top_left), radius=1, color=(255, 0, 0), thickness=1, lineType=cv2.LINE_AA)
  
  # 좌상단, 우하단 점 그리기
  cv2.circle(img, center=(tuple(bottom_right), radius=1, color=(255,0,0), thickness=1, lineType=cv2.LINE_AA)
  cv2.circle(img, center=(tuple((center_x, center_y)), radius=1, color=(0,255,0), thickness=1, lineType=cv2.LINE_AA)
  cv2.circle(img, center=(tuple((left_x, left_y)), radius=1, color=(0,0,255), thickness=1, lineType=cv2.LINE_AA)
  cv2.circle(img, center=(tuple((right_x,  right_y)), radius=1, color=(0,0,255), thickness=1, lineType=cv2.LINE_AA)
  
  cv2.imshow('img', img)
  cv2.imshow('result', result)
  cv2.imwrite('images/result/image_{0}.jpg'.format(idx), result)
  cv2.waitKey(0)
  cv2.destroyAllWindows()
```
- ![image](https://user-images.githubusercontent.com/77317312/119214642-5f1d8c00-bb03-11eb-987d-4045e1cda151.png)
