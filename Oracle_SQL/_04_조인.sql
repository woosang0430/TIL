-- 카티션 곱 : join 연산을 잘못해서 두 테이블의 모든 행들이 cross로 join된것.
-- 6개 table -> join 연산 최소 5개
-- n개 table -> join 연산 최소 n-1개
-- 오라클 조인에서 이런 현상 발생
-- ANSI JOIN은 명시적인 표현 덕분에 실수를 줄일수 있음(---- cross join ----)
select  * 
from    emp e, dept d, b, c, d, e;

-- 부모-자식 테이블간 조인연산 : 부모.pk컬럼 = 자식.fk컬럼

/* ****************************************
조인(JOIN) 이란
- 2개 이상의 테이블에 있는 컬럼들을 합쳐서 가상의 테이블을 만들어 조회하는 방식을 말한다.
 	- 소스테이블 : 내가 먼저 읽어야 한다고 생각하는 테이블 - 메인 데이터 테이블
	- 타겟테이블 : 소스를 읽은 후 소스에 조인할 대상이 되는 테이블 - 추가정보, 부가정보
        ## 소스와 타켓에 대한 개념 !!! 꼭 !! 알아두기

ex) id가 xxx인 직원의 id와 이름, 연봉, 부서이름, 부서위치 : 소스 - 직원, 타겟 - 부서
- id인 xxx인 부서의 이름, 위치, 소속직원의 이름, 연봉 : 소스 - 부서, 타켓 - 직원

 
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산이라고 한다.
    - 조인 연산에 따른 조인종류
        - Equi join , non-equi join
- 조인의 종류
    - Inner Join 
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
    - Outer Join (메인정보(소스테이블)는 다나온다.)
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        - 종류 : Left Outer Join,  Right Outer Join, Full Outer Join
    - Cross Join(안나오는게 좋은거)
        - 두 테이블의 곱집합을 반환한다. 
- 조인 문법
    - ANSI 조인 문법
        - 표준 SQL 문법
        - 오라클은 9i 부터 지원.
    - 오라클 조인 문법
        - 오라클 전용 문법이며 다른 DBMS는 지원하지 않는다.
**************************************** */        
        

/* ****************************************
-- inner join : ANSI 조인 구문
FROM  테이블a [별칭] INNER JOIN 테이블b [별칭] ON 조인조건 (연산)

- inner는 생략 할 수 있다.
**************************************** */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서 ID, 소속부서이름(dept.dept_name)을 조회
select  e.emp_id,
        e.emp_name,
        e.hire_date,
        d.dept_id,
        d.dept_name
from   emp e inner join dept d on e.dept_id = d.dept_id; 


-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회.
select  e.emp_id,
        e.emp_name,
        to_char(e.hire_date, 'yyyy"년"') hire_year,
        d.dept_name
--from    emp e inner join dept d on e.dept_id = d.dept_id
from    emp e join dept d on e.dept_id = d.dept_id -- inner는 생략 가능.
where   e.emp_id = 100;

-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회
select  e.emp_id,
        e.emp_name,
        e.salary,
        j.job_title,
        d.dept_name
from    emp e inner join job j on e.job_id = j.job_id 
                    join dept d on e.dept_id = d.dept_id
order by 1 asc;

-- 부서_ID(dept.dept_id)가 30인 부서의 이름(dept.dept_name), 위치(dept.loc), 그 부서에 소속된 직원의 이름(emp.emp_name)을 조회.
-- 소스테이블 : 부서(부모), 타겟테이블 : 직원(자식)
select  d.dept_name,
        d.loc,
        e.emp_name
from dept d inner join emp e on d.dept_id = e.dept_id
where d.dept_id = 30;

-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 급여 등급 오름차순으로 정렬
select  e.emp_id,
        e.emp_name,
        e.salary,
        s.grade||'등급'
from emp e join salary_grade s on e.salary between s.low_sal and s.high_sal
order by 4 asc;


--TODO 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from emp e inner join dept d on e.dept_id = d.dept_id
where e.emp_id between 200 and 299
order by 1 asc;

