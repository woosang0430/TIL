# 배열을 파일에 저장 및 불러오기
## 1. 바이너리 파일로 저장/불러오기
- `np.save("파일경로", 배열)`
    - 배열을 raw 바이너리 형식으로 저장한다. (압축하지 않은)
    - 파일명에 확장자로 npy를 붙인다. (무조건 붙인다. abc.xxx 해도 abc.xxx.npy 로 저장)
    
- `np.load("파일경로")`
    - 파일에 저장된 배열을 불러온다.
    
- `np.savez("파일경로", 이름=배열, 이름=배열, ...)`
    - 여러개의 배열을 저장할 때 사용
    - 파일명에 확장자로 npz가 붙는다.
    - 내부적으로 압축해서 저장한다.
    - load() 함수로 불러오면 저장된 배열목록이 반환 된다. 저장시 지정한 이름을 이용해 조회 
    
## 2. 텍스트 파일로 저장하고 불러오기
- `savetxt("파일경로", 배열 [, delimiter='공백'])`
    - 텍스트 형태로 저장.
    - 각 원소는 공백을 기준으로 나뉘며 delimiter 속성으로 구분자를 지정할 수 있다. (delimiter생략시 공백)
    - 1차원과 2차원 배열만 저장 가능하다. (3차원 이상은 저장이 안된다.)
- `loadtxt("파일경로" [,dtype=float, delimiter=공백])`

```python
import numpy as np

a = np.arange(10)
b = np.arange(12).reshape(4,3)
c = np.arange(24).reshape(4,2,3)

# 한개의 배열 저장
np.save('a.npy', a) # 배열 a를 'a.npy' 파일로 저장
np.save('b', b) # 확장자를 생략해도 npy 확장자는 자동으로 붙는다.

a2 = np.load('a.npy')
a2
# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

b2 = np.load('b.npy')
b2
# [[ 0,  1,  2],
#  [ 3,  4,  5],
#  [ 6,  7,  8],
#  [ 9, 10, 11]]

# 한 파일에 여러 배열 저장 (압축)
np.savez('arr.npz', one = a, two = b)
arr = np.load('arr.npz')

arr.files # 배열의 이름들을 반환
# ['one', 'two']

a3 = arr['one']
# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

b3 = arr['two']
# [[ 0,  1,  2],
#  [ 3,  4,  5],
#  [ 6,  7,  8],
#  [ 9, 10, 11]]

# 텍스트 파일로 저장
np.savetxt('a.txt', a)
np.savetxt('b.csv', b, delimiter=',') # 1, 2차원 배열만 저장가능
b4 = np.loadtxt('b.csv', delimiter=',')
b4
# [[ 0.,  1.,  2.],
#  [ 3.,  4.,  5.],
#  [ 6.,  7.,  8.],
#  [ 9., 10., 11.]]
```
