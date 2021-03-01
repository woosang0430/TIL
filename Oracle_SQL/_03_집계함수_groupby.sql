/* **************************************************************************
����(Aggregation) �Լ��� GROUP BY, HAVING
************************************************************************** */

/* ************************************************************
�����Լ�, �׷��Լ�, ������ �Լ�
- �μ�(argument)�� �÷�.
  - sum(): ��ü�հ�
  - avg(): ���
  - min(): �ּҰ�
  - max(): �ִ밪
  - stddev(): ǥ������
  - variance(): �л� -- ���� ������ ��ճ���
  - count(): ����
        - �μ�: 
            - �÷���: null�� ������ ����
            -  (*): �� ���(null�� ����)

- count(*) �� �����ϰ� ��� �����Լ��� null�� ���� ����Ѵ�.
- sum, avg, stddev, variance: number Ÿ�Կ��� ��밡��.
- min, max, count :  ��� Ÿ�Կ� �� ��밡��.
************************************************************* */

-- EMP ���̺��� �޿�(salary)�� ���հ�, ���, �ּҰ�, �ִ밪, ǥ������, �л�, ���������� ��ȸ 
select  sum(salary) "���հ�",
        round(avg(salary), 2) "���",
        min(salary) "�ּҰ�",
        max(salary) "�ִ밪",
        round(stddev(salary),2) "ǥ������",
        round(variance(salary), 2) "�л�",
        count(salary) "��������"
from    emp;

-- EMP ���̺��� ���� �ֱ� �Ի���(hire_date)�� ���� ������ �Ի����� ��ȸ
select  max(hire_date) "�ֱ� �Ի���",
        min(hire_date) "���� ������ �Ի���"
from    emp;


-- EMP ���̺��� �μ�(dept_name) �� ������ ��ȸ
select count(dept_name)
from    emp;


-- emp ���̺��� job ������ ���� ��ȸ
select count(distinct job)
from    emp;

select count(distinct nvl(dept_name, '�̹�ġ'))
from    emp;

--TODO:  Ŀ�̼� ����(comm_pct)�� �ִ� ������ ���� ��ȸ
select count(comm_pct)
from    emp;

select count(*)
from    emp
where comm_pct is not null;

--TODO: Ŀ�̼� ����(comm_pct)�� ���� ������ ���� ��ȸ

select count(*)
from    emp
where   comm_pct is null;

select count(*) - count(comm_pct)
from   emp;

--TODO: ���� ū Ŀ�̼Ǻ���(comm_pct)�� �� ���� ���� Ŀ�̼Ǻ����� ��ȸ
select max(comm_pct),
        min(comm_pct)
from    emp;

select max(comm_pct),
        min(comm_pct)
from    emp;

--TODO:  Ŀ�̼� ����(comm_pct)�� ����� ��ȸ. 
--�Ҽ��� ���� 2�ڸ����� ���
select round(avg(comm_pct), 2), -- comm_pct�� �ִ� �������� comm_pct���
        round(avg(nvl(comm_pct, 0)), 3) "��ü ���" -- comm_pct�� ���� ��� 0���� ġȯ�ѵ� ��� ���, ��ü ������ ���
        -- ��Ȳ�� �°� ��� ���Ҷ� �ΰ��� ���
from    emp;

select comm_pct from emp;


--TODO: ���� �̸�(emp_name) �� ���������� �����Ҷ� ���� ���߿� ��ġ�� �̸��� ��ȸ.
select max(emp_name), min(emp_name)
from    emp;

select emp_name from emp order by 1 desc;

--TODO: �޿�(salary)���� �ְ� �޿��װ� ���� �޿����� ������ ���
select max(salary) - min(salary)
from    emp;

select max(salary) - min(salary)
from    emp;

--TODO: ���� �� �̸�(emp_name)�� ����� ���� ��ȸ.
-- length(���ڿ�) : ���ڼ�
select max(length(emp_name))
from    emp;

select emp_name
from    emp
where   length(emp_name) = (select max(length(emp_name)) from emp); -- subqery


--TODO: EMP ���̺��� �μ�(dept_name)�� �������� �ִ��� ��ȸ. 
-- ���������� ����
select count(distinct dept_name), -- null�� ���� ��
       count(distinct nvl(dept_name, 'a')) -- null �����ؼ� ��
from    emp;

