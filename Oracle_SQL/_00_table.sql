-- ���� �ּ�
/*
block �ּ�
���̺� : ȸ��(member)
�Ӽ�
id : varchar2(10) primary key
password : varchar2(10) not null
name : nvarchar2(50)not null(not null�� ���� ������ nullable
point : number(7) nullable
join_date : date not null
*/
create table member(
    id varchar2(10) primary key,  -- ��Ű(�� ������) �ߺ� XX
    password varchar2(10) not null,
    name nvarchar2(50) not null,
    point number(7),
    join_date date not null
);
select * from tab;

-- ���̺� ����
 drop table member;
 
 -- ������ ���� �߰� - insert
 -- ���ڿ� : ' ' ���Ѵ�.
 -- date : '��/��/��' - ��/���� �ܴ����� ��� �տ� 0�� ���δ�. ex) 05, 03
 insert into member (id, password, name, point, join_date) values ('id-1', 'abcde', 'ȫ�浿', 10000, '2020/10/05');
 -- ��� �÷��� ���� �� ���� ��� �÷����� ���� ����.
 insert into member values ('id-2', '11111', '�ڿ���', 10000, '2010/05/07');
 -- primary key(pk) �÷� : not null + unique
 insert into member values ('id-2', '11111', '�念��', 10000, '2013/07/07');
 --pk�� ������ �ִ� ���� ���� �� ����.
 insert into member values ('id-4', '11111', '�ڿ���', 10000, '2013/07/07');
 insert into member values ('id-5', '11111', null, 10000, '2013/07/07'); 
 -- null : ���� ����. name : not null  �̱� ������ null�� ���� �� ����.
 insert into member values ('id-5', '11111', '�����', null, '2013/07/07');
 
select * from member;