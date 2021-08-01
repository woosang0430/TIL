a = [[1,0,0],[1,0,0],[1,0,0]]
n = len(a)

# 방법 1
def rotate(a):
  n = len(a)
  ret = [[0]*n for _ in range(n)]
  for i in range(n):
    for j in range(n):
      ret[j][n-i-1] = a[i][j]
  return ret
"""
결과
[[1,1,1],
[0,0,0],
[0,0,0]]
"""

# 방법 2
def rotate(a):
  ret = list(zip(*a[::-1]))
  return ret
"""
결과
[(1,1,1),
(0,0,0),
(0,0,0)]
"""