/* *****************************************************
group by ��
- Ư�� �÷�(��)�� ������ ���� ������ �� ������ �����÷��� �����ϴ� ����.
	- ��) ������ �޿����. �μ�-������ �޿� �հ�. ���� �������
- ����: group by �÷��� [, �÷���]
	- �÷�: �з���(������, �����) - �μ��� �޿� ���, ���� �޿� �հ�
	- select�� where �� ������ ����Ѵ�.
	- select ������ group by ���� ������ �÷��鸸 �����Լ��� ���� �� �� �ִ�
*******************************************************/

-- ����(job)�� �޿��� ���հ�, ���, �ּҰ�, �ִ밪, ǥ������, �л�, �������� ��ȸ
--              ~~�� ``�� ���
--               ^    ^
--        group by / ������ �÷�
select  job,
        sum(salary) "SUM",
        round(avg(salary), 2) "AVG",
        min(salary) "MIN",
        max(salary) "MAX",
        round(stddev(salary), 2) "STDDEV",
        round(variance(salary), 2) "VAR",
        count(*) "COUNT"
from emp
group by job
order by 1 asc;


-- �Ի翬�� �� �������� �޿� ���.
select  extract(year from hire_date) "year",
        round(avg(salary), 2) "sal_avg"
from    emp
group by extract(year from hire_date)
order by 1 asc;

-- �μ���(dept_name) �� 'Sales'�̰ų� 'Purchasing' �� �������� ������ (job) �������� ��ȸ
select  dept_name,
        job,
        count(*) as "������"
from    emp
where   dept_name in ('Sales', 'Purchasing')
group by dept_name, job
order by 1 desc;

-- �μ�(dept_name), ����(job) �� �ִ� ��ձ޿�(salary)�� ��ȸ.
select  dept_name,
        job,
        max(salary)
from    emp
group by dept_name, job
order by 1;

-- �޿�(salary) ������ �������� ���. �޿� ������ 10000 �̸�,  10000�̻� �� ����.
select  case when salary >= 10000 then '10000�̻�'
              else '10000�̸�' end "�޿�����",
        count(*)
from    emp
group by case when salary >= 10000 then '10000�̻�'
              else '10000�̸�' end;


--TODO: �μ���(dept_name) �������� ��ȸ
select dept_name,
        count(*)
from    emp
group by dept_name
order by 2 desc;

--TODO: ������(job) �������� ��ȸ. �������� ���� �ͺ��� ����.
select job,
        count(*)
from    emp
group by job
order by 2 desc;

--TODO: �μ���(dept_name), ����(job)�� ������, �ְ�޿�(salary)�� ��ȸ. �μ��̸����� �������� ����.
select dept_name,
        count(job),
        max(salary)
from    emp
group by dept_name, job
order by dept_name asc;

select  dept_name,
        job,
        count(*)
from    emp
group by dept_name, job
order by 1;



--TODO: EMP ���̺��� �Ի翬����(hire_date) �� �޿�(salary)�� �հ��� ��ȸ. 
--(�޿� �հ�� �ڸ������� , �� �����ÿ�. ex: 2,000,000)
select extract(year from hire_date) "�Ի�⵵",
        to_char(sum(salary), '9,999,999') "�� �޿�"
from    emp
group by extract(year from hire_date);

select  to_char(hire_date, 'yyyy') "�Ի�⵵",
        to_char(sum(salary), 'fmL9,999,999') "�޿��հ�"
from    emp
group by to_char(hire_date, 'yyyy');


--TODO: ����(job)�� �Ի�⵵(hire_date)�� ��� �޿�(salary)�� ��ȸ
select job,
        extract(year from hire_date) "�Ի�⵵",
        round(avg(salary), 2) "��ձ޿�"
from    emp
group by job, extract(year from hire_date)
order by 1;


--TODO: �μ���(dept_name) ������ ��ȸ�ϴµ� �μ���(dept_name)�� null�� ���� �����ϰ� ��ȸ.
select  dept_name,
        count(dept_name)
from    emp
group by dept_name;

select  dept_name,
        count(*)
from    emp
where dept_name is not null
group by dept_name;


--TODO �޿� ������ �������� ���. �޿� ������ 5000 �̸�, 5000�̻� 10000 �̸�, 10000�̻� 20000�̸�, 20000�̻�. 
select case when salary >= 20000 then '2���̻�'
            when salary < 20000 and salary >= 10000 then '2���̸� 1���̻�'
            when salary < 10000 and salary >= 5000 then '1���̸� 5õ�̻�'
            else '5õ�̸�' end "�޿�����",
        count(*)
