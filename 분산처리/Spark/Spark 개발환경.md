# Spark 환경 맞추기


## java 8 버전 다운
- https://www.oracle.com/kr/java/technologies/javase/javase-jdk8-downloads.html
- 본인에게 맞는 운영체제와 비트 맞춰 다운로드
- 환경 변수 잡아주기
- ![image](https://user-images.githubusercontent.com/77317312/123965149-1fde3700-d9ef-11eb-97c3-4b8c93b7caae.png)

## spark & winutils 다운
### Spark 다운
- http://spark.apache.org/downloads.html 
- spark, hadoop 버전 지정(hadoop의 경우 2.7로)
- ![image](https://user-images.githubusercontent.com/77317312/123965329-4ac88b00-d9ef-11eb-985c-990e14502150.png)
- [Spark 3.1.2, Hadoop 2.7.0 바로 다운](https://mirror.navercorp.com/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop2.7.tgz)

- 압축 풀고 C 아래 Spark 디렉토리 만들고 안에 넣기
- ![image](https://user-images.githubusercontent.com/77317312/123965795-c6c2d300-d9ef-11eb-85f3-8a85c3b91674.png)

### winutils 다운
- https://github.com/cdarlint/winutils
- Spark 다운받았을 때 hadoop의 버전과 맞춰서 `winutils.exe` 다운
- ![image](https://user-images.githubusercontent.com/77317312/123966880-c6770780-d9f0-11eb-83aa-86ae2f10559b.png)

- 다운받은 exe 파일 C 아래 Hadoop 아래 bin 디렉토리 만들고 안에 넣기
- ![image](https://user-images.githubusercontent.com/77317312/123967279-2077cd00-d9f1-11eb-93db-46075ffd6b88.png)

- 환경 변수 잡기
- `SPARK_HOME`, `HADOOP_HOME` 변수명으로 bin 전 까지의 경로 설정
- ![image](https://user-images.githubusercontent.com/77317312/123966506-74ce7d00-d9f0-11eb-8bb6-4c63b11322b7.png)
- `%변수명%\bin`으로 환경 변수 설정
- ![image](https://user-images.githubusercontent.com/77317312/123966107-0c7f9b80-d9f0-11eb-9e78-526f359bff57.png)

## CMD 창에서 확인
- spark-shell 명령어 실행하면 이렇게 나옴
- ![image](https://user-images.githubusercontent.com/77317312/123968006-cf1c0d80-d9f1-11eb-8f8d-ab1763bc01a6.png)
