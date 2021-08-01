## bisect
- 이진 탐색 알고리즘을 사용하여 특정 값이 있는 idx 검색
    1. 주어진 `list`에 값 `x`가 있을 때, `x`가 들어갈 인덱스를 구하는 함수
    2. 값 `x`를 이진탐색으로 넣는 함수
    
- `bisect.bisect(list, x, lo = 0, hi = len(lst))`
    - `list`라는 오름차순 정렬 배열에 x값이 들어갈 **index** 반환
    - `lo`와 `hi`를 이용해 배열의 영역을 제어
- `bisect.bisect_left(list, x)`
    - list에서 x값이 들어가야할 **index** 반환
- `bisect.bisect_right(list, x)`
    - `bisect_left`와 비슷하지만, 동일한 값이 있을 경우 **동일 값 오른쪽 index** 반환
- `bisect.insort(list, x)`
    - binary search로 x값을 lst에 넣는다.
   
- 사용 예제
```python
import bisect
data = [1, 2, 4, 4, 8]
#            ^     ^
print(bisect.bisect(data, 4))
print(bisect.bisect_left(data, 4))
print(bisect.bisect_right(data, 4))
"""
결과값
2
2
4
"""
```
