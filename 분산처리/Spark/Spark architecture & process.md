# Spark architecture & processing
- 스파크는 크게 보면 **Spark applicatoin**과 **Cluster manager**로 구성되어 있다.

- **Spark application** : 실제 일을 수행하는 역할을 담당
- **Cluster manager** : Spark application 사이에 자원을 중계해주는 역할을 담당

## Spark application
- Driver process와 Executors process로 구성
- `Spark Driver`
  - 한 개의 노드에서 실행되며, 스파크 전체의 main() 함수를 실행
  - 어플리케이션 내 정보의 **유지 관리**, Executer의 **실행 및 실행 분석, 배포** 등의 역할을 수행
  - 사용자가 구성한 사요자 프로그램(job)을 task 단위로 변환하여, Executor로 전달.

- `Executor`
  - 다수의 worker 노드에서 실행되는 프로세스
  - **Spark Driver**가 할당한 작업(task)을 수행하여 결과를 반환
  - 블록매니저를 통해 cache하는 RDD를 저장


![image](https://user-images.githubusercontent.com/77317312/122904199-14ee2b80-d38b-11eb-8f6a-71679afc11dd.png)


- 1개의 Spark application은 **1개의 Spark Driver**와 **N개의 Executor**가 존재
- `Executor`는 `Cluter manager`에 의하여 해당 Spark application에 할당된다.
- 해당 Spark application이 완전히 종료된 후 할당에서 해방된다.
  - 위의 이유로 **서로 다른 Spark application 간의 직접적인 데이터 공유는 불가능하다.**
  - (각 Spark application이 별도의 JVM 프로세스에서 동작하기 때문에)

### 번외. Cluster Manager란?
- Spark와 붙이거나 뗄 수 있는, Pluggable한 컴포넌트
- Spark application의 resouce를 효율적으로 분배하는 역할을 담당한다.
- Spark는  Executor에 task를 할당하고 관리하기 위하여 Cluter manger에 의존
  - 이 때, Spark는 Cluster Manager의 상세 동작을 알지 못한다.(Black-box)
  - 단지 클러스터 매니저와의 통신을 통하여, 할당 가능한 Executor를 전달 받는다.
  - [Spark StandAlone, (Hadoop)Yarn, Mesos, Kubernetes등]

## Spark Application 실행 과정(Flow)
- Spark를 사용할 때의 대략적인 실행 흐름
1. 사용자가 Spark-submit을 통해 application 제출
2. Spark Driver가 main()을 실행하며, Spark Context 생성
3. Spark Context가 Cluster Manager와 연결
4. Spark Driver가 Cluster Manager로부터 Executor 실행을 위한 리소스를 요청
5. Spark Context는 작업 내용을 task 단위로 분할하여 Executor에 보낸다.
6. 각 Executor는 작업을 수행하고, 결과를 저장
- ![image](https://user-images.githubusercontent.com/77317312/122904055-f25c1280-d38a-11eb-849e-8679ead3fc0b.png)
- 요약 : 사용자 프로그램을 수행하기 위하여, Spark Driver 내의 Spark Context가 job을 task 단위로 쪼갠다.
- Cluster Manager로 부터 할당받은 Executor로 task를 넘긴다.























