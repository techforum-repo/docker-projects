FROM tomcat
MAINTAINER admin@albinsblog.com

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps-bkp

RUN mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps

#Copy Jacocco agent
COPY jacocoagent.jar /usr/local/tomcat/lib

#Expose manager application externally, if required expose only the specific IP's
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

#Expose host-manager application externally, if required expose only the specific IP's
COPY context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

#Add Remote Sample War
ADD https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war /usr/local/tomcat/webapps/

#Add Local Sample War
COPY helloworld.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]