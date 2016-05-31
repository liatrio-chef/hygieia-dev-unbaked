# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  #
  # hygieia-liatrio
  #
  config.vm.define "hygieia", :primary => true do |hygieia|
    hygieia.vm.box = "liatrio/centos7chefjava"

    hygieia.vm.provision "chef_solo" do |chef|
      chef.add_recipe "archiva-liatrio"
      chef.add_recipe "sonarqube-liatrio"
      chef.add_recipe "tomcat-liatrio"
      chef.add_recipe "jenkins-liatrio"
      chef.add_recipe "jenkins-liatrio::install_plugins"
      chef.add_recipe "jenkins-liatrio::install_plugins_pipeline"
      chef.add_recipe "jenkins-liatrio::install_plugins_hygieia"
      chef.add_recipe "jenkins-liatrio::create_jobs"
      chef.add_recipe "jenkins-liatrio::create_creds"
      chef.add_recipe "selenium-liatrio"
      chef.add_recipe "hygieia-liatrio"
      chef.json = {
        "java" => {
          "jdk_version" => "8",
        },
        "archiva" => {
          "version" => "2.2.0",
          "checksum" => "6af7c3c47c35584f729a9c139675a01f9a9819d0cdde292552fc783284a34cfa",
          #"mirror" => "http://192.168.1.125/",
          "web_port" => "8081",
        },
        "sonarqube" => {
          #"mirror" => "https://sonarsource.bintray.com/Distribution/sonarqube/",
          #"mirror" => "http://downloads.sonarsource.com/sonarqube/",
          #"mirror" => "http://192.168.1.125/"
        },
        "tomcat_liatrio" => {
          #"version" => "8.0.33",
          #"tarball_base_path" => "http://192.168.1.125/",
          #"checksum_base_path" => "http://192.168.1.125/",
          "connector_port" => "8082",
          "ajp_port" => "8010"
        },
        "jenkins" => {
          "master" => {
            "host" => "localhost",
            "port" => 8083,
            #"repostiroy" => "http://pkg.jenkins-ci.org/redhat",
            "version" => "1.651-1.1"
          }
        },
        "jenkins_liatrio" => {
          "install_plugins" => {
            "enablearchiva" => true,
            "maven_mirror" => "http://localhost:8081/repository/internal",
            "enablesonar" => true,
            "sonarurl" => "http://localhost:9000",
            "sonarjdbcurl" => "tcp://localhost:9092/sonar",
            "githuburl" => "https://github.com/drewliatro/spring-petclinic/",
            "giturl" => "https://github.com/drew-liatrio/spring-petclinic.git",
            "hygieiaurl" => "http://192.168.100.10:8080/api/"
          },
          "create_job" => {
            "maven_goals" => "clean deploy"
          }
        },
        "hygieia_liatrio" => {
          "dbname" => "dashboard",
          "dbhost" => "127.0.0.1",
          "dbport" => 27017,
          "dbusername" => "db",
          "dbpassword" => "dbpass",
          "jenkins_url" => "http://192.168.100.10:8083/",
          "udeploy_url" => "http://192.168.100.40:8080",
          "udeploy_username" => "admin",
          "udeploy_password" => "password",
          "sonar_url" => "http://192.168.100.10:9000/",
          "stash_url" => "http://192.168.100.60:7990/"
        }
      }
    end

    hygieia.berkshelf.enabled = true

    hygieia.vm.hostname = 'hygieia'
    hygieia.vm.network :private_network, ip: "192.168.100.10"
    hygieia.vm.network :forwarded_port, guest: 22, host: 2210, id: "ssh"
    hygieia.vm.network :forwarded_port, guest: 8081, host: 18081 # archiva
    hygieia.vm.network :forwarded_port, guest: 9000, host: 19000 # sonarqube
    hygieia.vm.network :forwarded_port, guest: 8082, host: 18082 # tomcat
    hygieia.vm.network :forwarded_port, guest: 8083, host: 18083 # jenkins
    hygieia.vm.network :forwarded_port, guest: 4444, host: 14444 # selenium
    hygieia.vm.network :forwarded_port, guest: 5555, host: 15555 # selenium
    hygieia.vm.network :forwarded_port, guest: 3000, host: 13000 # hygieia
    hygieia.vm.network :forwarded_port, guest: 8080, host: 18080 # hygieia-api

    hygieia.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--cpus", 2]
      v.customize ["modifyvm", :id, "--memory", 8192]
      #v.customize ["modifyvm", :id, "--name", "hygieia-dev"]
    end

    hygieia.vm.provision "shell", inline: "firewall-cmd --permanent --add-port=8081/tcp --add-port=9000/tcp --add-port=8082/tcp --add-port=8083/tcp --add-port=4444/tcp --add-port=3000/tcp --add-port=8080/tcp && firewall-cmd --reload && echo '192.168.100.40 imbucd' >> /etc/hosts"

  end

end
