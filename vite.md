# Vite
JavaScript의 양이 증가됨에 따라 대규모 프로젝트에서 수천 개의 모듈을 포함하는 일은 드문 일이 아니다.
이에 따라 JS 기반 도구에 대한 성능 병목 현상이 발생하기 시작했고, 개발 서버를 가동하는 데 오랜 시간을 소모해야 했다.
브라우저에서의 느린 피드백 루프는 개발자의 생산성과 행복에 큰 영향을 준다.

이러한 **개발자의 생산성과 행복을 지키기 위해 나온 친구가 Vite**이다.

## Vite 작동 및 사용 이유
기존의 번들러 기반 빌드 설정은 서비스를 제공하기 전에 전체 애플리케이션을 크롤링하고 빌드한다.

**Vite는 먼저 애플리케이션의 모듈을 종속성**과 **소스 코드**의 두가지 범주로 나누어 개발 서버 시작 시간을 개선한다.

- **종속성** : 대부분의 개발 중에 자주 변경되지 않는 일반 JS입니다.(node_modules와 같은 수백 개의 모듈이 있는 라이브러리는 처리하는 데 큰 비용이 든다.)
  - Vite는 [esbuild](https://esbuild.github.io/)를 사용하여 종속성을 미리 묶는다. **esbuild는 Go로 작성되어 JS기반의 번들러보다 10 ~ 100배 더 빠르게 종속성을 사전 번들링**한다.

- **소스코드** : 변환이 필요한 비일반 JS(JSX, CSS, Vue...) - 자주 수정되는 친구들.

> - 기존의 번들러는 모든 모듈들을 묶어 번들한 이후에 서버를 준비한다.
> - Vite는 ESM(es module)을 통해 소스코드를 제공해주어 서버가 준비된 이후 필요한 모듈을 HTTP 요청을 불러오는 형식으로 진행합니다.
> **때문에 모든 모듈을 읽는 준비 시간보다 더 빠르게 서버를 준비 시킬 수 있습니다. **

![image](https://user-images.githubusercontent.com/77317312/162099835-50281c0e-2416-4311-a582-341aac950ab4.png)
번들러 기반 dev server

![image](https://user-images.githubusercontent.com/77317312/162099886-3592943f-e1d6-4131-a24c-0b0996be8ee8.png)
ESM(ES Module) 기반 dev server


## Vite 설정하기(using vue)

### 프로젝트 초기 생성 시(vite + vue)
```bash
$ npm create vite@latest project-name --template vue
```

### 기존 프로젝트에 vite 추가하는 경우
**`vite`, `vite vue plugin install`**(vue2로 셋팅)
```bash
$ npm install vite -D

$ npm install vite-plugin-vue2 -D
```

기존에 있던 `@vue/cli-service`과 `@vue/cli-[관련plugin]`의 다른 dev dependencies 지우기

```bash
$ npm un @vue/cli-service
$ npm un @vue/cli-xxx ...
```

### scripts 수정하기
`package.json` 안에 있는 scripts 내용 수정

vue cli에서 사용하던 `"serve": "vue-cli-service serve"`를 `"dev": "vite"`로 수정하기

위의 내용을 적용한 scripts문
```js
// package.json
{
  "scripts": {
    "dev": "vite", // start dev server, aliases: "vite dev", "vite serve"
    "build": "vite build", // build for production
    "preview": "vite preview" // locally preview production build
  }
}
```

### favicon 경로 바꾸기
vite는 public폴더를 root로 잡기 때문에 favicon의 경로를 변경한다.

in the index.html
`<link rel="icon" href="<%= BASE_URL %>favicon.ico">` => `<link rel="icon" href="/favicon.ico">`


### vite.config.js 추가
```js
// vite.config.js
import { defineConfig } from "vite";
import { createVuePlugin } from "vite-plugin-vue2";

export default defineConfig({
  plugins: [
    createVuePlugin(/* options */)
  ],
})'
```
[vite.config option 관련 링크](https://vitejs.dev/config/#config-file-resolving)


### 환경 변수 변경

`process`환경변수를 `import.meta`로 변경

> router 객체에 인자로 넣는 base 변경
> `process.env.BASE_URL -> import.meta.env.BASE_URL`
> 
> in the src/router/index.js
> ```js
> import Router from "vue-router";
> 
> const router = new Router({
>   mode: "history",
>   base: process.env.BASE_URL, // -> import.meta.env.BASE_URL로 변경
>   routes: [...],
> });
> ```
[Env variables and mode 관련 링크](https://vitejs.dev/guide/env-and-mode.html)


https://medium.com/nerd-for-tech/from-vue-cli-to-vitejs-648d2f5e031d
