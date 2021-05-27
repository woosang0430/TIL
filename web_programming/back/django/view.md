# View

## 1. View 개요
- 사용자가 요청을 처리하여 응답하는 작업
  - 1개의 HTTP 요청에 대하여 1개의 View가 실행되어 요청된 작업을 처리
- app내의 urls.py(없으면 만들자)에 사용자가 View를 요청할 URL을 mapping한다.
  - `path(요청URL, view, name='이름')`
- View 구현의 두가지 방법
  - **함수 기반 View(Function Based View - FBV)**
    - 각 기능을 함수별로 구현한다.
    - 요청에 대한 처리 구현을 직접 다 해야한다.
    - 구현에 대한 자유도가 높은 대신 View들을 구현할 때 공통 로직이 반복되는 단점이 있음
  - **클래스 기반 View(Class Based View - CBV)**
    - View들을 역할 별로 그 기능을 미리 구현한 View를 상속받아 클래스로 구현
    - View 구현이 간단해 지지만 진입장벽이 높다.(상속받는 View에 대한 이해가 요구)
    - https://docs.djangoproject.com/en/3.0/ref/class-based-views/

## 2. 함수 기반 View
- 반환값
  - Client에게 응답할 내용을 Response 객체에 담아 반환
  - `django.http.HttpResponse`객체를 생성해 반환
    - 응답을 위한 정보(응답 content type, 응답 데이터, 응답 헤더 값 등등)을 HttpResponse객체에 속성으로 담아 반환
  - `django.shorcuts.render()`
    - 응답 처리를 위해 구현한 Template호출하여 응답할 경우 render() short cut 함수를 사용
  - `django.shorcuts.redirect()`
    - 요청한 웹 브라우저가 다른 URL로 재 요청하도록 할 경우 redirect() short cut 함수를 사용
  - `django.http.JsonResponse`
    - https://docs.djangoproject.com/en/3.0/ref/request-response/#jsonresponse-objects
    - HttpResponse의 하위 클래스로 JSON 형식의 응답을 할 경우 사용
    - dictionary를 받아 JSON으로 변환하여 사용자에게 전달

