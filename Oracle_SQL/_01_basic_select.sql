/* *************************************

Select 기본 구문 - 연산자, 컬럼

select [distinct] 컬럼명1 [별칭], 컬럼명2 => 조회할 컬럼이름들을 지정. 테이블의 모든 컬럼을 조회하는 경우 *를 사용
                                  => distinct : 유일값 지정을 위해! (중복제거)
                                  => 컬럼명 별칭 : 별칭은 조회결과로 보여질 컬럼의 이름. 별칭은 " " 로 감쌀 수 있다.(공백이 들어갈경우 반드시 " " 사용)
                                  => select 절이 distinct로 시작 중복된 조회결과는 하나행만 보여준다.
from   테이블명        => 조회할 컬럼이 있는 테이블의 이름 지정

실행: control + enter
*************************************** */

--EMP 테이블의 모든 컬럼의 모든 항목을 조회.
select  emp_id, 
        emp_name, 
        job, 
        mgr_id, 
        hire_date, 
        salary, 
        comm_pct, 
        dept_name
from    emp;        

select * from emp;

--EMP 테이블의 직원 ID(emp_id), 직원 이름(emp_name), 업무(job) 컬럼의 값을 조회.
select  emp_id,
        emp_name,
        job
from    emp;

--EMP 테이블의 업무(job) 어떤 값들로 구성되었는지 조회. - 동일한 값은 하나씩만 조회되도록 처리.
select  distinct job 
from    emp;

--EMP 테이블의 부서명(dept_name)이 어떤 값들로 구성되었는지 조회 - 동일한 값은 하나씩만 조회되도록 처리.
select distinct dept_name
from   emp;

select  distinct emp_name, job
from emp;
--EMP 테이블에서 emp_id는 직원ID, emp_name은 직원이름, hire_date는 입사일, salary는 급여, dept_name은 소속부서 별칭으로 조회한다.
select  emp_id as "직원ID",  --emp_id에서 조회, 결과는 직원ID로 보여준다.  컬럼명 [as] 별칭
        emp_name "직원 이름",
        hire_date "입사일",
        salary "급여",
        dept_name "소속부서"
from    emp;        

/* 
연산자 
 연산은 그 컬럼의 모든 값들에 일률적으로 적용된다.
 같은 컬럼을 여러번 조회할 수 있다.

- 산술연산: +, -, *, /,    mod(n, m) == n%m
***피연산자 중 null이 있으면 결과는 무조건 null. null + 10=>null
 > null: 값이 없다. 모르는 값.
***date타입값 +/- 정수 : day(일)을 +/-.  오늘날짜 + 5: 5일후 날짜. 오늘날짜 - 5 : 5일전 날짜
- 연결연산자: 문자열을 붙이는 연산자.  || => 모든타입을 다 붙일 수 있다.
*/

select 10 "num1", 20 "num2"
from   dual;--dual: 더미(dummy) 테이블 -  select의 from절을 만들기 위해서 사용하는 가짜 테이블

select 10+20, 20-5, 5*3, 10/2, mod(10, 3) "10%3"
from dual;

select '홍길동'||'씨', 30000||'원' "가격", 5000||20
from dual;

select 2000+100, null+100, null||'값'
from dual;

--sysdate:실행시점의 일시를 반환. 반환타입: date
select sysdate, sysdate + 3 "3일후", sysdate+20, sysdate-5 "5일전 날짜"
from dual;

select sysdate*3 from dual; --date는 +/-만 가능

select salary, salary, salary -- 동일한 컬럼을 여러번 조회할 수 있다.
from emp;
--EMP 테이블에서 직원의 이름(emp_name), 급여(salary) 그리고  급여 + 1000 한 값을 조회.
select  emp_name,
        salary,
        salary+1000 "1000달러 인상분"
from    emp;        


--EMP 테이블에서 입사일(hire_date)과 입사일에 10일을 더한 날짜를 조회.
select  hire_date,
        hire_date+10 "입사 10일후"
from emp;        

