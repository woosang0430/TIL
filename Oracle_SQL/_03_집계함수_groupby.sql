/* **************************************************************************
집계(Aggregation) 함수와 GROUP BY, HAVING
************************************************************************** */

/* ************************************************************
집계함수, 그룹함수, 다중행 함수
- 인수(argument)는 컬럼.
  - sum(): 전체합계
  - avg(): 평균
  - min(): 최소값
  - max(): 최대값
  - stddev(): 표준편차
  - variance(): 분산 -- 편차 제곱을 평균낸것
  - count(): 개수
        - 인수: 
            - 컬럼명: null을 제외한 개수
            -  (*): 총 행수(null을 포함)

- count(*) 를 제외하고 모든 집계함수는 null은 빼고 계산한다.
- sum, avg, stddev, variance: number 타입에만 사용가능.
- min, max, count :  모든 타입에 다 사용가능.
************************************************************* */

-- EMP 테이블에서 급여(salary)의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 총직원수를 조회 
select  sum(salary) "총합계",
        round(avg(salary), 2) "평균",
        min(salary) "최소값",
        max(salary) "최대값",
        round(stddev(salary),2) "표준편차",
        round(variance(salary), 2) "분산",
        count(salary) "총직원수"
from    emp;

-- EMP 테이블에서 가장 최근 입사일(hire_date)과 가장 오래된 입사일을 조회
select  max(hire_date) "최근 입사일",
        min(hire_date) "가장 오래된 입사일"
from    emp;


-- EMP 테이블의 부서(dept_name) 의 개수를 조회
select count(dept_name)
from    emp;


-- emp 테이블에서 job 종류의 개수 조회
select count(distinct job)
from    emp;

select count(distinct nvl(dept_name, '미배치'))
from    emp;

--TODO:  커미션 비율(comm_pct)이 있는 직원의 수를 조회
select count(comm_pct)
from    emp;

select count(*)
from    emp
where comm_pct is not null;

--TODO: 커미션 비율(comm_pct)이 없는 직원의 수를 조회

select count(*)
from    emp
where   comm_pct is null;

select count(*) - count(comm_pct)
from   emp;

--TODO: 가장 큰 커미션비율(comm_pct)과 과 가장 적은 커미션비율을 조회
select max(comm_pct),
        min(comm_pct)
from    emp;

select max(comm_pct),
        min(comm_pct)
from    emp;

--TODO:  커미션 비율(comm_pct)의 평균을 조회. 
--소수점 이하 2자리까지 출력
select round(avg(comm_pct), 2), -- comm_pct가 있는 직원들의 comm_pct평균
        round(avg(nvl(comm_pct, 0)), 3) "전체 평균" -- comm_pct가 없을 경우 0으로 치환한뒤 평균 계산, 전체 직원의 평균
        -- 상황에 맞게 평균 구할때 두가지 방법
from    emp;

select comm_pct from emp;


--TODO: 직원 이름(emp_name) 중 사전식으로 정렬할때 가장 나중에 위치할 이름을 조회.
select max(emp_name), min(emp_name)
from    emp;

select emp_name from emp order by 1 desc;

--TODO: 급여(salary)에서 최고 급여액과 최저 급여액의 차액을 출력
select max(salary) - min(salary)
from    emp;

select max(salary) - min(salary)
from    emp;

--TODO: 가장 긴 이름(emp_name)이 몇글자 인지 조회.
-- length(문자열) : 글자수
select max(length(emp_name))
from    emp;

select emp_name
from    emp
where   length(emp_name) = (select max(length(emp_name)) from emp); -- subqery


--TODO: EMP 테이블의 부서(dept_name)가 몇종류가 있는지 조회. 
-- 고유값들의 개수
select count(distinct dept_name), -- null은 빼고 셈
       count(distinct nvl(dept_name, 'a')) -- null 포함해서 셈
from    emp;

