# 미세조정(Fine-tuning)
- 주어진 문제에 더 적합하도록 모델의 가중치들 조정
- **Fine tuning 전략**
- ![image](https://user-images.githubusercontent.com/77317312/116376870-9de55c80-a84b-11eb-971b-0c934c051937.png)
- 3가지 전략 모두 classifier layer들은 train한다.

1. **전체 모델 전부 학습하기 (1번)**
- Pretrained 모델의 weight는 Feature extraction의 초기 weight 역할을 한다.
- Train dataset의 양이 많고 pretrained 모델이 학습했던 dataset과 custom dataset간의 유사성이 낮은 경우 적용
  - 학습 시간이 많이 걸린다.
2. **Top layer의 일부를 재학습 시킨다. (2번)**
- train dataset의 양이 많고 유사성이 높은 경우
- train dataset의 양이 적고 유사성이 낮은 경우

3. **pretrained 모델 전체를 고정시키고 classifier layer들만 학습시킨다. (3번)**
- train dataset의 양이 적고 유아사성이 높은 경우

#### 08_파일 이어서
```python
conv_base = VGG16(weights='imagenet', include_top=False, input_shape=(150,150,3))

# network(모델)을 구성하는 layer들 추출
layers = conv_base.layers
type(layers), len(layers) # model을 구성하는 layer들을 추출해 list에 묶어 반환
## >>> (list, 19)

# layer의 이름 조회
layers[2].name
## >>> block1_conv2

# 모델.get_layer('layer이름') 지정한 이름의 layer 반환
l = conv_base.get_layer('block1_conv2')
l
## >>> <tensorflow.python.keras.layers.convolutional.Conv2D at 0x7f383a532ed0>

# layer의 가중치(weight)를 조회
l_w = l.weights
type(l_w), len(l_w) # [weight, bias]
## >>> (list, 2)
```
## pretrained 모델 bottom layer들(input과 가까운 layer들)은 고정시키고 top layer의 일부 재학습
- conv_base에서 가장 top 부분에 있는 레이어에 대해 fine_tuning를 학습
- 너무 많은 parameter를 학습시키면 overfitting의 워험이 있음(특히 새로운 데이터의 수가 적을 때)
```python
def create_model():
  # VGG16 : block5_conv2, block5_conv3 두개의 convolution layer들을 fine tuning
  conv_base = VGG16(weights='imagenet', include_top=False, input_shape=(150,150,30))
  
  # trainable 설정
  is_trainable = False
  for layer in conv_base.layers:
    if layer.name == 'block5_conv2':
      is_trainable = True
    layer.trainable - is_trainable
  
  model = keras.Sequential()
  model.add(conv_base)
  model.add(layers.GlobalAveragePooling2D())
  model.add(layers.Dense(256, activation='relu'))
  model.add(layers.Dense(1, activation='sigmoid'))
  
  return model
  
model = create_model()
model.compile(optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
              loss='binary_crossentropy',
              metrics=['accuracy'])

train_iterator, validaion_iterator, test_iterator = get_generators()

N_EPOCHS = 30
mc_callback = keras.callbacks.ModelCheckpoint('./models/cat_dog_model', monitoy='val_loss', save_best_only=True)
history = model.fit(train_iterator, epochs=N_EPOCHS,
                    steps_per_epoch=len(train_iterator),
                    validation_data=validation_iterator,
                    validation_steps=len(validation_iterator),
                    callbacks=[mc_callback])

best_model = keras.models.load_model('./models/cat_dog_model')

# evaluation
best_model.evaluate(train_iterator)
## >>> [0.16870158910751343, 0.9359999895095825]

best_model.evaluate(test_iterator)
## >>> [0.18708403408527374, 0.9210000038146973]
```
