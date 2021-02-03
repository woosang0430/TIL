# JOIN 연산(INNER JOIN, ORACLE JOIN, OUTER JOIN)
- 연관 있는 2개 이상의 테이블에 있는 컬럼들을 합쳐 가상의 테이블을 만들어 조회하는 방식
 	- **소스테이블** : 먼저 읽어야 한다고 생각하는 테이블 - 메인 데이터 테이블
	- **타겟테이블** : 소스에 조인할 대상이 되는 테이블 - 추가정보, 부가정보
        ## 소스와 타켓에 대한 개념 !!! 꼭 !! 알아두기

- ex) id가 xxx인 직원의 id와 이름, 연봉, 부서이름, 부서위치 : 소스 - 직원, 타겟 - 부서
- id인 xxx인 부서의 이름, 위치, 소속직원의 이름, 연봉 : 소스 - 부서, 타켓 - 직원

 
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산!
    - 조인 연산에 따른 조인종류
    	- `Equi join`, `non-equi join`
- 조인의 종류
    - `Inner Join`
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
    - `Outer Join` (메인정보(소스테이블)는 다나온다.)
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        - 종류 : `Left Outer Join`,  `Right Outer Join`, `Full Outer Join`
    - `Cross Join`(안나오는게 좋은거)
        - 두 테이블의 곱집합(교집합?)을 반환한다. 
- 조인 문법
    - ANSI 조인 문법
        - 표준 SQL 문법
        - 오라클은 9i 부터 지원.
    - 오라클 조인 문법
        - 오라클 전용 문법, 다른 DBMS는 지원안함.


## 1. inner join : ANSI 조인 구문
- FROM `테이블a` [별칭] INNER JOIN `테이블b` [별칭] ON 조인조건
- `테이블a` == 소스테이블, `테이블b` == 타켓테이블
- inner는 생략 할 수 있다.

- inner join 사용예제
```sql
# 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회.
select  e.emp_id,
        e.emp_name,
        to_char(e.hire_date, 'yyyy"년"') hire_year,
        d.dept_name
from    emp e inner join dept d on e.dept_id = d.dept_id
# from    emp e join dept d on e.dept_id = d.dept_id -- inner는 생략 가능.
where   e.emp_id = 100;

# 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬.
# 급여는 , 단위구분자와 $ 를 붙여 출력.
select  d.dept_name,
        to_char(round(avg(e.salary), 2), '$999,999.99') "avg_salary"
from    emp e inner join dept d on e.dept_id = d.dept_id
group by d.dept_id, d.dept_name # group by는 primary  key가 오는게 좋음
order by 2 desc;

# 부서별 급여등급이(salary_grade.grade) 1등급인 직원있는 부서이름(dept.dept_name)과 1등급인 직원수 조회. 직원수가 많은 부서 순서대로 정렬.
## select, from, where, group by, order by 총 출동!
select  d.dept_name,
        count(s.grade),
        s.grade||'등급'
from    emp e inner join dept d on e.dept_id = d.dept_id
                    join salary_grade s on e.salary between s.low_sal and s.high_sal
where   s.grade = 1
group by d.dept_name, s.grade
order by count(s.grade) desc;
```
## 1-1. inner join : Oracle 조인 구문
- Join할 테이블은 from절에 나열
- Join 연산은 where절에서
- Oracle Join 사용예제
```sql
# 200번대(200 ~ 299) 직원 ID(emp.emp_id)를 가진 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 
# 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 오름차순으로 정렬.
select  e.emp_id,
        e.emp_name,
        e.salary,
        d.dept_name,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id
and     e.emp_id between 200 and 299
order by e.emp_id asc;

# 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 
# 직원이름 내림차순으로 정렬
select  d.dept_name,
        d.loc,
        e.emp_name,
        j.job_title
from    dept d, emp e, job j
where   d.dept_id = e.dept_id
and     e.job_id = j.job_id
and     d.dept_name = 'Shipping'
order by e.emp_name desc;
```
## 1-2. Self join : Oracle 조인 구문
- 하나의 테이블 안에 계층 관계를 이룰 때
- 하나의 테이블을 둘로 나눈다.
- 사용예제
```sql
# ANSI 사용
# 직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회
select  e1.emp_id,
        e1.emp_name "직원이름",
        e1.mgr_id "상사아이디",
        e2.emp_name "상사이름"
from    emp e1 join emp e2 on e1.mgr_id = e2.emp_id ; 
# e1 : 부하직원 table, e2 : 상사 table

# Oracle Join 사용
select  e1.emp_id,
        e1.emp_name "직원이름",
        e1.mgr_id "상사아이디",
        e2.emp_name "상사이름"
from    emp e1, emp e2
where   e1.mgr_id = e2.emp_id;
```

