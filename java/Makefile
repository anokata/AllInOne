Quiz:
	javac Quiz.java && java Quiz
Hello:
	javac Hello.java && java Hello
Oop:
	javac Oop.java && java Oop
CL:
	javac CL.java && java CL
RobotMain:
	javac RobotMain.java && java RobotMain

TestJnlp:
	javac -cp /usr/share/icedtea-web/netx.jar ./TestJnlp.java  && \
	java -cp /usr/share/icedtea-web/netx.jar:. TestJnlp

HelloWorld:
	javac -cp .:subtest.jar ai/eu/work/train0/HelloWorld.java && java -cp .:subtest.jar ai.eu.work.train0.HelloWorld
	# need learn maven
SubTest:
	javac ai/eu/work/train0/SubTest.java && \
		java -cp . ai.eu.work.train0.SubTest

java:
	javac $(JavaSource) && \
	java $(JavaClass)

jdbcdemo:
	javac -cp . jdbcdemo.java && \
	java -cp .:postgresql-42.0.0.jar jdbcdemo