select  emp_id
from    emp;
------------------------------------------------------------
select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from    emp e inner join dept d on e.dept_id = d.dept_id
where e.emp_id between 200 and 299;

--TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.  직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.job_id,
        d.dept_name,
        d.loc
from    emp e inner join dept d on e.dept_id = d.dept_id
where   e.job_id = 'FI_ACCOUNT'
order by 1 asc;
---------------------------------------------------
select  e.emp_id,
        e.emp_name,
        e.job_id,
        d.dept_name,
        d.loc
from    emp e inner join dept d on e.dept_id = d.dept_id
where   e.job_id = 'FI_ACCOUNT'
order by e.emp_id asc;

--TODO 커미션비율(emp.comm_pct)이 있는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 커미션비율(emp.comm_pct), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.salary,
        e.comm_pct,
        d.dept_name,
        d.loc
from    emp e inner join dept d on e.dept_id = d.dept_id
where e.comm_pct is not null
order by 1 asc;
----------------------------------------------------
select  e.emp_id,
        e.emp_name,
        e.salary,
        e.comm_pct,
        d.dept_name,
        d.loc
from    emp e inner join dept d on e.dept_id = d.dept_id
where e.comm_pct is not null
order by 1 asc;

--TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
--     그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 부서_ID 의 오름차순으로 정렬.
select  d.dept_id,
        d.dept_name,
        d.loc,
        e.emp_id,
        e.emp_name,
        e.job_id
from    dept d inner join emp e on d.dept_id = e.dept_id
where   d.loc = 'New York'
order by 1 asc;

-- TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select  e.emp_id,
        e.emp_name,
        e.job_id,
        j.job_title
from emp e inner join job j on e.job_id = j.job_id;

-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--       담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select  e.emp_id,
        e.emp_name,
        e.salary,
        j.job_title,
        d.dept_name
from    emp e inner join job j on e.job_id = j.job_id
                    join dept d on e.dept_id = d.dept_id
where   e.emp_id = 200;


-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 
--       직원이름 내림차순으로 정렬
select  d.dept_name,
        d.loc,
        e.emp_name,
        j.job_title
from    dept d inner join emp e on d.dept_id = e.dept_id
                     join job j on e.job_id = j.job_id
where   d.dept_name = 'Shipping'
order by e.emp_name desc;
-----------------------------------------------------------------------------
select  d.dept_name,
        d.loc,
        e.emp_name,
        j.job_title
from    emp e inner join dept d on d.dept_id = e.dept_id
                     join job j on e.job_id = j.job_id
where   d.dept_name = 'Shipping'
order by e.emp_name desc;
-----------------------------------------------------------------
select  d.dept_name,
        d.loc,
        e.emp_name,
        j.job_title
from    dept d inner join emp e on d.dept_id = e.dept_id
                     join job j on e.job_id = j.job_id
where d.dept_name = 'Shipping'
order by 3 desc;


-- TODO:  'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date)를 조회
--         입사일은 'yyyy-mm-dd' 형식으로 출력
select  e.emp_id,
        e.emp_name,
        to_char(e.hire_Date, 'yyyy-mm-dd') "hire_date"
from dept d inner join emp e on d.dept_id = e.dept_id
where d.loc = 'San Francisco';
--------------------------------------------------------
select  e.emp_id,
        e.emp_name,
        to_char(e.hire_date, 'yyyy-mm-dd') hire_date,
        d.loc
from    emp e join dept d on e.dept_id = d.dept_id
where   d.loc = 'San Francisco';

-- TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
-- 급여는 , 단위구분자와 $ 를 붙여 출력.
select  d.dept_name,
        to_char(round(avg(e.salary), 2), '$999,999.99') "avg_salary"
from    dept d inner join emp e on d.dept_id = e.dept_id
group by d.dept_name -- 만약 지역이 같은 친구가 있으면 겹쳐서 나옴...
order by round(avg(e.salary), 2) desc;
----------------------------------------------
select  d.dept_name,
        to_char(round(avg(e.salary), 2), '$999,999.99') "avg_salary"
