# SUB QUERY(비상관 서브쿼리(단일행, 다중행), 상관 서브쿼리)

## 1. 비상관 서브쿼리(단일행, 다중행)
  - 안쪽에 있는 쿼리문이 바깥쪽 쿼리문과 상관없이 일한다.
### 1-1. 단일행 서브쿼리
  - 서브쿼리의 조회결과 행이 한행인 것 - pk로 조회(조회 결과가 없거나 한행이 나오는거)
- 사용예제
```sql
## 직원_ID(emp.emp_id)가 120번인 직원과 같은 업무(emp.job_id)가진 
## 직원의 id(emp_id),이름(emp.emp_name), 업무(emp.job_id), 급여(emp.salary) 조회
select  emp_id,
        emp_name,
        job_id,
        salary
from    emp
where   job_id = (select job_id from emp
                    where emp_id = 120);
                    
## 전체 직원의 평균 급여(emp.salary) 이상을 받는 부서의  이름(dept.dept_name), 소속직원들의 평균 급여(emp.salary) 출력. 
## 평균급여는 소숫점 2자리까지 나오고 통화표시($)와 단위 구분자 출력
select  d.dept_name,
        to_char(round(avg(e.salary), 2), '$99,999') "평균급여"
from emp e left join dept d on e.dept_id = d.dept_id
group by d.dept_name
having  avg(salary) > (select avg(salary) from emp);

## 담당 업무ID(emp.job_id) 가 'ST_CLERK'인 직원들의 평균 급여보다 적은 급여를 받는 직원들의 모든 정보를 조회. 단 업무 ID가 'ST_CLERK'이 아닌 직원들만 조회. 
select  *
from    emp
where   salary < (select avg(salary) from emp
                  where job_id = 'ST_CLERK')
and     nvl(job_id, '미배치') != 'ST_CLERK';

```

### 1-2. 다중행 서브쿼리
  - 서브쿼리의 조회결과가 여러행인 것
  - where절 연산자
    - `in`
    - 비교연산자 `any` : 조회된 값들 중 하나만 참이면 참 (where 컬럼 > any(서브쿼리))
    - 비교연산자 `all` : 조회된 값들 모두와 참이면 참 (where 컬럼 > all(서브쿼리))
- 사용예제
```sql
## 최대 급여(job.max_salary)가 6000이하인 업무를 담당하는 직원(emp)의 모든 정보를 sub query를 이용해 조회.
select  *
from    emp
where   job_id in (select job_id from job
                    where max_salary <= 6000);

## 부서별 급여의 평균중 가장 적은 부서의 평균 급여보다 많이 받는 직원들이 이름, 급여, 업무를 sub query를 이용해 조회
select  emp_name,
        job_id,
        salary
from    emp
where   salary >  any(select avg(salary) 
                    from emp group by dept_id);
```
  
## 2. 상관 서브쿼리
  - 안쪽에 있는 쿼리문이 바깥쪽 쿼리문과 연관있게 일한다.
