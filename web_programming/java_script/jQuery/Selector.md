# jquery Selector

## Selector를 이용한 HTML구조 접근
- 구조 태그(HTML 태그) 와 javascript 분리
  - 동작을 HTML에 적용하기 위해 HTML 태그에 접근을 해야함
  - CSS기본 selector나 jquery 정의 selector 이용해 접근한다.

- 태그명 조회

| CSS | jQuery |
| -- | -- |
| `div{}` | `$("div")` |

- ID 속성값 조회

| CSS | jQuery |
| -- | -- |
| #address{} | `$("#address")` |

- class 속성값 조회

| CSS | jQuery |
| -- | -- |
| .hobbyinput{} | `$(".hobbyinput")` |

## 태그기반 Selector(선택자)

| 셀렉터 | 설명 | Ex) |
| -- | -- | -- |
| * | 모든 태그 | `$('*')` |
| E | 태그 명 E와 일치하는 모든 element node | `$('div')` |
| E.C | E 요소들 중 class 속성값이 C인 모든 element node | `$('div.result')`, `$('.input_form')` |
| E#I | E 요소들 중 id 속성값이 I인 모든 element node | `$('span#layer')`, `$('#message')` |
| E F | E 로 선택된 요소의 자손인 모든 F element node | `$('ul li')` |
| E>F | E 로 선택된 요소의 자식인 모든 element node | `$('table > tr')`, `$('#layer > li')` |
| E+F | E 로 선택된 요소의 바로 다음 형제 element node | `$('input+span')` |
| E~F | E 로 선택된 요소 다음에 나오는 모든 형제 element node | `$('div~span')` |
| E:has(F) | 자손 태그로 F를 가지는 태그며이 E인 element node | `$('table:has(tbody)')` |
| E[A] | 태그명이 E인 것 중 속성 A를 가지는 모든 element node | `$('input[value]')` |
| E[A=V] | 태그명이 E인 것 중 속성 A의 값이 V인 모든 element node | `$('input[type=checkbox]')` |
| E[A^=V] | 태그명이 E인 것 중 속성 A의 값이 V로 시작하는 모든 element node | `$('a[href^=www]')` |
| E[A$=V] | 태그명이 E인 것 중 속성 A의 값이 V로 끝나는 모든 element node | `%('a[href$=net]')` |
| E[A*=V] | 태그명이 E인 것 중 속성 A의 값에 V가 들어가는 모든 element node | `$('a[href*=google]')` |



































