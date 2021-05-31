# Project와 Apps
## 프로젝트 만들기
- `django-admin startproject 프로젝트명`
  - 이렇게 생성 시 config디렉토리 명이 프로젝트명이랑 같게 설정됨
## 프로젝트 디렉토리 생성 후
- 프로젝트를 생성하고 싶은  디렉토리를 만들고 안에 들어온 후
  - `mkdir project` (프로젝트 디렉토리 생성
  - `cd mysite`
  - `django-admin startproject config .`


## App 만들기
1. `python manage.py startapp App이름`
2. project/전체설정경로/settings.py에 등록
  - installed_apps 설정에 생성한 app의 이름 등록
  - ![image](https://user-images.githubusercontent.com/77317312/119466556-b039b400-bd7f-11eb-9853-a37e0871ca87.png)
3. project/전체설정경로/urls.py에 path 등록
  - ![image](https://user-images.githubusercontent.com/77317312/119466695-d9f2db00-bd7f-11eb-9aea-d31efee1784c.png)

## Project 구조
- ![image](https://user-images.githubusercontent.com/77317312/119466789-ed9e4180-bd7f-11eb-8388-953f0f5f8f14.png)
- **config** -> 프로젝트 전체 설정 디렉토리
  - `settings.py`
    - 현재 프로젝트에 대한 설정을 하는 파일
  - `urls.py`
    - 최상위 URL 패턴 설정
    - 사용자 요청과 실행할 app의 urls.py를 연결해준다.
  - `wsgi.py`
    - 장고를 실행시켜 주는 환경인 wsgi에 대한 설정
- **app 디렉토리** (polls)
  - `admin.py`
    - admin 페이지에서 관리할 model 등록
  - `apps.py`
    - Application이 처음 시작할 때 실행될 코드 작성
  - `models.py`
    - app에서 사용할 model 코드 작성
  - `views.py`
    - app에서 사용할 view 코드 작성
  - `urls.py`
    - 사용자 요청 URL과 그 요청을 처리할 View를 연결하는 설정 작성
- **manage.py**
  - 사이트 관리를 하는 스크립트

### manage.py
- python manage.py 명령어 모음
  - `startapp` : 프로젝트에 app을 새로 생성
  - `makemigrations` : 어플리케이션의 변경을 추적해 DB에 적용할 변경사항을 정리
  - `migrate` : makemigrations로 정리된 DB 변경 내용을 Database에 적용
  - `sqlmigrate` : 변경사항을 DB에 적용할 때 사용한 SQL 확인
  - `runserver` : 테스트 서버를 실행
  - `shell` : 장고 shell 실행
  - `createsuperuser` : 관리자 계정 생성
  - `changepassword` : 계정의 비밀번호 변경
- https://docs.djangoproject.com/en/3.0/ref/django-admin/

## 전체적인 흐름
- ![image](https://user-images.githubusercontent.com/77317312/119468295-45897800-bd81-11eb-922b-bf9715fab620.png)































