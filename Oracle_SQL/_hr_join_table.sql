--------------------------------------------------------
-- DDL FOR DEPT
-- 부서 테이블
--------------------------------------------------------
DROP TABLE DEPT CASCADE CONSTRAINT;
CREATE TABLE DEPT(
    DEPT_ID NUMBER(4,0) PRIMARY KEY,
    DEPT_NAME VARCHAR2(100) NOT NULL,
    LOC VARCHAR2(100) NOT NULL
);
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (10,'Administration','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (20,'Marketing','New York');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (30,'Purchasing','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (40,'Human Resources','New York');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (50,'Shipping','San Francisco');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (60,'IT','San Francisco');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (70,'Public Relations','New York');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (80,'Sales','New York');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (90,'Executive','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (100,'Finance','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (110,'Accounting','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (120,'Treasury','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (130,'Corporate Tax','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (140,'Control And Credit','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (150,'Shareholder Services','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (160,'Benefits','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (170,'Manufacturing','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (180,'Construction','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (190,'Contracting','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (200,'Operations','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (210,'IT Support','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (220,'NOC','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (230,'IT Helpdesk','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (240,'Government Sales','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (250,'Retail Sales','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (260,'Recruiting','Seattle');
Insert into DEPT (DEPT_ID,DEPT_NAME,LOC) values (270,'Payroll','Seattle');




--------------------------------------------------------
--  DDL for Table JOB
--  직원 업무 테이블?
--------------------------------------------------------
DROP TABLE JOB CASCADE CONSTRAINT;
CREATE TABLE JOB(
    JOB_ID VARCHAR(30) PRIMARY KEY,
    JOB_TITLE VARCHAR(100) NOT NULL,
    MIN_SALARY NUMBER(6) NOT NULL,
    MAX_SALARY NUMBER(6) NOT NULL
);


Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AD_PRES','President',20080,40000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AD_VP','Administration Vice President',15000,30000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AD_ASST','Administration Assistant',3000,6000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('FI_MGR','Finance Manager',8200,16000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('FI_ACCOUNT','Accountant',4200,9000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AC_MGR','Accounting Manager',8200,16000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('AC_ACCOUNT','Public Accountant',4200,9000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('SA_MAN','Sales Manager',10000,20080);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('SA_REP','Sales Representative',6000,12008);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('PU_MAN','Purchasing Manager',8000,15000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('PU_CLERK','Purchasing Clerk',2500,5500);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('ST_MAN','Stock Manager',5500,8500);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('ST_CLERK','Stock Clerk',2008,5000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('SH_CLERK','Shipping Clerk',2500,5500);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('IT_PROG','Programmer',4000,10000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('MK_MAN','Marketing Manager',9000,15000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('MK_REP','Marketing Representative',4000,9000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('HR_REP','Human Resources Representative',4000,9000);
Insert into JOB (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('PR_REP','Public Relations Representative',4500,10500);



--------------------------------------------------------
--  DDL for Table EMP 
--  직원 테이블
--------------------------------------------------------
DROP TABLE EMP CASCADE CONSTRAINT;
DROP TABLE EMP;
CREATE TABLE EMP(
    EMP_ID NUMBER(6) PRIMARY KEY,
    EMP_NAME VARCHAR2(20) NOT NULL,
    JOB_ID VARCHAR2(30),
    MGR_ID NUMBER(6),
    HIRE_DATE DATE NOT NULL,
    SALARY NUMBER(7,2) NOT NULL,
    COMM_PCT NUMBER(2,2),
    DEPT_ID NUMBER(4,0),
    CONSTRAINT FK_EMP_DEPT FOREIGN KEY(DEPT_ID) REFERENCES DEPT(DEPT_ID) ON DELETE SET NULL,
    CONSTRAINT FK_EMP_JOB FOREIGN KEY(JOB_ID) REFERENCES JOB(JOB_ID) ON DELETE SET NULL,
    CONSTRAINT FK_EMP_MGR FOREIGN KEY(MGR_ID) REFERENCES EMP(EMP_ID) ON DELETE SET NULL
);

Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (100,'Steven','AD_PRES',null,to_date('03/06/17','RR/MM/DD'),24000,null,90);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (101,'Neena','AD_VP',100,to_date('05/09/21','RR/MM/DD'),17000,null,90);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (102,'Lex','AD_VP',100,to_date('01/01/13','RR/MM/DD'),17000,null,90);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (103,'Alexander','IT_PROG',102,to_date('06/01/03','RR/MM/DD'),9000,null,60);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (104,'Bruce','IT_PROG',103,to_date('07/05/21','RR/MM/DD'),6000,null,60);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (105,'David','IT_PROG',103,to_date('05/06/25','RR/MM/DD'),4800,null,60);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (106,'Valli','IT_PROG',103,to_date('06/02/05','RR/MM/DD'),4800,null,60);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (107,'Diana','IT_PROG',103,to_date('07/02/07','RR/MM/DD'),4200,null,60);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (108,'Nancy','FI_MGR',101,to_date('02/08/17','RR/MM/DD'),12008,null,100);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (109,'Daniel','FI_ACCOUNT',108,to_date('02/08/16','RR/MM/DD'),9000,null,100);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (110,'John','FI_ACCOUNT',108,to_date('05/09/28','RR/MM/DD'),8200,null,100);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (111,'Ismael','FI_ACCOUNT',108,to_date('05/09/30','RR/MM/DD'),7700,null,100);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (112,'Jose Manuel','FI_ACCOUNT',108,to_date('06/03/07','RR/MM/DD'),7800,null,100);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (113,'Luis','FI_ACCOUNT',108,to_date('07/12/07','RR/MM/DD'),6900,null,100);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (114,'Den','PU_MAN',100,to_date('02/12/07','RR/MM/DD'),11000,null,30);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (115,'Alexander','PU_MAN',100,to_date('03/05/18','RR/MM/DD'),9100,null,30);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (116,'Shelli','PU_CLERK',114,to_date('05/12/24','RR/MM/DD'),2900,null,30);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (117,'Sigal','PU_CLERK',114,to_date('05/07/24','RR/MM/DD'),2800,null,30);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (118,'Guy','PU_CLERK',114,to_date('06/11/15','RR/MM/DD'),2600,null,30);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (119,'Karen','PU_CLERK',114,to_date('07/08/10','RR/MM/DD'),2500,null,30);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (120,'Matthew','ST_MAN',100,to_date('04/07/18','RR/MM/DD'),8000,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (121,'Adam','ST_MAN',100,to_date('04/07/18','RR/MM/DD'),8200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (122,'Payam','ST_MAN',100,to_date('03/05/01','RR/MM/DD'),7900,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (123,'Shanta','ST_MAN',100,to_date('05/10/10','RR/MM/DD'),6500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (124,'Kevin','ST_MAN',100,to_date('07/11/16','RR/MM/DD'),5800,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (125,'Julia','ST_CLERK',120,to_date('05/07/16','RR/MM/DD'),3200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (126,'Irene','ST_CLERK',120,to_date('06/09/28','RR/MM/DD'),2700,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (127,'James','ST_CLERK',120,to_date('07/01/14','RR/MM/DD'),2400,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (128,'Steven','ST_CLERK',120,to_date('08/03/08','RR/MM/DD'),2200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (129,'Laura','ST_CLERK',121,to_date('05/07/16','RR/MM/DD'),3300,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (130,'Mozhe',null,121,to_date('05/07/16','RR/MM/DD'),2800,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (131,'James',null,121,to_date('05/02/16','RR/MM/DD'),2500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (132,'TJ','ST_CLERK',121,to_date('07/04/10','RR/MM/DD'),2100,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (133,'Jason','ST_CLERK',122,to_date('04/06/14','RR/MM/DD'),3300,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (134,'Michael','ST_CLERK',122,to_date('06/08/26','RR/MM/DD'),2900,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (135,'Ki','ST_CLERK',122,to_date('07/12/12','RR/MM/DD'),2400,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (136,'Hazel','ST_CLERK',122,to_date('08/02/06','RR/MM/DD'),2200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (137,'Renske','ST_CLERK',123,to_date('03/07/14','RR/MM/DD'),3600,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (138,'Stephen','ST_CLERK',123,to_date('05/10/26','RR/MM/DD'),3200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (139,'John','ST_CLERK',123,to_date('08/02/06','RR/MM/DD'),2700,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (140,'Joshua',null,123,to_date('08/02/06','RR/MM/DD'),2500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (141,'Trenna','ST_CLERK',124,to_date('03/10/17','RR/MM/DD'),3500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (142,'Curtis','ST_CLERK',124,to_date('05/01/29','RR/MM/DD'),3100,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (143,'Randall','ST_CLERK',124,to_date('06/03/15','RR/MM/DD'),2600,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (144,'Peter','ST_CLERK',124,to_date('06/07/09','RR/MM/DD'),2500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (145,'John','SA_MAN',100,to_date('04/10/01','RR/MM/DD'),14000,0.4,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (146,'Karen','SA_MAN',100,to_date('04/10/01','RR/MM/DD'),13500,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (147,'Alberto','SA_MAN',100,to_date('05/03/10','RR/MM/DD'),12000,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (148,'Gerald','SA_MAN',100,to_date('07/10/15','RR/MM/DD'),11000,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (149,'Eleni','SA_MAN',100,to_date('07/10/15','RR/MM/DD'),10500,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (150,'Peter','SA_REP',145,to_date('07/10/15','RR/MM/DD'),10000,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (151,'David','SA_REP',145,to_date('05/03/24','RR/MM/DD'),9500,0.25,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (152,'Peter','SA_REP',145,to_date('05/08/20','RR/MM/DD'),9000,0.25,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (153,'Christopher','SA_REP',145,to_date('06/03/30','RR/MM/DD'),8000,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (154,'Nanette','SA_REP',145,to_date('06/12/09','RR/MM/DD'),7500,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (155,'Oliver','SA_REP',145,to_date('07/11/23','RR/MM/DD'),7000,0.15,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (156,'Janette','SA_REP',146,to_date('04/01/30','RR/MM/DD'),10000,0.35,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (157,'Patrick','SA_REP',146,to_date('04/03/04','RR/MM/DD'),9500,0.35,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (158,'Allan','SA_REP',146,to_date('04/08/01','RR/MM/DD'),9000,0.35,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (159,'Lindsey','SA_REP',146,to_date('05/03/10','RR/MM/DD'),8000,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (160,'Louise','SA_REP',146,to_date('05/12/15','RR/MM/DD'),7500,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (161,'Sarath','SA_REP',146,to_date('06/11/03','RR/MM/DD'),7000,0.25,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (162,'Clara','SA_REP',147,to_date('05/11/11','RR/MM/DD'),10500,0.25,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (163,'Danielle','SA_REP',147,to_date('07/03/19','RR/MM/DD'),9500,0.15,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (164,'Mattea','SA_REP',147,to_date('08/01/24','RR/MM/DD'),7200,0.1,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (165,'David','SA_REP',147,to_date('08/02/23','RR/MM/DD'),6800,0.1,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (166,'Sundar','SA_REP',147,to_date('08/03/24','RR/MM/DD'),6400,0.1,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (167,'Amit','SA_REP',147,to_date('08/04/21','RR/MM/DD'),6200,0.1,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (168,'Lisa','SA_REP',148,to_date('05/03/11','RR/MM/DD'),11500,0.25,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (169,'Harrison','SA_REP',148,to_date('06/03/23','RR/MM/DD'),10000,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (170,'Tayler','SA_REP',148,to_date('06/01/24','RR/MM/DD'),9600,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (171,'William','SA_REP',148,to_date('07/02/23','RR/MM/DD'),7400,0.15,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (172,'Elizabeth','SA_REP',148,to_date('07/03/24','RR/MM/DD'),7300,0.15,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (173,'Sundita','SA_REP',148,to_date('08/04/21','RR/MM/DD'),6100,0.1,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (174,'Ellen','SA_REP',149,to_date('04/05/11','RR/MM/DD'),11000,0.3,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (175,'Alyssa','SA_REP',149,to_date('05/03/19','RR/MM/DD'),8800,0.25,null);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (176,'Jonathon','SA_REP',149,to_date('06/03/24','RR/MM/DD'),8600,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (177,'Jack','SA_REP',149,to_date('06/04/23','RR/MM/DD'),8400,0.2,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (178,'Kimberely','SA_REP',149,to_date('07/05/24','RR/MM/DD'),7000,0.15,null);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (179,'Charles','SA_REP',149,to_date('08/01/04','RR/MM/DD'),6200,0.1,80);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (180,'Winston','SH_CLERK',120,to_date('06/01/24','RR/MM/DD'),3200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (181,'Jean','SH_CLERK',120,to_date('06/02/23','RR/MM/DD'),3100,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (182,'Martha','SH_CLERK',120,to_date('07/06/21','RR/MM/DD'),2500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (183,'Girard','SH_CLERK',120,to_date('08/02/03','RR/MM/DD'),2800,null,null);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (184,'Nandita','SH_CLERK',121,to_date('04/01/27','RR/MM/DD'),4200,null,null);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (185,'Alexis','SH_CLERK',121,to_date('05/02/20','RR/MM/DD'),4100,null,null);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (186,'Julia','SH_CLERK',121,to_date('06/06/24','RR/MM/DD'),3400,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (187,'Anthony',null,121,to_date('07/02/07','RR/MM/DD'),3000,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (188,'Kelly','SH_CLERK',122,to_date('05/06/14','RR/MM/DD'),3800,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (189,'Jennifer','SH_CLERK',122,to_date('05/08/13','RR/MM/DD'),3600,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (190,'Timothy',null,122,to_date('06/07/11','RR/MM/DD'),2900,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (191,'Randall',null,122,to_date('07/06/21','RR/MM/DD'),2500,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (192,'Sarah','SH_CLERK',123,to_date('04/02/04','RR/MM/DD'),4000,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (193,'Britney','SH_CLERK',123,to_date('05/03/03','RR/MM/DD'),3900,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (194,'Samuel','SH_CLERK',123,to_date('07/06/21','RR/MM/DD'),3200,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (195,'Vance','SH_CLERK',123,to_date('07/06/21','RR/MM/DD'),2800,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (196,'Alana','SH_CLERK',124,to_date('06/04/24','RR/MM/DD'),3100,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (197,'Kevin','SH_CLERK',124,to_date('06/05/23','RR/MM/DD'),3000,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (198,'Donald','SH_CLERK',124,to_date('07/06/21','RR/MM/DD'),2600,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (199,'Douglas','SH_CLERK',124,to_date('07/06/21','RR/MM/DD'),2600,null,50);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (200,'Jennifer','AD_ASST',101,to_date('03/09/17','RR/MM/DD'),4400,null,10);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (201,'Michael','MK_MAN',100,to_date('04/02/17','RR/MM/DD'),13000,null,20);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (202,'Pat','MK_REP',201,to_date('05/08/17','RR/MM/DD'),6000,null,20);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (203,'Susan','HR_REP',101,to_date('02/06/07','RR/MM/DD'),6500,null,40);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (204,'Hermann','PR_REP',101,to_date('02/06/07','RR/MM/DD'),10000,null,70);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (205,'Shelley','AC_MGR',101,to_date('02/06/07','RR/MM/DD'),12008,null,110);
Insert into EMP (EMP_ID,EMP_NAME,JOB_ID,MGR_ID,HIRE_DATE,SALARY,COMM_PCT,DEPT_ID) values (206,'William','AC_ACCOUNT',205,to_date('02/06/07','RR/MM/DD'),8300,null,110);


--------------------------------------------------------
--  DDL for Table SALARY_GRADE 
--  급여 등급 테이블
--------------------------------------------------------
DROP TABLE SALARY_GRADE;
CREATE TABLE SALARY_GRADE(
    GRADE NUMBER,
    LOW_SAL NUMBER,
    HIGH_SAL NUMBER
);

INSERT INTO SALARY_GRADE (GRADE,LOW_SAL,HIGH_SAL) VALUES (1, 0, 5000);
INSERT INTO SALARY_GRADE (GRADE,LOW_SAL,HIGH_SAL) VALUES (2, 5001, 10000);
INSERT INTO SALARY_GRADE (GRADE,LOW_SAL,HIGH_SAL) VALUES (3, 10001, 15000);
INSERT INTO SALARY_GRADE (GRADE,LOW_SAL,HIGH_SAL) VALUES (4, 15001, 20000);
INSERT INTO SALARY_GRADE (GRADE,LOW_SAL,HIGH_SAL) VALUES (5, 20001, 999999);

COMMIT;