from    emp e inner join dept d on e.dept_id = d.dept_id
group by d.dept_id, d.dept_name -- group by는 primary  key가 오는게 좋음
order by 2 desc;


--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--     급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select  e.emp_id,
        e.emp_name,
        j.job_title,
        e.salary,
        s.grade||'등급',
        d.dept_name
from    emp e inner join job j on e.job_id = j.job_id
                    join dept d on e.dept_id = d.dept_id
                    join salary_grade s on e.salary between s.low_sal and s.high_sal
order by s.grade desc;
-------------------------------------------------------------------------------------
select  e.emp_id,
        e.emp_name,
        j.job_title,
        e.salary,
        s.grade,
        d.dept_name
from emp e join job j on e.job_id = j.job_id
           join salary_grade s on e.salary between s.low_sal and s.high_sal
           join dept d on e.dept_id = d.dept_id
order by 5 asc;
--TODO 부서별 급여등급이(salary_grade.grade) 1등급인 직원있는 부서이름(dept.dept_name)과 1등급인 직원수 조회. 직원수가 많은 부서 순서대로 정렬.
select  d.dept_name,
        count(s.grade),
        s.grade||'등급'
from    emp e inner join dept d on e.dept_id = d.dept_id
                    join salary_grade s on e.salary between s.low_sal and s.high_sal
where   s.grade = 1
group by d.dept_name, s.grade
order by count(s.grade) desc;
---------------------------------------------
select  d.dept_name,
        count(*) "직원수"
from    emp e inner join dept d on e.dept_id = d.dept_id
                    join salary_grade s on e.salary between s.low_sal and s.high_sal
where   s.grade = 1
group by d.dept_id, d.dept_name
order by count(s.grade) desc;

/* ###################################################################################### 
오라클 조인 
- Join할 테이블들을 from절에 나열한다.
- Join 연산은 where절에 기술한다. 

###################################################################################### */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
-- 입사년도는 년도만 출력
select  e.emp_id,
        e.emp_name,
        extract(year from e.hire_date) "hire_year",
        d.dept_name
from    emp e, dept d
where   e.dept_id = d.dept_id;

-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
-- 입사년도는 년도만 출력
select  e.emp_id,
        e.emp_name,
        e.hire_date,
        d.dept_name
from    emp e, dept d
where   e.emp_id = d.dept_id -- join 조건
and     e.emp_Id = 100; -- where 조건 -- 순서 상관없음 하고 싶은데로~~~!!

-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회
select  e.emp_id,
        e.emp_name,
        e.salary,
        j.job_title,
        d.dept_name
from   emp e,
       job j,
       dept d
where  e.job_id = j.job_id
and    e.dept_id = d.dept_id;

--TODO 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.emp_id between 200 and 299
order by e.emp_id asc;

select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.emp_id between 200 and 299;
--TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.  직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.job_id,
        d.dept_name
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.job_id = 'FI_ACCOUNT'
order by 1 asc;

select  e.emp_id,
        e.emp_name,
        e.job_id,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.job_id = 'FI_ACCOUNT';

--TODO 커미션비율(emp.comm_pct)이 있는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 커미션비율(emp.comm_pct), 
--     소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.salary,
        e.comm_pct,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.comm_pct is not null
order by e.emp_id asc;

select  e.emp_id,
        e.emp_name,
        e.salary,
        e.comm_pct,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.comm_pct is not null
order by e.emp_id;



--TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
--     그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 부서_ID 의 오름차순으로 정렬.
select  d.dept_id,
        d.dept_name,
        d.loc,
        e.emp_id,
        e.emp_name,
        e.job_id
from    dept d, emp e
where   d.dept_id = e.dept_id
and     d.loc = 'New York'
order by d.dept_id asc;

--TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select  e.emp_id,
        e.emp_name,
        e.job_id,
        j.job_title
from emp e, job j
where   e.job_id = j.job_id;
             
select  e.emp_id,
        e.emp_name,
        e.job_id,
        j.job_title
from    emp e, job j
where   e.job_id = j.job_id;

