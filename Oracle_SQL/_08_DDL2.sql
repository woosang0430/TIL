CREATE TABLE salary_stat (dept_id number(6), salary_sum number(15,2), salary_avg number(10, 2), salary_max number(7, 2),
salary_min number(7, 2), salary_var number(20, 2), salary_stddev number(7, 2));

INSERT INTO salary_stat 
SELECT  dept_id,
        sum(salary),
        round(avg(salary), 2),
        max(salary),
        min(salary),
        round(variance(salary), 2),
        round(stddev(salary), 2) 
FROM emp 
GROUP BY dept_id;


/* ***********************************************************************************
DDL - DataBase�� ��ü�� �����Ѵ�.
- ���� : create
- ���� : alter
- ���� : drop

���̺� ����
- ����
create table ���̺�_�̸�(
  �÷� ���� [, �÷�����]
)

�������� ���� 
- �÷� ���� ����
    - �÷� ������ ���� ����
- ���̺� ���� ����
    - �÷� �����ڿ� ���� ����

- �⺻ ���� : `constraint ���������̸� [��������Ÿ��]`
- ���̺� ���� ���� ��ȸ
    - USER_CONSTRAINTS ��ųʸ� �信�� ��ȸ
    
���̺� ����
- ����
DROP TABLE ���̺��̸� [CASCADE CONSTRAINTS(�θ����̺� ������ ��)]
*********************************************************************************** */
create table emp(
    id varchar2(10) primary key
); 

-- �÷� ���� ����
--no number primary key
create table parent_tb(
    no  number constraint pk_parent_tb primary key,
    name  nvarchar2(30) not null,
    birthday date default sysdate, -- �⺻�� ���� : insert�� ���� ���� ������ insert�� �⺻��.
    email varchar2(100) constraint uk_parent_tb_email unique, -- unique�������� : �ߺ��� ���� �� �� ����. (null ����)
    gender char(1) not null constraint ck_parent_tb_gender check(gender in ('M', 'F')) -- check key : ���� ���� ���� ('M', 'F'�� gender�� insert����)
);
-- check(price > 100)

insert into parent_tb values(1, 'ȫ�浿', '2000/01/01', 'a@a.com', 'M');
insert into parent_tb (no, name, gender) values (2, '�̼���', 'M');
insert into parent_tb values(3, 'ȫ�浿2', null, 'b@a.com', 'M'); -- ��������� null�� ������ default ���� �ƴ϶� null�� insert�ȴ�.
insert into parent_tb values(4, 'ȫ�浿2', null, 'b@a.com', 'M');
insert into parent_tb values(5, '�迵��', null, 'c@a.com', 'm');

select * from parent_tb;

insert into dept values (10, 'a', 'b');

-- ���̺� ���� ����
create table child_tb(
    no number, --pk  
    jumin_num char(14) not null, --.uk
    age number(3) default 0, -- 10 ~ 90 (ck)
    parent_no number, -- parent_tb�� �����ϴ� fk
    constraint pk_child_tb primary key(no),
    constraint uk_child_tb_jumin_num unique(jumin_num),
    constraint ch_child_tb_age check(age between 10 and 90),
    constraint fk_child_tb_parent_tb foreign key(parent_no) references parent_tb(no)
);




