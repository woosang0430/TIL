# Dynumic_programming(동적계획법)
- 하나의 큰 문제를 여러 개의 공통되는 작은 문제로 나누어 작은 문제의 정답들을 결합하여 알고리즘을 푸는 과정
- 규칙을 찾는 문제이다.

## 접근 방법
1. Bottom Up 방법
  - 작은 문제에서 큰 문제로 반복문 호출
2. Top Down 방법
  - 큰 문제에서 작은 문제로 재귀 호출

## 동적계획법 활용
- 피보나치 수열(Bottom Up 방식)
```python
def fibonach(n):
  fibList = [1, 1]
  for i in range(2, n+1):
    fibList.append(fibList[i-2]+fibList[i-1])
  return fibList[-1]
```
- 피보나치 수열(Top Down 방식)
```python
def fib(n):
  if n in [0, 1]:
    return 1
  return fib(n-1) + fib(n-2)
```

## Memoization
- 중복된 계산을 방지하기 위한 장치
- 배열 or 해쉬를 활용하는 것이 핵심
```python
memo = {0:1, 1:1}

def fib(n):
  if n in memo:
    return memo[n]
  result = fib(n-1) + fib(n-2)
  memo[n] = result
  return result
```

## Dynamic Programming 예시
- `data = [3, 4, 5, 6, 1, 2, 5]`
- 이웃하지 않는 숫자들의 합의 최댓값은?
![image](https://user-images.githubusercontent.com/77317312/127170283-72af0331-5218-4176-b6f1-2bac80cabc16.png)

- 규칙
 
![image](https://user-images.githubusercontent.com/77317312/127170500-064d6d0e-130b-4301-9987-3274defb4643.png)
```python
def solution(data):
  if len(data) == 1:
    return data[0]
  result = [data[0], max(data[0], data[1])
  for i in range(2, len(data)):
    result.append(max(data[i-1], data[i-2]+data[i]))
  return result[-1]
```