-- TODO: EMP 테이블의 업무(job)이 어떤 값들로 구성되었는지 조회 - 동일한 값은 하나씩만 조회되도록 처리
select  distinct job
from    emp;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션_PCT(comm_pct), 급여에 커미션_PCT를 곱한 값을 조회.
select  emp_id,
        emp_name,
        salary,
        comm_pct,
        salary * comm_pct "commetion" -- 컬럼 * 컬럼 : 행단위로 계산
from    emp;

--TODO:  EMP 테이블에서 급여(salary)을 연봉으로 조회. (곱하기 12)
select  salary "월급", salary * 12 "연봉"
from    emp;

--TODO: EMP 테이블에서 직원이름(emp_name)과 급여(salary)을 조회. 급여 앞에 $를 붙여 조회.
select  emp_name, '$'||salary "급여"
from    emp;

--TODO: EMP 테이블에서 입사일(hire_date) 30일전, 입사일, 입사일 30일 후를 조회
select  hire_date -30 "입사 30일 전",
        hire_date "입사일",
        hire_date +30 "입사 30일 후"
from    emp;


/* *************************************
Where 절을 이용한 행 행 제한
************************************* */

--EMP 테이블에서 직원_ID(emp_id)가 110인 직원의 이름(emp_name)과 부서명(dept_name)을 조회
select  emp_name,
        dept_name
from    emp
where   emp_id=110;


--EMP 테이블에서 'Sales' 부서에 속하지 않은 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
SELECT  EMP_ID, 
        emp_name,
        dept_name
from    emp
where   dept_name <> 'Sales';
--where   dept_name != 'Sales';

--EMP 테이블에서 급여(salary)가 $10,000를 초과인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select  emp_id, 
        emp_name,
        salary
from   emp
where  salary > 10000;

 
--EMP 테이블에서 커미션비율(comm_pct)이 0.2~0.3 사이인 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
select  emp_id,
        emp_name,
        comm_pct
from    emp
where   comm_pct between 0.2 and 0.3;

select  emp_id,
        emp_name,
        comm_pct
from    emp
where   comm_pct >= 0.2
and comm_pct <= 0.3;

--EMP 테이블에서 커미션을 받는 직원들 중 커미션비율(comm_pct)이 0.2~0.3 사이가 아닌 직원의 ID(emp_id), 이름(emp_name), 커미션비율(comm_pct)을 조회.
select emp_id,
        emp_name,
        comm_pct
from emp
where comm_pct not between 0.2 and 0.3;
---where comm_pct < 0.2
---or  comm_pct > 0.3;


--EMP 테이블에서 업무(job)가 'IT_PROG' 거나 'ST_MAN' 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select  emp_id,
        emp_name,
        job
from emp
where job in ('IT_PROG', 'ST_MAN');
---where   job = 'IT_PROG'r
---or      job = 'ST_MAN';

--EMP 테이블에서 업무(job)가 'IT_PROG' 나 'ST_MAN' 가 아닌 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회.
select  emp_id,
        emp_name,
        job
from    emp
where job not in ('IT_PROG', 'ST_MAN');
---where   job != 'IT_PROG'
---and     job != 'ST_MAN'

--EMP 테이블에서 직원 이름(emp_name)이 S로 시작하는 직원의  ID(emp_id), 이름(emp_name)
select  emp_id,
        emp_name
from    emp
where   emp_name like 'S%'; -- % : 0개 이상의 모든글자

--EMP 테이블에서 직원 이름(emp_name)이 S로 시작하지 않는 직원의  ID(emp_id), 이름(emp_name)
select  emp_id,
        emp_name
from    emp
where   emp_name not like 'S%';

--EMP 테이블에서 직원 이름(emp_name)이 en으로 끝나는 직원의  ID(emp_id), 이름(emp_name)을 조회
select  emp_id,
        emp_name
from    emp
where   emp_name like '%en';

--- ~~로 끝나는 것 : '%~~'
--- ~~로 시작하는 것 : '~~%'
--- ~~를 포함하는 것 : '%en%'

--EMP 테이블에서 직원 이름(emp_name)의 세 번째 문자가 “e”인 모든 사원의 이름을 조회
select  emp_name
from    emp
where   emp_name like '__e%';