- `urls.py`
>  - 사용자 요청 URL과 그 요청을 처리할 View를 연결해 등록
>    - `path('요청 경로', 함수, name='설정이름')`
>    - `path('hello', views.hello, name='hello')`
>    - `path('detail/<int:pk>', views.post_detail, name='post_detail')`
>  - path converter(Path parameter)
>    - url 경로를 이용해 view가 사용할 값을 전달 할 때 사용
>    - 기존의 querystring을 대신
>    - <타입:이름> 형식으로 path의 요청 경로에 추가
>      - 타입은 전달 값의 Data Type, 이름은 처리할 View에서 이 값을 받을 매개변수 이름을 지정
>      - `path('detail/<int:pk>', views.post_detail, name='post_detail')`
>      - `http://localhost:8000/detail/3`
>      - `def post_detail(request, post_id):`
- ![image](https://user-images.githubusercontent.com/77317312/119793966-076f8e00-bf12-11eb-88ba-86e490b4d29b.png)

- **HttpRequest**
  - 사용자가 요청할 때 보낸 모든 정보들을 담고 있으며 그와 관련된 기능을 제고
  - View 함수의 첫번째 매개변수로 선언하면 django 실행환경이 View호출 시 제공
- **HttpRequest 주요 속성**
  - `method` : 요청 방식을 문자열로 제공
  - `get` : GET 방식으로 전달된 요청 파라미터를 name:value 형태로 dictionary 형식의 객체에 담아 제공
  - `post` : POST 방식으로 전달된 요청 파라미터를 name:value 형태로 dictionary 형식의 객체에 담아 제공
  - `files` : upload된 모든 파일을 담고 있는 dictionary형태의 객체. key: form name, value: 업로드된 파일- UploadFile 객체
    - https://docs.djangoproject.com/en/3.0/ref/files/uploads/#django.core.files.uploadedfile.UploadedFile
  - `body` : POST 방식으로 전달된 요청 파라미터를 원래 형태의 문자열로 전달(id=abc&count=30)
  - `cookie` : 클라이언트가 전송한 쿠키들을 dictionary에 담아 전달한다. (쿠키이름 : 쿠키값)
  - `session` : 현재 session의 정보들(session data)를 dictionary로 반환. session에 값을 추가하거나 조회할 때 사용
  - `user` : 로그인한 User객체를 전달한다.(AUTH_USER_MODEL)
```python
from django.shortcuts import render, redirect
from django.http import HttpResponse
from .models import Question, Choice

def list(request):
  question_list  = Question.objects.all().order_by('-pub_date')
  # template을 호출 - render(request, 'template의 경로', [, template에 전할달 값 - dictionary]
  return render(request, 'polls/list.html', {'question_list':question_list})

# vote_form View(한개 질문에 대한 정보를 조회해서 응답)
def vote_form(request, question_id):
  # question_id 질문 조회
  try:
    question = Question.objects.get(pk=quesion_id)
    return render(request, 'polls/vote_form.html', {'question':question})
  except:
    return render(request, 'polls/error.html', {'error_message':'없는 질문을 조회하셨습니다.'})

def vote(request):
  # 요청 파라미터 조회 + 검증
  # post 요청 : request.POST.get('요청파라미터') request.POST['이름']
  # get 요청 : request.GET.get('요청파라미터') request.GET['이름']
  choice_id = request.POST.get('choice')
  # 요청파리미터 검증 : choice로 넘어온 값이 없다면(None) 다시 vote_form으로 이동
  question_id = request.POST.get('question_id')
  if not choice_id:
    question = Question.objects.get(pk=question_id)
    return render(request, 'polls/vote_form.html', {'question':question, 'error_message':'보기를 선택하세요'})
    
  # Business Logic처리 - 투표처리
  # update할 보기(Choice)를 조회
  choice = Choice.object.get(pk=choice_id)
  choice.vote += 1
  # pk가 있으면 update, 없으면 insert
  choice.save()
  return redirect(f'/polls/vote_result/{question_id}')
  
def vote_result(request, question_id):
  question = Question.object.get(pk=question_id)
  return render(request, 'polls/vote_result.html', {'question':question})
```

## 3. Class 기반 View
- View의 각 기능을 클래스로 작성
  - https://docs.djangoproject.com/en/3.0/topics/class-based-views/
- 장점
  - 클래스로 구현하므로 객체지향 프로그래밍의 장점을 누릴 수 있다. 특히 반복적인 코드들은 상속을 이용해 효율적으로 작성 할 수 있다.
  - 장고에서 제공하는 Generic View를 상속받아 구현할 경우 아주 적은 코드로 View를 작성할 수 있다.
- 단점
  - Generic View는 추상화가 많이 되어 있어 간편한 대신 커스터마이징 하기가 어렵다.
    - 커스터마이징은 Method overriding을 이용해 할 수 있다. 그래서 그 구조를 잘 알지 못하면 어렵다.

### - Base View
- View들의 가장 기본 기능들을 구현해 제공하는 View
- View : 모든 View들의 최상위 View
- TemplateView : 설정된 template으로 rendering하는 View
- RediectView : 주어진 URL로 redirect 방식 이동 처리 하는 View
### - Generic Display View
- Model을 이용해 조회한 결과를 리스트로 보여주거나 상세 페이지로 보여주는 View들
- ListView : 조회한 모델객체 목록을 보여주는 View
- DetailView : 조회한 하나의 모델객체를 보여주는 View

## 3-1. Class기반 View -> Generic View의 종류
- 요청 파라미터로 전달된 값들을 이용해 Model을 생성(insert), 수정(update), 삭제(delete)하는 View들
  - FormView : HTML 입력 폼(Form Data)관련 처리 기능을 제공하는 View
    - Template에 입력 Form을 만들고 그 Form에서 사용자가 입력해 전송한 요청 파라미터 처리
    - Validation(입력데이터 검증)과 처리(저장/변경/삭제)를 지원
  - CreateView : 입력 폼을 만들고 그 폼에서 전송된 값을 등록(insert) 처리
  - UpdateView : 수정 폼을 만들고 그 폼에서 전송된 값으로 변경(update) 처리
  - DeleteView : 삭제를 위한 폼을 만들고 그 폼에서 요청한 데이터를 삭제(delete) 처리
```python
# views.py에 구현
class PostDetailView(DetailView):
  ...
class PostListView(ListView):
  ...

# urls.py에 URL 매핑
path('post_detail/<int:pk>', PostDetailView.as_view(), name='post_detail')
path('post_list', PostListView.as_view(), name='post_list')
```
- View설정시 View클래스이름.as_view() 메소드를 호출
- as_view()는 View객체를 생성하고 dispatch()메소드를 호출
- dipatch() 메소드는 HTTP 요청 방식에 맞는 처리 메소드를 찾아 호출한다.
