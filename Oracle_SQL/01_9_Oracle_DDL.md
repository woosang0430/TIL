# DDL
- 생성 : create
- 수정 : alter
- 삭제 : drop

## 1. 테이블 생성(CREATE)
- 구문
   - `create table 테이블_이름( 컬럼설정 [,컬럼설정])`
### 제약 조건 설정

- 기본 문법
     - `constraint 제약조건이름 [제약조건타입]`
     - 테이블 제약 조건 조회 : USER_CONSTRAINTS 딕셔너리 뷰에서 조회
     ```sql
     select * from user_constraints where table_name = 'CUST';
     ```
     - 테이블 삭제
        - `drop table 테이블이름 [CASCADE CONSTRAINTS(부모테이블 삭제할 때)]`
  - `컬럼 레벨 설정` : 컬럼 설정에 같이 설정
  ```sql
  create table parent_tb(
    no  number constraint pk_parent_tb primary key,
    name  nvarchar2(30) not null,
    birthday date default sysdate, # 기본값 설정 : insert시 값을 넣지 않으면 insert될 기본값.
    email varchar2(100) constraint uk_parent_tb_email unique, # unique제약조건 : 중복된 값이 들어갈 수 없다. (null 제외)
    gender char(1) not null constraint ck_parent_tb_gender check(gender in ('M', 'F')) # check key : 값에 대한 제약 ('M', 'F'만 gender에 insert가능)
  );
  ```
  - `테이블 레벨 설정` : 뒤에서 따로 컬럼 설정
  ```sql
  create table child_tb(
    no number, --pk  
    jumin_num char(14) not null, --.uk
    age number(3) default 0, -- 10 ~ 90 (ck)
    parent_no number, -- parent_tb를 참조하는 fk
    constraint pk_child_tb primary key(no),
    constraint uk_child_tb_jumin_num unique(jumin_num),
    constraint ch_child_tb_age check(age between 10 and 90),
    constraint fk_child_tb_parent_tb foreign key(parent_no) references parent_tb(no)
  );
  ```
  
## 2. 테이블 수정(ALTER)
  
### 2-1. 컬럼 관련 수정

- 컬럼 추가
  ```sql
  alter table cust3 add(age number default 0 not null, point number);
  ```
  - ALTER TABLE 테이블이름 ADD(추가할 컬럼설정 [, 추가할 컬럼설정])
  - 하나의 컬럼만 추가할 경우 ( ) 는 생략가능

- 컬럼 수정
  ```sql
  alter table cust3 modify(age number(3)); -- 바꿀 값만 지정
  alter table cust3 modify(cust_email null); -- not null -> null로 바꾼다.
  ```
  ALTER TABLE 테이블이름 MODIFY(수정할컬럼명  변경설정 [, 수정할컬럼명  변경설정])
	- 하나의 컬럼만 수정할 경우 ( )는 생략 가능
	- 숫자/문자열 컬럼은 크기를 늘릴 수 있다.
		- 크기를 줄일 수 있는 경우 : 열에 값이 없거나 모든 값이 줄이려는 크기보다 작은 경우
	- 데이터가 모두 NULL이면 데이터타입을 변경할 수 있다. (단 CHAR<->VARCHAR2 는 가능.)

