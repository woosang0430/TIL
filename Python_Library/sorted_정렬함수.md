# sorted 정렬
- dictionary에서는 .sort()정렬이 안된다.
1. 인자 없이 sorted 사용
- `a = [(1, 2), (0, 3), (2, 6), (1, 5)]`
```python
b = sorted(a)
# [(0,3), (1,2), (1,5), (2,6)]
```

2. 인자의 *key=함수* 를 같이 넘기면 함수 반환값 기준으로 정렬
```python
c = sorted(a, key= lambda x : x[1]) # 1번 인덱스로 정렬
# [(2,6),(1,5),(0,3),(1,2)]
```

3. 정렬의 default 는 오름차순으며 reverse=True하면 내림차순 (변수 앞에 `-`를 붙이면 원래의 값의 반대로 정렬)
```python
d = sorted(a, key= lambda x: -x[0])
d = sorted(a, key= lambda x: x[0], reverse=True)
# [(2,6), (1,2), (1,5), (0,3)]
```

4. 처음 정렬이 똑같을 경우 다음 정렬을 정의 하고 싶으면 중괄호로 묶기
```python
e = sorted(a, key= lambda x: (x[0], -x[1]))
# [(0,3), (1,5), (1,3), (2, 6)]
```

5. 딕셔너리의 values값들로 정렬하고 싶을때 (대신 key와 value가 튜플로 묶인 리스트로 반환)
```python
dict = {c : 2, a : 6, b : 1}
sort_dict = sorted(dict.items(), key= lambda x: x[1])
# [(b, 1), (c, 2), (a, 6)]
```
