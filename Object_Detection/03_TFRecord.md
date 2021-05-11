# TFRecord
- https://www.tensorflow.org/tutorials/load_data/tfrecord
  - ~~텐서플로우 공부하기 좋음~~
- Tensorflow에서 제공하는 데이터셋을 파일 저장방식.
  - 데이터 양이 많을 경우 이를 Binart로 Seralization(직렬화)하여 하나의 파일로 저장하고 있다가, 이를 다시 읽어 들여 처리속도를 향상시킬 수 있다.
  - Tensorflow에서 이를 위해 데이터 셋을 protocol buffer혀애로 serialization을 수행해서 저장할 수 있는 TFRecords 파일 포맷 형태를 지원한다.
    - ~~Protocol Buffer : 파일 포맷이라 생각하자~~
- `tf.train.Example`
  - 하나의 데이터를 TFRecord에 저장하기 위해 변환하는 클래스. 하나의 데이터를 tf.train.Example의 객체로 변환하여 저장
- `tf.train.Feature`
  - 하나의 데이터를 구성하는 속성(Feature)들을 변환하는 클래스.
  - tf.train.Feature는 다음 세가지 타입을 지원한다.
    - `tf.train.BytesList` - string, byte(일반 파일, 이미지) 타입을 변환
    - `tf.train.FloatList` - float(float32), double(float64) 타입을 변환
    - `tf.train.Int64List` - bool, enum, int32, uint32, int64, uint64 타입을 변환
  - tf.train.Example의 형태
```python
{
  'feature명':tf.train.Feature타입객체,
  'feature명':tf.train.Feature타입객체,
  ...
}
```
### 실습
```python
# tf.train.Feature 객체들을 생성하는 (기본타입의 값들을 Feature로 변환하는) 함수 구현
def _bytes_feature(value):
  """
  value로 string, bytes를 받아 BytesList로 변환하는 함수
  """
  # value가 Tensor(텐서플로우의 배열 타입) 타입인 경우 ndarray로 변환 --> binary 파일
  if isinstance(value, type(tf.constant(0))):
    value = value.numpy()
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

def _float_feature(value):
  """
  float타입의 value를 받아 FloatList로 변환하는 함수
  """
  return tf.train.Feature(float_list=tf.train.FloatList(value=[value]))

def _int64_feature(value):
  """
  int, uint, bool 타입의 value를 받아 Int64List로 변환하는 함수
  """
  return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))

type(tf.constant(0))
## >>> tensorflow.python.framework.ops.EagerTensor

v = _int64_feature(20)
print(type(v))
print(v)
## >>> <class 'tensorflow.core.example.feature_pb2.Feature'>
## >>> int64_list {
## >>>   value: 20
## >>> }

v = _bytes_feature(b'hello') # 문자열, bype -> bytes타입으로 전달해줘야한다.
print(v)
## >>> bytes_list {
## >>>   value: "hello"
## >>> }

# 일반 string인 경우 -> bytes타입으로 변환한 뒤 byteslist로 변환
s = '홍길동'
_bytes_feature(s.encode('utf-8'))
## >>> bytes_list {
## >>>   value: "\355\231\215\352\270\270\353\217\231"
## >>> }
```
## Feature 직렬화
- `.SerializeToString()`
  - proto 메세지를 bytes(binary string)로 직렬화
  - Example을 tfrecord로 출력하기 전에 변환해야 한다.
```python
feature = _float_feature(30.2)
type(feature)
## >>> tensorflow.core.example.feature_pb2.Feature

v = feature.SerializeToString() # 출력형태로 변환. String => dyte
type(v)
## >>> bytes
print(v)
## >>> b'\x12\x06\n\x04\x9a\x99\xf1A'
```

