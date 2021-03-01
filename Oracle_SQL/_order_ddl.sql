/* �� */
DROP TABLE CUSTOMERS 
	CASCADE CONSTRAINTS;

/* �ֹ� */
DROP TABLE ORDERS 
	CASCADE CONSTRAINTS;

/* �ֹ�_��ǰ */
DROP TABLE ORDER_ITEMS 
	CASCADE CONSTRAINTS;

/* ��ǰ */
DROP TABLE PRODUCTS 
	CASCADE CONSTRAINTS;

/* �� */
CREATE TABLE CUSTOMERS (
	CUST_ID NUMBER(3) NOT NULL, /* ��_ID */
	CUST_NAME VARCHAR2(20) NOT NULL, /* ��_�̸� */
	ADDRESS VARCHAR2(40) NOT NULL, /* �ּ� */
	POSTAL_CODE VARCHAR2(10) NOT NULL, /* �����ȣ */
	CUST_EMAIL VARCHAR2(30) NOT NULL, /* ��_�̸����ּ� */
	PHONE_NUMBER VARCHAR2(15), /* ��ȭ��ȣ */
	GENDER CHAR(1), /* ���� */
	JOIN_DATE DATE NOT NULL /* ������ */
);

ALTER TABLE CUSTOMERS
	ADD
		CONSTRAINT CUSTOMERS_PK_CUSTID
		PRIMARY KEY (
			CUST_ID
		);

/* �ֹ� */
CREATE TABLE ORDERS (
	ORDER_ID NUMBER NOT NULL, /* �ֹ�_ID */
	ORDER_DATE DATE NOT NULL, /* �ֹ��� */
	CUST_ID NUMBER(3) NOT NULL, /* ��_ID */
	ORDER_STATUS VARCHAR2(20) NOT NULL, /* �ֹ����� */
	ORDER_TOTAL NUMBER /* �ѱݾ� */
);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT ORDERS_PK_ORDERID
		PRIMARY KEY (
			ORDER_ID
		);

/* �ֹ�_��ǰ */
CREATE TABLE ORDER_ITEMS (
	ORDER_ITEM_ID NUMBER NOT NULL, /* �ֹ���_ID */
	SELL_PRICE NUMBER(8) NOT NULL, /* �ǸŰ��� */
	QUANTITY NUMBER(8) NOT NULL, /* ���� */
	PRODUCT_ID NUMBER(3), /* ��ǰ_ID */
	ORDER_ID NUMBER /* �ֹ�_ID */
);

ALTER TABLE ORDER_ITEMS
	ADD
		CONSTRAINT ORDITEMS_PK
		PRIMARY KEY (
			ORDER_ITEM_ID
		);

/* ��ǰ */
CREATE TABLE PRODUCTS (
	PRODUCT_ID NUMBER(3) NOT NULL, /* ��ǰ_ID */
	PRODUCT_NAME VARCHAR2(125) NOT NULL, /* ��ǰ_�̸� */
	CATEGORY VARCHAR2(30) NOT NULL, /* ��ǰ�з� */
	MAKER VARCHAR2(50) NOT NULL, /* ������ */
	PRICE NUMBER(8) NOT NULL /* ��ǰ���� */
);

ALTER TABLE PRODUCTS
	ADD
		CONSTRAINT PRODUCTS_PK_PRODID
		PRIMARY KEY (
			PRODUCT_ID
		);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT ORDERS_FK_CUSTID
		FOREIGN KEY (
			CUST_ID
		)
		REFERENCES CUSTOMERS (
			CUST_ID
		);

ALTER TABLE ORDER_ITEMS
	ADD
		CONSTRAINT FK_PRODUCTS_TO_ORDER_ITEMS
		FOREIGN KEY (
			PRODUCT_ID
		)
		REFERENCES PRODUCTS (
			PRODUCT_ID
		);

ALTER TABLE ORDER_ITEMS
	ADD
		CONSTRAINT FK_ORDERS_TO_ORDER_ITEMS
		FOREIGN KEY (
			ORDER_ID
		)
		REFERENCES ORDERS (
			ORDER_ID
		);
        
