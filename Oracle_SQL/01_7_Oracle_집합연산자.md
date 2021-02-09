# 집합연산자(병합쿼리)

- 둘 이상의 select 결과를 연산.
- 구문
    - `select문  집합연산자 select문 [집합연산자 select문 ...] [order by 정렬컬럼 정렬방식]`

- 연산자
  - `UNION` : 두 select 결과를 하나로 결합한다. 단 중복되는 행은 제거한다. (합집합)
  - `UNION ALL` : 두 select 결과를 하나로 결합한다. 중복되는 행을 포함한다. (합집합)
  - `INTERSECT` : 두 select 결과의 동일한 결과행만 결합한다. (교집합)
  - `MINUS : 왼쪽 조회결과에서 오른쪽 조회결과에 없는 행만 결합한다. (차집합)
  - union all 빼고는 전부 중복되는 행을 제거한다.
  
- 규칙
  - 연산대상 select 문의 컬럼 수가 같아야 한다. 
  - 연산대상 select 문의 컬럼의 타입이 같아야 한다.(select문에 같은 번째 컬럼의 데이터 타입이 같아야됨)
  - 연산 결과의 컬럼이름은 첫번째 select문의 것을 따른다.
  - order by 절은 구문의 마지막에 넣을 수 있다.
  - UNION ALL을 제외한 나머지 연산은 중복되는 행은 제거한다.
  
```sql
# emp 테이블의 salary 최대값와 salary 최소값, salary 평균값 조회
select 'MAX' "LABEL", max(salary) "급여 집계" from emp
union all
select 'MIN', min(salary) from emp
union all
select 'AVG', round(avg(salary), 2) from emp
order by 1;

# 1990년 주요 수출 품목(export_rank.item)중 2018년과 2000년에는 없는 품목 조회
# 1990 - 2018 - 2000
select item from export_rank where year = 1990
minus
select item from export_rank where year = 2018
minus
select item from export_rank where year = 2000;
```