-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
--       담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select  e.emp_id,
        e.emp_name,
        e.salary,
        j.job_title,
        d.dept_name
from emp e, job j, dept d
where   e.job_id = j.job_id
and     e.dept_id = d.dept_id
and     e.emp_id = 200;
        
select  e.emp_id,
        e.emp_name,
        e.salary,
        j.job_title,
        d.dept_name
from    emp e, job j, dept d
where   e.job_id = j.job_id
and     e.dept_id = d.dept_id
and     e.emp_id = 200;
        
-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 
--       직원이름 내림차순으로 정렬
select  d.dept_name,
        d.loc,
        e.emp_name,
        j.job_title
from    dept d, emp e, job j
where   d.dept_id = e.dept_id
and     e.job_id = j.job_id
and     d.dept_name = 'Shipping'
order by e.emp_name desc;

select  d.dept_name,
        d.loc,
        e.emp_name,
        j.job_title
from    dept d, emp e, job j
where   d.dept_id = e.dept_id
and     e.job_id = j.job_id
and     d.dept_name = 'Shipping'
order by 3 desc;

-- TODO:  'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date)를 조회
--         입사일은 'yyyy-mm-dd' 형식으로 출력
select  e.emp_id,
        e.emp_name,
        to_char(e.hire_date, 'yyyy-mm-dd')
from    emp e, dept d
where   e.dept_id = d.dept_id
and     d.loc = 'San Francisco';

select  e.emp_id,
        e.emp_name,
        to_char(e.hire_date, 'yyyy-mm-dd') hire_date
from    emp e, dept d
where   e.dept_id = d.dept_id
and     d.loc = 'San Francisco';

--TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
-- 급여는 , 단위구분자와 $ 를 붙여 출력.
select  d.dept_name,
        to_char(round(avg(e.salary), 2) ,'$999,999.99') "avg_salary"
from    emp e, dept d
where   e.dept_id = d.dept_id
group by d.dept_id, d.dept_name
order by round(avg(e.salary), 2) desc;

select  d.dept_name,
        to_char(round(avg(e.salary), 2), '$999,999.99') avg_salary
from    dept d, emp e
where   e.dept_id = d.dept_id
group by d.dept_name
order by avg(e.salary) desc;

--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 직원 id 오름차순으로 정렬
select  e.emp_id,
        e.emp_name,
        e.salary,
        s.grade
from    emp e, salary_grade s
where   e.salary between s.low_sal and s.high_sal
order by 4 asc;

--TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
--     급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select  e.emp_id,
        e.emp_name,
        j.job_title,
        e.salary,
        s.grade,
        d.dept_name
from    emp e, job j, salary_grade s, dept d
where   e.job_id = j.job_id
and     e.dept_id = d.dept_id
and     e.salary between s.low_sal and s.high_sal
order by 5 desc;

--TODO 부서별 급여등급이(salary_grade.grade) 1인 직원있는 부서이름(dept.dept_name)과 1등급인 직원수 조회. 직원수가 많은 부서 순서대로 정렬.
select  d.dept_name,
        count(*)||'등급'
from    dept d, emp e, salary_grade s
where   e.dept_id = d.dept_id
and     e.salary between s.low_sal and s.high_sal
and     s.grade = 1
group by d.dept_id, d.dept_name
order by count(*) desc;

/* ****************************************************
Self 조인( 한 테이블 안에 계층 관계일 때)
- 물리적으로 하나의 테이블을 두개의 테이블처럼 조인하는 것.
**************************************************** */
--직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회
select  e1.emp_id,
        e1.emp_name "직원이름",
        e1.mgr_id "상사아이디",
        e2.emp_name "상사이름"
from    emp e1 join emp e2 on e1.mgr_id = e2.emp_id ;-- e1 : 부하직원 tb, e2 : 상사 tb

select  e1.emp_id,
        e1.emp_name "직원이름",
        e1.mgr_id "상사아이디",
        e2.emp_name "상사이름"
from    emp e1, emp e2
where   e1.mgr_id = e2.emp_id;



