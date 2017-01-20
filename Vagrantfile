# -*- mode: ruby -*-
# vi: set ft=ruby :

[
  { name: 'vagrant-berkshelf', version: '>= 5.0.0' }
].each do |plugin|
  unless Vagrant.has_plugin?(plugin[:name], plugin[:version])
    raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
  end
end

Vagrant.configure(2) do |config|
  #
  # hygieia-liatrio
  #
  config.vm.define 'hygieia', primary: true do |hygieia|
    hygieia.vm.box = 'bento/centos-7.2'

    hygieia.vm.provision 'chef_solo' do |chef|
      chef.version = '12.16.42'

      chef.add_recipe 'archiva-liatrio'
      chef.add_recipe 'sonarqube-liatrio'
      chef.add_recipe 'tomcat-liatrio'
      chef.add_recipe 'jenkins-liatrio'
      chef.add_recipe 'jenkins-liatrio::install_plugins'
      chef.add_recipe 'jenkins-liatrio::install_plugins_pipeline'
      chef.add_recipe 'jenkins-liatrio::install_plugins_hygieia'
      chef.add_recipe 'jenkins-liatrio::plugin_maven'
      chef.add_recipe 'jenkins-liatrio::m2_settings'
      chef.add_recipe 'jenkins-liatrio::job_vagrantbox'
      # chef.add_recipe 'selenium-liatrio'
      chef.add_recipe 'hygieia-liatrio::mongodb'
      chef.add_recipe 'hygieia-liatrio::node'
      chef.add_recipe 'hygieia-liatrio'
      chef.add_recipe 'hygieia-liatrio::apache2'

      chef.json = {
        'java' => {
          'jdk_version' => '8'
        },
        'archiva' => {
          'version' => '2.2.0',
          'checksum' => '6af7c3c47c35584f729a9c139675a01f9a9819d0cdde292552fc783284a34cfa',
          # "mirror" => "http://192.168.1.125/",
          'web_port' => '8081'
        },
        'sonarqube' => {
          'version' => '5.6.1',
          'checksum' => '9cb74cd00904e7c804deb3b31158dc8651a41cbe07e9253c53c9b11c9903c9b1'
          # "mirror" => "https://sonarsource.bintray.com/Distribution/sonarqube/",
          # "mirror" => "http://downloads.sonarsource.com/sonarqube/",
          # "mirror" => "http://192.168.1.125/"
        },
        'tomcat_liatrio' => {
          # "version" => "8.0.33",
          # "tarball_base_path" => "http://192.168.1.125/",
          # "checksum_base_path" => "http://192.168.1.125/",
          'connector_port' => '8082',
          'ajp_port' => '8010'
        },
        'jenkins' => {
          'java' => 'java',
          'master' => {
            'host' => 'localhost',
            'port' => 8083,
            # "repostiroy" => "http://pkg.jenkins-ci.org/redhat",
            'version' => '1.651-1.1'
          }
        },
        'jenkins_liatrio' => {
          # 'maven_mirror' => 'http://localhost:8081/repository/internal',
          'install_plugins' => {
            # 'enablearchiva' => true,
            'enablesonar' => true,
            'sonarurl' => 'http://localhost:9000',
            'sonarjdbcurl' => 'tcp://localhost:9092/sonar',
            'githuburl' => 'https://github.com/drewliatro/spring-petclinic/',
            'giturl' => 'https://github.com/drew-liatrio/spring-petclinic.git',
            'hygieiaurl' => 'http://192.168.100.10:8080/api/'
          },
          'create_job' => {
            'maven_goals' => 'clean deploy'
          }
        },
        'hygieia_liatrio' => {
          'user' => 'vagrant',
          'group' => 'vagrant',
          'home' => '/home/vagrant',
          'dbname' => 'dashboard',
          'dbhost' => '127.0.0.1',
          'dbport' => 27_017,
          'dbusername' => 'db',
          'dbpassword' => 'dbpass',
          'jenkins_url' => 'http://192.168.100.10:8083/',
          'udeploy_url' => 'http://192.168.100.40:8080',
          'udeploy_username' => 'admin',
          'udeploy_password' => 'password',
          'sonar_url' => 'http://192.168.100.10:9000/',
          'stash_url' => 'http://192.168.100.60:7990/'
        },
        'apache2_liatrio' => {
          'place' => 'holder'
        }
      }
    end

    hygieia.berkshelf.enabled = true

    # hygieia.vm.hostname = 'hygieia.local'
    hygieia.vm.network :private_network, ip: '192.168.100.10'
    hygieia.vm.network :forwarded_port, guest: 22, host: 2210, id: 'ssh'
    hygieia.vm.network :forwarded_port, guest: 80, host: 1080 # apache http
    hygieia.vm.network :forwarded_port, guest: 443, host: 1443 # apache https
    hygieia.vm.network :forwarded_port, guest: 8081, host: 18_081 # archiva
    hygieia.vm.network :forwarded_port, guest: 9000, host: 19_000 # sonarqube
    hygieia.vm.network :forwarded_port, guest: 8082, host: 18_082 # tomcat
    hygieia.vm.network :forwarded_port, guest: 8083, host: 18_083 # jenkins
    hygieia.vm.network :forwarded_port, guest: 4444, host: 14_444 # selenium
    hygieia.vm.network :forwarded_port, guest: 5555, host: 15_555 # selenium
    hygieia.vm.network :forwarded_port, guest: 3000, host: 13_000 # hygieia
    hygieia.vm.network :forwarded_port, guest: 8080, host: 18_080 # hygieia-api
    hygieia.vm.network :forwarded_port, guest: 27_017, host: 37_017 # mognodb

    hygieia.vm.provider :virtualbox do |v|
      # fix for bento box issue https://github.com/chef/bento/issues/682
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--cableconnected1', 'on']
      v.customize ['modifyvm', :id, '--cableconnected2', 'on']
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--cpus', 2]
      v.customize ['modifyvm', :id, '--memory', 8192]
      # v.customize ["modifyvm", :id, "--name", "hygieia-dev"]
    end
  end
end
