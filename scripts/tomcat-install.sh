#!/bin/bash
tomcat8="/opt/apache-tomcat-8.5.42"

sudo yum update -y
# java
sudo yum install -y java
sudo yum clean all
# tomcat8
sudo wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.tar.gz
sudo tar -xzvf apache-tomcat-8.5.42.tar.gz -C /opt
sudo rm -f apache-tomcat-8.5.42.tar.gz

# user tomcat:tomcat
sudo groupadd tomcat
sudo useradd -g tomcat -d $tomcat8 -s /bin/nologin tomcat
# permissions
sudo chown -R tomcat:tomcat $tomcat8

# create daemon
sudo tee /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat 9
After=syslog.target network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
Environment=CATALINA_PID=/opt/apache-tomcat-8.5.42/tomcat.pid
Environment=CATALINA_HOME=/opt/apache-tomcat-8.5.42
Environment=CATALINA_BASE=/opt/apache-tomcat-8.5.42
Environment=CATALINA_OPTS=-Xms256m -Xmx512m -verbose:gc -Xloggc:/opt/apache-tomcat-8.5.42/logs/jvm_gc_%p.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/apache-tomcat-8.5.42/logs/heap_dump_%p.log
Environment=JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom
ExecStart=/opt/apache-tomcat-8.5.42/bin/startup.sh
ExecStop=/opt/apache-tomcat-8.5.42/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# tomcat user
# login/password: admin
sudo tee $tomcat8/conf/tomcat-users.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">

        <role rolename="admin-gui"/>
        <role rolename="manager-gui"/>
        <user username="admin" password="admin" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOF

# 9: mange rolename
sudo tee $tomcat8/webapps/manager/META-INF/context.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF

# CATALINA_HOME
export CATALINA_HOME=$tomcat8

# service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
