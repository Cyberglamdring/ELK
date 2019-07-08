#!/bin/bash

# installing from repo
# import GPG key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
# add repo
sudo tee /etc/yum.repos.d/logstash.repo <<EOF
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
# install logstash
sudo yum install -y logstash
sudo yum clean all

# config logs
sudo tee /etc/logstash/conf.d/tomcat8.conf <<EOF
input {
  file {
    path => "/opt/apache-tomcat-8.5.42/logs/catalina.*.log"
    start_position => "beginning"
  }
}

output {
  stdout {
    codec => rubydebug
  }
  elasticsearch {
    hosts => ["172.10.48.2:9200"]
    index => "tomcat"
  }
}
EOF

sudo tee /etc/logstash/logstash.yml <<EOF
path.data: /var/lib/logstash
http.host: "172.10.48.3"
path.logs: /var/log/logstash
EOF

# enable & ran service
sudo systemctl start logstash.service
sudo systemctl enable logstash.service
