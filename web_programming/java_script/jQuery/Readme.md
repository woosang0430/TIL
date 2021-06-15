# jQuery
![image](https://user-images.githubusercontent.com/77317312/122073277-44ed7a00-ce33-11eb-84a9-bb81ff75dbaa.png)

- **javascript library**
  - 웹 브라우저 마다 다르게 작성해야 되는 크로스 브라우저 자바스크립트 코드를 최대한 공통된 방법으로 작성할 수 있도록 하는 것을 목표로 만들어졌다.
  - https://jquery.com/
- **다운로드**
  - https://jquery.com/download/
  - jquery-x.x.x-min.js 다운(compressed 버전--> 압축되어있음 한줄로..)
  - library 파일 다운로드 후 사용하고자 하는 페이지에서 script태그의 src속성으로 등록 후 사용

## 기본 문법
- jQuery 객체
  - jQuery의 모든 기능을 제공하는 객체
  - `$.ajax(..)`, `$.get(..)`
- Selector 함수
  - jQuery가 제공하는 기능을 적용할 DOM 객체를 찾아 jQuery 객체에 넣는 함수
  - $('selector') ex) `$('div').on(..)`, `$(#email).css(..)`
