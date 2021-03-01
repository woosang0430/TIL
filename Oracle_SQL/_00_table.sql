-- 한줄 주석
/*
block 주석
테이블 : 회원(member)
속성
id : varchar2(10) primary key
password : varchar2(10) not null
name : nvarchar2(50)not null(not null로 하지 않으면 nullable
point : number(7) nullable
join_date : date not null
*/
create table member(
    id varchar2(10) primary key,  -- 주키(행 구별용) 중복 XX
    password varchar2(10) not null,
    name nvarchar2(50) not null,
    point number(7),
    join_date date not null
);
select * from tab;

-- 테이블 제거
 drop table member;
 
 -- 한행의 값을 추가 - insert
 -- 문자열 : ' ' 감싼다.
 -- date : '년/월/일' - 월/일이 단단위일 경우 앞에 0을 붙인다. ex) 05, 03
 insert into member (id, password, name, point, join_date) values ('id-1', 'abcde', '홍길동', 10000, '2020/10/05');
 -- 모든 컬럼에 값을 다 넣을 경우 컬럼명은 생략 가능.
 insert into member values ('id-2', '11111', '박영희', 10000, '2010/05/07');
 -- primary key(pk) 컬럼 : not null + unique
 insert into member values ('id-2', '11111', '장영수', 10000, '2013/07/07');
 --pk는 기존에 있는 값을 넣을 수 없다.
 insert into member values ('id-4', '11111', '박영희', 10000, '2013/07/07');
 insert into member values ('id-5', '11111', null, 10000, '2013/07/07'); 
 -- null : 값이 없다. name : not null  이기 때문에 null을 넣을 수 없다.
 insert into member values ('id-5', '11111', '윤우상', null, '2013/07/07');
 
select * from member;