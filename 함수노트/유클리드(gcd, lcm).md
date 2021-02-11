# 유클리드 알고리즘

## 최대공약수 찾기(gcd)
```python
def gcd(n,m):
  n, m = max(n, m), min(n, m)
  
  while m != 0:
    temp = n%m
    n, m = m, temp
    return n
```
## 최대공약수 재귀적 접근법
- 두 자연수 A, B에 대하여 (A > B) A를 B로 나눈 나머지를 R이라고 한다.
- 이때 A와 B의 최대공약수는 B와 R의 최대공약수와 같다.
```python
def gcd(a, b):
  if a % b == 0:
    return a
   return gcd(b, a % b)
```

## 최소공배수 찾기(lcm)
```python
def lcm(n, m):
  return n*m/gcd(n, m)
# n과 m을 곱한값을 최대공약수로 나눈다.
```
