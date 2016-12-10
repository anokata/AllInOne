javac -classpath ./;./lib/j3dcore.jar;./lib/j3dutils.jar;./lib/vecmath.jar -d ./ ./%1.java
java -classpath ./;./lib/j3dcore.jar;./lib/j3dutils.jar;./lib/vecmath.jar -Djava.library.path=./lib %1
pause