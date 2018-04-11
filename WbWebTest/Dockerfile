FROM soonenough/ubuntu_java8_tomcat8:latest
MAINTAINER dockerwb

RUN rm -rf /home/tomcat8/webapps/ROOT/
COPY build/libs/*.war /home/tomcat8/webapps/ROOT.war