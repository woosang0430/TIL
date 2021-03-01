/*
1. 제품 테이블은 제품_ID 컬럼이 [PRIMARY KEY] 컬럼으로 그 행을 다른 행과 식별할 때 사용된다.
2. 제품 테이블의 제조사 컬럼은 Not Null(NN) 인 것으로 봐서 [NULL] 인 상태일 수가 없다.
3. 고객 테이블에서 다른행과 식별할 때 사용하는 컬럼은 [CUST_ID] 이다. 
4. 고객 테이블의 전화번호 컬럼의 데이터 타입은 [VARCHAR2] 으로 [문자열]형태의 값 [15]바이트 저장할 수 있으며 NULL 값을 [포함한다].
5. 고객 테이블의 가입일 컬럼에 대해 4번 처럼 설명해 보시오.
- 고객 테이블의 가입일 컬럼의 데이터 타입은 [DATE] 로 [날짜/시간]형태의 값 null값을 포함하지 않는다.
6. 주문 테이블은 총 5개 컬럼이 있다. 정수 타입이 [3]개이고 문자열 타입이 [1]개 이고 날짜 타입이 [1]개이다.
7. 고객 테이블과 주문테이블은 서로 관계가 있는 테이블입니다.
    부모테이블은[고객테이블(CUSTOMERS)] 이고 자식 테이블은 [주문테이블(ORDERS)]이다.
    부모테이블의 [cust_id]컬럼을 자식테이블의 [CUST_ID]컬럼이 참조하고 있다.
    고객테이블의 한행의 데이터는 주문테이블의 [0 ~ n개] 행과 관계가 있을 수 있다.
    주문테이블의 한행은 고객테이블의 [ 1 ]행과 관계가 있을 수 있다.
8. 주문 테이블과 주문_제품 테이블은 서로 관계가 있는 테이블입니다.
    부모 테이블은 [ORDERS] 이고 자식 테이블은 [ORDER_ITEMS]이다.
    부모 테이블의 [ORDER_ID]컬럼을 자식 테이블의 [ORDER_ID]컬럼이 참조하고 있다.
    주문 테이블의 한행의 데이터는 주문_제품 테이블의 [0~n개] 행과 관계가 있을 수 있다.
    주문_제품 테이블의 한행은 주문 테이블의 [ 1 ]행과 관계가 있을 수 있다.
9. 제품과 주문_제품은 서로 관계가 있는 테이블입니다. 
    부모 테이블은 [PRODUCTS] 이고 자식 테이블은 [ORDER_ITEMS]이다.
    부모 테이블의 [PRODUCT_ID]컬럼을 자식 테이블의 [PRODUCT_ID]컬럼이 참조하고 있다.
    제품 테이블의 한행의 데이터는 주문_제품 테이블의 [0 ~ n개] 행과 관계가 있을 수 있다.
    주문_제품 테이블의 한행은 제품 테이블의 [ 1 ]행과 관계가 있을 수 있다.
*/

-- TODO: 4개의 테이블에 어떤 값들이 있는지 확인.
select * from customers;
select * from orders;
select * from order_items;
select * from products;

-- TODO: 주문 번호가 1인 주문의 주문자 이름, 주소, 우편번호, 전화번호 조회
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

-- TODO : 주문 번호가 2인 주문의 주문일, 주문상태, 총금액, 주문고객 이름, 주문고객 이메일 주소 조회
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

-- TODO : 고객 ID가 120인 고객의 이름, 성별, 가입일과 지금까지 주문한 주문정보중 주문_ID, 주문일, 총금액을 조회
select  c.cust_name,
        c.gender,
        c.join_date,
        os.order_id,
        os.order_date,
        os.order_total
from    customers c join orders os on c.cust_id = os.cust_id
where   c.cust_id = 120;
-- 자식 테이블의 데이터들 중에 null 값이 있는데 기본정보 전체 조회를 원하는 outer join!
select  c.cust_name,
        c.gender,
        decode(c.gender, 'M', '남성', '여성') gender2,
        case c.gender when 'M' then '남성'
                      else '여성' end gender3,
        c.join_date,
        o.order_id,
        o.order_date,
        o.order_total
from    customers c left join orders o on c.cust_id = o.cust_id
where   c.cust_id = 120;

select  c.cust_name,
        c.gender,
        decode(c.gender, 'M', '남성', '여성') gender2,
        case c.gender when 'M' then '남성'
                      else '여성' end gender3,
        c.join_date,
        o.order_id,
        o.order_date,
        o.order_total
from    customers c, orders o
where   c.cust_id = o.cust_id(+)
and     c.cust_id = 120;

-- TODO : 고객 ID가 110인 고객의 이름, 주소, 전화번호, 그가 지금까지 주문한 주문정보중 주문_ID, 주문일, 주문상태 조회
select  c.cust_name,
        c.address,
        c.phone_number,
        os.order_id,
        os.order_date,
        os.order_status
from    customers c join orders os on c.cust_id = os.cust_id
where   c.cust_id = 110;

-- TODO : 고객 ID가 120인 고객의 정보와 지금까지 주문한 주문정보를 모두 조회.
select  *
from    customers c left join orders os on c.cust_id = os.cust_id
where   c.cust_id = 120;

--select  * -- 전체 컬럼
--select  c.* -- customers의 컬럼
--select o.*-- orders의 컬럼
select  c.*, 
        o.order_date
from    customers c left join orders o on c.cust_id = o.cust_id
where   c.cust_id = 120;

-- TODO : '2017/11/13'(주문날짜) 에 주문된 주문의 주문고객의 고객_ID, 이름, 주문상태, 총금액을 조회
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


-- TODO : 주문상세 ID가 xxxx(임의의 id)인 주문제품의 제품이름, 판매가격, 제품가격을 조회.
select  p.product_name,
        oi.sell_price "판매가격",
        p.price "제품가격"
from    products p join order_items oi on p.product_id = oi.product_id
where   oi.order_item_id = 10;

select  p.product_name,
        to_char(oi.sell_price, 'fml999,999') "판매가격",
        p.price "제품가격",
        p.price - oi.sell_price "할인액수"
from    order_items oi left join products p on oi.product_id = p.product_id
where   oi.order_item_id = 1;
;

-- TODO : 주문 ID가 4인 주문의 주문 고객의 이름, 주소, 우편번호, 주문일, 주문상태, 
-- 총금액, 주문 제품이름, 제조사, 제품가격, 판매가격, 제품수량을 조회.
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

-- TODO : 제품 ID가 200인 제품이 2017년에 몇개 주문되었는지 조회. #########################
select count(*)
from    orders
where   to_char(order_date, 'yyyy') = 2017;

select  count(*) "주문회수",
        sum(oi.quantity) "총주문개수"
from    products p left join order_items oi on p.product_id = oi.product_id
                   left join orders o on oi.order_id = o.order_id
where   p.product_id = 200
and     to_char(o.order_date, 'yyyy') = 2017
;

-- TODO : 제품분류별 총 주문량을 조회 ###########################################
select distinct category
from    products;

select  count(oi.order_item_id)
from    products p join order_items oi on p.product_id = oi.product_id
group by p.category;

select  p.category,
        nvl(sum(quantity), 0) "주문수량"
from    products p left join order_items oi on p.product_id = oi.product_id
--from    products p join order_items oi on p.product_id = oi.product_id
group by p.category
order by 2
;