/* ************************************************************************************
ALTER : ���̺� ����

�÷� ���� ����

- �÷� �߰�
  ALTER TABLE ���̺��̸� ADD (�߰��� �÷����� [, �߰��� �÷�����])
  - �ϳ��� �÷��� �߰��� ��� ( ) �� ��������

- �÷� ����
  ALTER TABLE ���̺��̸� MODIFY (�������÷���  ���漳�� [, �������÷���  ���漳��])
	- �ϳ��� �÷��� ������ ��� ( )�� ���� ����
	- ����/���ڿ� �÷��� ũ�⸦ �ø� �� �ִ�.
		- ũ�⸦ ���� �� �ִ� ��� : ���� ���� ���ų� ��� ���� ���̷��� ũ�⺸�� ���� ���
	- �����Ͱ� ��� NULL�̸� ������Ÿ���� ������ �� �ִ�. (�� CHAR<->VARCHAR2 �� ����.)

- �÷� ����	
  ALTER TABLE ���̺��̸� DROP COLUMN �÷��̸� [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : �����ϴ� �÷��� Primary Key�� ��� �� �÷��� �����ϴ� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.
	- �ѹ��� �ϳ��� �÷��� ���� ����.
	
  ALTER TABLE ���̺��̸� SET UNUSED (�÷��� [, ..])
  ALTER TABLE ���̺��̸� DROP UNUSED COLUMNS
	- SET UNUSED ������ �÷��� �ٷ� �������� �ʰ� ���� ǥ�ø� �Ѵ�. 
	- ������ �÷��� ����� �� ������ ���� ��ũ���� ����� �ִ�. �׷��� �ӵ��� ������.
	- DROP UNUSED COLUMNS �� SET UNUSED�� �÷��� ��ũ���� �����Ѵ�. 

- �÷� �̸� �ٲٱ�
  ALTER TABLE ���̺��̸� RENAME COLUMN �����̸� TO �ٲ��̸�;

**************************************************************************************  
���� ���� ���� ����
-�������� �߰�
  ALTER TABLE ���̺�� ADD CONSTRAINT �������� ����

- �������� ����
  ALTER TABLE ���̺�� DROP CONSTRAINT ���������̸�
  PRIMARY KEY ����: ALTER TABLE ���̺�� DROP PRIMARY KEY [CASCADE]
	- CASECADE : �����ϴ� Primary Key�� Foreign key ���� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.

- NOT NULL <-> NULL ��ȯ�� �÷� ������ ���� �Ѵ�.
   - ALTER TABLE ���̺�� MODIFY (�÷��� NOT NULL),  - ALTER TABLE ���̺�� MODIFY (�÷��� NULL)  
************************************************************************************ */
-- customers Ŀ���ؼ� cust
-- select ��� set�� ���̺�� ���� (not null�� ������ �ٸ� ���������� ī�ǰ� �ȵ�)
create table cust
as
select * from customers; -- select�� ����� ���̺��� �����.

create table cust2
as
select cust_id, cust_name, address from customers;

create table cust3
as
select * from customers
where 1 = 0; -- False

select * from cust3;

--�߰�
alter table cust3 add(age number default 0 not null, point number);

--����
alter table cust3 modify(age number(3)); -- �ٲ� ���� ����
alter table cust3 modify(cust_email null); -- not null -> null�� �ٲ۴�.
alter table cust3 modify(cust_email not null);

--�÷��� ����
alter table cust3 rename column cust_email to email; -- cust_email => email ����

-- �÷� ����
alter table cust3 drop column age;
desc cust3;

desc cust;
select * from cust;

alter table cust modify (cust_id number(2)); -- -99~99
alter table cust modify (cust_id number(5)); -- -99999~99999
alter table cust add (age number(3));
select * from cust;


alter table cust3 modify (cust_id number(2));

--rollback/commit-DML��; DDL���� rollback/commit ����� �ƴϴ�.
desc cust;

-- �������� ����
-- �� ���̺��� �������ǵ� ��ȸ
select * from user_constraints;

--�߰�
alter table cust add constraint pk_cust primary key(cust_id); -- cust���̺� pk�� �߰�
alter table cust add constraint uk_cust_cust_email unique(cust_email); -- uk �߰�
alter table cust add constraint ck_cust_gender check(gender in ('M', 'F')); -- ch

-- ����
alter table cust drop constraint ck_cust_gender;
alter table cust drop constraint pk_cust;
alter table cust drop primary key;

select * from user_constraints where table_name = 'CUST';


--TODO: emp ���̺��� ī���ؼ� emp2�� ����(Ʋ�� ī��)
create table emp2
as
select * from emp
where 1 = 0;

desc emp2;
desc emp;
--TODO: gender �÷��� �߰�: type char(1)
alter table emp2 add (gender char(1));
select * from emp2;


--TODO: email �÷� �߰�. type: varchar2(100),  not null  �÷�
alter table emp2 add (email varchar2(100) not null);
select * from emp2;


--TODO: jumin_num(�ֹι�ȣ) �÷��� �߰�. type: char(14), null ���. ������ ���� ������ �÷�.
alter table emp2 add (jumin_num char(14) constraint uk_emp2_jumin unique);

