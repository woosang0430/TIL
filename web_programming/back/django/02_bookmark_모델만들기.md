# 모델 만들기
- bookmark 디렉토리의 models.py파일
  - 모델 데이터베이스를 SQL없이 다루려고 모델을 사용한다/
  - 우리가 데이터를 객체화해서 다루겠다.
  - 모델 == 테이블
  - 모델의 필드 == 테이블의 컬럼
  - 인스턴스 == 테이블의 레코드
  - 필드의 값(인스턴스의 필드값) == 레코드의 컬럼 데이터 값

- 데이터베이스에 무엇을 저장하고 싶다.
- 그러면 모델(테이블)을 만들면 된다.!!

### models.py
```python
from django.db import models

# Create your models here
class Bookmark(models.Model):
  # 저장할 타입을 지정해준다.
  site_name = models.CharField(max_length=100)
  url = models.URLField('Site URL')
  # 링크가 자동으로 걸리기 떄문에 URLField를 사용!!
```
### 필드의 종류가 결정하는 것
1. 데이터베이스의 컬럼 종류
2. 제약사항(몇글자까지)
3. Form의 종류
4. Form에서 제약사항

## 순서
- 모델을 만들었다.
  => 데이터베이스에 어떤 데이터들을 어떤 형태로 넣을지 결정!
- makemigrations
  - 모델의 변경사항을 추적해 기록
- migrate(마이그레이션)
  - 데이터베이스에 모델의 내용을 반영(테이블 생성)
  - 모델을 수정하고 나서도 migrate를 해줘야한다.

## 터미널에서 makemigrations bookmark하기
- `python manage.py makemigrations bookmark`
  - 마이그레이션을 할 정보가 만들어진다.
  - migrations 디렉토리 안에 0001파일이 생성

## 터미널에서 migrate하기
- `python manage.py migrate bookmark 0001`
  - 모델의 내용을 반영

## 확인하기
- admin파일에서 관리자 페이지에 들록해서
- 내가 만든 모델을 관리자 페이지에 관리할 수 있도록 등록
### admin.py
```python
from django.contrib import admin

# Register your models here.
# 내가 만든 모델을 관리자 페이지에서 관리할 수 있도록 등록
from .models import Bookmark

admin.site.register(Bookmark)
```

## 서버 실행
- `python manage.py runserver`
- 주소창에 /admin 추가
- ![image](https://user-images.githubusercontent.com/77317312/119252382-e5f76500-bbe6-11eb-96e9-a31b65ee236c.png)
---------------------------
- ![image](https://user-images.githubusercontent.com/77317312/119252391-eee83680-bbe6-11eb-8458-6a9865676484.png)
- 아이디와 패스워드는 처음에 만듬!!

### bookmark에서 add
- bookmark에서 add를 누르기
- site name, site URL 지정 후 save
- ![image](https://user-images.githubusercontent.com/77317312/119252463-61591680-bbe7-11eb-90ad-9c5f920d2a04.png)

- bookmark를 생성하면 이렇게 뜸
- ![image](https://user-images.githubusercontent.com/77317312/119252537-d9274100-bbe7-11eb-9589-2ed3137c6bf6.png)
- 그런데 못생겼으니까 models 파일에서 custom해보자
### models.py
```python
from django.db import models

class Bookmark(models.Model):
  site_name = models.CharField(max_length=100)
  url = models.URLField('Site URL')
  
  def __str__(self):
    return '이름 : {0}, 주소 : {1}'.format(self.site_name, self.url)
```
- ![image](https://user-images.githubusercontent.com/77317312/119252706-9c0f7e80-bbe8-11eb-8a07-dfe3a2e35885.png)
