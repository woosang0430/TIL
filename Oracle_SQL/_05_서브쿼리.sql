/* **************************************************************************
서브쿼리(Sub Query)
- 쿼리(insert, delete, update, select) 안에서 select 쿼리를 사용하는 것.
- 메인 쿼리(밖) - 서브쿼리(안)
- 보통 delete, update는 where절에 쓰임

서브쿼리가 사용되는 구
 - select절, from절, where절, having절
 
서브쿼리의 종류
- 어느 구절에 사용되었는지에 따른 구분
    - 스칼라 서브쿼리 - select 절에 사용. 반드시 서브쿼리 결과가 1행 1열(값 하나-스칼라) 0행이 조회되면 null을 반환
    - 인라인 뷰 - from 절에 사용되어 테이블의 역할을 한다.
서브쿼리 조회결과 행수에 따른 구분
    - 단일행 서브쿼리 - 서브쿼리의 조회결과 행이 한행인 것. - pk로 조회(조회 결과가 없거나 한행이 나오는거)
    - 다중행 서브쿼리 - 서브쿼리의 조회결과 행이 여러행인 것.
    - 단일행|다중행에 따라 연산자가 달라진다.
동작 방식에 따른 구분
    - select문과 관계된다.
    - 비상관(비연관) 서브쿼리 - 서브쿼리에 메인쿼리의 컬럼이 사용되지 않는다. 메인쿼리에 사용할 값을 서브쿼리가 제공하는 역할을 한다.
        - 안쪽에 있는 궈리문이 바깥쪽 쿼리문과 상관없이 일한다.
    - 상관(연관) 서브쿼리 - 서브쿼리에서 메인쿼리의 컬럼을 사용한다. 
        - 메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인하고자 할때 주로 사용한다.
        - 안쪽에 있는 궈리문이 바깥쪽 쿼리문과 연관있게 일한다.
                            

- **서브쿼리는 반드시 ( ) 로 묶어줘야 한다.**
************************************************************************** */
--단일행 서브쿼리

-- 직원_ID(emp.emp_id)가 120번인 직원과 같은 업무(emp.job_id)가진 
-- 직원의 id(emp_id),이름(emp.emp_name), 업무(emp.job_id), 급여(emp.salary) 조회

select  emp_id,
        emp_name,
        job_id,
        salary
from    emp
where   job_id = (select job_id from emp
                    where emp_id = 120);
















select  emp_id,
        emp_name,
        job_id,
        salary
from    emp
where   job_id = (select  job_id
                  from    emp
                  where   emp_id = 120);
-- 단일행 서브쿼리
-- 비상관 쿼리

-- 직원_id(emp.emp_id)가 115번인 직원과 같은 업무(emp.job_id)를 하고 같은 부서(emp.dept_id)에 속한 직원들을 조회하시오.
select  job_id, dept_id
from    emp
where   emp_id = 115;


-- pair 방식 서브쿼리
select * from emp
where   job_id, dept_id = (select job_id, dept_id
                          from emp
                          where emp_id = 115);

-- 직원들 중 급여(emp.salary)가 전체 직원의 평균 급여보다 적은 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회. 급여(emp.salary) 내림차순 정렬.
select  emp_id,
        emp_name,
        salary
from    emp
where   salary < (select avg(salary) from emp)
order by 3 desc;

-- 전체 직원의 평균 급여(emp.salary) 이상을 받는 부서의  이름(dept.dept_name), 소속직원들의 평균 급여(emp.salary) 출력. 
-- 평균급여는 소숫점 2자리까지 나오고 통화표시($)와 단위 구분자 출력

select  d.dept_name,
        to_char(round(avg(e.salary), 2), '$99,999') "평균급여"
from emp e left join dept d on e.dept_id = d.dept_id
group by d.dept_name
having  avg(salary) > (select avg(salary) from emp);

-- TODO: 직원의 ID(emp.emp_id)가 145인 직원보다 많은 연봉을 받는 직원들의 이름(emp.emp_name)과 급여(emp.salary) 조회.
-- 급여가 큰 순서대로 조회
select  emp_name,
        salary
from    emp
where   salary > (select salary from emp
                     where emp_id = 145)
                     
order by 2 desc;

select * from emp
where emp_id = 145;

select  emp_name, salary
from    emp
where   salary > (select salary from emp where emp_id=145)
;


