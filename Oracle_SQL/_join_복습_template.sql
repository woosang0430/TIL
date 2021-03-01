/*
1. ��ǰ ���̺��� ��ǰ_ID �÷��� [PRIMARY KEY] �÷����� �� ���� �ٸ� ��� �ĺ��� �� ���ȴ�.
2. ��ǰ ���̺��� ������ �÷��� Not Null(NN) �� ������ ���� [NULL] �� ������ ���� ����.
3. �� ���̺��� �ٸ���� �ĺ��� �� ����ϴ� �÷��� [CUST_ID] �̴�. 
4. �� ���̺��� ��ȭ��ȣ �÷��� ������ Ÿ���� [VARCHAR2] ���� [���ڿ�]������ �� [15]����Ʈ ������ �� ������ NULL ���� [�����Ѵ�].
5. �� ���̺��� ������ �÷��� ���� 4�� ó�� ������ ���ÿ�.
- �� ���̺��� ������ �÷��� ������ Ÿ���� [DATE] �� [��¥/�ð�]������ �� null���� �������� �ʴ´�.
6. �ֹ� ���̺��� �� 5�� �÷��� �ִ�. ���� Ÿ���� [3]���̰� ���ڿ� Ÿ���� [1]�� �̰� ��¥ Ÿ���� [1]���̴�.
7. �� ���̺�� �ֹ����̺��� ���� ���谡 �ִ� ���̺��Դϴ�.
    �θ����̺���[�����̺�(CUSTOMERS)] �̰� �ڽ� ���̺��� [�ֹ����̺�(ORDERS)]�̴�.
    �θ����̺��� [cust_id]�÷��� �ڽ����̺��� [CUST_ID]�÷��� �����ϰ� �ִ�.
    �����̺��� ������ �����ʹ� �ֹ����̺��� [0 ~ n��] ��� ���谡 ���� �� �ִ�.
    �ֹ����̺��� ������ �����̺��� [ 1 ]��� ���谡 ���� �� �ִ�.
8. �ֹ� ���̺�� �ֹ�_��ǰ ���̺��� ���� ���谡 �ִ� ���̺��Դϴ�.
    �θ� ���̺��� [ORDERS] �̰� �ڽ� ���̺��� [ORDER_ITEMS]�̴�.
    �θ� ���̺��� [ORDER_ID]�÷��� �ڽ� ���̺��� [ORDER_ID]�÷��� �����ϰ� �ִ�.
    �ֹ� ���̺��� ������ �����ʹ� �ֹ�_��ǰ ���̺��� [0~n��] ��� ���谡 ���� �� �ִ�.
    �ֹ�_��ǰ ���̺��� ������ �ֹ� ���̺��� [ 1 ]��� ���谡 ���� �� �ִ�.
9. ��ǰ�� �ֹ�_��ǰ�� ���� ���谡 �ִ� ���̺��Դϴ�. 
    �θ� ���̺��� [PRODUCTS] �̰� �ڽ� ���̺��� [ORDER_ITEMS]�̴�.
    �θ� ���̺��� [PRODUCT_ID]�÷��� �ڽ� ���̺��� [PRODUCT_ID]�÷��� �����ϰ� �ִ�.
    ��ǰ ���̺��� ������ �����ʹ� �ֹ�_��ǰ ���̺��� [0 ~ n��] ��� ���谡 ���� �� �ִ�.
    �ֹ�_��ǰ ���̺��� ������ ��ǰ ���̺��� [ 1 ]��� ���谡 ���� �� �ִ�.
*/

-- TODO: 4���� ���̺� � ������ �ִ��� Ȯ��.
select * from customers;
select * from orders;
select * from order_items;
select * from products;

-- TODO: �ֹ� ��ȣ�� 1�� �ֹ��� �ֹ��� �̸�, �ּ�, �����ȣ, ��ȭ��ȣ ��ȸ
select  c.cust_name,
        c.address,
        c.postal_code,
        c.phone_number
from    customers c join orders os on c.cust_id = os.cust_id
where   os.order_id = 1;

select  c.cust_id,
        c.cust_name,
        c.address,
        c.postal_code,
        c.phone_number
from    customers c join orders o on c.cust_id = o.cust_id
where   o.order_id = 1;

-- TODO : �ֹ� ��ȣ�� 2�� �ֹ��� �ֹ���, �ֹ�����, �ѱݾ�, �ֹ��� �̸�, �ֹ��� �̸��� �ּ� ��ȸ
select  os.order_date,
        os.order_status,
        os.order_total,
        os.order_id,
        c.cust_name,
        c.cust_email
from    orders os join customers c on os.cust_id = c.cust_id
where   os.order_id = 2;

select  o.order_date,
        o.order_status,
        c.cust_id,
        c.cust_email
from    customers c join orders o on c.cust_id = o.cust_id
where   o.order_id = 2;

-- TODO : �� ID�� 120�� ���� �̸�, ����, �����ϰ� ���ݱ��� �ֹ��� �ֹ������� �ֹ�_ID, �ֹ���, �ѱݾ��� ��ȸ
select  c.cust_name,
        c.gender,
        c.join_date,
        os.order_id,
        os.order_date,
        os.order_total