- 컬럼 삭제	
  ```sql
  alter table cust3 drop column age;
  ```
  ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름 [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : 삭제 컬럼 Primary Key인 경우 그 컬럼을 참조하는 다른 테이블의 Foreign key 설정을 모두 삭제한다.
	- 한번에 하나의 컬럼만 삭제 가능.
	
- ALTER TABLE 테이블이름 SET UNUSED (컬럼명 [, ..])
- ALTER TABLE 테이블이름 DROP UNUSED COLUMNS
    - SET UNUSED 설정시 컬럼을 바로 삭제하지 않고 삭제 표시를 한다. 
    - 설정된 컬럼은 사용할 수 없으나 실제 디스크에는 저장되 있다. 그래서 속도가 빠르다.
    - DROP UNUSED COLUMNS 로 SET UNUSED된 컬럼을 디스크에서 삭제한다. 

- 컬럼 이름 바꾸기
  ```sql
  alter table cust3 rename column cust_email to email; # cust_email => email 변경
  ```
    - ALTER TABLE 테이블이름 RENAME COLUMN 원래이름 TO 바꿀이름;

### 2-2. 제약 조건 관련 수정
-제약조건 추가
  ```sql
  alter table cust add constraint pk_cust primary key(cust_id); # cust테이블에 pk를 추가
  alter table cust add constraint uk_cust_cust_email unique(cust_email); # uk 추가
  alter table cust add constraint ck_cust_gender check(gender in ('M', 'F')); # ch 추가
  ```
  - ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 설정
 
- 제약조건 삭제
  ```sql
  alter table cust drop constraint ck_cust_gender;
  alter table cust drop constraint pk_cust;
	alter table cust drop primary key;
  ```
  - ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
  - PRIMARY KEY 제거: ALTER TABLE 테이블명 DROP PRIMARY KEY [CASCADE]
	      - `CASECADE` : 제거하는 Primary Key를 Foreign key 가진 다른 테이블의 Foreign key 설정을 모두 삭제한다.

  - NOT NULL <-> NULL 변환은 `컬럼 수정`을 통해 한다.
      - `ALTER TABLE 테이블명 MODIFY (컬럼명 NOT NULL)`
      - `ALTER TABLE 테이블명 MODIFY (컬럼명 NULL)`
      
      
#### 테이블 복사!
- customers 커피해서 cust
- select 결과 set을 테이블로 생성 (not null를 제외한 다른 제약조건은 카피가 안됨)
  ```sql
  create table cust
  as
  select * from customers; # select한 결과로 테이블을 만든다.
  ```

## 3. SEQUENCE(시퀀스)
- 자동증가하는 숫자를 제공하는 오라클 객체
- 테이블 컬럼이 자동증가하는 고유 번호를 가질때 사용
    - 하나의 시퀀스를 여러 테이블이 공유하면 중간이 빈 값들이 들어갈 수 있다.
### 3-1. 구문
```sql
CREATE SEQUENCE sequence이름
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE(default)]   
	[MINVALUE n | NOMINVALUE(default)]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]
```
- `INCREMENT BY n`: 증가치(default : 1)
- `START WITH n`: 시작 값(default : 0)
	- 시작값 설정시
	 - 증가: MINVALUE 보다 크커나 같은 값이어야 한다.
	 - 감소: MAXVALUE 보다 작거나 같은 값이어야 한다.
- `MAXVALUE n`: 생성할 수 있는 최대값
- `NOMAXVALUE` : 시퀀스가 생성할 수 있는 최대값을 오름차순의 경우 10^27 의 값. 내림차순의 경우 -1을 자동으로 설정. 
- `MINVALUE n` :최소 값을 지정
- `NOMINVALUE` :시퀀스가 생성하는 최소값을 오름차순의 경우 1, 내림차순의 경우 -(10^26)으로 설정
- `CYCLE` 또는 `NOCYCLE` : 최대/최소값까지 갔을때 순환할 지 여부. NOCYCLE이 (default : 순환반복하지 않는다.)
- `CACHE|NOCACHE` : 캐쉬 사용여부 지정.(오라클 서버가 시퀀스가 제공할 값을 미리 조회해 메모리에 저장) NOCACHE가 기본값(CACHE를 사용하지 않는다. )

### 3-2. 시퀀스 자동증가값 조회
 - `sequence이름.nextval`  : 다음 증감치 조회
 - `sequence이름.currval`  : 현재 시퀀스값 조회


### 3-3. 시퀀스 수정
```sql
ALTER SEQUENCE 수정할 시퀀스이름
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]	
```
- 수정후 생성되는 값들이 영향을 받는다. (그래서 `start with` 절은 **수정대상**이 아니다.)	  


### 3-4. 시퀀스 제거
 - `DROP SEQUENCE sequence이름`
