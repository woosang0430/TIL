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
```

#### 2. having 절
- 집계결과에 대한 행 제약 조건
- group by 다음 order by 전에 온다.
- 구문
    having 제약조건  --연산자는 where절의 연산자를 사용한다. 피연산자는 집계함수(의 결과)

where절은 그룹 함수를 사용할 수 없다.



#### 3. rollup : group by의 확장.
  - 두개 이상의 컬럼을 group by로 묶은 경우 누적집계(중간집계나 총집계)를 부분 집계에 추가해서 조회한다.
  - 구문 : group by rollup(컬럼명 [,컬럼명,..])


#### 4. grouping(), grouping_id()
  - decode나 case구문이랑 같이 쓴다.
  - rollup 이용한 집계시 컬럼이 각 행의 집계에 참여했는지 여부를 반환하는 함수.
  - case/decode를 이용해 레이블을 붙여 가독성을 높일 수 있다.
  - 반환값
	- 0 : 참여한 경우
	- 1 : 참여 안한 경우.
 
##### 4-1. rollup 사용시
- grouping() 함수 
 - 구문: grouping(groupby컬럼)
 - select 절에 사용되며 rollup이나 cube와 함께 사용해야 한다.
 - group by의 컬럼이 집계함수의 집계에 참여했는지 여부를 반환
	- 반환값 0 : 참여함(부분집계함수 결과), 반환값 1: 참여 안함(누적집계의 결과)
 - 누적 집계인지 부분집계의 결과인지를 알려주는 알 수 있다.


##### 4-2. rollup 사용시
- grouping_id() 함수
  - 구문: grouping_id(groupby 컬럼, ..)
  - 전달한 컬럼이 집계에 사용되었는지 여부 2진수(0: 참여 안함, 1: 참여함)로 반환 한뒤 10진수로 변환해서 반환한다.

