# ✔ FastAPI

- 현대적이고 빠르며, 파이썬 표준 타입 힌트에 기초한 python3.6+의 API를 빌드하기 위한 웹 프레임 워크

## 특징
1. NodeJS 및 Go와 대등할 정도로 빠름(`Starlette`, `Pydantic` 덕분에)
2. 적은 버그 및 직관적
3. 쉽게 사용하고 배우도록 설계되어 있다. 

- FastAPI는 기존 Python web application server에서 최고의 성능을 보인다.
- ![image](https://user-images.githubusercontent.com/77317312/120888594-1a7e0e80-c634-11eb-8ca1-d94ee99daa37.png)

## FastAPI의 구성 요소
- FastAPI를 구성하는 요소는 2가지로 볼 수 있다.
  - `Uvicorn`
  - `Starlette`

1. **Uvicorn(ASGI Server)**
  - Uvicorn은 초고속 ASGI Web server입니다. 단일 프로세스에서 uvloop기반 비동기 Python code를 실행한다.

2. **Starlette(Web Application Server)**
  - Starlette는 비동기적으로 실핼할 수 있는 Web application server입니다. Starlette는 Uvicorn 위에서 실행된다.
 
### FastAPI
- FastAPI는 Starlette 위에서 많은 기능을 제공합니다. FastAPI를 사용하지 않고 Starlette만 사용했다면, 모든 데이터 유효성검사 및 직렬화를 직접 구현해야합니다.
- 이 때문에 최종 애플리케이션은 FastAPI를 사용하여 빌드하는 것과 동일한 오버헤드를 갖는다.
- **데이터 유효성 검사 및 직렬화는 애플리케이션에서 작성되는 가장 많은 양의 코드이다.**
- 따라서 FastAPI를 사용하면 개발 시간, 버그, 코드 줄을 절약 할 수 있으며 사용하지 않았을 때와 동일한 성능을 얻을 수 있다.

### BUT
- Uvicon-FastAPI에서 Uvicorn은 Single process로만 작동하여 병렬성이 부족해져 multi process를 돌려야 하는 상황에는 대처할 수 없다.
- 때문에 `Gunicorn`을 통해 process를 동시에 여러개 돌려 병렬성을 확보한다.

3. **Gunicorn**
  - Gunicorn은 서버이자 프로세스 관리자이다.
  - python web application을 production 환경에 deployment 할 때 일반적으로 세가지를 섞어 사용한다.
    - `Web server`
    - `WSGI (web) server)
    - `Web application server(web app or web framwork)`

### Gunicorn is a WSGI server
- Gunicorn은 다양한 web server와 상호 작용할 수 있도록 구축되어있다.
- Gunicorn은 web server와 web application 사이에서 일어나는 모든 일을 처리한다.
- 이렇게하면 web application을 코딩 할 때 다음을 위한 자체 솔루션을 찾을 필요가 없다.
  - 여러 web server와 통신
  - 한 번에 많은 requeset를 처리하고 부하를 분산
  - 실핼중인 web application의 multi process 유지

### Uvicorn with Gunicorn
- Uvicorn에는 Gunicorn worker class가 포함되어있어 Uvicorn의 모든 성능 이점과 함께 ASGI 애플리케이션을 실행할 수 있습니다.
- 최종적으로 Gunicorn을 사용하여 Uvicorn을 관리하고 이를 통해 동시에 여러 process를 실행할 수 있다.



###### [참조] https://chacha95.github.io/2021-01-17-python6.5/