/* *****************************************************
group by 절
- 특정 컬럼(들)의 값별로 나눠 집계할 때 나누는 기준컬럼을 지정하는 구문.
	- 예) 업무별 급여평균. 부서-업무별 급여 합계. 성별 나이평균
- 구문: group by 컬럼명 [, 컬럼명]
	- 컬럼: 분류형(범주형, 명목형) - 부서별 급여 평균, 성별 급여 합계
	- select의 where 절 다음에 기술한다.
	- select 절에는 group by 에서 선언한 컬럼들만 집계함수와 같이 올 수 있다
*******************************************************/

-- 업무(job)별 급여의 총합계, 평균, 최소값, 최대값, 표준편차, 분산, 직원수를 조회
--              ~~별 ``의 평균
--               ^    ^
--        group by / 집계대상 컬럼
select  job,
        sum(salary) "SUM",
        round(avg(salary), 2) "AVG",
        min(salary) "MIN",
        max(salary) "MAX",
        round(stddev(salary), 2) "STDDEV",
        round(variance(salary), 2) "VAR",
        count(*) "COUNT"
from emp
group by job
order by 1 asc;


-- 입사연도 별 직원들의 급여 평균.
select  extract(year from hire_date) "year",
        round(avg(salary), 2) "sal_avg"
from    emp
group by extract(year from hire_date)
order by 1 asc;

-- 부서명(dept_name) 이 'Sales'이거나 'Purchasing' 인 직원들의 업무별 (job) 직원수를 조회
select  dept_name,
        job,
        count(*) as "직원수"
from    emp
where   dept_name in ('Sales', 'Purchasing')
group by dept_name, job
order by 1 desc;

-- 부서(dept_name), 업무(job) 별 최대 평균급여(salary)를 조회.
select  dept_name,
        job,
        max(salary)
from    emp
group by dept_name, job
order by 1;

-- 급여(salary) 범위별 직원수를 출력. 급여 범위는 10000 미만,  10000이상 두 범주.
select  case when salary >= 10000 then '10000이상'
              else '10000미만' end "급여범위",
        count(*)
from    emp
group by case when salary >= 10000 then '10000이상'
              else '10000미만' end;


--TODO: 부서별(dept_name) 직원수를 조회
select dept_name,
        count(*)
from    emp
group by dept_name
order by 2 desc;

--TODO: 업무별(job) 직원수를 조회. 직원수가 많은 것부터 정렬.
select job,
        count(*)
from    emp
group by job
order by 2 desc;

--TODO: 부서명(dept_name), 업무(job)별 직원수, 최고급여(salary)를 조회. 부서이름으로 오름차순 정렬.
select dept_name,
        count(job),
        max(salary)
from    emp
group by dept_name, job
order by dept_name asc;

select  dept_name,
        job,
        count(*)
from    emp
group by dept_name, job
order by 1;



--TODO: EMP 테이블에서 입사연도별(hire_date) 총 급여(salary)의 합계을 조회. 
--(급여 합계는 자리구분자 , 를 넣으시오. ex: 2,000,000)
select extract(year from hire_date) "입사년도",
        to_char(sum(salary), '9,999,999') "총 급여"
from    emp
group by extract(year from hire_date);

select  to_char(hire_date, 'yyyy') "입사년도",
        to_char(sum(salary), 'fmL9,999,999') "급여합계"
from    emp
group by to_char(hire_date, 'yyyy');


--TODO: 업무(job)와 입사년도(hire_date)별 평균 급여(salary)을 조회
select job,
        extract(year from hire_date) "입사년도",
        round(avg(salary), 2) "평균급여"
from    emp
group by job, extract(year from hire_date)
order by 1;


--TODO: 부서별(dept_name) 직원수 조회하는데 부서명(dept_name)이 null인 것은 제외하고 조회.
select  dept_name,
        count(dept_name)
from    emp
group by dept_name;

select  dept_name,
        count(*)
from    emp
where dept_name is not null
group by dept_name;


--TODO 급여 범위별 직원수를 출력. 급여 범위는 5000 미만, 5000이상 10000 미만, 10000이상 20000미만, 20000이상. 
select case when salary >= 20000 then '2만이상'
            when salary < 20000 and salary >= 10000 then '2만미만 1만이상'
            when salary < 10000 and salary >= 5000 then '1만미만 5천이상'
            else '5천미만' end "급여범위",
        count(*)
