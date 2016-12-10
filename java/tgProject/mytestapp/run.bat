set PACKAGE=com.example.testapp
set MAIN_CLASS=MainActivity

set DEV_HOME=%CD%
set ANDROID_HOME=d:\Q\Android\sdk
set ADB=%ANDROID_HOME%\platform-tools\adb.exe

call %ADB% uninstall %PACKAGE%
call %ADB% install %DEV_HOME%/bin/AndroidTest.signed.apk
call %ADB% shell am start %PACKAGE%/%PACKAGE%.%MAIN_CLASS%