-- EMP 테이블에서 직원의 이름에 '%' 가 들어가는 직원의 ID(emp_id), 직원이름(emp_name) 조회
select  emp_id, emp_name
from    emp
where   emp_name like '%\%%' escape '\';

--EMP 테이블에서 부서명(dept_name)이 null인 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select  emp_id, emp_name, dept_name
from    emp
where   dept_name is null;

--부서명(dept_name) 이 NULL이 아닌 직원의 ID(emp_id), 이름(emp_name), 부서명(dept_name) 조회
select emp_name, dept_name
from emp
where dept_name is not null;
---where not dept_name is null;

--TODO: EMP 테이블에서 업무(job)가 'IT_PROG'인 직원들의 모든 컬럼의 데이터를 조회. 
select  *
from    emp
where   job = 'IT_PROG';

--TODO: EMP 테이블에서 업무(job)가 'IT_PROG'가 아닌 직원들의 모든 컬럼의 데이터를 조회. 
select  *
from    emp
where   job != 'IT_PROG';  -- <>

--TODO: EMP 테이블에서 이름(emp_name)이 'Peter'인 직원들의 모든 컬럼의 데이터를 조회
select  *
from    emp
where   emp_name = 'Peter';

--TODO: EMP 테이블에서 급여(salary)가 $10,000 이상인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select  emp_id, emp_name, salary
from    emp
where   salary >= 10000;

--TODO: EMP 테이블에서 급여(salary)가 $3,000 미만인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id, emp_name, salary
from emp
where salary < 3000;

--TODO: EMP 테이블에서 급여(salary)가 $3,000 이하인 직원의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id, emp_name, salary
from emp
where salary <= 3000;

--TODO: 급여(salary)가 $4,000에서 $8,000 사이에 포함된 직원들의 ID(emp_id), 이름(emp_name)과 급여(salary)를 조회
select emp_id, emp_name, salary
from emp
where salary between 4000 and 8000;

--TODO: 급여(salary)가 $4,000에서 $8,000 사이에 포함되지 않는 모든 직원들의  ID(emp_id), 이름(emp_name), 급여(salary)를 표시
select emp_id, emp_name, salary
from emp
where salary not between 4000 and 8000;

--TODO: EMP 테이블에서 2007년 이후 입사한 직원들의  ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
select  emp_id, emp_name, hire_date
from    emp
where   hire_date > '2007/01/01';

--TODO: EMP 테이블에서 2004년에 입사한 직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date)을 조회.
select  emp_id, emp_name, hire_date,
        extract(year from hire_date),
        extract(month from hire_date),
        extract(day from hire_date)
from    emp
where extract(year from hire_date)=2004;
-- where   hire_date between '2004/01/01' and '2004/12/31';
-- exstract(year|month|day from date) : date에서 year, month, day만 추출

--TODO: EMP 테이블에서 2005년 ~ 2007년 사이에 입사(hire_date)한 직원들의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date)을 조회.
select  emp_id,
        emp_name,
        job,
        hire_date,
        extract(year from hire_date),
        extract(month from hire_date),
        extract(day from hire_date)
from    emp
--where   hire_date between '2005/01/01' and '2007/12/31';
where   extract(year from hire_date) between 2005 and 2007;

--TODO: EMP 테이블에서 직원의 ID(emp_id)가 110, 120, 130 인 직원의  ID(emp_id), 이름(emp_name), 업무(job)을 조회
select  emp_id,
        emp_name,
        job
from    emp
where   emp_id in (110, 120, 130);

--TODO: EMP 테이블에서 부서(dept_name)가 'IT', 'Finance', 'Marketing' 인 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select  emp_id,
        emp_name,
        dept_name
from    emp
where   dept_name in ('IT', 'Finance', 'Marketing');

--TODO: EMP 테이블에서 'Sales' 와 'IT', 'Shipping' 부서(dept_name)가 아닌 직원들의 ID(emp_id), 이름(emp_name), 부서명(dept_name)을 조회.
select  emp_id,
        emp_name,
        dept_name
from    emp
where   dept_name not in ('Sales', 'IT', 'Shipping');

--TODO: EMP 테이블에서 급여(salary)가 17,000, 9,000,  3,100 인 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select  emp_id,
        emp_name,
        job,
        salary
