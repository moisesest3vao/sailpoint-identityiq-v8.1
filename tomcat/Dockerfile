FROM tomcat:9.0.34-jdk11-openjdk


#INSTALL PLUGINS IN IMAGE
RUN apt-get -y update  && \
        apt-get install -y curl && \
        apt-get install -y telnet && \
        apt-get install -y vim && \
        apt-get install -y zip

#CREATE ENVIRONMENT SET SPTARGET THAT SSB USE FOR BULD .WAR
ENV SPTARGET=docker

#COPY FILE *.SH FOR START CATHALINA
COPY ./*.sh /tmp/

#COPY FOLDER INSTALL
COPY ./file_install/ ../

#UNZIP SSB
RUN unzip -o ../ssb.zip -d ../ssb/

#REMOVE ZIP SSB
RUN rm ../ssb.zip


#COPY ALL ARTIFACTS .XML
COPY ./file_config/ ../ssb/config/


#PERMISSION SET
RUN chmod -R 777 ../ssb/


#MOVE FILE PROPERTIES IN THE SSB
RUN ls -la  ../ssb

#BUILD SSB
RUN cd ../ssb && sh build.sh clean war
#UNZIP .WAR IN FOLDER TOMCAT
RUN unzip ../ssb/build/deploy/identityiq.war -d webapps/identityiq
#REMOVE WAR
RUN rm ../ssb/build/deploy/identityiq.war && rm ../ssb/build/deploy/identityiq.war.MD5
#PERMISSION SET IIQ CONSOLE
RUN chmod +x webapps/identityiq/WEB-INF/bin/iiq
#GENERATE FILE TO IMPORT INIT.XML
RUN find /usr/local/tomcat/webapps/identityiq/WEB-INF/config/ -type f -name "init*" > /tmp/init.txt