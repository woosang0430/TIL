## Database 연동모듈
- sqlite3 : 파이썬에 내장되어 있어 바로 연동가능
- cs_Oracle : 오라클 연동 모듈
  - `pip install cx_Oracle`로 설치
- PyMySQL : MySql 연동 모듈
  - `pip install PyMySQL`로 설치

## cx_Oracle을 이용한 SQL 전송
- Connection : DB 연결정보를 가진 객체
  - connection() 함수를 이용해 연결
- Cursor
  - SQL문 실행을 위한 메소드 제공
  - Connection.cursor()함수를 이용해 조회

## 1. 연결
```python
import cx_Oracle

# username, password, host
conn = cx_Oracle.connect('c##scott_join@tiger/localhost:1521/XE')
     # cx_Oracle.connect('c##scorr_join', 'tiger', 'localhost:1521/XE')
```

## 2. cursor 생성
```python
cursor = conn.cursor()
```

## 3. sql 실행
```python
cursor.execute('select * from emp')

# 보기
result = cursor.fetchall()
print(result) 
```
## 4. 연결 끊기
```python
cursor.close()
conn.close()
```
## 5. 데이터프레임으로 전환
```python
import pandas as pd

emp_df = pd.DataFrame(result)
```

# 판다스 오라클 연동
- pd.read_sql('select문', con=connection)
```python
import cx_Oracle
import pandas as pd

conn = cx_Oracle.connect('c##scot_join@tiger/localhost:1521/XE')

emp_df = pd.read_sql('select * from emp', con=conn)
```
