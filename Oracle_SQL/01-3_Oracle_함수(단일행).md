## 단일행 함수(행 단위 처리)
- select, where절에 사용가능

### 1. data type별 함수

#### 1-1. 문자열(조회 결과만 바뀜, 원본은 변환 X)
- `upper()`/`lower()` : 대문자/소문자로 변환
- `initcap()` : 단어 첫글자만 대문자 나머진 소문자로 변환
      - (예제1)
    
- `LENGTH()` : 글자수 조회
      - (예제2)

- `LPAD(값, 크기, 채울값)` : **값**을 지정한 **크기**의 고정길이 문자열로 만들고 모자라는 것은 왼쪽부터 **채울값**으로 채운다.
- `RPAD(값, 크기, 채울값)` : **값**을 지정한 **크기**의 고정길이 문자열로 만들고 모자라는 것은 오른쪽부터 **채울값**으로 채운다.
          - (예제3)
    
- `SUBSTR(값, 시작index, 글자수)` : **값**에서 **시작index**번째 글자부터 지정한 **글자수** 만큼의 문자열을 추출. 글자수 생략시 끝까지.
           - (예제4)
    
- `REPLACE(값, 찾을문자열, 변경할문자열)` : **값**에서 **찾을문자열**을 **변경할문자열**로 바꾼다.
           - (예제5)
    
- `LTRIM(값)`: 왼공백 제거
- `RTRIM(값)`: 오른공백 제거
- `TRIM(값)`: 양쪽 공백 제거
           - (예제6)
```sql
## 예시1 UPPER(), LOWER(), INITCAP()
select  upper('abcDE') "소문자를대문자로",
        lower('ABCde') "대문자를소문자로",
       	initcap('abcde abced') "단어의 첫글자만대문자"
from    dual;
```
```sql
## 예시2 LENGTH()
select  *
from    emp
where   length (emp_name) > 7;
```
```sql
## 예시3 LPAD(), RPAD()
select  lpad('abc', 10, '+') "A",
        rpad('abc', 10) "B"
		rpad('123456789', 3) # 앞에 3글자 나옴
		from dual;
```
```sql
## 예시4 SUBSTR()
select substr('123456789', 2, 5) #2번째 글자부터 5개 글자만 출력.
       substr('123456789', 2)		
       from dual;
```
```sql
## 예시5 REPLACE()
select replace('010-1111-2222', '010', '###')
       from dual;
```
```sql
## 예시6 TRIM(), LTRIM(), RTRIM()
select  trim('   abc   ') "A",
        ltrim('    abc    ') "B",
        rtrim('    abc    ') "C"
		from dual;
```

### 1-2. 정수 / 실수 (함수 - 숫자관련 함수)
	    	
- 결과 : 정수, 실수
    - `round(값, 자릿수)` : 자릿수이하에서 반올림 (양수 - 실수부, 음수 - 정수부, 기본값 : 0)
    - `trunc(값, 자릿수)` : 자릿수이하에서 절삭(양수 - 실수부, 음수 - 정수부, 기본값: 0)
		
- 결과 : 정수
    - `ceil(값)` : 올림
	- `floor(값)` : 내림


- `mod(나뉘는수, 나누는수)` : 나눗셈의 나머지 연산

#### 1-3. date(함수 - 숫자관련 함수)

- `sysdate` : 실행시점의 일시
- `Date +- 정수` : 일자 계산.
- `months_between(d1, d2)` : 경과한 개월수(**d1**이 최근, **d2**가 과거)
    - 일수가 다를 경우 소수로 나오기때문에 **ceil**로 묶어주자
    - (예시 1)
- `add_months(d1, 정수)` : **정수**개월 지난 날짜. 마지막 날짜의 1개월 후는 달의 마지막 날이 된다.
    - (예시 2)
- `next_day(d1, '요일')` : d1에서 첫번째 지정한 요일의 날짜. 요일은 한글(locale)로 지정한다.
    - (예시 3)
