# 글

| 태그 | 설명 |
| -- |  -- |
| `br` | 줄바꿈 |
| `p` | text 작성, `font-size: 16px` |
| `a` |  `href=""`(하이퍼링크), `target="[_blank or _self]"`([새로운 창 or no]) |
| `i` | 이태릭채 |
| `sup` | hat |
| `ins` | 밑줄 |
| `del` | 취소선 |

```html
<h1>H1</h1>
<h2>H2</h2>
<h3>H3</h3>
<h4>H4</h4>
<h5>H5</h5>
<h6>H6</h6>

<p>주로 본문에 사용되는 태그로 단락 구분</p>
<p>주로 본문에 사용되는 태그로 단락 구분<br /> 행바꿈 태그</p>
<p>주로 <b>본문</b>에 사용되는 태그</p>

<p><i>기울임</i></p>
<p>위로<sup>올림</sup></p>
<p><ins>밑줄</ins></p>
<p><del>취소선</del></p>
```
<h1>H1</h1>
<h2>H2</h2>
<h3>H3</h3>
<h4>H4</h4>
<h5>H5</h5>
<h6>H6</h6>

<p>주로 본문에 사용되는 태그로 단락 구분</p>
<p>주로 본문에 사용되는 태그로 단락 구분<br /> 행바꿈 태그</p>
<p>주로 <b>본문</b>에 사용되는 태그</p>

<p><i>기울임</i></p>
<p>위로<sup>올림</sup></p>
<p><ins>밑줄</ins></p>
<p><del>취소선</del></p>

# 리스트

| 리스트 태그 | 설명 |
| -- | -- |
| `ul` | Unorder List |
| `li` | List Item |
| `ol` | Order List |
| - | - |
| `dl` | wrap |
| `dt` | title |
| `dd` | context |

```HTML
<p>메뉴 리스트</p>

<ul>
  <li>menu1</li>
  <li>menu2</li>
</ul>

<p>지역 리스트</p>

<ol>
  <li>서울</li>
  <li>경기</li>
</ol>

<dl>
  <dt>메뉴 리스트</dt>
  <dd>메뉴1</dd>
  <dd>메뉴2</dd>

  <dt>지역 리스트</dt>
  <dd>서울</dd>
  <dd>경기</dd>
</dl>
```
<p>메뉴 리스트</p>

<ul>
  <li>menu1</li>
  <li>menu2</li>
</ul>

<p>지역 리스트</p>

<ol>
  <li>서울</li>
  <li>경기</li>
</ol>

<dl>
  <dt>메뉴 리스트</dt>
  <dd>메뉴1</dd>
  <dd>메뉴2</dd>

  <dt>지역 리스트</dt>
  <dd>서울</dd>
  <dd>경기</dd>
</dl>

# 오디오

| 속성 | 설명 |
| -- | -- |
| `src` | 경로 |
| `controls` | 컨트롤러이 보이고 싶으면 설정(`controls="controls"`) |
| `autoplay` | 자동 플레이 원하면 설정(`autoplay="autoplay"`) |
| `loop` | 1번 이상 재생하고 싶으면 설정(`loop="loop"`) |

