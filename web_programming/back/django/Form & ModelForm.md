# 1. Form
### 주요 역할
- HTML의 입력폼 생성
- 입력폼 값들에 대한 유효성 검증(Validatoin)
- 검증을 통과한 값들을 dictionary 형태로 제공

### Form 처리 방식
- 하나의 URL로 입력폼 제공와 폼 처리를 같이 함
  - GET 방식 요청
    - 입력폼을 보여준다.
  - POST 방식 요청
    - 입력폼을 받아 유효성 검증을 한다.
    - 유효성 검증 성공 : 해당 데이터를 모델로 저장하고 SUCCRSS_URL로 **redirect 방식**으로 이동
    - 유효성 검증 실패 : 오류 메세지와 함께 입력폼을 다시 보여준다. (render()를 통해 이동)

### Form 클래스 정의

- app/forms.py(모듈)에 구현
```python
from django import forms

class PostForm(forms.Form):
  title = forms.CharField()
  content = forms.CharField(widget=forms.Textarea)
```
- Form Field 클래스
  - Model의 Fields 들과 유사
    - Model Field : Database 컬럼들과 연결
    - Form Field : HTML 입력 폼과 연결
  - 입력 받는 input type에 따라 다양한 built-in form field 클래스 제공
  - form field 마다 기본 validation(검증) 처리가 구현되어있다.
- 유효성 검증 / 데이터 변환 메소드 추가
  - clean 메소드를 이용해 기본 검증을 통과한 요청 파라미터 값에 추가 검증이나 값 변환을 할 수 있다.
  - `clean(self)`
    - 모든 Field에 대한 추가 유효성 검증/변환을 구현
  - `clean_field명(self)`
    - 특정 field에 대한 추가 유효성 검증/변환을 구현
  - `self.cleaned_data` : dictionary 타입으로 기본 유효성검증을 통과한 입력데이터를 제공
    - 이 값을 이용해 추가  검증
  - 검증 성공 시 cleaned_data(clean())또는 검증한 field의 value(clean_field())를 반환
  - 검증 실패 시 ValidationError를 발생시킨다.
    - clean() 메소드에서는 여러 form을 처리하므로 self.add_error() 메소드를 이용해 에러들을 모은다.
    - self.add_error('Field 이름', '에러메세지')

### View에서 Form 처리 - 함수형 View
```python
if request.method == 'POST':
  # Form 객체 생성
  form = PostForm(request.POST, request.FILES)
  # 폼 검증.is_valid() : Form의 검증 로직을 실행해 유효성 여부를 반환
  if form.is_valid():
    # 등록 작업
    # 입력 폼 값을 이용해 Model 생성 후 save() 한다.
  else:
    # 등록실패 - 입력폼 페이지로 이동
```

# 2. ModelForm
- 설정한 Model을 이용해 Form Field들을 구성
  - Form의 하위클래스
  - ModelForm은 Model과 연동되어 save(저장) 기능을 제공한다.
- 지정된 Model로 부터 Field들을 읽어 Form Field를 만든다.
  - 일반적으로 Form의 Field들과 Model의 Field들은 서로 연결된다.
    - Form에서 입력 받은 값들을 Database에 저장하므로 Form Field와 Model Field는 유사
  - Form의 Field들을 따로 만드는 것이 아니라 Model의 것을 가져와 생성한다.
  - 입력 폼에서 받은 요청 파라미터들을 처리하는 것은 Form과 동일하다.
- Class Based View의 Generic Edit View(CreateView, UpdateView)와 같이 사용되면 HTML에 입력 폼 생성과 처리를 쉽게 할 수 있다.
```python
from django import forms

class PostForm(forms.ModelForm):
  
  class Meta:
    model = Post
    fields = '__all__'
```
- Meta 클래스에 Form을 만들 때 사용할 모델 클래스를 지정
- fields에 모델클래스에서 Form Field를 만들 때 사용할 Model Field변수들을 지정
  - '__all__' : 모든 필드를 사용
  - 리스트 : 사용할 필드들 지정
  - 자동 증가하는 필드들은 빼고 한다.

## Form을 이용해 입력 Form 템플릿 생성
- csrf token 설정
  - 사이트 간 요처 위조를 막기위한 토큰값
  - 장고의 경우 설정하는 것이 default로 되있다.
  - form태그 안에 `{% csrf_token %}`를 넣으면 자동으로 생성
- View에서 전달된 Form/ModelForm 객체를 이용해 입력폼 생성
  - `{{ form }}`
    - 입력 폼 나열
  - `{{ form.as_p }}`
    - 입력 폼들을 \<p>로 구분한다.
  - `{{ form.as_table }}`
    - 각 입력 폼들을 \<tr>로 묶는다. (테이블 내에 생성할 경우 사용)
  - bootstrap4를 install하여 사용하면 편하게 예쁨!
    - `{{ bootstrap_form form }}`

- form은 iterable로 반복 시 각각의 필드를 반환
  - 반환되는 필드를 이용해 입력폼을 커스터마이징 할 수 있다.
```html
{% for field in form %}
...
{% endfor %}
```
- 각 Field 속성
  - `field` : 입력 폼을 만든다.
  - `id_for_label` : 입력 폼의 id
  - `label_tag` : 입력 폼의 Label
  - `errors` : View에서 Field Validation 실패 시 전송되는 에러 메시지들
```html
<form method='POST'>
  {% csrf_token %}
  {% for field in form %}
  <label for='{{field.id_for_label}}'>{{field.label_tag}}</label>
    {{field}}
    {% for error in field.errors %}
      <span style='color:red'>{{error}}</span>
    {% endfor %}
  <br>
  {% endfor %}
  <br>
  <button type="submit"> 가입 </button>
</form>
```
