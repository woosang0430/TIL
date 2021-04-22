# CNN - 합성곱 신경망(Convolutional Neural Network)
- 주로 컴퓨터 비전(이미지, 동영상관련 처리)에서 사용되는 딥러닝 모델로 Convolution 레이어를 이용해 데이터의 특징을 추출하는 전처리 작업을 포함시킨 신경망 모델
- ![image](https://user-images.githubusercontent.com/77317312/115717363-12844b00-a3b5-11eb-9e32-23f406678999.png)

# CNN 응용되는 다양한 컴퓨터 비전 영역
## 1. Image Classification(이미지 분류)
- ![image](https://user-images.githubusercontent.com/77317312/115717526-3778be00-a3b5-11eb-9497-f8739e0ab59d.png)

## 2. Object Detection(객체 찾기)
- 하나의 object를 찾는 것을 Localization이라고 하고 여러개를 찾는 것을 Object Detection이라 한다.
- ![image](https://user-images.githubusercontent.com/77317312/115717696-61ca7b80-a3b5-11eb-934f-a135a188ec4a.png)

## 3. Image Segmentation
- ![image](https://user-images.githubusercontent.com/77317312/115717850-8b83a280-a3b5-11eb-9ebd-08d2f6b683cf.png)

## 번외. Classification, Localization, Object Detection, Segmentation 차이
- ![image](https://user-images.githubusercontent.com/77317312/115717952-a5bd8080-a3b5-11eb-88db-705b6c171bc8.png)

## 4. Image Captioning
- 이미지에 대한 설명문을 자동으로 생성
- ![image](https://user-images.githubusercontent.com/77317312/115718060-bbcb4100-a3b5-11eb-802c-2ec05dccf905.png)

## 5. Super Resolution
- ![image](https://user-images.githubusercontent.com/77317312/115718143-d1406b00-a3b5-11eb-952c-a072dd401154.png)

## 6. Neural Style Transfer
- 입력 이미지와 스타일 이미지를 합쳐 합성된 새로운 이미지 생성

## 7. Text Dectection & OCR

## 8. Human Pose Estimation
- ![image](https://user-images.githubusercontent.com/77317312/115718420-106ebc00-a3b6-11eb-893a-aa90cd236215.png)

# CNN 구성
- 이미지로 부터 부분적 특성을 추출하는 Feature Extraction 부분과 분류를 위한 Classification 부분으로 나뉜다.
- Feature Extraction 부분에 이미지 특징 추출에 성능이 좋은 Convolution Layer를 사용
  - 이미지 특징 추출에 특화
  - Feature Extraction : Convolution Layer
  - Classification : Dense Layer
- ![image](https://user-images.githubusercontent.com/77317312/115718830-778c7080-a3b6-11eb-9840-1fd99ef587b2.png)

## Dense Layer를 이용한 이미지 처리의 문제점
- 이미지를 input으로 사용하면 dimension(차원)이 매우 큼
- 64 * 64 픽셀 이미지 경우
  - 흑백은 unit당 64 * 64 = 4096개 학습 파라미터(컬러일 경우 3배(RGB))
- Fully connected layer만을 사용한다면 이미지의 공간적 구조 학습이 어려움

## 합성곱
- Convolution Layer는 이미지와 필터간의 **합성솝 연산**을 통해 이미지의 특징을 추출한다.
- ![image](https://user-images.githubusercontent.com/77317312/115719283-e8338d00-a3b6-11eb-9c5b-43c629a73187.png)

## CNN 에서 Filter
- CNN의 Layer는 이런 Filter(Kernel)들로 구성
- CNN은 주어진 Filter(Kernel)를 사용하는 것이 아니라 Filter(Kernel)의 값을 가중치(파라미터)로 데이터를 학습해 찾아낸다.
- 한 Layer를 구성하는 Filter들은 Input 이미지에서 각각 다른 패턴들을 찾아낸다.

## CNN도 레이어를 쌓는다.
- 첫번째 레이어는 부분적 특징을 찾는다.
- 다음 단계에서는 이전 레이어에서 찾아낸 부분적 특징들을 합쳐 점점 추상적 개념을 잡아낸다.
- ![image](https://user-images.githubusercontent.com/77317312/115719721-55dfb900-a3b7-11eb-8c22-f4afa08a8b27.png)

## Convolution operation의 작동방식
- hyper parameter 정의
  - Filter의 크기 : 보통 홀수 크기로 잡는다. (3*3, 5*5). 주로 3*3 필터를 사용
    - 필터의 채널은 input image의 채널과 동일
  - Filter의 수 : 필터의 개수. Feature map output의 깊이가 된다.
    - **Feature map**
      > - Filter를 거쳐 나온 결과물
      > - Feature map의 개수는 Filter당 한개가 생성된다.
      > - Feature map의 크기는 Filter의 크기, Stride, Padding 방식에 따라 다르다.
- 흑백 이미지는 하나의 행렬, 컬러 이미지는 RGB 3개의 행렬
- ![image](https://user-images.githubusercontent.com/77317312/115720271-e1594a00-a3b7-11eb-9923-19b7e20fe627.png)

### Padding
- 이미지 가장자리의 픽셀은 convolution 계산에 상대적으로 적게 반영된다. 
- 위의 문제를 방지하기 위해 이미지 가장자리에 0으로 둘러 싸 반영 횟수를 늘림
- 'valid' padding
  - Padding을 적용하지 않음
  - Output(Feature map)의 크기가 줄어든다.
- 'same' padding
  - Input과 output의 이미지 크기가 동일하게 되도록 padding 수를 결정
  - **보통 same 패딩을 사용**
  - Output의 크기는 Pooling Layer를 이용해 줄인다.
  - ![image](https://user-images.githubusercontent.com/77317312/115720752-50cf3980-a3b8-11eb-870c-8e963b635f46.png)

### Strides
- Filter(Kernel)가 한번 Convolution 연산을 수행한 후 옆 또는 아래로 얼마나 이동할 것인가.
- **보통은 1**, stride=2로 지정하면 한 번에 두칸 씩 이동

## Max Pooling Layer(최대풀링)
- 해당 영역의 input 중 가장 큰 값을 출력
- **일반적으로 2*2 크기에 stride는 2를 사용 (겹치지 않게 한다.)**
- 강제적인 subsampling 효과 -> 이미지 줄이는 효과
  - weight 수를 줄여 계산 속도를 높인다.
- 학습할 weight가 없음 : 일반적으로 Convolution layer + pooling layer를 하나의 레이어로 취급한다.
- ![image](https://user-images.githubusercontent.com/77317312/115721211-caffbe00-a3b8-11eb-8b5a-e36916064bd4.png)
