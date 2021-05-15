# Object Detection을 위한 주요 Open Dataset
## Open Dataset이란
- computer vistion을 위한 Open Dataset들은 이미지와 그 이미지에 대한 문제영역 관련 Annotataion파일을 제공

## Annotation이란
- 학습시킬때 필요한 정보(보통, Label(y)값)를 제공하는 문서(text) 파일
- 보통 각 이미지파일의 위치, 학습시 필요한 출력 정보(y, output)등을 제공
  - 출력 정보 : 이미지내의 Oject들의 bounding box 위치 정보, object의 label, segmentation 파일 위치 등
- Open dataset마다 작성 포멧이 다른데 **JSON, XML, CSV**등을 사용

- Annotation 예
- ![image](https://user-images.githubusercontent.com/77317312/118351898-77d4f180-b599-11eb-9745-e212c4049778.png)


## PASCAL VOC(Visual Object Classes)
- http://host.robots.ox.ac.uk/pascal/VOC/
- 2005년에서 2012년까지 열렸던 VOC challenges 대회에서 사용한 데이터셋으로 각 대회별 데이터셋을 Open Dataset으로 제공
- 20개 CLass

## MS-COCO Dataset
- COCO (Common Objects in Context)
- https://cocodataset.org/
- https://arxiv.org/pdf/1405.0312.pdf
- 총 80개의 category의 class들을 제공
- ![image](https://user-images.githubusercontent.com/77317312/118351750-b0280000-b598-11eb-9267-6c46d63f9735.png)

## 그외 Datasets
- Open Image
  - 구글에서 공개하는 Image Data 현존 최대 규모 범용 이미지 데이터 category 약 9천만장 제공
  - https://storage.googleapis.com/openimages/web/index.html
  - https://github.com/cvdfoundation/open-images-dataset
- KITTI
  - 차 주행 관련 데이터셋을 제공
  - http://www.cvlibs.net/datasets/kitti/
- AIHub
  - 이미지, 텍스트, 법률, 농업, 영상, 음성 등 다양한 분야의 딥러닝 학습에 필요한 데이터를 수집 구축한 곳
  - https://aihub.or.kr/
