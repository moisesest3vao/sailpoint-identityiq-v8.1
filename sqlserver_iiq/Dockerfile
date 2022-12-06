FROM mcr.microsoft.com/mssql/server:2017-latest

ENV ACCEPT_EULA=Y

#PASSWORD  SA
ENV SA_PASSWORD=Change@123
ENV CHECK_POLICY=OFF
EXPOSE 1433

#CREATE FOLDER SCRIPTS *.SQL
RUN mkdir -pv /tmp/scripts

#COPY SCRIPTS *.SQL IIQ FOR CONTAINERS 
COPY ./scripts/* /tmp/scripts/

RUN chmod +x /tmp/scripts/

#COPY SCRIPTS *.SH FOR CONTAINERS
COPY ./*.sh /tmp/