## git init
-------------------
- `git init` : 디렉토리 초기화
> - 명령어 입력 전까지는 일반 디렉토리
> - `git init`으로 초기화 시키면 디렉토리를 로컬 깃 저장소로 등록
```
github_test git init
# Initailized empty Git repository in {PATH}
```

![image](https://user-images.githubusercontent.com/77317312/127762680-f089f981-675e-4e2b-a761-a05ece98021d.png)

## git status
-------------------
- `git status` : 지정 repo의 현재 상태
> - 상태 변경이 필요한 파일들을 알려준다.
> - 트래킹되지 않는 파일이 있으면, `git add`를 이용해 트래킹을 시작하라고 알려준다.

## git add <file name>
-------------------
- `git add` : 변경사항을 stage에 올리기
> - `git add` 뒤에 스테이지에 올릴 파일 이름을 적어 작업 진행
> - `git add --all` or `git add .`을 사용하면 status에 변경사할을 모두 stage에 올린다.
> - `git add` 이 후 status를 확인하면 stage에 올라간 후 commit 대상으로 file들이 바뀐다.
> - 만약 stage에서 내리고 싶을 경우 `git rm --cached <file name>` 입력

## git commit -m "commit msg"
-------------------
- `git commit -m "commit msg` : 로컬 저장소의 최종 단계
> - 커밋 대상들의 파일을 한 번에 커밋시킨다.
> - `-m` 뒤에는 메시지를 작성한다.
> - commit을 하면 working tree는 비워진다.
> - 원격 저장소와 로컬 저장소 연결 과정만 남음

## git remote add origin
-------------------
- `git remote add ~`는 현재의 로컬 저장소를 깃허브에 있는 특정 repository에 연결하는 명령어

## git remote -v
-------------------
- `git remote -v` : 연결이 잘 되어있는지 확인

## git push <remote repo name> <branch name to push>
-------------------
- `git push` : 로컬 저장소에 있던 파일들 원격 저장소로 보내기

## git clone
-------------------
- repo clone...

## git branch <new branch name>
-------------------
- `git brach` : 새로운 브랜치를 생성하거나 존재하는 브런치 조회
> - `<new branch name>`을 채우면 브랜치 생성 아니면 존재하는 브런치 조회
> - `git branch -d` : 브랜치 삭제할 때(현재의 브런치 삭제하고 싶은 경우 `git checkout`으로 이동 후 삭제)
> - `git branch -D` : 병합하지 않는 브랜치 강제 삭제

## git checkout <branch name>
-------------------
- `git checkout` : 브랜치 이동
> - `git checkout -b <new branch name>` 브랜치를 생성하고 전환까지