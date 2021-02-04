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

## 최소공배수 찾기(lcm)
```python
def lcm(n, m):
  return n*m/gcd(n, m)
# n과 m을 곱한값을 최대공약수로 나눈다.
```
