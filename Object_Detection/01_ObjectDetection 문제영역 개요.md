## Computer vision
- 인간의 시각과 관련되 부분을 컴퓨터 알고리즘을 이용해 구현하는 방법을 연구하는 분야

### 주요 컴퓨터 비전 분야
- **Image Classification**
- **Image Segmentaion**
- **Object Detection**

# Object Detection 개요
### Object Detection = Localization + Classification
- **object detection**은 이미지에 존재하는 object들을 bounding box를 이용해 그 위치를 찾아내고(Localization) class를 분류 하는 작업이다.
- one stage detector : localization과 classification을 하나의 네트워크에서 같이 처리
- two stage detector : localization과 classification을 순차적으로 처리

### Object Detection의 출력값
- **bouding box(BBox)의 location**
  - x, y, w, h 이용
    - x, y : bounding box 중심점의 좌표
    - w, h : bounding box의 너비와 높이
  - x_min, y_min, x_max, y_max 이용
    - x_min, y_min : 왼쪽 위(left-top)의 x, y좌표
    - x_max, y_max : 오른쪽 아래(right-bottom)의 x, y좌표
  - 알고리즘에 따라 실제 좌표를 또는 비율로 반환(대부분 비율로 넘겨준다.)
- **class**
  - bounding box안의 물체의 class 또는 확률
- **confidence score**
  - bounding box안에 실제 물체가 있을 것이라고 확신하는 화신의 정도의 값 0 ~ 1 사이의 값

# Object Detection 성능 평가
### IoU(Intersection Over Union, Jaccard overlap)
- 모델이 예측한 bounding box(bbox)와 Ground Truth bounding box가 얼마나 겹치는지 나타내는 평가지표
  - 두개의 bounding box가 일치할수록 1에 가까운 값이 나오고 그렇지 않으면 0에 가까운 값이 계산된다.
- 일반적으로 IoU값 **0.5를 기준으로 그 이상이면 검출한 것**으로 미만이면 잘못찾은 것(제거)으로 한다.
  - 이 기준이 되는 값을 IoU Threshold라고 한다.
  - 0.5 수치는 ground  truth와 66.% 이상 겹쳐야 나오는 수치 이면서 사람의 눈으로 봤을 때 잘 찾았다고 느껴지는 수준이다.
  - ![image](https://user-images.githubusercontent.com/77317312/117636917-41276180-b1bc-11eb-8da5-52ea7ec044ce.png)

### NMS(Non Max Suppression) 많이 쓰임
- **이거 꼭 기억하자**
- object detection 알고리즘은 object가 있을 것이라 예측하는 위치에 여러개의 bounding box들을 예측한다.
- NMS는 Detect된 bounding box들 중에서 비슷한 위치에 있는 겹치는 bbox들을 제거하고 가장 적합한 bbox를 선택하는 방법이다.
- ![image](https://user-images.githubusercontent.com/77317312/117637144-7df35880-b1bc-11eb-908a-4d5c04f3ede5.png)

#### **NMS 실행 로직**
1. detect된 bounding box 중 confidence threshold값 이하의 박스들을 제거한다.
  - confidence score : bounding box내에 object가 있을 확률
2. 가장 높은 confidence score를 가진 bounding box 순서대로 내림차순 정렬을 한 뒤 높은 confidence score를 가진 bounding box와 겹치는 다른 bounding box를 모두 조사하여 IoU가 특정 threshold 이상인 bounding box들을 모두 제거
  - 가장 높은 confidence score를 가진 bounding box와 IoU가 높게 나온다는 것은 그만큼 겹치는 박스
  - 이 작업을 남아있는 모든 bounding box에 적용한 뒤 남아있는 박스만 선택
  - ![image](https://user-images.githubusercontent.com/77317312/117637695-04a83580-b1bd-11eb-8ffb-84bc0505df45.png)
- ↘
  - ![image](https://user-images.githubusercontent.com/77317312/117637759-17226f00-b1bd-11eb-84a9-ef1199684fbd.png)

#### mAP(mean Average Precision)
- 여러개의 실제 object가 검출된 재현율(recall)의 변화에 따른 정밀도(precision) 값을 평균화 한 것
- mAP를 이해하기 위해서 precision, recall, precision-recall curve, AP(Averge precision)을 이해 해야한다.

#### precision(정밀도)와 recall(재현율)
- **정밀도**는 Positive로 예측한 것 중 실제 Positive인 것의 비율(Positive로 예측한 것이 얼마나 맞았는지의 수치)
  - object detection에서는 detect 예측결과가 실제 object들과 얼마나 일치하는지를 나타내는 지표
- **재현율**은 실제 positive인 것 중 positive로 예측한 것의 비율.(Positive인 것을 얼마나 맞았는지의 수치)
  - object detection에서는 실제 object들을 얼마나 잘 detect했는지를 나타내는 지표
- ![image](https://user-images.githubusercontent.com/77317312/117638355-b6476680-b1bd-11eb-8345-5b3d43d35aa5.png)

#### precision과 recall의 trade off(반비례관계)
- confidence threshold를 낮게 낮으면 precision은 낮게 recall은 높게 나온다.
  - recall이 올라가면 precision은 낮아진다.
- confidence threshold를 높게 잡으면 precision은 놓게 recall은 낮게 나온다.
  - precision이 올라가면 recall은 낮아진다.
- precision과 recall은 이렇게 반비례 관계를 가지기 때문에 precision과 recall의 성능 변화 전체를 확인해야한다.
- 그렇게 때문에 대표적인 평가지표는 precision-recall curve를 이용해야한다.


#### precision-recall curve
- confidence threshold의 변화에 따라 recall과 precision의 값이 변하게 된다. 이것을 recall이 변화할 때 precision이 어떻게 변하는지를 선그래프로 나타내는 것

#### Average precision(AP)
- precision-recall curve로 그래프를 그리고 선 아래의 값들 면적을 계산한 값

#### mAP(mean Average Precision)
- 검출해야하는 object가 여러개인 걍우 각 클래스당 ap를 구한 다음 그것을 모두 합해 클래스 개수로 나눈 값을 mAP라 한다.
  - 클래스들의 AP 평균
- 대부분의 알고리즘은 mAP를 이용해 detection 성능을  평가

## 논문의 평가지표 예
- ![image](https://user-images.githubusercontent.com/77317312/117639543-fe1abd80-b1be-11eb-9974-b45c95c1a99a.png)
