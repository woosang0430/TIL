## numpy 패키지의 dot과 matmul의 차이

###  numpy의 행렬곱을 지원하는 함수
- 둘의 행렬 곱은 동일하다
- **But** 3차원 이상의 행렬끼리 곱할 때의 결과는 다르다.
- 두가지 다 서로 다른 차원의 배열을 곱할 수 있다.
```python
import numpy as np

A = np.arange(2 * 3 * 4).reshape((2, 3, 4))
B = np.arange(2 * 3 * 4).reshape((2, 4, 3))

np.dot(A, B).shape
## (2, 3, 2, 3)

np.matmul(A, B).shape
## (2, 3, 3)
```

## np.dot()
- dot 연산 document
> - if 'a' is an N-D array and 'b' is an M-D array (where M >=2),
> - it is a sum product over the last axis of 'a' and the second-to-last axis of 'b'

```python
A.shape # (a1, a2, a3)
B.shape # (b1, b2, b3)
## (a3 == b2) 같아야 내적 가능

C = np.dot(A, B)
C.shape # (a1, a2, b1, b3)

A = np.arange(2*3*4).reshape((2,3,4))
B1 = np.arange(2*3*4).reshape((2,3,4))
B2 = np.arange(2*3*4).reshape((2,4,3))

np.dot(A, B1).shape # Error
np.dot(A, B2).shape # (2,3,2,3)
```
- 위의 설명과 같이 `dot()`연산은 첫번째 배열의 마지막 축, 두번째 배열의 뒤에서 두번째 축(2, *4*, 3)(2, 3, *4*)의 shape의 크기가 같아야 연산이 가능하다
- 3차원 텐서끼리 dot연산하면 4차원 텐서를 얻는 것을 볼 수 있다.

## np.matmul()
- matmul 연산 document
> - if either argument is N-D, N >2, it is treated as a stack of matrics residing in the last two indexes and broadcast accordingly.

```python
A.shape # (a1, a2, a3)
B.shape # (b1, b2, b3)
## (a1 == b1, a3 == b2) 같아야 내적가능

C = np.matmul(A, B)
C.shape # (a1, a2, b3)

A = np.arange(2*3*4).reshape((2,3,4))
B1 = np.arnage(2*3*4).reshape((2,4,3))
B2 = np.arange(3*3*4).reshape((3,4,3))

np.matmul(A, B1).shape # (2,3,3)
np.matmul(A, B2).shape # Error
```
- 위의 설명과 같이 `matmul()`연산은 첫번째 배열의 개수(첫 axis)와 마지막 축, 두번째 배열의 개수(뒤에서 3번째)와 뒤에서 2번째 축(*2*, 3, *4*)(*2*, *4*, 3)의 shape의 크기가 같아야 연산이 가능하다
- 3차원 텐서끼리 matmul연산해도 3차원 텐서를 얻는 것을 볼 수 있다.

## 결론
- 두 함수 dot과 matmul은 2차원 행렬의 곱셈에서는 서로 같은 기능을 하지만 고차원 배열 또는 텐서의 곱셈에서의 용법이 다른 것을 볼 수 있다.
- `np.dot()`은 (a1, a2, a3)(b1, b2, b3)에서 **a3==b2** 면 연산 가능
- `np.matmul()`은 (a1, a2, a3)(b1, b2, b3)에서 **a1==b1 and a3==b2** 가 만족하면 연산 가능

