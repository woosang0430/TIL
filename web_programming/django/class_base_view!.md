# CreateView, DetailView, UpdateView, ListView!!

### board/models.py
```python
from django.db import models

# 글의 category를 저장하고 있는 값
class Category(models.Model):
  # pk - 자동증가 정수 컬럼
  category_code = models.AutoField(primary_key=True)
  category_name = models.CharField(max_length=200, verbose_name='글 카테고리')
  
  def __str__(self):
    return f'{self.pk}. {self.category_name}'
  
# 게시물(글)
# title(제목), content(글내용), create_at(등록일시), update_at(수정일시), [writer(글쓴 사람 - 후에 추가.)]
class Post(models.Model):
  title = models.CharField(max_length=255, verbose_name='글제목')
  content = models.TextField(verbose_name='글내용')
  # null=False(기본) : not null 여부 - False : Not null, True : null 허용컬럼
  # blank=False(기본) : 빈 문자열 허용여부
  category = models.ForeignKey(to=Category, on_delete=models.SET_NULL, verbose_name='글 분류', null=True, blank=True)
  # 작성일시. auto_now_add=True(기본값:False) -> insert 시점의 일시를 저장하고 그 이후에는 update안함
  create_at = models.DateTimeField(verbose_name='작성일시', auto_now_add=True)
  # 수정일시. auto_now=True(기본값:False) -> insert/update 할 때 마다 그 시점의 일시를 저장
  update_at = models.DateTimeField(verbose_name='수정일시', auto_now=True)
  
  def __str__(self):
    return f"{self.pk}. {self.title}"
```
### board/forms.py
```python
from django import forms
from .models import Post

# form 클래스 - forms.Form 상속
# ModelForm 클래스 - forms.ModelForm 상속

# class PostForm(forms.Form):
#   title = forms.CharField()
#   content = forms.chatField(widget=forms.Textarea)

class PostForm(forms.ModelForm):
  # 내부(nested/inner) 클래스로 Meta 클래스를 정의 -> ModelForm관련 설정
  def Meta:
    model = Post # Form을 만들 때 참조할 Model클래스 지정
    fields = '__all__' # 자동 등록되는 친구들은 Form Field로 사용안한다.
    # Model의 Field들 중 Form Field로 만들 Field들 지정
```

### board/views.py
```python
from django.shorcuts import render, redirect
from django.views.generic import CreateNiew, DetailView, UpdateView, ListView
from django.urls import reverse_lazy

from .models import Post
from .forms import PostForm

# 글 등록
# CreateView 등록(저장-insert 처리)
# get 방식 요청 : 입력양식 화면으로 이동(render())
# post 방식 요청 : 입력(등록) 처리
#   - 처리 성공 : 성공 페이지로 이동(redirect())
#   - 처리 실패 : 입력양식 화면으로 이동(render())
class PostCreateView(CreateView):
  template_name = 'board/post_create.html' # 입력방식 화면 template 경로
  form_class = PostForm # 요청파라미터를 처리할 Form을 지정
  # success_url = reverse_lazy('board:detail') # 등록 처리 후 이동할 경로 -> redirect방식 이동 -> View의 url을 등록
  
  # success_url 설정을 대신 success_url은 args를 못받음
  #   success_url에서 insert한 Model 객체를 접근하려면 이 메소드를 overriding 해야한다.
  #   insert한 모델 객체 조회 : self.object
  def get_success_url(self):
    # 반환값 : 등록 성공 후 redirect 방식으로 이동할 View의 url을 문자열로 반환
    # args : path parameter로 전달할 값들을 리스트에 순서대로 담는다.
    return reverse_lazy('board:detail', args=[self.object.pk]
    

# 하나의 글 정보 조회(pk)
# DetailView - pk로 조회한 결과를 template으로 보내주는 generic View
#   - url 패턴 : pk를 path 파라미터로 받는다. <type:pk> 변수명을 pk로 지정해야한다. 이 path parameter값을 이용해 select
class PostDetailView(DetailView):
  template_name = 'board/post_detail.html' # 응답할 template 경로
  model = Post # pk로 조회할 Model 클래스
  # pk로 조회할 Model 클래스. 조회결과를 'post'(모델클래스명을 소문자), 'object' 라는 이름으로 template으로 전달
  
# urls.py에서 한줄로 끝내기
path('detail/<int:pk>', DetailView.as_view(template_name='board/post_detail.html', model=Post), name='detail')


글 수정처리
  UpdateView
    - GET 요청처리 : pk로 수정할 정보를 조회해서 template(수정 form)으로 전달(render())
    - POST 요청처리 : update 처리.(redirect방식으로 View를 요청)
    - template_name : 수정 form template파일의 경로
    - form_class : Form/ModelForm 클래스 등록
    - model : Model 클래스 등록(수정폼 template에 전달

```

