desc emp2;
select * from user_constraints where table_name= 'EMP2';-------------------------------------

--TODO: emp_id �� primary key �� ����
alter table emp2 modify (emp_id primary key); 
select * from emp2;

alter table emp2 add constraint pk_emp2 primary key(emp_id);
  
--TODO: gender �÷��� M, F �����ϵ���  �������� �߰�
alter table emp2 add constraint ck_emp2_gender check(gender in ('M','F'));
select * from emp2;

 
--TODO: salary �÷��� 0�̻��� ���鸸 ������ �������� �߰�
alter table emp2 add constraint ck_emp2_salary check(salary >=0);
select * from user_constraints where table_name= 'EMP2';---------------------------------------

--TODO: email �÷��� null�� ���� �� �ֵ� �ٸ� ��� ���� ���� ������ ���ϵ��� ���� ���� ����
alter table emp2 add constraint uk_emp2_email unique (email);
alter table emp2 modify (email null);


--TODO: emp_name �� ������ Ÿ���� varchar2(100) ���� ��ȯ
alter table emp2 modify (emp_name varchar2(100));

desc emp2;
--TODO: job_id�� not null �÷����� ����
alter table emp2 modify (job_id not null);


--TODO: dept_id�� not null �÷����� ����
alter table emp2 modify (dept_id not null);

--TODO: job_id  �� null ��� �÷����� ����
alter table emp2 modify (job_id null);


--TODO: dept_id  �� null ��� �÷����� ����
alter table emp2 modify (dept_id null);

--TODO: ������ ������ uk_emp2_email ���� ������ ����
alter table emp2 drop constraint uk_emp2_email;


--TODO: ������ ������ ck_emp2_salary ���� ������ ����
alter table emp2 drop constraint ck_emp2_salary;

select * from user_constraints where table_name= 'EMP2';
--TODO: primary key �������� ����
alter table emp2 drop primary key;


--TODO: gender �÷�����
alter table emp2 drop column gender;


--TODO: email �÷� ����
alter table emp2 drop column email;

desc emp2;
/* **************************************************************************************************************
-- ����Ŭ ����
������ : SEQUENCE
- �ڵ������ϴ� ���ڸ� �����ϴ� ����Ŭ ��ü
- ���̺� �÷��� �ڵ������ϴ� ������ȣ�� ������ ����Ѵ�.
	- �ϳ��� �������� ���� ���̺��� �����ϸ� �߰��� �� ������ �� �� �ִ�.

���� ����
CREATE SEQUENCE sequence�̸�
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE(default)]   
	[MINVALUE n | NOMINVALUE(default)]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE] 

- INCREMENT BY n: ����ġ ����. ������ 1
- START WITH n: ���� �� ����. ������ 0
	- ���۰� ������
	 - ����: MINVALUE ���� ũĿ�� ���� ���̾�� �Ѵ�.
	 - ����: MAXVALUE ���� �۰ų� ���� ���̾�� �Ѵ�.
- MAXVALUE n: �������� ������ �� �ִ� �ִ밪�� ����
- NOMAXVALUE : �������� ������ �� �ִ� �ִ밪�� ���������� ��� 10^27 �� ��. ���������� ��� -1�� �ڵ����� ����. 
- MINVALUE n :�ּ� ������ ���� ����
- NOMINVALUE :�������� �����ϴ� �ּҰ��� ���������� ��� 1, ���������� ��� -(10^26)���� ����
- CYCLE �Ǵ� NOCYCLE : �ִ�/�ּҰ����� ������ ��ȯ�� �� ����. NOCYCLE�� �⺻��(��ȯ�ݺ����� �ʴ´�.)
- CACHE|NOCACHE : ĳ�� ��뿩�� ����.(����Ŭ ������ �������� ������ ���� �̸� ��ȸ�� �޸𸮿� ����) NOCACHE�� �⺻��(CACHE�� ������� �ʴ´�. )


������ �ڵ������� ��ȸ
 - sequence�̸�.nextval  : ���� ����ġ ��ȸ
 - sequence�̸�.currval  : ���� �������� ��ȸ


������ ����
ALTER SEQUENCE ������ �������̸�
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]	

������ �����Ǵ� ������ ������ �޴´�. (�׷��� start with ���� ��������� �ƴϴ�.)	  


������ ����
DROP SEQUENCE sequence�̸�
	
************************************************************************************************************** */