-- TODO: 직원의 ID(emp.emp_id)가 150인 직원과 같은 업무(emp.job_id)를 하고 같은 상사(emp.mgr_id)를 가진 직원들의 
-- id(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 상사(emp.mgr_id) 를 조회
select  emp_id,
        emp_name,
        job_id,
        mgr_id
from    emp
where   job_id = (select job_id from emp
                  where emp_id = 150)
and     mgr_id = (select mgr_id from emp
                  where emp_id = 150);
                
-- 서브쿼리에서만 지원한다.
select  emp_id,
        emp_name,
        job_id,
        mgr_id
from    emp
where   (job_id, mgr_id) = (select job_id, mgr_id
                            from emp
                            where emp_id = 150);


-- TODO : EMP 테이블에서 직원 이름이(emp.emp_name)이  'John'인 직원들 중에서 급여(emp.salary)가 가장 높은 직원의 salary(emp.salary)보다 많이 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 직원 ID(emp.emp_id) 오름차순으로 조회.
select  emp_id,
        emp_name,
        salary
from    emp
where   salary > all(select salary from emp
                      where emp_name = 'John')
order by 3 asc;

select  emp_id,
        emp_name,
        salary
from    emp
where   salary > (select max(salary)
                 from   emp
                 where  emp_name = 'John')
order by 3 asc;
;

-- TODO: 급여(emp.salary)가 가장 높은 직원이 속한 부서의 이름(dept.dept_name), 위치(dept.loc)를 조회.
select  d.dept_name,
        d.loc
from    dept d
where   d.dept_name = (select d.dept_name 
                       from dept d join emp e on d.dept_id = e.dept_id
                       where e.salary = (select max(salary) from emp);

select  d.dept_id,
        d.dept_name,
        d.loc
from    emp e left join dept d on e.dept_id = d.dept_id
where   e.salary = (select max(salary) from emp)
;

-- TODO: 급여(emp.salary)를 제일 많이 받는 직원들의 이름(emp.emp_name), 부서명(dept.dept_name), 급여(emp.salary) 조회. 
--       급여는 앞에 $를 붙이고 단위구분자 , 를 출력
select  e.emp_name,
        d.dept_name,
        to_char(e.salary, '$9,999,999')
from    emp e join dept d on e.dept_id = d.dept_id
group by d.dept_id, d.dept_name, e.emp_name
where   e.salary = (select max(salary) from emp);
        
select  e.emp_name,
        d.dept_name,
        to_char(e.salary, '$99,999')
from    emp e join dept d on e.dept_id = d.dept_id
where   e.salary = (select max(salary) from emp);

select  e.emp_name,
        d.dept_name,
        to_char(e.salary, 'fm$999,999') salary
from    emp e left join dept d on e.dept_id = d.dept_id
where   salary = (select max(salary) from emp)
;
-- TODO: 담당 업무ID(emp.job_id) 가 'ST_CLERK'인 직원들의 평균 급여보다 적은 급여를 받는 직원들의 모든 정보를 조회. 단 업무 ID가 'ST_CLERK'이 아닌 직원들만 조회. 
select  *
from    emp
where   salary < (select avg(salary) from emp
                  where job_id = 'ST_CLERK')
and     nvl(job_id, '미배치') != 'ST_CLERK'
;

select  *
from    emp
where   salary < (select avg(salary) from emp 
                   where job_id = 'ST_CLERK')
and     (job_id != 'ST_CLERK'
or      job_id is null)
-- job_id가 null이거나 st_clerk이 아닌 직원중에서 salary가 ST_CLERK의 평균급여보다 작은 직원 
order by salary desc
;

-- TODO: 30번 부서(emp.dept_id) 의 평균 급여(emp.salary)보다 급여가 많은 직원들의 모든 정보를 조회.
select  *
from    emp
where   salary > (select avg(salary) from emp
                      where dept_id = 30);

select *
from    emp
where   salary > (select avg(salary) from emp where dept_id=30)
order by salary
;

-- TODO: EMP 테이블에서 업무(emp.job_id)가 'IT_PROG' 인 직원들의 평균 급여 이상을 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 급여 내림차순으로 조회.
select  emp_id,
        emp_name,
        salary
from    emp
where   salary > (select avg(salary) from emp
                      where job_id = 'IT_PROG')
order by 3 desc;

select  emp_id,
        emp_name,
        salary
from    emp
where   salary > (select avg(salary) from   emp where job_id = 'IT_PROG')
order by salary desc;

-- TODO: 'IT' 부서(dept.dept_name)의 최대 급여보다 많이 받는 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date), 부서 ID(emp.dept_id), 급여(emp.salary) 조회
-- 입사일은 "yyyy년 mm월 dd일" 형식으로 출력
-- 급여는 앞에 $를 붙이고 단위구분자 , 를 출력
select  emp_id,
        emp_name,   
        to_char(hire_date, 'yyyy"년"mm"월"dd"일"') "hire_date",
        dept_id,
        to_char(salary, '$999,999') salary
from    emp
where   salary > (select max(e.salary)
                    from    emp e join dept d on e.dept_id = d.dept_id
                    where   d.dept_name = 'IT');

select  emp_id,
        emp_name,
        to_char(hire_date, 'yyyy"년" mm"월" dd"일"') hire_date,
        to_char(salary, 'fm$99,999') salary
from    emp
where   salary > (select max(e.salary)
                    from emp e join dept d on e.dept_id = d.dept_id
                    where d.dept_name = 'IT')
order by salary
;

/* ----------------------------------------------
 다중행 서브쿼리
 - 서브쿼리의 조회 결과가 여러행인 경우
 - where절 에서의 연산자
	- in
	- 비교연산자 any : 조회된 값들 중 하나만 참이면 참 (where 컬럼 > any(서브쿼리) )
	- 비교연산자 all : 조회된 값들 모두와 참이면 참 (where 컬럼 > all(서브쿼리) )
------------------------------------------------*/

--'Alexander' 란 이름(emp.emp_name)을 가진 관리자(emp.mgr_id)의 
-- 부하 직원들의 ID(emp_id), 이름(emp_name), 업무(job_id), 입사년도(hire_date-년도만출력), 급여(salary)를 조회
-- 급여는 앞에 $를 붙이고 단위구분자 , 를 출력
select  emp_id,
        emp_name, 
        job_id,
        to_char(hire_date, 'yyyy') hire_year,
        to_char(salary, '$99,999') salary
from    emp
where   mgr_id in (select emp_id from emp
                   where emp_name = 'Alrexander');

-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 보다 급여(emp.salary)를 많이 받는 직원의 모든 정보를 조회.
select * from emp
where   salary > all(select salary from emp
                    where emp_id in (101,102,103));
                    
select * from emp
where   salary > (select max(salary) from emp
                    where emp_id in (101,102,103));


-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 중 급여가 가장 적은 직원보다 급여를 많이 받는 직원의 모든 정보를 조회.
select  salary
from    emp
where   emp_id in (101,102,103);

select * from emp
where salary > any(select salary from emp
                where emp_id in (101,102,103))
order by salary;

select * from emp
where salary > (select min(salary) from emp
                where emp_id in (101,102,103))
order by salary;

-- TODO : 부서 위치(dept.loc) 가 'New York'인 부서에 소속된 직원의 ID(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id) 를 sub query를 이용해 조회.
select  e.emp_id,
        e.emp_name,
        e.dept_id
from    emp e join dept d on e.dept_id = d.dept_id
where   d.loc = 'New York';

select  emp_id,
        emp_name,
        dept_id
from    emp
where   dept_id in (select dept_id from dept 
                    where loc = 'New York')
;


-- TODO : 최대 급여(job.max_salary)가 6000이하인 업무를 담당하는 직원(emp)의 모든 정보를 sub query를 이용해 조회.
select  *
from    emp
where   job_id in (select job_id from job
                    where max_salary <= 6000)
;

-- TODO: 부서_ID(emp.dept_id)가 20인 부서의 직원들 보다 급여(emp.salary)를 많이 받는 직원들의 정보를  sub query를 이용해 조회.

select  *
from    emp
where   salary > all(select salary from emp 
                        where dept_id = 20)
;

-- TODO: 부서별 급여의 평균중 가장 적은 부서의 평균 급여보다 많이 받는 직원들이 이름, 급여, 업무를 sub query를 이용해 조회
select  e.emp_name,
        e.salary,
        e.job_id
from emp e join dept d on e.dept_id = d.dept_id
group by d.dept_id, e.emp_name, e.salary, e.job_id
having avg(salary) > any(select avg(salary) 
                        from emp e join dept d on e.dept_id = d.dept_id
                        group by d.dept_id);

select  emp_name,
        job_id,
        salary
from    emp
where   salary >  any(select avg(salary) 
                    from emp group by dept_id)
;

-- TODO: 업무 id(job_id)가 'SA_REP' 인 직원들중 가장 많은 급여를 받는 직원보다 많은 급여를 받는 직원들의 이름(emp_name), 급여(salary), 업무(job_id) 를 sub query를 이용해 조회.
select  emp_name,
        salary,
        job_id
from    emp
where   salary > all(select salary from emp
                      where job_id = 'SA_REP');

select  emp_name,
        salary,
        job_id
from    emp
where   salary > all(select salary from emp 
                        where job_id = 'SA_REP')
;

-- 비상관쿼리 실행 순서 : subquery 실행 -> subquery실행결과를 가지고 main 쿼리가 실행.
/* ****************************************************************
상관(연관) 쿼리
메인쿼리문의 조회값을 서브쿼리의 조건에서 사용하는 쿼리.
메인쿼리를 실행하고 그 결과를 바탕으로 서브쿼리의 조건절을 비교한다.
* ****************************************************************/
-- 각 부서에서(DEPT) 급여(emp.salary)를 가장 많이 받는 직원들의 id(emp.emp_id), 이름(emp.emp_name), 연봉(emp.salary), 소속부서ID(dept.dept_id) 조회
select  e.emp_id,
        e.emp_name,
        e.salary,
        e.dept_id
from    emp  e
where   salary = 
;

select max(salary)
from    emp
where   dept_id = 자기가 속한 부서ID;

select  e.emp_id,
        e.emp_name,
        e.salary,
        e.dept_id
from    emp  e
where   salary = (select max(salary)
                  from    emp
                  where   nvl(dept_id, 0) = nvl(e.dept_id, 0))
order by 4
;

select distinct dept_id from emp order by 1;

/* ******************************************************************************************************************
EXISTS, NOT EXISTS 연산자 (상관(연관)쿼리와 같이 사용된다)
- 컬럼 비교하지 않는다. 있냐? 없냐?로 
-- 서브쿼리의 결과를 만족하는 값이 존재하는지 여부를 확인하는 조건. 조건을 만족하는 행이 여러개라도 한행만 있으면 더이상 검색하지 않는다.

[데이터 테이블(고객, 장비 -부모)] - [Transaction(내역, 이력) 테이블(주문, 대여 -자식)]
-- 내역테이블에서 데이터테이블의 값이 참조되고 있는지(EXISTS) 없는지(NOT EXISTS) 확인
-- 고객중에 (한번이상) 주문한 고객?
**********************************************************************************************************************/
-- 직원이 한명이상 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select  d.dept_id,
        d.dept_name,
        d.loc
from    dept d
where   exists (select * from emp e where e.dept_id  = d.dept_id)
order by 1
;

select * from dept
where dept_id in (select distinct dept_id from emp)
order by 1
;

-- 직원이 한명도 없는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select  d.dept_id,
        d.dept_name,
        d.loc
from    dept d
where   not exists (select * from emp e where e.dept_id  = d.dept_id)
order by 1
;

-- 부서(dept)에서 연봉(emp.salary)이 13000이상인 한명이라도 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select  *
from    dept d
where   exists (select * from emp e where d.dept_id = e.dept_id and salary>=13000);


/* ******************************
주문 관련 테이블들 이용.
1. from
2. where - 행선택 (조건은 행별로 체크 - True인 행이 통과)
******************************* */

--TODO: 고객(customers) 중 주문(orders)을 한번 이상 한 고객들을 조회.
select  *
from    customers c
where   exists (select * from orders o
                where c.cust_id = o.cust_id);

--TODO: 고객(customers) 중 주문(orders)을 한번도 하지 않은 고객들을 조회.
select  *
from    customers c
where   not exists (select * from orders o
                    where nvl(c.cust_id, 0) = nvl(o.cust_id, 0));

--TODO: 제품(products) 중 한번이상 주문된 제품 정보 조회
select *
from    products p
where   exists (select * from order_items oi
                where p.product_id = oi.product_id);

--TODO: 제품(products)중 주문이 한번도 안된 제품 정보 조회
select  *
from    products p
where   not exists (select * from order_items oi
                    where p.product_id = oi.product_id);