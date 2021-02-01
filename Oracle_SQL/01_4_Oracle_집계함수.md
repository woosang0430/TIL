## 집계(Aggregation) 함수와 GROUP BY, HAVING

### 집계함수, 그룹함수, 다중행 함수
- 인수(argument)는 컬럼.
  - `sum()`: 전체합계
  - `avg()`: 평균
  - `min()`: 최소값
  - `max()`: 최대값
  - `stddev()`: 표준편차
  - `variance()`: 분산 - 편차 제곱을 평균낸것
  - `count()`: 개수
          - 인수: 
              - 컬럼명: null을 제외한 개수
              -  *: 총 행수(null을 포함)

- 모든 집계함수는 null은 빼고 계산(**count(*) 를 제외하고**)
- `sum`, `avg`, `stddev`, `variance` : `number 타입`만 사용가능.
- `min`, `max`, `count` :  `모든 타입` 사용가능.


#### 1. group by 절
- 나눠서 집계를 구하고 싶을때 사용한다.
    => ex) 부서별 합계를 구한다.!!
    - ex)  ~~~~별 ~~~~~의 평균 ( 업무별 급여의 총합계, 평균)
    -        ^      ^
    - group by / 집계대상 컬

- 특정 컬럼(들)의 값별로 나눠 집계할 때 나누는 기준컬럼을 지정하는 구문.
	- 예) 업무별 급여평균. 부서-업무별 급여 합계. 성별 나이평균
- 구문: group by 컬럼명 [, 컬럼명]
	- 컬럼: 분류형(범주형, 명목형) - 부서별 급여 평균, 성별 급여 합계
	- where절 다음 온다.
	- select 절에는 group by 에서 선언한 컬럼들만 집계함수와 같이 올 수 있다
- group by 사용 예제
```sql
## 입사연도 별 직원들의 급여 평균.
select  extract(year from hire_date) "year",
        round(avg(salary), 2) "sal_avg"
from    emp
group by extract(year from hire_date)
order by 1 asc;
---------------------------------------------------------------------------
## 급여(salary) 범위별 직원수를 출력. 급여 범위는 10000 미만,  10000이상 두 범주.
select  case when salary >= 10000 then '10000이상'
              	     		  else '10000미만' end "급여범위",
        count(*)
from    emp
group by case when salary >= 10000 then '10000이상'
              else '10000미만' end;
```
#### 2. having 절(group의 조건을 넣어주는 구문)
- group by 다음 위치
- 그룹으로 나누것 중 (조건을 만족하는) 일부 그룹만 집계하고 싶을 때 사용
- 구문
    having 제약조건  -연산자는 **where**절의 연산자를 사용한다. 피연산자는 집계함수(의 결과)
- where절은 그룹 함수를 사용 X
- having절 사용예제
```sql
## 직원수가 10 이상인 부서의 부서명(dept_name)과 직원수를 조회
select  dept_name,
        count(*) "직원수",
        sum(salary)
from    emp
group by dept_name
having count(*) >= 10  -- where절에서는 집계함수 사용 못함
order by 2 desc;
--------------------------------------------------------------------------------------------------
## 평균급여가 $5,000 이상이고 총급여가 $50,000 이상인 부서의 부서명(dept_name), 평균급여와 총급여를 조회
select  dept_name,
        round(avg(salary), 2),
        sum(salary)
from    emp
group by dept_name
having round(avg(salary), 2) >=5000 
and sum(salary) >= 50000;
```

#### 3. rollup : group by의 확장.
  - group by로 묶어 집계할 경우 누적집계(중간집계나 총집계)를 부분 집계에 추가해서 조회한다.
  - 구문 : group by rollup(컬럼명 [,컬럼명,..])
- rollup 사용예제
```sql
## EMP 테이블에서 업무(job) 별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회.
select job,
        round(avg(salary), 2) "평균급여"
from    emp
group by rollup(job);
--------------------------------------------------------------------------------
## EMP 테이블에서 업무(JOB) 별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회.
## 업무 컬럼에 소계나 총계이면 '총평균'을  일반 집계이면 업무(job)을 출력
select  decode(grouping(job), 0,job, 
                              1, '총평균') "job", 
        round(avg(salary), 2) "평균"
from    emp
group by rollup(job);
```
#### 4. grouping(), grouping_id()
  - decode나 case구문이랑 같이 쓴다.
  - rollup 사용시 컬럼이 각 행의 집계에 참여했는지 여부를 반환하는 함수.
  - case/decode를 이용해 레이블을 붙여 가독성을 높일 수 있다.
  - 반환값
	- 0 : 참여한 경우
	- 1 : 참여 안한 경우.
 
##### 4-1. rollup 사용시 (grouping() 함수)
- grouping() 함수 
 - 구문: grouping(group by컬럼)
 - select 절에 사용되며 rollup이나 cube와 함께 사용해야 한다.
 - group by의 컬럼이 집계함수의 집계에 참여했는지 여부를 반환
	- 반환값 0 : 참여함(부분집계함수 결과), 반환값 1: 참여 안함(누적집계의 결과)
 - 누적 집계인지 부분집계의 결과인지를 알려주는 알 수 있다.


##### 4-2. rollup 사용시 (groupin_id() 함수)
- grouping_id() 함수
  - 구문: grouping_id(group by 컬럼, ..)
  - 전달한 컬럼이 집계에 사용되었는지 여부 2진수(0: 참여 안함, 1: 참여함)로 반환 한뒤 10진수로 변환해서 반환한다.
  	- `0` : 전부 참여안함, `1` : 한개 참여, `3` : 두개 참여, `7` : 3개 참여 .....
```sql
## 총계/소계 행의 경우 :  총계는 '총계', 중간집계는 '계' 로 출력
## 부서별(dept_name) 별 최대 salary와 최소 salary를 조회
##      nvl(decode(group_id()))
select  nvl(decode(grouping_id(dept_name), 1, '총계',
                                           0, dept_name), '미배치') "dept_name",
        max(salary),
        min(salary)
from    emp
group by rollup(dept_name);
---------------------------------------------------------------------------------------------
## 부서별(dept_name), 입사년도별 평균 급여(salary) 조회. 부서별 집계와 총집계가 같이 나오도록 조회
select  decode(grouping_id(dept_name, to_char(hire_date, 'yyyy')),
                                       3, '총계',
                                       1, dept_name|| ' 소계',
                                       0, dept_name||'-'||to_char(hire_date, 'yyyy')) "Label",
        to_char(hire_date, 'yyyy'),
        round(avg(salary), 2) "평균급여"
from    emp
group by rollup(dept_name, to_char(hire_date, 'yyyy'))
order by 1 asc;

```