from    emp
group by case when salary >= 20000 then '2���̻�'
            when salary < 20000 and salary >= 10000 then '2���̸� 1���̻�'
            when salary < 10000 and salary >= 5000 then '1���̸� 5õ�̻�'
            else '5õ�̸�' end;
            
select case when salary < 5000 then '1���'
              when salary between 5000 and 9999.99 then '2���'
              when salary between 10000 and 19999.99 then '3���'
              else '4���' end "�޿����",
       count(*)
from    emp
group by case when salary < 5000 then '1���'
              when salary between 5000 and 9999.99 then '2���'
              when salary between 10000 and 19999.99 then '3���'
              else '4���' end
order by 1 asc;


/* **************************************************************
having ��
- �������� ���� �� ���� ����
- group by ���� order by ���� �´�.
- ����
    having ��������  --�����ڴ� where���� �����ڸ� ����Ѵ�. �ǿ����ڴ� �����Լ�(�� ���)
************************************************************** */

-- �������� 10 �̻��� �μ��� �μ���(dept_name)�� �������� ��ȸ
select  dept_name,
        count(*) "������",
        sum(salary)
from    emp
group by dept_name
having count(*) >= 10  -- where�������� ������ ������ ���Ѵ�.
order by 2 desc;

-- �������� 10�� �̻��� �μ��� �μ��� �޿��հ�
select  dept_name,
        to_char(sum(salary), '$999,999') "�޿��հ�"
from    emp
group by dept_name
having count(*) >= 10
order by 2 desc;

--TODO: 15�� �̻��� �Ի��� �⵵�� (�� �ؿ�) �Ի��� �������� ��ȸ.
select  extract(year from hire_date),
        count(*)
from    emp
group by extract(year from hire_date)
having count(*) >= 15;


select to_char(hire_date, 'yyyy') "�Ի�⵵",
       count(*) "������",
       max(salary) "�ְ�޿�"
from    emp
group by to_char(hire_date, 'yyyy')
having count(*) >= 15;
------------------------------------------
select extract(year from hire_date),
        count(*)
from emp
group by extract(year from hire_date);

--TODO: �� ����(job)�� ����ϴ� ������ ���� 10�� �̻��� ����(job)��� ��� �������� ��ȸ
select  job,
        count(job)
from    emp
group by job
having count(*) >= 10;

select job,
        count(*)
from    emp
group by job
having count(*) >= 10;

--TODO: ��� �޿���(salary) $5000�̻��� �μ��� �̸�(dept_name)�� ��� �޿�(salary), �������� ��ȸ
select dept_name,
        round(avg(salary), 2),
        count(*)
from emp
group by dept_name
having  round(avg(salary), 2) >= 5000;

--TODO: ��ձ޿��� $5,000 �̻��̰� �ѱ޿��� $50,000 �̻��� �μ��� �μ���(dept_name), ��ձ޿��� �ѱ޿��� ��ȸ
select  dept_name,
        round(avg(salary), 2),
        sum(salary)
from    emp
group by dept_name
having round(avg(salary), 2) >=5000 
and sum(salary) >= 50000;



--TODO ������ 2�� �̻��� �μ����� �̸��� �޿��� ǥ�������� ��ȸ
select dept_name,
        stddev(salary)
from    emp
group by dept_name
having count(*) >=2;

select dept_name,
       round(stddev(salary), 2) "�޿�ǥ������"
from    emp
group by dept_name
having count(*) >= 2;



/* **************************************************************
- rollup : group by�� Ȯ��.
  - group by�� ���� ������ ��� ��������(�߰����質 ������)�� �κ� ���迡 �߰��ؼ� ��ȸ�Ѵ�.
  - ���� : group by rollup(�÷��� [,�÷���,..])



- grouping(), grouping_id()
  - rollup �̿��� ����� �÷��� �� ���� ���迡 �����ߴ��� ���θ� ��ȯ�ϴ� �Լ�.
  - case/decode�� �̿��� ���̺��� �ٿ� �������� ���� �� �ִ�.
  - ��ȯ��
	- 0 : ������ ���
	- 1 : ���� ���� ���.
 
rollup ����
- grouping() �Լ�     ====�Ѱ� �ۿ� ó�� ���� �׳� grouping_id�������
 - ����: grouping(groupby�÷�)
 - select ���� ���Ǹ� rollup�̳� cube�� �Բ� ����ؾ� �Ѵ�.
 - group by�� �÷��� �����Լ��� ���迡 �����ߴ��� ���θ� ��ȯ
	- ��ȯ�� 0 : ������(�κ������Լ� ���), ��ȯ�� 1: ���� ����(���������� ���)
 - ���� �������� �κ������� ��������� �˷��ִ� �� �� �ִ�.


rollup ����
- grouping_id() �Լ�   ==== ������ ó�� ����
  - ����: grouping_id(groupby �÷�, ..)
  - ������ �÷��� ���迡 ���Ǿ����� ���� 2����(0: ���� ����, 1: ������)�� ��ȯ �ѵ� 10������ ��ȯ�ؼ� ��ȯ�Ѵ�.
 
************************************************************** */