from    emp
group by case when salary >= 20000 then '2만이상'
            when salary < 20000 and salary >= 10000 then '2만미만 1만이상'
            when salary < 10000 and salary >= 5000 then '1만미만 5천이상'
            else '5천미만' end;
            
select case when salary < 5000 then '1등급'
              when salary between 5000 and 9999.99 then '2등급'
              when salary between 10000 and 19999.99 then '3등급'
              else '4등급' end "급여등급",
       count(*)
from    emp
group by case when salary < 5000 then '1등급'
              when salary between 5000 and 9999.99 then '2등급'
              when salary between 10000 and 19999.99 then '3등급'
              else '4등급' end
order by 1 asc;


/* **************************************************************
having 절
- 집계결과에 대한 행 제약 조건
- group by 다음 order by 전에 온다.
- 구문
    having 제약조건  --연산자는 where절의 연산자를 사용한다. 피연산자는 집계함수(의 결과)
************************************************************** */

-- 직원수가 10 이상인 부서의 부서명(dept_name)과 직원수를 조회
select  dept_name,
        count(*) "직원수",
        sum(salary)
from    emp
group by dept_name
having count(*) >= 10  -- where절에서는 조건을 붙히지 못한다.
order by 2 desc;

-- 직원수가 10명 이상인 부서의 부서별 급여합계
select  dept_name,
        to_char(sum(salary), '$999,999') "급여합계"
from    emp
group by dept_name
having count(*) >= 10
order by 2 desc;

--TODO: 15명 이상이 입사한 년도와 (그 해에) 입사한 직원수를 조회.
select  extract(year from hire_date),
        count(*)
from    emp
group by extract(year from hire_date)
having count(*) >= 15;


select to_char(hire_date, 'yyyy') "입사년도",
       count(*) "직원수",
       max(salary) "최고급여"
from    emp
group by to_char(hire_date, 'yyyy')
having count(*) >= 15;
------------------------------------------
select extract(year from hire_date),
        count(*)
from emp
group by extract(year from hire_date);

--TODO: 그 업무(job)을 담당하는 직원의 수가 10명 이상인 업무(job)명과 담당 직원수를 조회
select  job,
        count(job)
from    emp
group by job
having count(*) >= 10;

select job,
        count(*)
from    emp
group by job
having count(*) >= 10;

--TODO: 평균 급여가(salary) $5000이상인 부서의 이름(dept_name)과 평균 급여(salary), 직원수를 조회
select dept_name,
        round(avg(salary), 2),
        count(*)
from emp
group by dept_name
having  round(avg(salary), 2) >= 5000;

--TODO: 평균급여가 $5,000 이상이고 총급여가 $50,000 이상인 부서의 부서명(dept_name), 평균급여와 총급여를 조회
select  dept_name,
        round(avg(salary), 2),
        sum(salary)
from    emp
group by dept_name
having round(avg(salary), 2) >=5000 
and sum(salary) >= 50000;



--TODO 직원이 2명 이상인 부서들의 이름과 급여의 표준편차를 조회
select dept_name,
        stddev(salary)
from    emp
group by dept_name
having count(*) >=2;

select dept_name,
       round(stddev(salary), 2) "급여표준편차"
from    emp
group by dept_name
having count(*) >= 2;