-- TODO : EMP 테이블에서 직원 ID(emp.emp_id)가 110인 직원의 급여(salary)보다 많이 받는 직원들의 id(emp.emp_id), 
-- 이름(emp.emp_name), 급여(emp.salary)를 직원 ID(emp.emp_id) 오름차순으로 조회.
select  e2.emp_id,
        e2.emp_name,
        e2.salary
from    emp e1 join emp e2 on e1.salary < e2.salary ----- e1: emp_id : 110직원, e2 : 조회할 직원 정보
where e1.emp_id = 110
order by e2.salary;

select  emp_name, salary
from    emp
where   salary > (select salary from emp where emp_id = 110)
order by salary;

/* ****************************************************
아우터 조인 (Outer Join)
- 조인테이블에 소스 테이블의 행은 모두 붙이고 타겟 테이블의 행은 조인연산을 만족하는 것만 붙힌다.

-불충분 조인 (조인 연산시 한쪽의 행이 불충분 해도 붙이도록) 
 - 소스(완전해야하는테이블)가 왼쪽이면 left join, 오른쪽이면 right join 양쪽이면 full outer join

-ANSI 문법
from 테이블a [LEFT | RIGHT | FULL] OUTER JOIN 테이블b ON 조인조건
-- 편한거 사용 ㄱㄱ 나는 left!
- OUTER는 생략 가능.

-오라클 JOIN 문법
- FROM 절에 조인할 테이블을 나열
- WHERE 절에 조인 조건을 작성
    - 타겟 테이블에 `(+)` 를 붙인다.
    - FULL OUTER JOIN은 지원하지 않는다.
- OUTER는 생략 할 수 있다.	
**************************************************** */
-- 직원의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 부서명(dept.dept_name), 부서위치(dept.loc)를 조회. 
-- 부서가 없는 직원의 정보도 나오도록 조회. (부서정보는 null). dept_name의 내림차순으로 정렬한다.
-- emp : 소스, dept : 타켓
select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from    emp e left outer join dept d on e.dept_id = d.dept_id
-- from     dept d right outer join emp e on e.dept_id = d.dept_id
order by    dept_name desc;

-- 오라클 문법
select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id(+) -- e : 소스, d:타켓(+)
--where   d.dept_id(+) = e.dept_id
order by d.dept_name desc;

-- 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
-- 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)
select  e.emp_id,
        e.emp_name,
        e.dept_id,
        d.dept_name,
        d.loc
from    emp e left join dept d on e.dept_id = d.dept_id
and     d.dept_id = 80;  -- 타켓 테이블의 추가 조건!!
--from    emp e left join dept d on e.dept_id = d.dept_id
--where   d.dept_id = 80;

-- 오라클 조인
select  e.emp_id,
        e.emp_name,
        e.detp_id,
        d.dept_ame,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id(+) -- join 연산
--and     d.dept_id = 80;        -- where 연산 but 타켓에 대한 join연산 하고싶..
and     d.dept_id(+) = 80;       -- 이렇게!!

--TODO: 직원_id(emp.emp_id)가 100, 110, 120, 130, 140인 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title) 을 조회. 
-- 업무명이 없을 경우 '미배정' 으로 조회
select  e.emp_id,
        e.emp_name,
        nvl(j.job_title, '0')
from    emp e left join job j on e.job_id = j.job_id
where   e.emp_id in (100, 110, 120, 130, 140);

-- 오라클
select  e.emp_id,
        e.emp_name,
        nvl(j.job_title, '미배정')
from    emp e, job j
where   e.job_id = j.job_id(+)
and     e.emp_id in (100, 110, 120, 130, 140);

--TODO: 부서의 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 
--      직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
select  d.dept_id,
        d.dept_name,
        count(emp_id) -- 직원관련 primary key컬럼 count()
from    dept d left join emp e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
order by 3 desc;

-- 오라클 조인
select d.dept_id,
        d.dept_name,
        count(e.emp_id)
from    dept d, emp e
where   d.dept_id = e.dept_id(+)
group by d.dept_id, d.dept_name
order by 3 desc;