from    emp
where   salary in (17000, 9000, 3100);

--TODO EMP 테이블에서 업무(job)에 'SA'가 들어간 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select  emp_id,
        emp_name,
        job
from    emp
where   job like '%SA%';

--TODO: EMP 테이블에서 업무(job)가 'MAN'로 끝나는 직원의 ID(emp_id), 이름(emp_name), 업무(job)를 조회
select  emp_id,
        emp_name,
        job
from    emp
where   job like '%MAN';

--TODO. EMP 테이블에서 커미션이 없는(comm_pct가 null인) 모든 직원의 ID(emp_id), 이름(emp_name), 급여(salary) 및 커미션비율(comm_pct)을 조회
select  emp_id,
        emp_name,
        salary,
        comm_pct
from    emp
where   comm_pct is null;
    

--TODO: EMP 테이블에서 커미션을 받는 모든 직원의 ID(emp_id), 이름(emp_name), 급여(salary) 및 커미션비율(comm_pct)을 조회
select  emp_id,
        emp_name,
        salary,
        comm_pct
from    emp
where   comm_pct is not null;

--TODO: EMP 테이블에서 관리자 ID(mgr_id) 없는 직원의 ID(emp_id), 이름(emp_name), 업무(job), 소속부서(dept_name)를 조회
select  emp_id,
        emp_name,
        job,
        dept_name,
        mgr_id
from    emp
where   mgr_id is null;

--TODO : EMP 테이블에서 연봉(salary * 12) 이 200,000 이상인 직원들의 모든 정보를 조회.
select *
from emp
where (salary * 12) >= 200000;

/* *************************************
 WHERE 조건이 여러개인 경우
 AND OR
 
 참 and 참 -> 참: 조회 결과 행
 거짓 or 거짓 -> 거짓: 조회 결과 행이 아님.
 
 연산 우선순위 : and > or
 
 where 조건1 and 조건2 or 조건3
 1. 조건 1 and 조건2
 2. 1결과 or 조건3
 
 or를 먼저 하려면 where 조건1 and (조건2 or 조건3)
 **************************************/
-- EMP 테이블에서 업무(job)가 'SA_REP' 이고 급여(salary)가 $9,000 인 직원의 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select  emp_id, emp_name, job, salary
from    emp
where   job = 'SA_REP'
and     salary > 9000;

-- EMP 테이블에서 업무(job)가 'FI_ACCOUNT' 거나 급여(salary)가 $8,000 이상인인 직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 조회.
select  emp_id, emp_name, job, salary
from    emp
where   job = 'FI_ACCOUNT'
or      salary >= 8000;

--TODO: EMP 테이블에서 부서(dept_name)가 'Sales이'고 업무(job)가 'SA_MAN' 이고 급여가 $13,000 이하인 
--      직원의 ID(emp_id), 이름(emp_name), 업무(job), 급여(salary), 부서(dept_name)를 조회
select  emp_id,
        emp_name,
        job,
        salary,
        dept_name
from    emp
where   dept_name = 'Sales'
and     job = 'SA_MAN'
and     salary <= 13000;


--TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서(dept_name)가 'Shipping' 이고 2005년이후 입사한 
--      직원들의  ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date), 부서(dept_name)를 조회
select  emp_id,
        emp_name,
        job,
        salary,
        dept_name
from    emp
where   job like '%MAN%'
and     (dept_name = 'Shipping'
and     hire_date >= '2005/01/01');


--TODO: EMP 테이블에서 입사년도가 2004년인 직원들과 급여가 $20,000 이상인 
--      직원들의 ID(emp_id), 이름(emp_name), 입사일(hire_date), 급여(salary)를 조회.
select  emp_id,
        emp_name,
        hire_date,
        salary
from    emp
where   hire_date between '2004/01/01' and '2004/12/31'
or      salary >= 20000;


--TODO : EMP 테이블에서, 부서이름(dept_name)이  'Executive'나 'Shipping' 이면서 급여(salary)가 6000 이상인 사원의 모든 정보 조회. 
select  *
from    emp
where   dept_name in ('Executive', 'Shipping')
and      salary >= 6000;

--TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중에서 부서이름(dept_name)이 'Marketing' 이거나 'Sales'인 
--      직원의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)를 조회
select  emp_id,
        emp_name,
        job,
        dept_name
from    emp
where   job like '%MAN%'
and     dept_name in ('Marketing', 'Sales');

--TODO: EMP 테이블에서 업무(job)에 'MAN'이 들어가는 직원들 중 급여(salary)가 $10,000 이하이 거나 2008년 이후 입사한 
--      직원의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date), 급여(salary)를 조회
select  emp_id,
        emp_name,
        job,
        hire_date,
        salary
from    emp
where   job like '%MAN%'
and     (salary <= 10000
or      hire_date > '2008/01/01');

/* *************************************
order by를 이용한 정렬
- select문에 가장 마지막에 오는 구절.
- order by 정렬기준컬럼 정렬방식 [, 정렬기준컬럼 정렬방식,...]
- 정렬기준컬럼
	- 컬럼이름.
	- select절에 선언된 순서.
	- 별칭이 있을 경우 별칭.
- 정렬방식
	- asc : 오름차순 (기본-생략가능)
	- desc : 내림차순
- 문자열: 특수문자 < 숫자 < 대문자 < 소문자 < 한글
- date : 과거 < 미래	

NULL 값
ASC : 마지막.  order by 컬럼명 asc nulls first
DESC : 처음.   order by 컬럼명 desc nulls last
-- nulls first, nulls last ==> 오라클 문법.

************************************* */

-- 직원들의 전체 정보를 직원 ID(emp_id)가 큰 순서대로 정렬해 조회
select  *
from    emp
order by emp_id desc;

select * from emp
order by 1 desc;

-- 직원들의 id(emp_id), 이름(emp_name), 업무(job), 급여(salary)를 
-- 업무(job) 순서대로 (A -> Z) 조회하고 업무(job)가 같은 직원들은  급여(salary)가 높은 순서대로 2차 정렬해서 조회.
select  emp_id,
        emp_name,
        job, 
        salary
from    emp
order by job asc, salary desc;
------다른 방법1--------
select  emp_id,
        emp_name,
        job, 
        salary
from    emp
order by 3 asc, 4 desc; -- select 절의 3번째(job), 4번째(salary) 컬럼기준 정렬. ***테이블의 컬럼순서가 아니라 select절에 선언한 컬럼순서

-------다른 방법2 --------
select  emp_id "직원ID",
        emp_name "이름",
        job "업무",
        salary "급여"
from    emp
order by "업무" asc, "급여" desc; -- 컬럼의 별칭을 사용할 수 있다.

--부서명을 부서명(dept_name)의 오름차순으로 정렬해 조회하시오.
select  *
from    emp
order by dept_name asc;

--TODO: 급여(salary)가 $5,000을 넘는 직원의 ID(emp_id), 이름(emp_name), 급여(salary)를 급여가 높은 순서부터 조회
select  emp_id,
        emp_name,
        salary
from    emp
where   salary > 5000
order by 3 desc;

--TODO: 급여(salary)가 $5,000에서 $10,000 사이에 포함되지 않는 모든 직원의  ID(emp_id), 이름(emp_name), 급여(salary)를 이름(emp_name)의 오름차순으로 정렬
select  emp_id,
        emp_name,
        salary
from    emp
where   salary not between 5000 and 10000
order by emp_name asc;

--TODO: EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 업무(job), 입사일(hire_date)을 입사일(hire_date) 순(오름차순)으로 조회.
select  emp_id,
        emp_name,
        job,
        hire_date
from    emp
order by hire_date asc;

--TODO: EMP 테이블에서 ID(emp_id), 이름(emp_name), 급여(salary), 입사일(hire_date)을 급여(salary) 오름차순으로 정렬하고 급여(salary)가 같은 경우는 입사일(hire_date)가 오래된 순서로 정렬.
select  emp_id,
        emp_name,
        salary,
        hire_date
from    emp
order by 3 asc, 4 asc;


select  dept_name
from    emp
--order by dept_name desc nulls last;
order by dept_name asc nulls first;