/* **************************************************************
- rollup : group by의 확장.
  - group by로 묶어 집계할 경우 누적집계(중간집계나 총집계)를 부분 집계에 추가해서 조회한다.
  - 구문 : group by rollup(컬럼명 [,컬럼명,..])



- grouping(), grouping_id()
  - rollup 이용한 집계시 컬럼이 각 행의 집계에 참여했는지 여부를 반환하는 함수.
  - case/decode를 이용해 레이블을 붙여 가독성을 높일 수 있다.
  - 반환값
	- 0 : 참여한 경우
	- 1 : 참여 안한 경우.
 
rollup 사용시
- grouping() 함수     ====한개 밖에 처리 못함 그냥 grouping_id사용하자
 - 구문: grouping(groupby컬럼)
 - select 절에 사용되며 rollup이나 cube와 함께 사용해야 한다.
 - group by의 컬럼이 집계함수의 집계에 참여했는지 여부를 반환
	- 반환값 0 : 참여함(부분집계함수 결과), 반환값 1: 참여 안함(누적집계의 결과)
 - 누적 집계인지 부분집계의 결과인지를 알려주는 알 수 있다.


rollup 사용시
- grouping_id() 함수   ==== 여러개 처리 가능
  - 구문: grouping_id(groupby 컬럼, ..)
  - 전달한 컬럼이 집계에 사용되었는지 여부 2진수(0: 참여 안함, 1: 참여함)로 반환 한뒤 10진수로 변환해서 반환한다.
 
************************************************************** */

-- EMP 테이블에서 업무(job) 별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회.
select job,
        round(avg(salary), 2) "평균급여"
from    emp
group by rollup(job);
        


select  job,
        round(avg(salary), 2) "평균"
from    emp
group by rollup(job);


-- EMP 테이블에서 업무(JOB) 별 급여(salary)의 평균과 평균의 총계도 같이나오도록 조회.
-- 업무 컬럼에  소계나 총계이면 '총평균'을  일반 집계이면 업무(job)을 출력
select  decode(grouping(job), 0, job,
                              1, '총평균') "job",
        round(avg(salary), 2) "평균"
from    emp
group by rollup(job);


-- dept_name, job
-- EMP 테이블에서 부서(dept_name), 업무(job) 별 salary의 합계와 직원수를 소계와 총계가 나오도록 조회
select  decode(grouping_id(dept_name, job), 0, nvl(dept_name, '미배치')||'-'||job,
                                         1, nvl(dept_name, '미배치')||' 소계',
                                         3, '총계') "Label",
        sum(salary) "총 급여",
        count(*) "총 직원수"
from    emp
group by rollup(dept_name, job);


--# 총계/소계 행의 경우 :  총계는 '총계', 중간집계는 '계' 로 출력
--TODO: 부서별(dept_name) 별 최대 salary와 최소 salary를 조회
-- nvl(decode(group_id()))
select  nvl(decode(grouping_id(dept_name), 1, '총계',
                                          0, dept_name), '미배치') "dept_name",
        max(salary),
        min(salary)
from    emp
group by rollup(dept_name);



--TODO: 상사_id(mgr_id) 별 직원의 수와 총계를 조회하시오.
select  decode(grouping_id(mgr_id), 1, '총계', -- decode()의 반환값으로 문자열과 다른 타입을 사용할 경우 문자열을 먼저 기술.
                                    0, mgr_id) "mgr_id",
        count(*)
from    emp
group by rollup(mgr_id);

--TODO: 입사연도(hire_date의 year)별 직원들의 수와 연봉 합계 그리고 총계가 같이 출력되도록 조회.
select  decode(grouping_id(to_char(hire_date, 'yyyy')), 1, '총계',
                                                       0, to_char(hire_date, 'yyyy')) "입사년도",
        count(*) "직원수",
        sum(salary) "급여합계"
from    emp
group by rollup(to_char(hire_date, 'yyyy'));

--TODO: 부서별(dept_name), 입사년도별 평균 급여(salary) 조회. 부서별 집계와 총집계가 같이 나오도록 조회
select  decode(grouping_id(dept_name, to_char(hire_date, 'yyyy')),
                                       3, '총계',
                                       1, dept_name|| ' 소계',
                                       0, dept_name||'-'||to_char(hire_date, 'yyyy')) "Label",
        to_char(hire_date, 'yyyy'),
        round(avg(salary), 2) "평균급여"
from    emp
group by rollup(dept_name, to_char(hire_date, 'yyyy'))
order by 1 asc;


-- 일하는 순서
-- 5 select  컬럼 선택
-- 1 from    테이블
-- 2 where   행 조건
-- 3 group by 그룹 기준 컬럼
-- 4 having  그룹을 선택조건
-- 6 order by 정렬;

select dept_name
from    emp
where   dept_name is not null;

select * from emp;







