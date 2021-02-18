# 배열의 형태(shape) 변경

## 1. reshape()를 이용한 차원 변경 (만능 치트키)
- `numpy.reshape(arr, newshape)` 또는 `ndarray.reshape(newshape)`
    - `a` : 형태를 변경할 배열
    - `newshape` : 변경할 형태 설정
        - 원소의 개수를 유지하는 shape으로만 변환 가능
    - 원본 배열을 변경시키지 않는다.(shape을 바꾼 새로운 배열을 반환)
    - 변경하는 배열의 사이즈가 같아야한다.


## 2. 차원 늘리기(확장)
### 2-1. `numpy.newaxis` 속성을 이용한 차원 늘리기(변수)
- `np.newaxis` == 1 이라고 생각하자
- size가 1인 축(axis)를 늘릴 때 사용
    - 지정한 axis에 size 1인 축을 추가
- slicing에 사용하거나 indexing에 `...`과 같이 사용
    - slicing의 경우 원하는 위치의 축을 늘릴 수 있다.
    - index에 `...`과 사용하는 경우 첫 번쨰나 마지막 축을 늘릴때 사용

### 2-2. indexing에 ...과 같이 사용
- `ndarray[..., np.newaxis]`
- 첫번째 축이나 마지막 축을 늘릴 때만 사용가능

### 2-3. numpy.expand_dims(배열, axis)
- 매개변수로 받은 배열에 지정한 axis의 rank를 확장한다.




## 3. 차원 줄이기(축소)
### 3-1. numpy.squeeze(배열, axis=None), 배열객체.squeeze(axis=None)
- 배열에서 지정한 축(axis)을 제거하여 차원(rank)를 줄인다.
- **제거하려는 축의 size는 1이어야 한다.**
- 축을 지정하지 않으면 size가 1인 모든 축을 제거한다.
    - (3,1,2,1) -> (3,2)

### 3-2. 배열객체.flatten()
- 다차원 배열을 1차원으로 만든다.



## 4. .append() / .insert() / .delete()
-  축(axis)  지정하는것을 유의해야 한다.
-  원본은 바뀌지 않고 새로운 배열로 반환

### 4-1. numpy.append(배열, 추가할 값, axis=None)
- `배열`의 마지막 index에 `추가할 값`을 추가
- `axis` : 축 지정
    - `None`(default) : flatten 한 뒤 추가한다.


### 4-2. numpy.insert(배열, index, 추가할 값, axis=None)
- `배열`의 `index`에 `추가할 값`을 추가
- `axis` : 축 지정
    - `None`(default) : flatten 한 뒤 삽입한다.


### 4-3. numpy.delete(배열, 삭제할index, axis=None)
- `배열`의 `삭제할 index`의 값들을 삭제한다.
- `삭제할 index`는 index or slice
- `axis` : 축 지정
    - `None`(default) : flatten 한 뒤 삭제한다.

## 5. 배열 합치기
### 5-1. np.concatenate(합칠 배열리스트, axis=0)
- 여러 배열을 **축의 개수(rank)**를 유지하며 합친다.
- `axis` : 축지정
    - 지정된 축을 기준으로 합친다.
    - default : 0
- 합치는 배열의 축의 개수(rank)는 같아야 한다.
    - 같은 차원끼리 합칠 수 있다.
- axis속성으로 **지정한 축 이외의 축의 크기가 같아**야 한다.
- 결과의 축의 개수(rank)는 대상 배열의 rank와 같다.
    - 1차원 끼리 합치면 1차원 결과가 나옴
- 2차원끼리, 3차원끼리, n차원끼리


### 5-2. vstack(합칠배열리스트) # 2차원 배열 전용!
- 수직으로 쌓는다.
- `concatenate()`의 axis=0와 동일
- 합칠 배열들의 열수가 같아야 한다.


### 5-3. hstack(합칠배열리스트) # 2차원 배열 전용!
- 수평으로 쌓는다.
- `concatenate()`의 axis=1와 동일
- 합칠 배열들의 행 수가 같아야 한다.



## 6. 배열 나누기





