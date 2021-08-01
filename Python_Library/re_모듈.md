##  import re (정규표현식)
- 문자열의 구분자가 여러개있을 경우 `split()` 함수를 이용하면 한개를 기준으로 나눈다.
- `re.split()` 함수를 이용하면 여러개의 구분자를 기준으로 나눌 수 있다.
- 첫번째 인자는 나눌 구분자를 정규식으로! 리스트로 묶어서!, 두번째 인자는 나눌 객체
```python
import re
my_str = 'Hello wolrd, Hello; python'
int_str = '55-50+40'

print(re.split('[,:]', my_str)) # , ; 두가지를 기준으로 나눈다.
print(re.split('[-+]', int_str)) # - + 두가지를 기준으로 나눈다.
# >> ['Hello world', ' Hello', ' python']
# >> ['55', '50', '40']
```