# TFRecord 저장 예제
- tf.train.Example 생성 및 직렬화(Serialize)
1. 각 관측값의 Feature들 하나하나는 위의 함수 중 하나를 사용하여 3 가지 호환 유형 중 하나를 포함하는 tf.train.Feature로 변환(인코딩)되어야 한다.
2. Feature이름 문자열에 1번에서 생성된 인코딩된 기능 값으로 딕셔너리를 생성
3. 2 단계에서 생성된 맵은 Features 메시지로 변환
### TFRecord로 저장할 Toy Dataset을 생성
```python
import numpy as np
N_DATA = 1000 # dataset의 데이터 개수

# bool 1000 생성
feature0 = np.random.choice([False, True], N_DATA)

# 정수 1000 생성
feature1 = np.random.randint(0, 5, N_DATA)

# string 1000 생성
str_list = np.array([b'lion', b'tiger', b'cat', b'dog', b'bear'])
feature2 = str_list[feature1]

# float 1000 생성
feature3 = np.random.randn(N_DATA)
feature0.shape, feature1.shape, feature2.shape, feature3.shape
## >>> ((1000,), (1000,), (1000,), (1000,))
```

```python
def serialize_example(feature0, feature1, feature2, feature3):
  """
  하나의 데이터의 속성(feature)값들을 받아 Example을 생성한 뒤 
  그 Example을 출력가능한 bytes로 만들어 반환(SerializeToString()이용)
  feature0 : bool, feature1 : int, feature2 : string, feature3 : float
  """
  # feature들을 dictionary로 생성
  feature = {
    'feature0' : _int64_feature(feature0),
    'feature1' : _int64_feature(feature1),
    'feature2' : _bytes_feature(feature2),
    'feature3' : _float_feature(feature3),
  }
  # feature들을 가진 tf.train.Example 객체 생성
  example = tf.train.Example(features=tf.train.Features(feature=feature))
  
  # Example을 TFRecord에 저장하기 위한 형태인 bytes로 변환 => SerializeToStrin()이용
  return example.SerializeToString()
```
### 출력처리
- _bytes_feature(), _float_feature(), _int64_feature() 중 하나를 사용하여 tf.train.Feature로 각각의 값을 변환한 뒤 tf.train.Example 메시지를 만든다.
- SerializeToString()을 이용해 binary string으로 변환한다.
- tf.io.TFRecordWriter를 이용해 출력
```python
import os
# TFRecord 파일 저장할 디렉토리 생성
if not os.path.isdir('tfrecord'):
  os.mkdir('tfrecord')
  
# TFRecordWriter 객체 생성 -> TFRecord파일로 직렬화된 Example을 출력하는 메소드 제공
tfrecord_file_path = './tfrecord/data.tfr' # 확장자 : [tfr, record, tfrecord]
tfrecord_writer = tf.io.TFRecordWriter(tfrecord_file_path)

for data in zip(feature0, feature1, feature2, feature3):
  sv = serialize_example(bool(data[0]), data[1], data[2], data[3])
  tfrecord_writer.write(sv)
  
tfrecord_writer.close() # 출력 stream 연결 닫기
```

# TFRecord파일 읽기 및 역직렬화(deserialize)
- tfrecord 파일로 저장된 직렬화된 데이터를 읽어 들어와서 feature들을 parsing
- tf.data.TFRordDataset를 이용해 읽는다.

```python
def _parse_function(tfrecord_serialized):
  """
  serialize(직렬화-bytes)된 Example 데이터 하나를 받아 역지렬화한 뒤에 반환하는 함수
  [매개변수]
    tfrecord_serialized : 직렬화된 Example
  [반환값]
    Example구성 Feature들. (feature0, 1, 2,3)
  """
  # 역직렬화해서 읽어온 Feature들을 저장할 Feature들을 dictionary로 구성
  # 이름 : 저장할 때 사용한 name
  # value : 읽어온 Feature를 저장할 빈 Feature(역직렬화할 값의 타입을 선언한다.)
  feature = {
    'feature0' : tf.io.FixedLenFeature([], tf.bool)
    'feature1' : tf.io.FixedLenFeature([], tf.int64)
    'feature2' : tf.io.FixedLenFeature([], tf.string)
    'feature3' : tf.io.FixedLenFeature([], tf.float32)
    
  return feature0, feature1, feature2, feature3

# tfrecord 파일 읽기
dataset = tf.data.TFRecordDataset(tfrecord_file_path).map(_parse_function)
```