from    customers c join orders os on c.cust_id = os.cust_id
where   c.cust_id = 120;
-- �ڽ� ���̺��� �����͵� �߿� null ���� �ִµ� �⺻���� ��ü ��ȸ�� ���ϴ� outer join!
select  c.cust_name,
        c.gender,
        decode(c.gender, 'M', '����', '����') gender2,
        case c.gender when 'M' then '����'
                      else '����' end gender3,
        c.join_date,
        o.order_id,
        o.order_date,
        o.order_total
from    customers c left join orders o on c.cust_id = o.cust_id
where   c.cust_id = 120;

select  c.cust_name,
        c.gender,
        decode(c.gender, 'M', '����', '����') gender2,
        case c.gender when 'M' then '����'
                      else '����' end gender3,
        c.join_date,
        o.order_id,
        o.order_date,
        o.order_total
from    customers c, orders o
where   c.cust_id = o.cust_id(+)
and     c.cust_id = 120;

-- TODO : �� ID�� 110�� ���� �̸�, �ּ�, ��ȭ��ȣ, �װ� ���ݱ��� �ֹ��� �ֹ������� �ֹ�_ID, �ֹ���, �ֹ����� ��ȸ
select  c.cust_name,
        c.address,
        c.phone_number,
        os.order_id,
        os.order_date,
        os.order_status
from    customers c join orders os on c.cust_id = os.cust_id
where   c.cust_id = 110;

-- TODO : �� ID�� 120�� ���� ������ ���ݱ��� �ֹ��� �ֹ������� ��� ��ȸ.
select  *
from    customers c left join orders os on c.cust_id = os.cust_id
where   c.cust_id = 120;

--select  * -- ��ü �÷�
--select  c.* -- customers�� �÷�
--select o.*-- orders�� �÷�
select  c.*, 
        o.order_date
from    customers c left join orders o on c.cust_id = o.cust_id
where   c.cust_id = 120;

-- TODO : '2017/11/13'(�ֹ���¥) �� �ֹ��� �ֹ��� �ֹ����� ��_ID, �̸�, �ֹ�����, �ѱݾ��� ��ȸ
select  c.cust_id,
        c.cust_name,
        os.order_status,
        os.order_total
from    customers c join orders os on c.cust_id = os.cust_id
where   os.order_date = '2017/11/13';

select  c.cust_id,
        c.cust_name,
        o.order_status,
        to_char(o.order_total, 'fml999,999') order_total
from    orders o left join customers c on o.cust_id = c.cust_id
where   o.order_date = to_date('2017/11/13', 'yyyy/mm/dd');


-- TODO : �ֹ��� ID�� xxxx(������ id)�� �ֹ���ǰ�� ��ǰ�̸�, �ǸŰ���, ��ǰ������ ��ȸ.
select  p.product_name,
        oi.sell_price "�ǸŰ���",
        p.price "��ǰ����"
from    products p join order_items oi on p.product_id = oi.product_id
where   oi.order_item_id = 10;

select  p.product_name,
        to_char(oi.sell_price, 'fml999,999') "�ǸŰ���",
        p.price "��ǰ����",
        p.price - oi.sell_price "���ξ׼�"
from    order_items oi left join products p on oi.product_id = p.product_id
where   oi.order_item_id = 1;
;

-- TODO : �ֹ� ID�� 4�� �ֹ��� �ֹ� ���� �̸�, �ּ�, �����ȣ, �ֹ���, �ֹ�����, 
-- �ѱݾ�, �ֹ� ��ǰ�̸�, ������, ��ǰ����, �ǸŰ���, ��ǰ������ ��ȸ.
select  c.cust_name,
        c.address,
        c.postal_code,
        os.order_date,
        os.order_status,
        os.order_total,
        p.product_name,
        p.maker,
        p.price,
        oi.quantity
from    customers c left join orders os on c.cust_id = os.cust_id
                    left join order_items oi on os.order_id = oi.order_id
                    left join products p on p.product_id = oi.product_id
where   os.order_id = 4;

select  c.cust_name,
        c.address,
        c.postal_code,
        o.order_date,
        o.order_status,
        o.order_total,
        p.product_name,
        p.maker,
        p.price,
        oi.quantity
from    orders o left join customers c on o.cust_id = c.cust_id
                 left join order_items oi on o.order_id = oi.order_id
                 left join products p on oi.product_id = p.product_id
where   o.order_id = 4;
;

-- TODO : ��ǰ ID�� 200�� ��ǰ�� 2017�⿡ � �ֹ��Ǿ����� ��ȸ. #########################
select count(*)
from    orders
where   to_char(order_date, 'yyyy') = 2017;

select  count(*) "�ֹ�ȸ��",
        sum(oi.quantity) "���ֹ�����"
from    products p left join order_items oi on p.product_id = oi.product_id
                   left join orders o on oi.order_id = o.order_id
where   p.product_id = 200
and     to_char(o.order_date, 'yyyy') = 2017
;

-- TODO : ��ǰ�з��� �� �ֹ����� ��ȸ ###########################################
select distinct category
from    products;

select  count(oi.order_item_id)
from    products p join order_items oi on p.product_id = oi.product_id
group by p.category;

select  p.category,
        nvl(sum(quantity), 0) "�ֹ�����"
from    products p left join order_items oi on p.product_id = oi.product_id
--from    products p join order_items oi on p.product_id = oi.product_id
group by p.category
order by 2
;