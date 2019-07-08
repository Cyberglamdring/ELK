# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # creating VM with CentOS v.7 + Tomcat v.8 + Logstash
  config.vm.define "centos-tomcat" do |centos_tomcat|
    centos_tomcat.vm.box = "sbeliakou/centos"
    centos_tomcat.vm.box_check_update = false
    centos_tomcat.vm.network :private_network, ip: "172.10.48.3"
    centos_tomcat.ssh.insert_key = false
    centos_tomcat.vm.hostname = "centos-tomcat"

    centos_tomcat.vm.provider "virtualbox" do |vb|
      vb.name = "CentOS7-Tomcat8-L"
      vb.memory = "1024"
    end
    # tomcat installing
    centos_tomcat.vm.provision "shell", path: "scripts/tomcat-install.sh"
    # logstash installing & configurating
    centos_tomcat.vm.provision "shell", path: "scripts/logstash-install.sh"
  end

    # creating VM with CentOS v.7 + Elasticsearch + Kebana
  config.vm.define "centos-monitoring" do |centos_monitoring|
    centos_monitoring.vm.box = "sbeliakou/centos"
    centos_monitoring.vm.box_check_update = false
    centos_monitoring.vm.network :private_network, ip: "172.10.48.2"
    centos_monitoring.ssh.insert_key = false
    centos_monitoring.vm.hostname = "centos-ek"

    centos_monitoring.vm.provider "virtualbox" do |vb|
      vb.name = "CentOS7-EK"
      vb.memory = "2048"
    end
    # elasticsearch installing
    centos_monitoring.vm.provision "shell", path: "scripts/elasticsearch-install.sh"
    # kibana installing
    centos_monitoring.vm.provision "shell", path: "scripts/kibana-install.sh"
  end

end
