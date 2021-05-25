# Model - ORM
- Object Relational Mapping - 객체 관계 매핑(ORM)
  - 객체와 관계형 데이터베이스의 데이터를 자동으로 연결하여 SQL문 없이 데이터베시으 작업(CRUD)를 작성할 수 있다.
- 장점
  - 비지니스로직과 데이터베이스 로직을 분리할 수 있다, 재사용성 유지보수성이 good
  - DBMS에 대한 종속성이 줄어든다.
- 단점
  - DMBS 고유 기능 사용 못함
  - DB의 관계가 복잡할 경우 난이도 또한 올라간다.

## ORM
- 장고는 SQL문을 직접 실핼 할 수도 있지만 가능하면 ORM을 사용하는 것이 좋다.
- django ORM이 지원하는 DBMS
  - mysql, oracle, postgresql, sqlite3
  - https://github.com/django/django/tree/stable/3.1.x/django/db/backends

## Model 생성 절차
- 장고 모델을 먼저 만들고 데이터베이스에 적용
  1. models.py에 Model 클래스 작성
  2. admin.py에 등록(admin app에서 관리할 경우)
    - admin.site.register(모델 클래스)
  3. migration 파일 생성 -> makemigrations 명령어
    - 변경 사항 DB에 넣기 위한(migrate) 내역을 가진 파일로 app/migrations 디렉토리에 생성된다.
    - `python manage.py makemigrations`
    - SQL문 확인
      - `python manage.py sqlmigrate app이름 migration파일명`
  4. Database에 적용(migrate 명령)
    - `python manage.py migrate`

- DB에 테이블이 있는 경우 다음을 장고 Model 클래스들을 생성할 수 있다.
  - inspectdb 명령 사용
  - `python manage.py inspectdb`
  - 파일에 저장
    - `python manage.py inspectdb > app/파일명`
- inspectdb로 생성된 model코드는 초안, 생성 코드를 바탕으로 수정


# Model 클래스
- ORM은 DB테이블과 파이썬 클래스를 1대1로 매핑한다. 이 클래스를 Model이라 함
- models.py에 작성
  - django.db.models.Model 상속 받아 생성
  - **클래스 이름은** 관례적으로 단수형으로 지정하고 Pascal 표기법 사용
  - Database 테이블 이름은 'app이름_모델클래스이름' 형식으로 만들어진다.
    - 모델의 Meta클래스의 db_table 속성을 이용해 원하는 테이블 이름을 지정할 수 있다.
  - Field 선언
    - **Field**는 테이블의 컬럼과 연결되는 변수를 말하며 class 변수로 선언
    - primary컬럼은 직접 지정하거나 생략가능
      - 생략시 1씩 자동 증가하는 값을 가지는 id 컬럼이 default로 생성됨

## Model 클래스 - Field 타입
### 테이블 속성은 클래스  변수로 선언
- 변수명(컬럼명) = Field객체() # 컬럼 데이터타입에 맞춰 선언
### 장고 필드 클래스
- 문자열 타입
  - CharField, TextField
- 숫자 타입
  - IntegerField, PositiveIntegerField, FloatField
- 날짜 시간 타입
  - DateTineField, DateField, TimeField
- 파일
  - FileField, ImageField
  - ImageField를 사용하기 위해서는 **Pillow 패키지를 설치해야 한다.**
```python
from django.db import models

class Question(models.Model):
  question_text = models.CharField(max_length=200)
  pub_date = models.DateTimeField(auto_now_add=True)
  
  def __str__(self):
    return self.question_text
    
class Choice(models.Model):
  choice_text = models.CharField(max_length=200)
  vote = models.PositiveIntegerField(default=0)
  question = models.ForeignKey(to=Question, on_delete=models.CASCADE)
  # to => 참조 Model 클래스(테이블) 지정
  #  on_delete => 부모테이블의 값이 delete될 경우 처리방식 (CASCADE : 참조하는 자식데이터도 같이 삭제)
  def __str__(self):
    return self.choice_text
```

### 장고 필드 클래스
- 논리형 필드
  - BoolkeanFiel
- 모델 간의 관계
  - ForeignKey : 외래키 설정(부모 테이블연결 모델 클래스 지정). 1대 다의 관계
  - ManyToMany : 다 대 다 관계 설정
  - OneToOne : 1 대 1 관계 설정
- 기타
  - EmailField
  - URLField
