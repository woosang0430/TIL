# DML

## DML (데이터를 다루는 sql문)
  - `insert` : 삽입(create)
  - `select` : 조회(read, retieve) - DQL
  - `update` : 수정(update)
  - `delete` : 삭제(delete)
  - 이들을 통틀어 `CRUD`라고 한다. (데이터를 관리한다는 약어)

### 1. insert문(행 추가)
- 구문
    - 한행 추가
       - `insert into 테이블명 (컬럼 [, 컬럼]) values (값 [, 값])`
       - 모든 컬럼의 값을 넣을 경우 (^이부분)컬럼 지정구문은 생략 가능
    - 여러행 추가 (조회결과를 insert하기)- subquery 사용
       - `insert into 테이블명 (컬럼 [, 컬럼]) select 구문`
       - insert할 컬럼과 조회한(subquery) 컬럼의 개수와 타입이 맞아야 한다.
       - 모든 컬럼의 값을 넣을 경우 컬럼 설정은 생략 가능
- 사용예시
```sql
desc dept; -- 간단한 정보조회
insert into dept (dept_id, dept_name, loc) values (1000, '기획부', '서울');
insert into dept values (1100, '구매부', '부산'); -- 전체 정보를 insert할 때는 컬럼 생략 가능
commit; -- 최종적으로 저장/ 처리해라

insert into dept values (1110, '구매부', '부산');
insert into dept values (1200, '구매부', '부산');
insert into dept values (1300, '구매부', '부산');
commit; -- commit을 하기 전까지는 임시로 처리된 상태. commit 전 단계는 메모리에 있는 것, commit 후는 최종 처리
rollback; -- insert/update/delete하기 전 상태로 돌려준다.(마지막 commit 상태로 돌려준다.)

## 부서별 직원의 급여에 대한 통계 테이블 생성. 
## 조회결과를 insert. 집계: 합계, 평균, 최대, 최소, 분산, 표준편차
create table salary_statu(
    dept_id number(6),
    salary_sum number(15,2),
    salary_avg number(10, 2),
    salary_max number(7,2),
    salary_min number(7,2),
    salary_var number(20,2),
    salary_stddev number(7,2)
);
insert  into salary_statu
select  dept_id,
        sum(salary),
        round(avg(salary), 2),
        max(salary),
        min(salary),
        round(variance(salary), 2),
        round(stddev(salary), 2)
from    emp
group by dept_id

```

### 2. update문(테이블의 컬럼 값 수정)
- 구문
   - UPDATE: 변경할 테이블 지정
   - SET: 변경할 컬럼과 값을 지정
   - WHERE: 변경할 행을 선택. 
```sql
UPDATE 테이블명
SET    변경할 컬럼 = 변경할 값  [, 변경할 컬럼 = 변경할 값]
[WHERE 제약조건]
```
- 사용 예제
```sql
## 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000을 더한 값으로, 상사_id는 100 변경.
update  emp
set     comm_pct = 0.2,
        salary = salary + 3000,
        mgr_id = 100
where   dept_id = 100;

## 전체 평균급여보다 적게 받는 직원들의 급여를 50% 인상.
update  emp
set     salary = salary * 1.5
where   salary < (select avg(salary)
                    from emp);
```

### 3. delete문(테이블의 행과 컬럼 삭제)
- 구문
- where => 삭제할 행 선택
```sql
delete from 테이블명 [were 제약조건]
```
- 사용예시
```sql
# 부서테이블에서 부서_ID가 10인 부서 삭제
delete  from dept
where   dept_id = 10
```
