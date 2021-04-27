# GlovalAveragePooling(GAP)
- feature map의 채널별로 평균값을 추출 1 x 1 x channel의 feature map을 생성
- `model.add(keras.layers.GlobalAveragePooling2D())`
- Feature Extraction layer에서 추출한 Feature map을 Classifier layer로 Flatten해서 전달하면 많은 연결노드와 파라미터가 샹송.
- GAP를 사용하면 노드와 파라미터의 개수를 효과적으로 줄일 수 있다.
- Feature map의 채널수가 많으면 GAP, 채널수가 적으면 Flatten
- ![image](https://user-images.githubusercontent.com/77317312/116216101-36fc7080-a783-11eb-978b-a5079422eb4e.png)
## colab 이미지 다운로드
```python
import gdown
url = 'https://drive.google.com/uc?id=1nBE3N2cXQGwD8JaD0JZ2LmFD-n3D5hVU'
fname = 'cats_and_dogs_small.zip'
gdown.download(url, fname, quiet=False)

!mkdir data

# 압축 풀기
!unzip -q ./cats_and_dogs_small.zip -d data/cats_and_dogs_small
```
- ![image](https://user-images.githubusercontent.com/77317312/116216325-77f48500-a783-11eb-9a87-c3ea50cb1a20.png)
## Transfer learning(전이학습)
- 큰 데이터 셋을 이용해 미리 학습된 pre-trained Model의 weight를 사용하여 현재 하려는 예측 문제에 활용
- **Convolution base(Feature Extraction 부분)만 활용**
  - Convolution base는 이미지에 나타나는 일반적인 특성을 파악하기 위한 부분이므로 재사용할 수 있다.
  - Classifier 부분은 학습하려는 데이터셋의 class들에 맞게 변경해야 하므로 재사용할 수 없다.
- Pretrained Convolution layer의 활용
  - Feature extraction
    - 학습시 학습되지 않고 Feature를 추출하는 역할만 한다.
  - Fine tuning
    - 학습시 Pretrained Convolution layer도 같이 학습해서 내 데이터셋에 맞춘다.

## Feature extraction
- 기존의 학습된 network에서 fully connected layer를 제외한 나머지 weight를 고정하고 새로운 목적에 맞는 fully connected layer를 추가하여 추가된 weight만 학습하는 방법
- `tensorflow.keras.applications` module이 지원하는 image classification models
- (https://www.tensorflow.org/api_docs/python/tf/keras/applications)
- **ImageNet**
  - 웹상에서 수집한 약 1500만장의 라벨링된 고해상도 이미지로 약 22,000개 카테고리로 구성된다.

## VGG16 모델
- ![image](https://user-images.githubusercontent.com/77317312/116217666-d1a97f00-a784-11eb-8ea0-7545abce365b.png)
- 단점 : 마지막 분류를 위해 Fully Connected layer 3개를 붙여 파라미터수가 많아진다.

## ResNet(Residual Networks)
- **Idea**
  - ![image](https://user-images.githubusercontent.com/77317312/116217989-0ddcdf80-a785-11eb-95c9-fda19e42c1eb.png)
  - 입력값을 그대로 출력하는 identity block을 사용하면 성능이 떨어지지 않는다.
  - 그럼 Convolution block을 identity block으로 만들면 최소한 성능은 떨어지지 않고 깇은 layer를 쌓을 수 있지 않을까?

- **Solution**
  - ![image](https://user-images.githubusercontent.com/77317312/116218243-4d0b3080-a785-11eb-8e9e-379ac05571c6.png)
  - 목표는 H(x)(레이어를 통과한 값)이 input인 x와 동일한 것으로 만들기 위해 F(x)를 0으로 만들기 위해 학습한다.
  - F(x)는 잔차가 된다. 그리고 잔차인 F(x)가 0이 되도록 학습하는 방식이므로 Residual Learning
  - 입력인 x를 직접 전달하는 것을 **shortcut connection** or **identity mapping** or **skip connection**이라 한다.
- **성능향상**
  - H(x) = F(x) + x 을 x에 대해 미분하면 최소한 1이므로 Gradient Vanishing문제를 극복
  - 잔차학습이라고 하지만 Residual block은 Convolution layer와 Activation layer로 구성되어 있기 때문에 이 layer를 통과한 Input으로 부터 Feature map을 추출하는 과정은 진행되며ㅑ 레이어가 깇으므로 더욱 풍부한 특성들을 추출하게 되어 성능이 향상된다.
- **ResNet 구조**
- ![image](https://user-images.githubusercontent.com/77317312/116219113-374a3b00-a786-11eb-9a3e-9e746ee0c1a0.png)
- 모든 Identity block은 두개의 3x3 conv layer로 구성
- 일정 레이어 수별로 filter의 개수를 두배로 증가시키며 stride를 2로 하여 downsampling함(Pooling은 시작과 마지막에만 적용)




































