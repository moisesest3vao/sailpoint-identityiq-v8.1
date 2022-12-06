#!/bin/bash
sleep 10s
initFile="/tmp/init.txt"

if [ -s "$initFile" ]
then  
    initDefault="/usr/local/tomcat/webapps/identityiq/WEB-INF/config/init.xml"
    if [ -f "$initDefault" ]
    then
       sh /usr/local/tomcat/webapps/identityiq/WEB-INF/bin/iiq console -c "import $initDefault"
    fi 

    initUpgrade="/usr/local/tomcat/webapps/identityiq/WEB-INF/config/patch/identityiq-8.1p2-objects.xml"
    if [ -f "$initUpgrade" ]
    then
       sh /usr/local/tomcat/webapps/identityiq/WEB-INF/bin/iiq patch "8.1p2"
    fi

    initCustom="/usr/local/tomcat/webapps/identityiq/WEB-INF/config/sp.init-custom.xml"
    if [ -f "$initCustom" ]
    then
       sh /usr/local/tomcat/webapps/identityiq/WEB-INF/bin/iiq console -c "import $initCustom"
    fi

    initLcm="/usr/local/tomcat/webapps/identityiq/WEB-INF/config/init-lcm.xml"
    if [ -f "$initLcm" ]
    then
       sh /usr/local/tomcat/webapps/identityiq/WEB-INF/bin/iiq console -c "import $initLcm"
    fi   
    rm -f $initFile
fi
sh bin/catalina.sh run

