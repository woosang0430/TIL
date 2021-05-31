## 드림코딩 엘리 Java_script 강의
- https://www.youtube.com/watch?v=tJieVCgGzhs&list=PLv2d7VI9OotTVOL4QmPfvJWPJvkmv6h-2&index=2

## 1. script가 head에 있는 경우
- ![image](https://user-images.githubusercontent.com/77317312/120216306-d248a000-c271-11eb-8c74-994624856db3.png)
- HTML을 위에서 부터 한줄씩 읽어오다 script를 만나게 되면 js파일을 다운 받고, 실행 후 나머지 진행
- 단점 --> js파일이 클 경우 사용자가 웹페이지를 보는데 많은 시간이 걸림. 

## 2. script를 body안에 넣는 경우
- ![image](https://user-images.githubusercontent.com/77317312/120217212-040e3680-c273-11eb-8f04-9a0e8b312a97.png)
- 페이지 준비 이후에 js를 다운 받고, 실행 
- 단점 --> 기본적인 HTML content를 빠르게 볼 수 있지만 js에 의존하는 웹페이지면 똑같이 시간이 오래걸림

## 3. head에서 asyn 사용하기!
- ![image](https://user-images.githubusercontent.com/77317312/120217416-459ee180-c273-11eb-9a3b-fa1673067cb5.png)
- asyn는 boolean type ==> HTML을 위에서 부터 읽어오다 asyn을 보면 병렬로 js를 다운 받은 후 다운이 끝나면 pasing을 멈추고 js 실행 나머지 pasing
- 2번 보다는 빠르지만 js가 웹페이지 준비가 되기 전에 실행할 수 있음

## 4. head에서 defer 사용하기! ** 많이 쓰는 듯
- ![image](https://user-images.githubusercontent.com/77317312/120217726-b9d98500-c273-11eb-8e18-0c486aeee779.png)
- defer은 pasing을 하다 defer을 만나면 병렬적으로 js파일을 다운 받은 후 pasing이 끝나면 js를 실행

## 번외. 조금 더 정확한 asyn과 defer의 차이점
- ![image](https://user-images.githubusercontent.com/77317312/120217931-002ee400-c274-11eb-887e-d68313bcf7eb.png)
- ![image](https://user-images.githubusercontent.com/77317312/120217954-0ae97900-c274-11eb-8b95-a3290d70cd46.png)
