# 이미지 수집
## google images download 라이브러리
- 다운받고 싶은 이미지 keyword를 입력하면 구글에서 이미지 검색해 다운로드 하는 라이브러리
- CLI (Command Line Interface) 환경에서 명령어를 이용해 다운받는 방법과 python 코드로 작성해 다운받는 2가지 방식을 다 지원한다.
- doc : https://google-images-download.readthedocs.io/en/latest/installation.html
- github :  https://github.com/Joeclinton1/google-images-download

## 설치
- `!pip install git+https://github.com/Joeclinton1/google-images-download.git`
- 100개 이상의 이미지를 다운받기 위해서는 Chromedriver를 받아 옵션에 설정해야한다.
  - https://chromedriver.chromium.org/downloads

## 명령프롬포트에서 실행
- 구문
  - googleimagesdownload -- 옵션 옵션값
  - ex) `googleimagesdownload --keywords "Polar bears, baloons, Beaches" --limit 20 -f jpg`
    - 키워드별로 limit 개수 만큼
- chrome driver 연동시 `--chromedriver 드라이버경로` 설정
- `googleimagesdownload --keywords "Polar bears, baloons, Beaches" --limit 1000 --chromedriver C:\Users\domain\Dowloads\chromdriver_win32\chromedriver.exe`
- 옵션 :  https://google-images-download.readthedocs.io/en/latest/arguments.html

## 설정파일
- json을 이용해
- keywords별로 각각 처리할 수 있다.
```python
%%writefile config.json
{
  "Records":[
    {
      "keywords":"apple",
      "limit":5,
      "format":"jpg",
      "color-type":"full-color",
      "print_url":true
      "print_size":true
    },
    {
      "keywords":"watermelon",
      "limit":50,
      "formay":"jpg",
      "color-type":"full-color",
      "print_url":true,
      "print_size":true
    },
    {
      "keywords":"peach",
      "limit":200,
      "format":"jpg",
      "color-type":"full-color",
      "print_urls":true,
      "print_size":true,
      "chromedriver":"c:\\tools\\chromedriver.exe"
    }
  ]
}
!googleimagesdownload --config_file config.json
```
## 파이썬 코드로 다운로드
```python
from google_images_download import google_images_download

response = google_images_download.googleimagesdownload()

args = {
  "keywords":"tiger,lion",
  "limit":30,
  "format":"jpg",
  "print_urls":True,
  "print_size":True
}

# 크롤링 시작
path = response.download(args)
```
