# 순환신경망 (RNN - Recurrent Neural Network)
- Sequence data(순차데이터)
  - 순서가 의미가 있으며, 순서가 달라질 경우 의미가 바뀌거나 손상되는 데이터를 말한다.
  - ![image](https://user-images.githubusercontent.com/77317312/116537222-ecb0f600-a920-11eb-847b-c9701d4ed9e0.png)
## Sequence data의 예
1. **Sequence-to-vector(many to one)**
- sequence : 순서 여러개, vector : 하나
- ex) 주가예측 : 4일간의 주가가 들어가면 그 다음날 주가가 나온다.
- ![image](https://user-images.githubusercontent.com/77317312/116537467-3dc0ea00-a921-11eb-8897-c9eb180cf782.png)
2. **Sequence-to-Sequence(many to many)**
- ex) Machine translation(번역)
- ![image](https://user-images.githubusercontent.com/77317312/116537571-5f21d600-a921-11eb-8375-9cf309426778.png)
3. **Vector-to-Sequence(one to many)**
- ex) image captioning(이미지를 설명하는 문장을 만드는 것)
- ![image](https://user-images.githubusercontent.com/77317312/116537732-90020b00-a921-11eb-8d5b-ba3948231a3c.png)

# RNN 개요
- Memory System(기억시스템)
  - 4일간의 주가 변화로 5일째 주가를 예측하려면 입력받은 4일간의 순서를 기억하고 있어야 한다.
  - Fully Connected layer나 Convolution layer의 출력은 이전 Data에 대한 출력에 영향을 받지 않는다.

### 1. Simple RNN
- ![image](https://user-images.githubusercontent.com/77317312/116538224-34844d00-a922-11eb-811f-58dfbfb00bab.png)
- RNN은 내부에 반복을 가진 신경망의 한 종류
- 각 입력 데이터는 순서대로 들어오며 Node/Unit은 **입력데이터와 이전 입력에 대한 출력데이터**를 같이 입력 받는다.
- 입력 데이터에 weight를 가중합한 값과 이전 입력에 대한 출력 값에 weight를 가중한 값을 더해 activation을 통과한 값이 출력값으로 된다. 그리고 이 값을 다음 Sequence 데이터 처리에 전달
- ![image](https://user-images.githubusercontent.com/77317312/116538506-98a71100-a922-11eb-8456-2b19180337dd.png)
#### **기본 순환신경망의 문제**
- Sequence가 긴 경우 앞쪽의 기억이 뒤쪽에 영향을 미치지  못해 학습능력이 떨어진다.
  - 경사 소실(Gradient Vanishing) 문제로 처음의 input값이 점점 잊혀지는 현상 발생
- ReLU activation, parameter initialization의 조정 등 보다 모형의 구조적으로 해결하려는 시도
  - Long  Short Term Memory(LSTM)
  - Gated Recurrent Unit(GRU)
### 2. LSTM(long short term memory)
- RNN을 개선한 변형 알고리즘
  - 바로 전 time step의 처리결과와 전체 time step의 처리결과를 같이 받는다.
- 오래 기억할 것은 유지하고 잊어버릴 것은 빨리 잊자
- ![image](https://user-images.githubusercontent.com/77317312/116538980-3569ae80-a923-11eb-9191-5d8ed40d6ff0.png)
- LSTM의 노드는 RNN의 hidden state에 Cell state를 추가로 출력을 한다.
  - Cell state
    - 기억을 오래 유지하기 위해 전달하는 값
    - 이전 노드들의 출력 값에 현재 입력에 대한 값을 더한다.
  - ![image](https://user-images.githubusercontent.com/77317312/116546851-18d27400-a92d-11eb-9c85-9f15f5a60c8d.png)
#### LSTM의 구조
- Forget gate : 잊어버리기 (안중요한 것을)
- Input gate : 현재값을 cell state에 추가하는 역할
- Output gate : 출력(현재 정보 처리)
- ![image](https://user-images.githubusercontent.com/77317312/116547082-63ec8700-a92d-11eb-96b7-84e7d90a3326.png)

1. Forget gate
  - 현재 노드의 입력값을 기준으로 cell state의 값에서 얼마나 잊을지 결정

2. Input gate
  - 현재 노드의 입력값을 Cell state에 추가

3. Cell state 업데이트
  - forget gate의 결과를 곱하고 input gate의 결과를 더한다.
    - 의미 : 이전 메모리에 현재 입력으로 대체되는 것을 지우고 현재 입력의 결과를 더한다.

4. Output gate
  - LSTM에서 output은 hidden state로 다음 Input Data를 처리하는 Cell로 전달된다.
