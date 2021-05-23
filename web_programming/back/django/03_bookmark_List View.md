## Bookmark_list View!!
- CRUD : Create, Read, Update, Delete

# CRUD의 별도의 List페이지 만들기
### 뷰에는 클래스형 뷰, 함수형 뷰로 나뉜다.
- 웹 페이지에 접속한다. -> 페이지를 본다.
- URL을 입력 -> 웹 서버가 뷰를 찾아 동작시킨다. => 응답

#### bookmark/views.py
```python
from django.shortcuts import render
from django.views.generic.list import ListView
from .models import Bookmark

# 클래스형 뷰 생성
class BookmarkListView(ListView):
  model = Bookmark
```
- 사용자가 어떤 URL을 입력했을 때 이 뷰가 동작할꺼야 를 설정해야됨
- config/urls.py에서 설정한다.

#### config/urls.py
```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
  path('bookmark/', include('bookmark.urls')),
  # http://127.0.0.1/admin/
  path('admin/', admin.site.urls),
]
```
## URL
- 1차 -> 2차 -> 3차
- http://127.0.0.1/bookmark/?
- http://127.0.0.1/중앙창구/외과
- http://127.0.0.1/중앙창구/내과

## bookmark/urls.py 생성
```python
from django.urls import path
from .views import BookmarkListView

urlpatterns = [
  # http://127.0.0.1/bookmark/???
  # ????
  path('', BookmarkListView.as_view(), name='list'),
] 
```
- 이렇게 하고 실행하면?!
- ![image](https://user-images.githubusercontent.com/77317312/119258402-6e383300-bc04-11eb-9f5a-276561ad4c93.png)
- 이런 에러 메시지가 뜸 --> 이것은 template이 없다는 것!!

## bookmark안에 templates 디렉토리 생성
- 보통 관례적으로 app이름(지금은 bookmark)이랑 똑같은 폴더를 만들고 합친다.
- ![image](https://user-images.githubusercontent.com/77317312/119258528-0504ef80-bc05-11eb-86ed-ed5d1db8bdf4.png)
