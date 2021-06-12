# Amazon Web Service(AWS)
![image](https://user-images.githubusercontent.com/77317312/121779040-afed4580-cbd4-11eb-9fea-20981679a281.png)
- 아마존의 자회사, public cloud computing service를 제공
  - AWS 보안 서비스 -> IAM
  - AWS 스토리지 서비스 -> S3 (static web site)
  - AWS 컴퓨팅 서비스 -> EC2, EBC(스토리지)
  - AWS 네트워크 서비스 -> VPC
  - 고가용성 아키텍처 -> ELB, EC2 Auto Scaling, CloudWatch
  - AWS 데이터베이스 서비스 -> RDS, DynamoDB
  - 
## Cloud computing
- 직접 서버 장비를 구매하거나 임대 계약을 하지 않고도, 요청하는 즉시 컴퓨팅 자원을 제공해주는 서비로 원하는 시간 동안 원하는 만큼 검퓨팅 자원을 사용할 수 있음
  - 물리 장비 구매나 임대 계약 없이 사용 가능
  - 원하는 시간 동안 원하는 만큼 컴퓨팅 자원 사용 가능(EC2는 초단위 과금)
  - 스케일 업/다운, 스케일 인/아웃이 자유롭다
  - 클라우드 자원에 대한 모든 조작을 API로 제공
  - 프라이빗 네트워크 구성 및 권한 관리 기능 제공
  - 컴퓨팅 자원부터(LaaS) 매니지드 서비스까지(SaaS) 다양한 계층의 서비스 제공
  - 다양한 리전(Region)을 제공하고 있어 글로벌 서비스 확장이 용이

- aws는 internet 기반 서비스이다(Public) -=> 보안을 신경써야됨
- 가상화하여 서비스! (Rest API로 제공)

## 용어
- Region : 데이터 센터 => 선택 가능
  - 데이터 센터 여러개 묶은 것을 가용영역(AZ)이라 부른다.
  - AZ를 묶어 Region이라 부른다. --> AZ와 AZ는 물리적으로 병리되어 있다.
- Eage Location : 작은 데이터 센터 => 선택 불가
- https://aws.amazon.com/ko/about-aws/global-infrastructure/?nc1=h_ls

- Region을 위하여
  1. Az
  2. VPC 만들기
  3. EC2

- Eage Location을 위하여
  1. CloudFront(CDN)
  2. Route53(DNS)
  3. Shield
    - > Ddos 보안 필요
  4. WAF
    - > Ddos 보안 필요

## Service, Resource 정리
- EC2 => EC2 instance
- S3 => S3 Bucket

#### 자동으로 Resource_id가 생김
- Resource_id(여러므로 많이 쓰임).
- ARN -> ZAM정책 쓰임

## * Scope
1. Global : ZAM
2. Region : VPC, S3, DynamoDB( <== 대부분의 서비스)
3. AZ(보통 multi AZ) : EC2(앞단에서 ELB가 EC2에게 트레픽을 분산해준다.)
  - -> EBS, RDS

----------------
# AWS 보안 서비스
![image](https://user-images.githubusercontent.com/77317312/121778536-3b190c00-cbd2-11eb-8617-6ca6e76e7d2b.png)
1. Amazon Cognito
- Web Application내의 회원관리
  - 웹 및 모바일 앱에 대한 인증, 권한 부여 및 사용자 관리 제공
  - 사용자 아이디, 암호로 로그인 하거나 Facebook, Amazon, Google 등과 같은 타사를 통해 로그인할 수 있다.
2. AWS IAM
- AWS 리소스에 대한 액세스를 안전하게 제어하는 서비스
  - 사용자(인증), 그룹, 역할, 정책(권한)
  - 연동 사용자와 권한 관리
  - 최소한의 권한 원칙
  - MFA(Multi-Factor Authentication) - VD
- **임사자격증명, 역할을 권장**
3. IAM
- 사용자
- 그룹
- 역할 => 권한 위임(IAM 사용자, AWS 서비스에 권한을 줄 수 있다.)
  - 방문증이라 생각하자
- 정책
  - 권한설정(사용자, 그룹, 역할에만 권한을 줄 수 있음)
- IAM 권한 평가

-----------------
# Storage
![image](https://user-images.githubusercontent.com/77317312/121779064-cd221400-cbd4-11eb-8d31-98958d553345.png)
- 많은 기업이 비즈니스 애플리케이션에 복잡성을 가중하고 혁신을 늦추는 조각난 스토리지 포트폴리오 문제와 씨름하는 문제를 해결하기 위해
- 객체 스토리지는 어떠한 유형의 데이터든 네이티브 형식으로 저장할 수 있는 고도의 확장 가능하고 비용 효율적인 스토리지를 제공함
  1. 안정서으 가용성 및 확장서
  2. 보안 및 규정 준수
  3. 유연한 관리
  4. 그대로 쿼리?
  5. 가장 광범위한 에코시스템
- [참조](https://aws.amazon.com/ko/what-is-cloud-object-storage/)

## 스토리지
- Block -> EBS
- File -> EHS, FSX
- Object -> S3 (자주 수정되는 곳에는 부적합)

-----------------------
# web server를 만드려면?!(AWS에서)
1. EC2 Instance 선택
  -> VPC
2. Region 선택
3. AMI(amazon machine image) -> os, application
4. Storage(EBS)
5. 태그 추가(효율성을 위해)선택사항
6. 보안그룹(방화벽)
7. 검토 및 key pare(요즘 잘 안씀)

# 이 링크 참고해서 더 내용 채워 넣자
- https://www.44bits.io/ko/keyword/amazon-web-service















