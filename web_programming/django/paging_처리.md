# paging 처리
## ListView에서는 paging기능을 지원한다.

### board/models.py
```python
from django.db import models
from django.db.models.deletion import SET_NULL

# 글의 category를 저장하고 있는 값
class Category(models.Model):
  # pk- 자동증가 정수 컬럼
  category_code = models.AutoField(primary_key=True)
  category_name = models.CharField(max_length=200, verbose_name='글 카테고리')
  
  def __str__(self):
    return f'{self.pk}. {self.category_name}'

# 게시물(글)
# title(제목), content(글내용), create_at(등록 일시), update_at(수정 일시)
class Post(models.Model):
  title = models.CharField(max_length=255, verbose_name='글제목') # NOT NULL,  빈문자열 허용 X
  content = models.TextField(verbose_name='글내용') # TextField : 대용량 text
  # null=False(기본) : not null 여부 - False  : Not null, True : null 허용컬럼
  # blank=False(기본) : 빈 문자열 허용여부
  category = models.ForiegnKey(to=Category, on_delete=models.SET_NULL, verbose_name='글 분류', null=True, blank=True)
  # 작성일시. auto_now_add=True(기본값:False) -> insert 시점의 일시를 저장하고 그 이후에는 update하지 않음
  create_at = models.DateTimeField(verbose_name='작성일시', auto_now_add=True)
  # 수정일시. auto_now=True(기본값:False) -> insert/update 할 때 마다 그 시점의 일시 저장
  update_at = models.DateTimeField(verbose_name='수정일시', auto_now=True)
  
  def __str__(self):
    return f'{self.pk}. {self.title}'
```

# 글 목록
- ListView 구현
- template_name : 결과를 보여줄 template 경로
- model : 조회할 모델클래스 지정
- 조회결과를 template에 'object_list', '모델이름소문자_list(post_list)'라는 이름으로 전달
- ListView는 paging기능 지원

### paging 처리
  - class 변수 : `paginate_by` = 한페이지의 데이터 개수
  - 요청 시 url : url?page=번호 --> http://127.0.0.1:8000/board/list?page=2, page를 생략하면 1번 페이지를 조회
  - 페이지  번호를 template에서 출력하기 위한 값들을 만들어 template에 전달. => `get_context_data()`를 오버라이딩
- `context` data : view가 template에게 전달하는 값(dictionary). key-value쌍. key : context, value : context value
- `get_context_data()` : Generic View를 구현할 때 template에게 추가적으로 전달해야하는 context data가 있을 때 오버라이딩.
- paging관련 값들을 context data에 추가
  - 이전/다음 페이지 그룹 유무(그룹의 시작/끝페이지)
  - 이전/다음 페이지 번호(그룹의 시작/끝페이지)
  - 현재 페이지 속한 페이지 그룹의 페이지 범위(시작 ~ 끝 페이지 번호)
### board/views.py
```python
class PostListView(ListView):
  template_name = 'post_list.html'
  model = Post
  
  paginate_by = 10 # 한페이지에 10개씩
  
  def get_context_data(self, **kwargs):
    # 부모객체의 get_context_data()를 호출해서 generic view가 자동으로 생성한 Context data를 받아온다.
    context = super().get_context_data(**kwargs)
    # ListView에서 paginate_by 속성을 설정하면 context data에 paginator객체가 등록된다.
    paginator = context['paginator']
    page_group_count = 10 # 페이지그룹에 속한 페이지 개수
    current_page = int(self.request.GET.get('page', 1))
    # CBV에서 HttpRequest는  self.request로 사용할 수 있다.
    
    # 페이지 그룹의 페이지 범위 조회
    start_idx = int((current_page - 1)/page_group_count) * page_group_count
    end_idx = start_idx + page_group_count
    page_range = paginator.page_range[start_idx:end_idx]
    
    start_page = paginator.page(page_range[0])
    end_page = paginator.page(page_range[-1])
    
    has_previous = start_page.has_previous() # 시작의 이전 페이지가 있는지 여부
    has_next = end_page.has_next() # 마지막 페이지의 다음 페이지가 있는지 여부
    
    context['page_range'] = page_range
    if has_previous:
      context['has_previous`] = has_previous
      context['revious_page_no'] = start_page.previous_page_number
    if has_next:
      context['has_next'] = has_next
      context['next_page_no'] = end_page.next_page_number
      
    return context
```
## HTML에서 paging 처리
### paging 처리
- paginator변수 : Paginator
- page_obj변수 : 현재 페이지의 Page 객체
- is_paginated : 페이징 처리 유무(ListView : paginate_by 설정하면 True, 안했으면 False)
```html
{% extends 'layout.html' %}

{% block title %} 글목록 {% endblock title %}

{% block contents %}
<h1>글목록</h1>
<table class="table">
    <thead class="thead-dark">
        <tr>
            <th>글번호</th>
            <th>제목</th>
        </tr>
    </thead>
    <tbody>
        {% for post in object_list %}
            <tr>
                <td>{{post.pk}}</td>
                <td>
                    <a href="{% url 'board:detail' post.pk %}">
                        {{post.title}}
                    </a>
                </td>
            </tr>
        {% endfor %}
    </tbody>

</table>

<!-- Paging 처리 -->
{% if is_paginated %}
  <ul class="pagination justify-content-center">
    {% if has_previous %}
      <li class="page-item">
        <a href="{% url 'board:list' %}?page={{previous_page_no}}" class='page-link'>previous</a>
      </li>
    {% else %}
      <li class="page-item">
        <span class='page-link'>previous</span>
      </li>
    {% endif %}
    <!-- 페이지 링크 -->
    {% for page in page_range %}
      <!-- page == 현재페이지번호(page_obj.number) -->
      {% if page == page_obj.number %}
        <li class='page-item active'>
          <span class='page-link'>{{page}}</span>
        </li>
      {% else %}
        <li class='page-item'>
          <a href="{% url 'board:list' %}?page={{page}}" class='page-link'>{{page}}</a>
        </li>
      {% endif %}
    {% endfor %}
    <!-- 다음 페이지 그룹 이동 링크 -->
    {% if has_next %}
      <li class='page-item'>
        <a href="{% url 'board:list' %}?page={{next_page_no}}" class='page-link'>next</a>
      </li>
    {% else %}
      <li class='page-item'>
        <span class='page-link'>next</span>
      </li>
    {% endif %}
  <ul>
{% endif %}
    
{% endblock contents %}
```