- https://docs.djangoproject.com/en/3.0/ref/models/fields/

### 주요 필드 옵션
- `max_length` : 문자타입의 최대 길이(글자수) 설정
- `blank` : 입력 값 유효성(validation) 검사 시에 empty 값 허용 여부
- `null`(DB 옵션) : DB필드에 NULL 허용 여부
- `unique`(DB 옵션) : 유일성 여부
- `default` : default 값 지정. 입력 시 값이 지어되지 않았을 때 사용
- `verbose_name` : 입력 폼으로 사용될 때 label로 사용될 이름. 지정되지 않으면 field명으로 쓰임
- `validators` : 입력 값 유효성 검사를 수행할 함수 지정
  - 각 필드타입들은 validator 함수들을 가지고 있다.
- `choices`(form widget 용) : select box소스로 사용
- `DateField.auto_now_add` : Bool, True이면 레코드 처음 생성 시 현재 시간으로 자동 저장
- `DateField.auto_now` : Bool, True이면 저장 시마다 그 시점을 현재 시간으로 자동 저장
- https://docs.djangoproject.com/en/3.0/ref/models/fields/


## Model 클래스를 이용한 CRUD
### Model Manager
- Model 클래스와 연결된 테이블에 SQL을 실행할 수 있는 인터페이스를 제공
- 각 Model 클래스의 class 변수 `objects`를 이용해 사용할 수 있다.
  - model클래스.objects
### QuerySet
- Model Manager를 이용해 호출된 SQL CRUD 실행 메소드들을 위한 SQL문을 생성해 실행 한다.
- iterable 객체
  - select의 경우 실행된 결과를 QuerySet을 이용해 조회
  - iterable타입으로 조회결과가 여러 개일 경우 for in 문을 이용해 조회
- Query Set은 Method Chaining을 지원
- query 속성 : 생성된 sql문을 확인 할 수 있다.
- QuerySet으로 만들어진 SQL 실행은 데이터가 필요한 시점에 실행된다.
- https://docs.djangoproject.com/ko/3.0/topics/db/queries/

### 전체 조회와 조건 조회
- 전체 조회
  - `모델클래스.objects.all()`
- 조건 조회
  - `filter(**kwargs)` : 조건을 만족하는 조회 결과를 **QuerySet으로 반환**
  - `exclude(**kwargs)` : 조건을 만족하지 않는 조회 결과를 **QuerySet으로 반환**
    - 조회결과가 1개 이상일 때 사용. 조회결과가 겂으면 빈 QuerySet을 반환
  - `get(**kwargs)` : 조건을 만족하는 조회결과를 **Model 객체로 반환**
    - 조회결과가 1개 일 때 사용 (주로 primary or foreign Key에 사용)
    - 조회결과가 없으면 DoseNotExist 예외 발생, 2개 이상이면 MultipleObjectsReturned 예외 발생

### Field type별 다양한 조건
- `필드명__조건 = 값` (언더스코어 2개)
- 주요 field 조건

| 입력 | 결과? |
| -- | -- |
| 필드명 = 값 | 필드명 = 값(값이 None일 경우 is null비교) |
| 필드명__lt = 값 | 필드명 < 값 |
| 필드명__lte = 값 | 필드명 <= 값 |
| 필드명__gt = 값 | 필드명 > 값 |
| 필드명__gte = 값 | 필드명 >= 값 |
| 필드명__startswith = 값 | 필드명 LIKE '값%'|
| 필드명__endswith = 값 | 필드명 LIKE '%값'|
| 필드명__contains = 값 | 필드명 LIKE '%값%' |
| 필드명__in = [v1, v2] | 필드명 IN (v1, v2) |
| 필드명__ranage = (s_v, e_v) | 필드명 BETWEEN s_v AND e_v |
- https://docs.djangoproject.com/en/3.0/ref/models/querysets/

- `dhango.db.models.Q`
  - filter와 exclude는 SELECT의 WHERE조건을 지정
  - 1개 이상의 인수를 지정하면 AND 조건으로 묶인다.
    - `Itme.objects.filter(name='TV', price=3000)`
  - OR 조건의 경우 Q()함수를 사용
  - & 와 | 연산자를 이용해 and, or 조건을 만들 수 있다.
  - ~Q(조건) : Q()앞에 `~`를 붙이면 not이 된다.
    - `Item.objects.filter(Q(name='TV') | ~Q(price=2000))`
