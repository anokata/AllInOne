echo off
set JAVA_HOME=c:\java\jre7\
set ANDROID_HOME=d:\Q\Android\sdk
set DEV_HOME=%CD%

set AAPT_PATH=%ANDROID_HOME%\build-tools\23.0.0\aapt.exe
set DX_PATH=%ANDROID_HOME%\build-tools\23.0.0\dx.bat
set ANDROID_JAR=%ANDROID_HOME%\platforms\android-23\android.jar
set ADB=%ANDROID_HOME%\platform-tools\adb.exe

set PACKAGE_PATH=com\example\testapp
set PACKAGE=com.example.testapp
set MAIN_CLASS=MainActivity


echo [[[COMPILING RESOURSES]]]
echo on

call %AAPT_PATH% package -f -m -S %DEV_HOME%\res -J %DEV_HOME%\src -M %DEV_HOME%\AndroidManifest.xml -I %ANDROID_JAR%

echo off
echo [[[COMPILING CLASSES]]]
echo on

call %JAVA_HOME%/bin/javac -d %DEV_HOME%/obj -cp %ANDROID_JAR% -sourcepath %DEV_HOME%/src %DEV_HOME%/src/%PACKAGE_PATH%/*.java

echo off
echo [[[DEXIFY]]]
echo on

call %DX_PATH% --dex --output=%DEV_HOME%/bin/classes.dex %DEV_HOME%/obj

echo off
echo [[[PACKING]]]
echo on

call %AAPT_PATH% package -f -M %DEV_HOME%/AndroidManifest.xml -S %DEV_HOME%/res -I %ANDROID_JAR% -F %DEV_HOME%/bin/AndroidTest.unsigned.apk %DEV_HOME%/bin

echo off
echo [[[KEYING]]]
echo on

call %JAVA_HOME%/bin/keytool -genkey -validity 10000 -dname "CN=AndroidDebug, O=Android, C=US" -keystore %DEV_HOME%/AndroidTest.keystore -storepass android -keypass android -alias androiddebugkey -keyalg RSA -v -keysize 2048
call %JAVA_HOME%/bin/jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore %DEV_HOME%/AndroidTest.keystore -storepass android -keypass android -signedjar %DEV_HOME%/bin/AndroidTest.signed.apk %DEV_HOME%/bin/AndroidTest.unsigned.apk androiddebugkey

pause