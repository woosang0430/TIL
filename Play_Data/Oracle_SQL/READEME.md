SQL
(데이터 베이스에 데이터를 질의, 등록, 수정, 삭제 등을 요청하기 위한 언어)

1. DML : insert, update, delete, select
table에 data 추가, 수정, 삭제, 조회

2. DDL(많이씀) : create, alter, drop, truncate
DB 스키마(database나 table등) 생성 및 변경

3. DCL : grant, revoke
사용자에게 권한을 주거나 없애는 것과 같은 data접근을 제어하기 위한 언어

4. TCL : commit, rollback, savepoint
Transaction을 관리하는 언어

오라클 함수

1. 단일행 함수 (행 단위로 처리)
 - 행을 한개씩 처리
 
data type별 함수
  - char : 문자열
  - number : 숫자 (정수/실수)
  - date : 날짜

변환 함수
  - data type을 바꿔주는 함수
  - char을 기준으로 변환을 해준다.
  - number이랑 date 는 서로 변환 안됨
기타 함수

2. 다중행 함수(집계, 그룹 함수)
  - 여러 행을 묶어 한번에 처리
  - 평균, 합계, max, min 등등
