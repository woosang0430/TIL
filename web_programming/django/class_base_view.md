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

## ---------------------------------------------------------------- ##

# 하나의 글 정보 조회(pk)
# DetailView - pk로 조회한 결과를 template으로 보내주는 generic View
#   - url 패턴 : pk를 path 파라미터로 받는다. <type:pk> 변수명을 pk로 지정해야한다. 이 path parameter값을 이용해 select
class PostDetailView(DetailView):
  template_name = 'board/post_detail.html' # 응답할 template 경로
  model = Post # pk로 조회할 Model 클래스
  # pk로 조회할 Model 클래스. 조회결과를 'post'(모델클래스명을 소문자), 'object' 라는 이름으로 template으로 전달
  
# urls.py에서 한줄로 끝내기
path('detail/<int:pk>', DetailView.as_view(template_name='board/post_detail.html', model=Post), name='detail')

## ---------------------------------------------------------------- ##

# 글 수정처리
#   UpdateView
#     - GET 요청처리 : pk로 수정할 정보를 조회해서 template(수정 form)으로 전달(render())
#     - POST 요청처리 : update 처리.(redirect방식으로 View를 요청)
#     - template_name : 수정 form template파일의 경로
#     - form_class : Form/ModelForm 클래스 등록
#     - model : Model 클래스 등록(수정폼 template에 전달할 값을 조회하기 위해)
#     - success_url : 수정 처리 후 redirect 방식으로 이동할 View의 url(path parameter로 update한 Model정보를 사용할 경우 get_success_url()를 오버라이딩)

class PostUpdateView(UpdateView):
  template_name = 'board/post_update.html'
  form_class = PostFrom
  model = Post
  
  def get_success_url(self):
    return reverse_lazy('board:detail', args=[self.object.pk])

## ---------------------------------------------------------------- ##

# 삭제처리
#   - generic view : deletevide를 사용 ==> 삭제 확인 화면을 거쳐 삭제 처리
#   - funcion view : path parameter로 삭제할 글의 id(pk)를 받아 삭제 처리
def post_delete(request, pk):
  post = Post.objects.get(pk=pk) # 삭제할 데이터 조회
  post.delete() # post 객체의 pk와 동일한 데이터 삭제
  return redirect('/') # 홈으로
    
## ---------------------------------------------------------------- ##

# 글목록
# ListView 구현
# template_name : 결과를 보여줄 template 경로
# model : 조회할 모델클래스 지정
# 조회결과를 template에 'object_list', '모델이름소문자_list(post_list)'라는 이름으로 전달.
# ListView는 paging기능 지원

class PostListView(ListView):
  template_name = 'board/post_list.html'
  model = Post
  
  # pagin 처리
  #   - class변수 : paginate_by = 한페이지의 데이터 개수
  #   - 요청 시 url : url?page=번호 --> http://1270.0.0.1:8000/board/list?page=2,  page를 생략하면 1번 페이지를 조회.
  paginate_by = 10 # 한페이지에 10개씩 (원하는데로)
  
  # context data : view가 template에게 전달하는 값(dictionary). key-value쌍. key --> context name, value --> context value
  # get_context_data() : Generic View를 구현할 때 template에게 추가적으로 전달해야하는 context data가 있을때 오버라이딩
  # paging관련 값들을 context data에 추가
  #   - 이전/다음 페이지 그룹 유무(그룹의 시작/끝페이지)
  #   - 이전/다음 페이지 번호(그룹의 시작/끝페이지)
  #   - 현재 페이지에 속한 페이지 그룹의 페이지 범위(시작 ~ 끝 페이지 번호)
  def get_context_data(self, **kwargs):
    # 부모객체의 get_context_data()를 호출해서 Generic View가 자동으로 생성한 context data를 받아온다.
    context = super().get_context_data(**kwargs)
    # ListView에서 paginate_by 속성을 설정하면 context data에 Paginator객체가 등록된다.
    paginator = context['paginator']
    page_group_count = 10 # 페이지그룹에 속한 페이지 개수
    current_page = int(self.request.GET.get('page', 1))
    # CBV에서 HttpRequest는 self.request로 사용할 수 있다.

    # 페이지 그룹의 페이지 범위 조회
    start_idx = int((current_page - 1) / page_group_count) * page_group_count)
    end_idx = start_idx + page_group_count
    page_range = paginator.page_range[start_idx : end_idx]

    # 그룹의 시작 페이지가 이전페이지가 있는지, 그룹의 마지막 페이지가 다음 페이지가 있는지 여ㅑ부 + 페이지 번호
    start_page = paginator.page(page_range[0]) # 시작  페이지의 Page객체
    end_page = paginator.page(page_range[-1]) # 마지막 페이지의 Page객체

    has_previous = start_page.has_previous() # 시작의 이전페이지가 있는지 여부
    has_next = end_page.has_next() # 마지막 페이지의 다음 페이지가 있는지 여부

    context['page_range'] = page_range
    if has_previous:
      context['has_previous'] = has_previous
      context['previous_page_no'] = start_page.previous_page_number # 시작 페이지의 이전페이지 번호

    if has_next:
      context['has_next'] = has_next
      context['next_page_no'] = end_page.next_page_number # 마지막 페이지의 다음 페이지 번호

    return context
```
