## django 프로젝트 생성
- `django-admin startproject config .`
- 기본 config 폴더들이 생성

## 확인하기
- `python manage.py runserver`
  - 빨간 글은 데이터베이스 migrate이 안되서 그럼

## migrate
- `python manage.py migrate`
  - 데이터베이스 migrate하기
  - db의 기본 테이블 생성

## 관리자 권한 생성
- `python manage.py createsuperuser`
  - Username : \<관리자계정>
  - Email address : 생략
  - Password : \<비밀번호>
  - Password (again) : \<비밀번호>

## bookmark app 만들기
- `python manage.py startapp bookmark`
  - ![image](https://user-images.githubusercontent.com/77317312/119232781-67a4af80-bb61-11eb-853a-a88f54f9a29f.png)
  - 화면을 구성하는 부분
    - `views.py` : 실제 서버쪽에서 돌아가는 일을 처리하는 애
  - `models.py` : 데이터베이스를 관리해주는 중간자(sql을 몰라도 가능! orm) --> orm을 사용하기 위한 목적
  - `tests.py` : 기능이 추가되거나 변경되었을 때 잘 동작하는기 확인하는 곳
  - `apps.py` : signal을 불러오는 역할?
  - `admin.py` : 우리가 만든 모델을 django에 기본으로 있는 관지라 페이지에 관리하기 위해 등록해주는 역활

## app을 만든 후
- `config/settings.py`에 등록해줘야함
- `settings`파일 안에 `INSTALLED_APPS`리스트에 넣어주기
- ![image](https://user-images.githubusercontent.com/77317312/119233118-63c55d00-bb62-11eb-9f95-5ef49d80fb38.png)
