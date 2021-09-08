# Web Programing

## Interrupt란?
- 어떤 장치가 다른 장치의 일을 잠시 중단시키고 자신의 상태 변화를 알려주는 것
- 인터럽트가 발생하면, 인터럽트를 받은 장치는 현재 자신의 상태를 기억시켜두고 인터럽트를 처리한다.

![image](https://user-images.githubusercontent.com/77317312/132474845-0bc716d4-5207-48d5-8935-6d19783ff4dd.png)

- interrupt를 받을 때 CPU가 어떻게 동작하는가?!
1. A 프로그램을 processor가 실행중인 상태에서 PC는 A 프로그램의 명령 부분을 가르키고 있다.
2. B 프로그램 실행을 위해 갑작스런 interrupt를 발생시킨다.
3. CPU는 현재 자신이 가지고 있던 레지스터의 모든 상태를 스택 혹은 processor 제어 블록에 저장하고 interrup vector를 이용하여 적절한 interrupt handler를 쓴다.(부른다.)
  - 컨텍스트 스위칭(context switching)이 일어나는 구간
4. B 프로그램의 PC를 가르키고 processor는 작업을 다시 시작한다.
5. B의 작업이 모두 끝나면 이전 저장해둔 스택에서 A의 상태를 프로세서에 복구한다.
6. 하던 일을 마저 진행한다.

## Dispatcher란?

![image](https://user-images.githubusercontent.com/77317312/132476722-edba064b-5a8e-4abf-b351-39f467d9994a.png)

- 사용자가 프로그램을 실행하면 processor가 생성되고 Ready상태가 된다.(Ready Queue)
- 이 후 스케줄러(scheduler)가 Ready Queue에 있는 Processor 중 하나를 Processor(CPU)가 사용가능한 상태가 될 때 CPU를 할당해준다.
- 이를 준비상태(**Ready**)에서 실행상태(**Running**)로 상태전이(**State Transition**)된다고 한다.
- 이 과정을 디스패칭(Dispatching)이라고 하고 디스패처(Dispatcher)가 이 일을 수행한다.

[출처](https://www.crocus.co.kr/1406)