## 2. Outer join
- 소스 테이블의 행은 전부 붙힌다.
- 타켓 테이블은 조인연산과 만족하지 않는 친구들은 null로 붙힌다.(만족하면 타켓 테이블 그래도)
- 불충분 조인 (조인 연산시 한쪽의 행이 불충분 해도 붙이도록) 
    - 소스(완전해야하는테이블)가 왼쪽이면 left join, 오른쪽이면 right join 양쪽이면 full outer join

## 2-1. ANSI 문법(Outer Join 구문)
- `from 테이블a [LEFT | RIGHT | FULL] OUTER JOIN 테이블b ON 조인조건`
- 편한거 사용 ㄱㄱ 나는 left!
- OUTER는 생략 가능.
- ANSI Oracle join 사용 예제
```sql
# 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
# 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)
select  e.emp_id,
        e.emp_name,
        e.dept_id,
        d.dept_name,
        d.loc
from    emp e left join dept d on e.dept_id = d.dept_id
and     d.dept_id = 80;  ## 타켓 테이블의 추가 조건!!

# from    emp e left join dept d on e.dept_id = d.dept_id
# where   d.dept_id = 80; 
## 이렇게 하면 null은 빼고 나옴

## 부서의 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 
## 직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
select  d.dept_id,
        d.dept_name,
        count(emp_id) # 직원관련 primary key컬럼 count()
	# count(*) 이렇게 하면 직원이 없는데도 1이 무조건 나옴(소스가 dept이기때문)
	
from    dept d left join emp e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
order by 3 desc;

## 2003년~2005년 사이에 입사한 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
## 입사일 (emp.hire_date), 상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 
## 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
## 2003년에서 2005년 사이 입사한 직원은 모두 나오도록 조회한다. 
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
               left join dept d on e1.dept_id = d.dept_id   ## d : 직원의 부서 table
               left join dept d2 on e2.dept_id = d2.dept_id ## d2 : 상사의 부서 table
where   to_char(e1.hire_date, 'yyyy') between 2003 and 2005;
```
## 2-2. Oracle 문법(Outer Join 구문)
- FROM 절에 조인할 테이블을 나열
- WHERE 절에 조인 조건을 작성
    - 타겟 테이블에 `(+)` 를 붙인다.
    - FULL OUTER JOIN은 지원하지 않는다.
- OUTER는 생략 가능.
- Oracle Outer join사용 예제
```sql
# 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
# 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)
select  e.emp_id,
        e.emp_name,
        e.detp_id,
        d.dept_ame,
        d.loc
from    emp e, dept d
where   e.dept_id = d.dept_id(+) -- join 연산
--and     d.dept_id = 80;        -- where 연산 but 타켓에 대한 join연산 하고싶..
and     d.dept_id(+) = 80;       -- 이렇게!!

## 부서의 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 
## 직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
select  d.dept_id,
        d.dept_name,
        count(e.emp_id)
from    dept d, emp e
where   d.dept_id = e.dept_id(+)
group by d.dept_id, d.dept_name
order by 3 desc;

## 2003년~2005년 사이에 입사한 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 
## 입사일 (emp.hire_date), 상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 
## 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
## 2003년에서 2005년 사이 입사한 직원은 모두 나오도록 조회한다. 
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
```
- join 했을 때 `*`를 붙이면 join한 테이블 전부 조회가 된다.
- 그래서 join한 상태에서 특정 테이블만 전체 조회 하고 싶으면 테이블명.*(`e1.*`)
```sql
select e1.*, j.* # e1과 j 테이블의 전체 컬럼들
from    emp e1 left join job j on e1.job_id = j.job_id
               left join emp e2 on e1.mgr_id = e2.emp_id
               left join dept d on e1.dept_id = d.dept_id -- d : 직원의 부서 table
               left join dept d2 on e2.dept_id = d2.dept_id -- d2 : 상사의 부서 table
where   to_char(e1.hire_date, 'yyyy') between 2003 and 2005;
```
