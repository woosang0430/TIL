# Event 처리
- 자바 스크립트는 사요자의 요청처리를 Event 모델을 통해 처리한다.
  - Event Source : Event가 발생한 컴포넌트
  - Event => Event Source의 상태를 바꾸게 만드는 action(마우스로 버튼 클릭 등등)
  - Event Handler : Event 발생 시 처리하는 코드를 등록하는 것
  - Listener : Event Source에서 Event가 발생하는 것을 감시하다 발생 시 Handler 호출
```html
<input type='button' value='확인' onclick="alert('button클릭')"/>
<form action='a.jsp' onsubmit="alert('전송합니다')">
```
## 주요 Event와 Handler
| Event | Handler | 설명 |
| -- | -- | -- |
| load | onload | 해당 페이지가 로딩 되었을 때(처음 읽힐 때) 발생 |
| blur | onfocus | 입력 양식을 선택해서 포커스가 주어졌을 때 |
| change | onchange | 입력 양식 select에서 선택 item이 바뀌었을 때 |
| mousemove | onmousemove | 해당 영역에 마우스를 움직였을 때 발생 |
| mouseover | onmouseover | 해당 영역에마우스가 올라갔을 때 발생 |
| mouseout | onmouseout | 해당 영역에서 마우스가 나갔을 떄 발생 |
| mousedown | onmousedown | 해당 영역에서 마우스버튼을 눌렀을 때 발생 |
| mouseup | onmouseup | 해당 영역에서 누르던 마우스버튼을 떼었을 때 발생 |
| click | onclick | 해당 영역에서 마우스를 클릭 했을 때 발생 |
| keydown | onkeydown | 해당 영역에서 키보드를 눌렀을 때 발생 |
| keyup | onkeyup | 해당 영역에서 누르고 있던 키보드를 떼었을 때 발생 |
| keypress | onkeypress | 해당 영역에서 키보드를 계속 누르고 있을 때 발생 |
| submit | onsubmit | 폼의 내용을 전송 할 때 발생 |
| reset | onreset | 폼의 내용을 초기화 시킬 때 |

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<!-- style : css(디자인) 코드를 작성하는 태그 -->
<style>
    /* # layer -> id가 layer인  태그 지정 { 스타일 설정} */
    #layer{
        width: 300px;
        height: 300px;
        background-color: blue;
    }
</style>
<script>
    // 일반 버튼을 이용하여 submit 처리. (입력값 체크 후 submit 처리)
    function checkForm() {
        // alert('클릭-폼')
        nameTF = document.getElementById('name'); // id가 name인 태그 조회
        ageTF = document.getElementById('age');
        name = nameTF.value; // 태그의 value 속성값(입력된 값)을 조회
        age = ageTF.value;
        alert(name+''+age);
        if(!name) {
            alert('이름을 입력하세요');
            nameTF.focus();
            return
        }else {
            // 5글자 이하만 가능.
            if (name.length > 5) {
                alert('이름은 5글자까지 가능합니다');
                nameTF.value='';
                nameTF.focus();
                return
            };
        };

        if (!age) {
            alert('나이를 입력하세요');
            ageTF.focus();
            return;
        } else {
            ageNum = parseInt(age); // 정수로 변경안되는 문자열일 경우 NaN(False)가 반환
            if (!ageNum) {
                alert('나이는 숫자만 가능합니다.');
                ageTF.value = '';
                ageTF.focus();
                return
            };
        };
        form = document.getElementById('form')
        form.submit() // form태그.submit() 전송
    }

    // form 태그의 submit 이벤트 처리
    function checkForm2() {
        // alert('클릭-폼')
        nameTF = document.getElementById('name')
        ageTF = document.getElementById('age')
        name = nameTF.value()
        age = ageTF.value()

        if (!name) {
            alert('이름을 입력하세요')
            nameTF.focus()
            return false
        } else {
            if (name.length > 5) {
                alert('이름은 5글자까지 가능합니다.')
                nameTF.value = ''
                nameTF.focus()
                return false
            };
        }
        if (!age) {
            alert('나이를 입력하세요')
            ageTF.focus()
            return false
        } else {
            ageNum = parseInt(age)
            if (!ageNum) {
                alert('숫자만 입력가능합니다.')
                ageTF.value = ''
                ageTF.focus()
                return false
            }
        }
    }

    function check(text_input) {
        alert(text_input.value)
        text_input.value = ''
        text_input.size = 30
    }
</script>
<body>
    <div id="layer" onmouseover="console.log('마우스 in')" onmouseout="console.log('마우스 out')" onclick="alert('클릭')"></div>

    <input type="text" name="txt" onfocus="console.log('get focus')" onblur="check(this)">
    <!-- <input type="text" name="txt" onfocus="console.log('get focus')" onblur="alert(this.value);this.value='';"> -->
    <!-- this : input tag(이벤트가 발생한 태그). this.value : value attribute of input tag -->
    <form action="/test" method="post" id="form" onsubmit="return checkForm2()">
        이름 : <input type="text" name="name" id="name"><br>
        나이 : <input type="text" name="age" id="age"><br>
        <input type="button" value="클릭" onclick="checkForm()">
        <input type="submit" value="등록" onclick="checkForm()">
    </form>
</body>
</html>
```
