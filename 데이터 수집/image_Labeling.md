# LabelImg를 이용한 object Detection데이터 Labelling
- github에서 다운 받은 뒤 압축풀기
  - https://github.com/tzutalin/labelImg
- 의존 라이브러리 설치
  - conda install pyqt=5
  - conda install -c anaconda lxml
  - pyrcc5 -o libs/resources.py resources.qrc
- data/predefined_classes.txt 변경
  - Labeling할 대상 클래스들로 변경
- 실행
  - labelImg-master이라는 디렉토리에서 명령 프롬포트창 실행
  - `python labelImg.py`
  - 메뉴 : view > Auto save mode 체크
  - open dir - labeling할 이미지 디렉토리 열기
  - change save dir : annotation 파일 저장 디렉토리 설정
  - Labelling Format 지정 : Pascal VOC, YOLO
-  주요 단축키


| 단축키 | 설명 |
| -- | -- |
| w | BBox 그리기|
| d | 다음 이미지 |
| a | 이전 이미지 |
| del | BBox 삭제 |
| ctrl+shift+d | 현재 이미지 삭제 |
