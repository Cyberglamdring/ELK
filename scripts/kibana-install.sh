#!/bin/bash

# installing from repo
# import GPG key
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
# add repo
sudo tee /etc/yum.repos.d/kibana.repo <<EOF
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
# install elasticsearch
sudo yum install -y kibana
sudo yum clean all

# default localhost:5601
# configurating remote accesse
sudo tee /etc/kibana/kibana.yml <<EOF
server.port: 5601
server.host: "172.10.48.2"
elasticsearch.hosts: ["http://172.10.48.2:9200"]
EOF

# enable & ran service
sudo systemctl start kibana.service
sudo systemctl enable kibana.service