-- TODO: EMP 테이블에서 부서_ID(emp.dept_id)가 90 인 직원들의 id(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name), 입사일(emp.hire_date)을 조회. 
-- 입사일은 yyyy-mm-dd 형식으로 출력
select e.emp_id,
        e.emp_name,
        e2.emp_name,
        to_char(e.hire_date, 'yyyy-mm-dd')
from    emp e left join emp e2 on e.mgr_id = e2.emp_id
where e.dept_id = 90;

select  e1.emp_id "직원ID",
        e1.emp_name "직원이름",
        e2.emp_name "상사이름",
        to_char(e1.hire_date, 'yyyy-mm-dd') "직원입사일"
from    emp e1 left join emp e2 on e1.mgr_id = e2.emp_id
where   e1.dept_id = 90;

-- 오라클
select  e1.emp_id "직원ID",
        e1.emp_name "직원이름",
        e2.emp_name "상사이름",
        to_char(e1.hire_date, 'yyyy-mm-dd') "직원입사일"
from emp e1, emp e2
where   e1.mgr_id = e2.emp_id(+)
and     e1.dept_id = 90;

--TODO 2003년~2005년 사이에 입사한 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
--     상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
-- 2003년에서 2005년 사이 입사한 직원은 모두 나오도록 조회한다. 
select  e.emp_name "직원이름",
        j.job_title "업무명",
        e.salary "급여",
        e.hire_date "입사일",
        e2.emp_name "상사이름",
        e2.hire_date "상사입사일",
        d.dept_name "부서명",
        d.loc "부서위치"
from    emp e left join job j on e.job_id = j.job_id
              left join emp e2 on e.mgr_id = e2.emp_id
              left join dept d on e.dept_id = d.dept_id
where  to_char(e.hire_date, 'yyyy') between 2003 and 2005;

-- 소스 e1(직원)
select  e1.emp_id "직원ID",
        e1.emp_name "직원이름",
        j.job_title "직원업무명",
        e1.salary "직원급여",
        e1.hire_date "직원 입사일",
        e2.emp_name "상사 이름",
        e2.hire_date "상사 입사일",
        d2.dept_name "상사 부서명",
        d.dept_name "직원 부서명",
        d.loc "직원의 부서 위치",
        d2.loc "상사의 부서 위치"
from    emp e1 left join job j on e1.job_id = j.job_id
               left join emp e2 on e1.mgr_id = e2.emp_id
               left join dept d on e1.dept_id = d.dept_id -- d : 직원의 부서 table
               left join dept d2 on e2.dept_id = d2.dept_id -- d2 : 상사의 부서 table
where   to_char(e1.hire_date, 'yyyy') between 2003 and 2005;

-- 오라클 조인
select  e1.emp_id "직원ID",
        e1.emp_name "직원이름",
        j.job_title "직원업무명",
        e1.salary "직원급여",
        e1.hire_date "직원 입사일",
        e2.emp_name "상사 이름",
        e2.hire_date "상사 입사일",
        d2.dept_name "상사 부서명",
        d.dept_name "직원 부서명",
        d.loc "직원의 부서 위치",
        d2.loc "상사의 부서 위치"
from    emp e1, job j, emp e2, dept d, dept d2
where   e1.job_id = j.job_id(+)
and     e1.mgr_id = e2.emp_id(+)
and     e1.dept_id = d.dept_id(+)
and     e2.dept_id = d2.dept_id(+)
and     to_char(e1.hire_date, 'yyyy') between 2003 and 2005
order by 1 asc;




-- join 했을 대 *를 하면 전부 나온다. 그래서 특정 테이블만 전체 조회 하고 싶으면 테이블명.*(e1.*)
select e1.*, j.* -- e1과 j 테이블의 컬럼들
from    emp e1 left join job j on e1.job_id = j.job_id
               left join emp e2 on e1.mgr_id = e2.emp_id
               left join dept d on e1.dept_id = d.dept_id -- d : 직원의 부서 table
               left join dept d2 on e2.dept_id = d2.dept_id -- d2 : 상사의 부서 table
where   to_char(e1.hire_date, 'yyyy') between 2003 and 2005;