```html
<audio src='/' controls='controls' autoplay="autoplay" loop="loop">
```
![image](https://user-images.githubusercontent.com/77317312/139515683-8961b5e8-e7ae-4ed2-9200-70534735b5b7.png)

  
# 동영상
```HTML
<video  controls="controls">
  <source src="/" type="video/mp4" />
</video>

<!-- or 요렇게 2가지 -->

<video src="/" type="video/mp4" controls="controls" ></video>
```

![image](https://user-images.githubusercontent.com/77317312/139515696-99d3914b-4057-4648-9722-a9a844b9af3b.png)


# 폼(form)

| input 태그 속성 | 설명 |
| -- | -- |
| `text` | text |
| `password` | password |
| `file` | file |
| `raido` | 동그라미 select(단일 선택) but name이 같은 것 끼리 |
| `checkbox` | 네모 select(다중 선택) but name이 같은 것 끼리 |
| `submit` | 위에서 체크된 정보들 서버로 보내는 친구 |

```html
<form action='#' method='get' style='margin-bottom: 30px;'>
  ID :
    <input type='text' name='uid'><br/>
  Password :
    <input type='password' name='upw'><br/>
  Phone :
    <input type='text' name='uphone1' size='3' /> -
    <input type='text' name='uphone2' size='4' /> -
    <input type='text' name='uphone3' size='4' /><br/>
  Picture :
    <input type='file' name='upic'><br/>
  Gender :
    <input type='radio' name='gender' value='m'> 남,
    <input type='radio' name='gender' value='w'> 여<br/>
  Language :
    <input type='checkbox' name='lan' value='ko'>한글,
    <input type='checkbox' name='lan' value='en'>영어,
    <input type='checkbox' name='lan' value='jap'>일본어,
    <input type='checkbox' name='lan' value='chi'>중국어<br/>
  About me :
    <textarea row='5' cols='20'></textarea><br/>
  nation :
    <select>
      <option>Korea</option>
      <option>USA</option>
      <option>JAPAN</option>
      <option>CHINA</option>
    </select><br/>
  favorite food :
    <select multiple="multiple">
      <option>김치</option>
      <option>불고기</option>
      <option>파전</option>
      <option>비빔밤</option>
    </select></br>
  <input type='submit'>
</form>
```

![image](https://user-images.githubusercontent.com/77317312/139515706-7aa1d595-a8cc-494f-a9f3-2a040508eab6.png)


# 레이아웃 구성
- `div` == `section` == `article` 3개 적절히 나눠서 사용하자

## DIV 레이아웃

- body의 전체적인 구성
```html
<body>
  <div>
    <h1>My Hompage</h1>
    <hr/>
  </div>

  <div>
    <ul>
      <li>menu1</li>
      <li>menu2</li>
      <li>menu3</li>
    </ul>
  </div>
  <hr/>

  <div>
    <h1>What is HTML5?</h1>
    <p>HTML5 is Goood!</p>
  </div>
  <hr/>

  <div>
    <p>xxx 주식회사 서울시 OO구 OO동</p>
  </div>
</body>
```
<body>
  <div>
    <h1>My Hompage</h1>
    <hr/>
  </div>

  <div>
    <ul>
      <li>menu1</li>
      <li>menu2</li>
      <li>menu3</li>
    </ul>
  </div>
  <hr/>

  <div>
    <h1>What is HTML5?</h1>
    <p>HTML5 is Goood!</p>
  </div>
  <hr/>

  <div>
    <p>xxx 주식회사 서울시 OO구 OO동</p>
  </div>
</body>


## 시멘틱 레이아웃(무조건 이거로)

| 시멘틱 태그 | 설명 |
| -- | -- |
| `header` | 제목 |
| `nav` | 메뉴바 |
| `section` | 본문 |
| `footer` | 마지막 |

```html
<body>
  <header>
    <h1>My Homepage</h1>
    <hr/>
  </header>

  <nav>
    <ul>
      <li>HTML5</li>
      <li>CSS3</li>
      <li>JAVASCRIPT</li>
    </ul>
    <hr/>
  </nav>

  <section>
    <h1>What is HTML5?</h1>
    <p>HTML5 is gooood!</p>
  </section>

  <footer>
    <p>xxx주식회사 서울시 OO구OO동</p>
  </footer>
</body>
```

<body>
  <header>
    <h1>My Homepage</h1>
    <hr/>
  </header>

  <nav>
    <ul>
      <li>HTML5</li>
      <li>CSS3</li>
      <li>JAVASCRIPT</li>
    </ul>
    <hr/>
  </nav>

  <section>
    <h1>What is HTML5?</h1>
    <p>HTML5 is gooood!</p>
  </section>

  <footer>
    <p>xxx주식회사 서울시 OO구OO동</p>
  </footer>
</body>