- `last_day(d)` : d 달의 마지막날.
- `extract(year|month|day from date)` : date에서 year/month/day만 추출
    - (예시 4)

```sql
## 예시1 MONTHS_BETWEEN()
select  months_between(sysdate, '2020/12/28')||'개월',
        months_between(sysdate, '2020/12/28')||'개월',
        ceil(months_between(sysdate, '2020/12/26'))||'개월'
from    dual;
"""
결과값 1개월    2개월     2개월 #ceil사용안할 시 소수로 나옴
"""
```
```sql
## 예시2 ADD_MONTHS()
select  add_months(sysdate, 2), --양수 : 2개월후
        add_months(sysdate, -2), --음수 : 2개월전
        add_months('2021/01/31', 1)
from dual;
```
```sql
## 예시3 LPAD(), RPAD()
select  next_day(sysdate, '금요일'),
        next_day(sysdate, '수요일')
from    dual;
```
```sql
## 예시4 EXTRACT()
select  extract(year from sysdate),
        extract(month from sysdate),
        extract(day from sysdate)
from    dual;
------------------------------------------
select * 
from   emp
where  extract(month from hire_date) = 11;
```

### 2. 변환 함수
- data type을 바꿔주는 함수
- 문자열을 기분으로 변환, number이랑 date는 서로 변환 X
    - `to_char()` : 숫자형, 날짜형을 문자형으로 변환
    - `to_number()` : 문자형을 숫자형으로 변환 
    - `to_date()` : 문자형을 날짜형으로 변환

###  3. 기타 함수

#### 3-1. 형식(format)문자 
- 숫자
    - `0`, `9` : 숫자가 들어갈 자릿수 지정. (9: 정수부 남는자리를 공백으로 채움, 0은 0으로 채움) 
        - 실수부 남는 자리는 둘다 0으로 채운다.
        - fm으로 시작하면 9일 경우 공백을 제거.
    - `.` : 정수/실수부 구문자.
    - `,`: 정수부 단위구분자
    - `$` : 통화표시, `L` : 로컬통화기호
    
- 일시
      - yyyy : 4자리, yy: 2자리(2000년대), rr: 2자리(50이상:90년대, 50미만:2000년대) - 50이 기준
      - mm: 월 2자리  (11, 05)
      - dd: 일 2자리
      - hh24: 시간(00 ~ 23) 2자리, hh(01 ~ 12)
      - mi: 분 2자리
      - ss: 초 2자리
      - day(요일), 
      - am 또는 pm : 오전/오후

#### 3-2 null 관련 함수 
    - **NVL(expr, 기본값)**(많이씀) : expr 값이 null이면 기본값을 null이 아니면 expr값을 반환.
    - NVL2(expr, nn, null) : expr이 null이 아니면 nn, null이면 세번째
    - nullif(ex1, ex2) : 둘이 같으면 null, 다르면 ex1

- DECODE함수와 CASE 문
    - 동등비교
        - `decode(컬럼, [비교값, 출력값, ...] , else출력)`
    - `decode()` : 오라클 구문
    - `case()` : 표준 구문

- decode구문
```sql
decode(컬럼, 10, 'A',  ## 조건문을 함수화
             20, 'B',
             30, 'C',
                'D')
             ^    ^
         #조건문 / 반환값
"""
반환값의 첫번째 타입에 맞춰서 작성하기
ex) 'A'가 char면 나머지도 char
          number면 나머지도 number
"""
```

- code 동등비교 구문
```sql
case 컬럼 when 10 then 'A'
        when 20 then 'B'
        when 30 then 'C'
        [else 'D'] end
	# else 생략시 null반환
"""
반환값의 첫번째 타입에 맞춰서 작성하기
ex) 'A'가 char면 나머지도 char
          number면 나머지도 number
"""
```
- code 조건문
```sql
case when 조건 then 출력값
    [when 조건 then 출력값]
    [else 출력값]   end

## 조건 : where절의 조건연산자
```