-- EMP ���̺��� ����(job) �� �޿�(salary)�� ��հ� ����� �Ѱ赵 ���̳������� ��ȸ.
select job,
        round(avg(salary), 2) "��ձ޿�"
from    emp
group by rollup(job);
        


select  job,
        round(avg(salary), 2) "���"
from    emp
group by rollup(job);


-- EMP ���̺��� ����(JOB) �� �޿�(salary)�� ��հ� ����� �Ѱ赵 ���̳������� ��ȸ.
-- ���� �÷���  �Ұ質 �Ѱ��̸� '�����'��  �Ϲ� �����̸� ����(job)�� ���
select  decode(grouping(job), 0, job,
                              1, '�����') "job",
        round(avg(salary), 2) "���"
from    emp
group by rollup(job);


-- dept_name, job
-- EMP ���̺��� �μ�(dept_name), ����(job) �� salary�� �հ�� �������� �Ұ�� �Ѱ谡 �������� ��ȸ
select  decode(grouping_id(dept_name, job), 0, nvl(dept_name, '�̹�ġ')||'-'||job,
                                         1, nvl(dept_name, '�̹�ġ')||' �Ұ�',
                                         3, '�Ѱ�') "Label",
        sum(salary) "�� �޿�",
        count(*) "�� ������"
from    emp
group by rollup(dept_name, job);


--# �Ѱ�/�Ұ� ���� ��� :  �Ѱ�� '�Ѱ�', �߰������ '��' �� ���
--TODO: �μ���(dept_name) �� �ִ� salary�� �ּ� salary�� ��ȸ
-- nvl(decode(group_id()))
select  nvl(decode(grouping_id(dept_name), 1, '�Ѱ�',
                                          0, dept_name), '�̹�ġ') "dept_name",
        max(salary),
        min(salary)
from    emp
group by rollup(dept_name);



--TODO: ���_id(mgr_id) �� ������ ���� �Ѱ踦 ��ȸ�Ͻÿ�.
select  decode(grouping_id(mgr_id), 1, '�Ѱ�', -- decode()�� ��ȯ������ ���ڿ��� �ٸ� Ÿ���� ����� ��� ���ڿ��� ���� ���.
                                    0, mgr_id) "mgr_id",
        count(*)
from    emp
group by rollup(mgr_id);

--TODO: �Ի翬��(hire_date�� year)�� �������� ���� ���� �հ� �׸��� �Ѱ谡 ���� ��µǵ��� ��ȸ.
select  decode(grouping_id(to_char(hire_date, 'yyyy')), 1, '�Ѱ�',
                                                       0, to_char(hire_date, 'yyyy')) "�Ի�⵵",
        count(*) "������",
        sum(salary) "�޿��հ�"
from    emp
group by rollup(to_char(hire_date, 'yyyy'));

--TODO: �μ���(dept_name), �Ի�⵵�� ��� �޿�(salary) ��ȸ. �μ��� ����� �����谡 ���� �������� ��ȸ
select  decode(grouping_id(dept_name, to_char(hire_date, 'yyyy')),
                                       3, '�Ѱ�',
                                       1, dept_name|| ' �Ұ�',
                                       0, dept_name||'-'||to_char(hire_date, 'yyyy')) "Label",
        to_char(hire_date, 'yyyy'),
        round(avg(salary), 2) "��ձ޿�"
from    emp
group by rollup(dept_name, to_char(hire_date, 'yyyy'))
order by 1 asc;


-- ���ϴ� ����
-- 5 select  �÷� ����
-- 1 from    ���̺�
-- 2 where   �� ����
-- 3 group by �׷� ���� �÷�
-- 4 having  �׷��� ��������
-- 6 order by ����;

select dept_name
from    emp
where   dept_name is not null;

select * from emp;







