APP=copy
CATALINA_HOME="/home/ksi/tomcat/tomcat8/"
APPDIR=$(CATALINA_HOME)/webapps/$(APP)
APPCLASSES_DIR=$(APPDIR)/WEB-INF/classes
CLASSPATH=$(CATALINA_HOME)/lib/servlet-api.jar:$(CATALINA_HOME)/lib/*:$(CATALINA_HOME)/bin/*
OUTDIR=/tmp/tomcatbuild
SOURCEDIR=src/hello
WEBINF=web/WEB-INF/web.xml

default: prepare compile deploy
	@echo OK

tomcat_restart:
	export JAVA_HOME=$(dirname $(dirname $(dirname $(readlink -f $(which java)))))
	$(CATALINA_HOME)/bin/daemon.sh stop
	$(CATALINA_HOME)/bin/daemon.sh --tomcat-user $(whoami) start

makejar:
	@echo TODO

compile:
	@echo Compiling
	javac -d $(OUTDIR) -cp $(CLASSPATH) $(SOURCEDIR)/HelloWorld.java 

prepare:
	if [ ! -e $(OUTDIR) ]; then mkdir $(OUTDIR); fi

deploy:
	@echo Deploy
	if [ ! -e $(APPCLASSES_DIR) ]; then mkdir -p $(APPCLASSES_DIR); fi
	cp -R $(OUTDIR)/* $(APPCLASSES_DIR)
	cp $(WEBINF) $(APPDIR)/WEB-INF

ant_build:
	@echo complicated
	ant clean compile dist remove install

