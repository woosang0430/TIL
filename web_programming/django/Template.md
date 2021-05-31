# Template
- 사용자에게 응답할 화면을 구현한 컴포넌트
  - HTML을 템플릿으로 작성하며 Template문법을 이용해 동적 처리코드를 HTML 중간 중간에 작성
  - 구성 언어
    - HTML 구성 언어(html, css, javescript) => 정적 화면 구성 코드
    - Django template 문법 => 동적 처리 코드
- Template 엔진
  - Django template script를 해석하여 사용자에게 응답할 최종 HTML을 생성한다.(Rendering).
  - View에서 전달된 데이터들을 이용해 사용자에게 응답할 화면을 동적으로 생성

- Template 파일
  - 확장자를 html로 한다.
  - Application 디렉토리 안에 /templates/app명 폴더 아래 위치시킨다.
  - 여러 App이 공통으로 사용하는 template파일들을 저장할 경로는 BASE_DIR에 디렉토리를 만들고 setting.py에 등록
```python
TEMPLATES = [
  {
    'BACKEND':'django.template.backends.django.DjangoTemplates',
    'DIRS':[os.path.join(BASE_DIR, 'templates')],
    'APP_DIRS':True,
    ...
```
- View등에서 요청한 template 파일 찾는 순서
  1. settings.py의 TEMPLATES 설정의 DIRS에 설정된 경로
  2. 각 App의 templates 디렉토리

## View에서 Template을 요청하는 방법 - render()
- ![image](https://user-images.githubusercontent.com/77317312/120095988-fe75fb00-c163-11eb-966d-3a7d7f0b1b82.png)
- `render()`로 호출 시 View에서 Template에 처리결과(값들)를 전달 할 수 있다.
- View에서 **DB의 값을 변경한 경우 새로고침하면 다시 적용되는 문제 발생**
- 위의 문제를 해결하기 위해서는 redirect!!
## View에서 Template을 요청하는 방법 - redirect()
- ![image](https://user-images.githubusercontent.com/77317312/120096051-48f77780-c164-11eb-9623-5d4b2b2e4e8e.png)
- `redirect()`로 호출 시 View에서 Template에 값을 전달 할 수 없다.
- View에서 **DB의 값을 변경한 경우 새로고침해도 다시 적용되는 문제를 해결!!**

# template 문법
- template 변수
  - 변수의 값을 출력
  - 구문 : `{{ 변수 }}`
- template 필터
  - https://docs.djangoproject.com/en/3.0/ref/templates/builtins/
  - 템플릿 변수의 값을 특정 형식으로 변환(처리) 한다.
  - 변수와 필터를 | 를 사용해 연결
  - 구문 : `{{변수 | 필터}}`, `{{변수 | 필터:argument}}`

- template 필터 예
  - `{{ val | upper }}` => 이름을 대문자로 변환 `lower`은 소문자
  - `{{ val | truncatewords:10 }}` 지정한 정수 단어만 보여주고 나머진 ... 으로 대체
  - `{{ val | default:'없음' }}` 변수의 값이 False로 평가되면 지정한 값 '없음'을 보여줘라
  - `{{ val | lenth }}` 변수의 값이 문자열이거나 list일때 크기 반환
  - `{{ val | linebreaksbr }}` 변수의 문자열의 엔터(\n)을 <br> 태그로 변환
  - `{{ val | data:'Y-m-d' }}` 변수의 값이 datetime 객체일때 원하는 일시 포멧으로 변환
    - Y : 4자리 연도, m : 2자리 월, d : 2자리 일
    - H : 시간(00 ~ 23), g : 시간(1 ~ 12), i : 분(00 ~ 59), s : 초(00~59), A : (AM, PM)

- template 태그
  - Template에서 python 구문 작성
  - https://docs.djangoproject.com/en/3.0/ref/templates/builtins/
  - 구문 : `{% 태그 %}`

- 반복문 - for in 문
  - iterable한 객체의 원소들을 반복 조회
```HTML
{% for 변수 in iterable %}
  반복구간

{% empty %}
  list가 빈 경우

{% endfor %}
```
  - empty는 반복 조회할 iterable이 원소가 없을 때 처리할 내용을 작성하며 생략 가능하다.

- 조건문
  - 조건에는 boolean 연산자가 들어간다.
  - 논리 연산자로 and, or, not을 사용
```HTML
{% if 조건 %}

{% elif 조건 %}

{% else %}

{% endif %}
```

- url
  - urls.py에 등록된 URL을 가져와 출력
  - `{% url 'app이름:url이름' 전달값 %}`
```python
# urls.py
app_name = 'exam'
path('detail/<int:pk>', views.detail, name='detail')
```
```HTML
<a href="{%url 'exam:detail' 10 %}"> 상세보기 </a>
```

- extends
  - 상속 받을 부모 템플릿을 지정한다.
  - 기존 template을 상속 받아 재사용할 수 있다.
  - 공통 부분은 그대로 사용하되 변경되는 영역만 재정의 해서 템플릿을 만든다.
  - `{% extends "상속받을 템플릿 경로" %}`
- block
  - 재정의할 구역을 지정
  - 부모 템플릿에서 **재정의할 영역을 지정**할 때, 자식 템플릿에서 **재정의 할 때** 사용한다.
```HTML
{% block block이름 %}
  내용
{% endblock [block이름] %}

{% block contents%}
  내용
{% endblock contents%}
```

# 부모 Template
- root경로에 template 디렉토리안에 만든다.
- 이하 layout.html

### 부모 template
```html
# layout.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}제목{% endblock title %}</title>
</head>
<body>
<div class='container'>
  <a href="{% url 'polls:list' %}">질문 목록</a>
  <a href='/admin'>관리</a>
  <hr> <!--구분선-->
  {% block contents %}{% endblock contents %}
</div>
</body>
</html>
```

# 자식 Template
- 원하는 앱 아래 template 디렉토리 경로

### 자식 template
```html
{% extends 'layout.html' %}

{% block title %} vote_form {% endblock title %}

{% block contents %}
<h1>vote form</h1>
  {% if error_message != None %}
    <div style='color:red'>
      {{error_message}}
    </div>
  {% else %}
    <div style='color:blue'>보기를 선택하세요</div>
  {% endif %}

  {{question.pk}}. {{question.question_text}}<p>
  
  <form action="{% url 'polls:vote' question.pk %}" method='POST'>
    {% csrf_token %} <!-- post 방식 요청 시 반드시 넣어줘야 한다.- csrf 공격을 방지하기 위해 token값을 생성 -->
    
    {% for choice in question.choice_set.all %}
      <input type='radio' name='choice' value='{{choice.pk}}' id='{{choice.pk}}'>
      <label for='{{choice.pk}}'>{{choice.choice_text}}</label><br>
    {% endfor %}
    <input type='submit', value='VOTE' class='btn btn-primary'> <button class='btn btn-info'>투표</button>
    <input type='reset', value='RESET' class='btn btn-danger'> <button type='reset' class='btn btn-dark'>초기화</button>
  </form>
{% endblock contents %}
```
- ![image](https://user-images.githubusercontent.com/77317312/120097280-95de4c80-c16a-11eb-866c-5b4556aad196.png)