-- 1���� 1�� �ڵ������ϴ� ������
create sequence dept_id_seq;-- �̸� ����: �������� ����� �÷���_seq
-- ################���� ���̾�###################
--seq�̸�.nextval()
select dept_id_seq.nextval from dual;
select dept_id_seq.currval from dual;

insert into dept values (dept_id_seq.nextval, '���μ�'||dept_id_seq.currval, '����');

select * from dept order by dept_id;
-- 1���� 50���� 10�� �ڵ����� �ϴ� ������
create sequence ex1_seq
       increment by 10 
       maxvalue 50;
       
select  ex1_seq.nextval from dual;



-- 100 ���� 150���� 10�� �ڵ������ϴ� ������
create sequence ex2_seq
        increment by 10
        start with 100
        maxvalue 150;
        
select ex2_seq.nextval from dual;


-- 100 ���� 150���� 10�� �ڵ������ϵ� �ִ밪�� �ٴٸ��� ��ȯ�ϴ� ������
-- ��ȯ(cycle) �Ҷ� ����(increment by ���) : minvalue(default:1)���� ����
-- ��ȯ(cycle) �Ҷ� ����(increment by ����) : maxvalue(default:-1)���� ����
drop sequence ex3_seq;
create sequence ex3_seq
        increment by 10
        start with 100
        maxvalue 150
        minvalue 100
        cache 5
        cycle; -- ����Ŭ ������ minvalue, maxvalue ���� ���!
        
select ex3_seq.nextval from dual;

-- -1���� -1�� �ڵ� �����ϴ� ������
create sequence ex4_seq
    increment by -1; -- �ڵ����� : start with (default = -1)

select ex4_seq.nextval from dual;


-- -1���� -50���� -10�� �ڵ� �����ϴ� ������
drop sequence ex5_seq;
create sequence ex5_seq
    increment by -10
    minvalue -50;

select ex5_seq.nextval from dual;

-- 100 ���� -100���� -100�� �ڵ� �����ϴ� ������
drop sequence ex6_seq;
create sequence ex6_seq
    increment by - 100
    start with 100
    maxvalue 100
    minvalue -100;
    -- maxvalue : 1(���ҽ� default : 1)
    -- ���� : maxvalure >= startvalue
    -- ���� : minvalue <= startvalue
select ex6_seq.nextval from dual;


-- 15���� -15���� 1�� �����ϴ� ������ �ۼ�
create sequence ex7_seq
    increment by -1
    start with 15
    maxvalue 15
    minvalue -15;
    
select ex7_seq.nextval from dual;


-- -10 ���� 1�� �����ϴ� ������ �ۼ�
drop sequence ex8_seq;
create sequence ex8_seq
        increment by 1
        start with -10
        minvalue -10
        ;
    -- ���� minvalue 1�� �⺻��. ���� : minvalue <= start with
select ex8_seq.nextval from dual;
-- Sequence�� �̿��� �� insert


-- TODO: �μ�ID(dept.dept_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 10�� �����ϴ� sequence
-- ������ ������ sequence�� ����ؼ�  dept_copy�� 5���� ���� insert.
select * from dept_copy;

create sequence dept_id_seq1
        increment by 10
        start with 10;

drop table dept_copy;

create table dept_copy
as
select * from dept
where 1=0;

insert into dept_copy values (dept_id_seq1.nextval, '��ȹ��', '����');

select * from dept_copy;

-- TODO: ����ID(emp.emp_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 1�� �����ϴ� sequence
-- ������ ������ sequence�� ����� emp_copy�� ���� 5�� insert
create sequence emp_id_seq
        start with 10;
        
insert into emp2 values(emp_id_seq.nextval, 'ȫ�浿', null, null, sysdate, 3000, null, null, null);
insert into emp2 values(emp_id_seq.nextval, '�̼���', null, null, sysdate, 3000, null, null, null);
insert into emp2 values(emp_id_seq.nextval, '�����', null, null, sysdate, 3000, null, null, null);

select *from emp2;