/*customers*/       
INSERT INTO CUSTOMERS VALUES(100, '���', '����� ���α� ������', '03084', 'kys@abc.com', '010-3232-5423', 'M', '2010/10/22');
INSERT INTO CUSTOMERS VALUES(110, '�̰�', '����� ������ ������', '06038', 'ljh@abc.com', '010-7623-1328', 'F', '2011/11/02');
INSERT INTO CUSTOMERS VALUES(120, '�ڰ�', '��⵵ ����� ����', '14204', 'lhj@abc.com', '010-3232-5423', 'M', '2016/03/07');
INSERT INTO CUSTOMERS VALUES(130, '���', '��⵵ ������ ������', '15843', 'oym@abc.com', '010-939-2000', 'F', '2014/08/22');
INSERT INTO CUSTOMERS VALUES(140, '�ְ�', '����� ����� ������', '01796', 'jjy@abc.com', '010-510-5500', 'F', '2010/02/12');
INSERT INTO CUSTOMERS VALUES(150, '�ְ�', '��󳲵� ������ ������', '53285', 'cmr@abc.com', '010-3258-6800', 'F', '2011/10/21');
INSERT INTO CUSTOMERS VALUES(160, '����', '����ϵ� ������ �ݵ�', '55769', 'kwj@abc.com', '010-9832-5522', 'M', '2009/06/28');
INSERT INTO CUSTOMERS VALUES(170, '���', '����� ������ ���嵿', '04965', 'bsp@abc.com', '010-3001-1177', 'M', '2004/05/03');
INSERT INTO CUSTOMERS VALUES(180, '����', '����� ���α� ��ô��', '08240', 'luj@abc.com', '010-4123-9876', 'M', '2002/05/29');

/*products*/
INSERT INTO PRODUCTS VALUES(200, '��ī���', 'Ŀ��', '������ǰ', 20000);
INSERT INTO PRODUCTS VALUES(210, '����ġī��', 'Ŀ��', '��������', 20000);
INSERT INTO PRODUCTS VALUES(220, 'ī��', 'Ŀ��', '������ǰ', 18000);
INSERT INTO PRODUCTS VALUES(230, '�ƽ��� �Ͽ콺', 'Ŀ��', '������ǰ', 10000);
INSERT INTO PRODUCTS VALUES(300, '������ ȫ��', '��', '����', 9000);
INSERT INTO PRODUCTS VALUES(310, '��׷���', '��', 'Ʈ���̴�', 15000);
INSERT INTO PRODUCTS VALUES(320, '������', '��', '�ٳ��', 13000);
INSERT INTO PRODUCTS VALUES(400, '��ī�ٹ̾� ���ݶ�', '���ݷ�', '�ﱤ��ǰ', 10000);
INSERT INTO PRODUCTS VALUES(410, 'ABC ���ݷ�', '���ݷ�', '�Ե�', 15000);
INSERT INTO PRODUCTS VALUES(420, 'Ų�� ���� ����', '���ݷ�', 'Ų��', 1000);
INSERT INTO PRODUCTS VALUES(430, '������', '��Ű', '������ǰ', 2000);
INSERT INTO PRODUCTS VALUES(440, '������ ����Ĩ', '��Ű', '������', 3000);     
INSERT INTO PRODUCTS VALUES(510, '������', '���̽�ũ��', '�Ե�', 1200);     
INSERT INTO PRODUCTS VALUES(520, '�����', '���̽�ũ��', '����', 1200);     

/*orders*/
insert into orders values(1, '2017/10/10', 110, '����Ȯ��', 77500);
insert into orders values(2, '2017/10/10', 120, '����Ȯ��', 140000);
insert into orders values(3, '2017/10/10', 170, '����Ȯ��', 122000);
insert into orders values(4, '2017/10/15', 110, '����Ȯ��', 54750);
insert into orders values(5, '2017/10/17', 110, '����Ȯ��', 53000);
insert into orders values(6, '2017/11/03', 120, '����Ȯ��', 96000);
insert into orders values(7, '2017/11/08', 140, '����Ȯ��', 54750);
insert into orders values(8, '2017/11/13', 130, '����Ȯ��', 53000);
insert into orders values(9, '2017/11/13', 180, '����Ȯ��', 20000);

/*order_items*/
insert into order_items values(1, 8000, 5, 300, 1);
insert into order_items values(2, 15000, 2, 410, 1);
insert into order_items values(3, 2500, 3, 440, 1);
insert into order_items values(4, 14000, 10, 310, 2);
insert into order_items values(5, 19000, 2, 210, 3);
insert into order_items values(6, 15000, 5, 410, 3);
insert into order_items values(7, 3000, 10, 440, 3);

insert into order_items values(8, 990, 25, 420, 4);
insert into order_items values(9, 3000, 10, 440, 4);

insert into order_items values(10, 19000, 1, 200, 5);
insert into order_items values(11, 9000, 1, 300, 5);
insert into order_items values(12, 12500, 2, 320, 5);

insert into order_items values(13, 20000, 3, 200, 6);
insert into order_items values(14, 18000, 2, 220, 6);

insert into order_items values(15, 990, 25, 420, 7);
insert into order_items values(16, 3000, 10, 440, 7);

insert into order_items values(17, 19000, 1, 200, 8);
insert into order_items values(18, 9000, 1, 300, 8);
insert into order_items values(19, 12500, 2, 320, 8);

insert into order_items values(20, 20000, 1, 200, 9);


COMMIT;