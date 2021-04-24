# DNN 모델 구조


# CNN 모델 구조
- cnn 모델로 학습할 data의 shape은 3차원이어야한다. (height, width, channel)
- data에 마지막 축 추가하기 `data[..., np.newaxis]`
1. input layer
- keras.Input(height, width, channel)

2. Feature Extraction(특징 추출, 축소)
- Convolution layer`Conv2D(..)`
  > - filters
  > - kernel_size
  > - padding
  > - strides
  > - activation
- Max Pooling layer`MaxPool2D(..)`
  > - padding
  > - pool_size : default=(2,2)
  > - strides : default=pool_size

3. Classification(분류)
- Flatten()
- Dense(relu)

4. output layer
- Dense(softmax)

5. compile
6. fit(callbacks[learning규제, best_weight 저장 등등])
