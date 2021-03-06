# Python 폴더 생성(os.mkdir) 사용 방법 및 예제

- 구문
- os.mkdir 작성 방법
```python
import os

os.mkdir(경로)
```
- 만약 mkdir에 짖어한 경로가 존재하지 않는 경우 [FileNotFoundError]발생

## 폴더 생성 예제
```python
import os

path = './dir/tmp'

os.mkdir(path)
# tmp라는 폴더 만들기
```

## 여러개 폴더 생성
```python
import os

path_list = ['./dir/tmp1', './dir/tmp2', './dir/tmp3',]

for path in path_list:
    os.mkdir(path)
```

## os.makedirs
- mkdir로 폴더를 생성할 때 지정한 경로가 존재하지 않으면 [FileNotFoundError]가 발생
- makedirs를 사용하면 경로가 없는 경우 중간에 지정한 폴더를 생성
```python
import os

path  = './dir/sub_dir/tmp1'

os.makedirs(path)
# sub_dir이랑 tmp1폴더를 생성
```
- **주의사항**
- makedirs에 지정한 폴더 중 마지막에 지정한 폴더가 이미 만들어져 있는 경우에는 에러 발생
- 인스턴스로 exist_ok=True를 넘기면 지정 폴더가 존재하지 않으면 생성, 존재하면 아무것도 하지 않음
```python
import os

path = './dir/sub_dir/temp1'

os.makedirs(path, exist_ok=True)
```
