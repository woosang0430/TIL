## factorial

### 반복문을 사용한 factorial 구현
```python
def factorial_iterative(n):
  ret = 1
  for i in range(1, n+1):
    ret *= i
  return ret

print(factorial_iterative(5))
# 결과값 120
```

### 재귀함수를 이용한 구현
```python
def factorial_recursive(n):
  if n == 1:
    return 1
  return n * factorial(n-1)
  
print(factorial_recursive(5))
# 결과값 120
```
