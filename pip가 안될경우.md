# pip로 install할 경우 이런 에러가 뜨면
- ![image](https://user-images.githubusercontent.com/77317312/114494613-a0df2b00-9c57-11eb-9ea5-f5e4a3e7a011.png)
- 일단은 콘다로 설치해보자
- ![image](https://user-images.githubusercontent.com/77317312/114494723-cbc97f00-9c57-11eb-9ab4-92848810e7c8.png)
- `conda install -c conda-forge 패키지명=버전` <= 이퀄 하나
- 주피터에서 설치할 경우
   - `conda install -y -c conda-forge 패키지명=버전`
   - 주피터에서는 yes를 미리 명령어로 같이 넣어준다.
# 그리고 setuptools도 확인 ㄱㄱ
- ![image](https://user-images.githubusercontent.com/77317312/114494844-ff0c0e00-9c57-11eb-9228-ec1d25437260.png)
- `pip install --upgrade setuptools`
-------------
-   ERROR: Command errored out with exit status 1:
   command: 'C:\Users\yws15\anaconda3\envs\ml2\python.exe' -u -c 'import sys, setuptools, tokenize; sys.argv[0] = '"'"'C:\\Users\\yws15\\AppData\\Local\\Temp\\pip-install-ps112_em\\jpype1_ab9fec04256e4f26abdc8070e6b4b4c6\\setup.py'"'"'; __file__='"'"'C:\\Users\\yws15\\AppData\\Local\\Temp\\pip-install-ps112_em\\jpype1_ab9fec04256e4f26abdc8070e6b4b4c6\\setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' bdist_wheel -d 'C:\Users\yws15\AppData\Local\Temp\pip-wheel-dosgn36q'
       cwd: C:\Users\yws15\AppData\Local\Temp\pip-install-ps112_em\jpype1_ab9fec04256e4f26abdc8070e6b4b4c6\
  Complete output (55 lines):
  Found native jni.h at C:\Program Files\Java\jdk-16\include
  C:\Users\yws15\anaconda3\envs\ml2\lib\distutils\dist.py:274: UserWarning: Unknown distribution option: 'use_scm_version'
    warnings.warn(msg)
  running bdist_wheel
  running build
  running build_py
  creating build
  creating build\lib.win-amd64-3.8
  creating build\lib.win-amd64-3.8\jpype
  copying jpype\beans.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\imports.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\nio.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\reflect.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\types.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_classpath.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_core.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_cygwin.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_darwin.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_gui.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jarray.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jboxed.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jclass.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jcollection.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jcomparable.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jcustomizer.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jexception.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jinit.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jio.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jobject.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jpackage.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jproxy.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jstring.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jtypes.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_jvmfinder.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_linux.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_pykeywords.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\_windows.py -> build\lib.win-amd64-3.8\jpype
  copying jpype\__init__.py -> build\lib.win-amd64-3.8\jpype
  running build_ext
  running build_java
  Using Jar cache
  creating build\lib
  creating build\lib\org
  creating build\lib\org\jpype
  creating build\lib\org\jpype\classloader
  copying native\jars\org\jpype\classloader\JPypeClassLoader.class -> build\lib\org\jpype\classloader
  copying native\jars\org.jpype.jar -> build\lib
  running build_thunk
  Building thunks
  C:\Users\yws15\AppData\Local\Temp\pip-install-ps112_em\jpype1_ab9fec04256e4f26abdc8070e6b4b4c6\setupext\build_ext.py:84: FeatureNotice: Turned ON Numpy support for fast Java array access
    warnings.warn("Turned ON Numpy support for fast Java array access",
    including thunk build\lib\org\jpype\classloader\JPypeClassLoader.class
    including thunk build\lib\org.jpype.jar
  building '_jpype' extension
  error: Microsoft Visual C++ 14.0 or greater is required. Get it with "Microsoft C++ Build Tools": https://visualstudio.microsoft.com/visual-cpp-build-tools/
  ----------------------------------------
  ERROR: Failed building wheel for JPype1
