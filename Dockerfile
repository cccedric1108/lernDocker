FROM centos:7
MAINTAINER cedric<cedric1108@126.com>

COPY readme.txt /usr/local/readme.txt

ADD apache-tomcat-9.0.89.tar.gz /usr/local/
ADD jdk-8u411-linux-x64.tar.gz /usr/local/

RUN yum -y install vim

ENV MYPATH /usr/local
WORKDIR $MYPATH

ENV JAVA_HOME /usr/local/jdk1.8.0_411
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.89
ENV CATALINA_BASH /usr/local/apache-tomcat-9.0.89

ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin

EXPOSE 8080

CMD /usr/local/apache-tomcat-9.0.89/bin/startup.sh && tail -F /usr/local/apache-tomcat-9.0.89/bin/logs/catalina.out

