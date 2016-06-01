infra-auto Cookbook
========================
A wrapper cookbook when used with vagrant that will spin up a pipeline consisting of archiva, bitbucket, ibm-ucd, sonarqube, jenkins, hygieia, and tomcat.

Requirements
------------
Ensure the ChefDK is installed: https://downloads.chef.io/chef-dk/

Ensure the vagrant-berkshelf plugin is installed: `vagrant plugin install vagrant-berkshelf`

Ensure git-lfs is installed: `brew install git-lfs`

4 CPU cores & >13GB RAM

Usage
-----
`git clone git@github.com:liatrio/infra-auto.git`

`cd infra-auto; git lfs pull`

`vagrant up`


Jenkins - Browse to http://localhost:18080/ (Internal IP 192.168.100.20)
- may need to build petclinic 1-3x due to network issues if archiva fails to mirror artifacts
- on successful build the war is deployed to the tomcat instance by scp'ing the artifact from archiva to /opt/tomcat_petclinic/webapps

Archiva - Browse to http://localhost:18081/ (Internal IP 192.168.100.30)
- admin :: admin1
- snapshots :: snapshots1
- deploy :: deploy1

ibm-ucd - Browse to http://localhost:18083/ (Internal IP 192.168.100.40)
- admin :: password
- needs integration with jenkins

Bitbucket - Browse to http://localhost:17990/ (Internal IP 192.168.100.60)
- admin :: password
- use the git ssh key in local repo bitbucket_ssh.priv.key
- only installs, has to be configured manually due to licensing

Sonarqube - Browse to http://localhost:19000/ (Internal IP 192.168.100.70)
- admin :: admin

Hygieia - Browse to http://localhost:13000/ (Internal IP 192.168.100.50)
- create a user and dashboard, the collectors are aware of the different components

Tomcat - Browse to http://localhost:18081/ (Internal IP 192.168.100.80)
- petclinic is deployed to a link in the form of http://localhost:1180/spring-petclinic-4.2.4-20160314.054124-1/ - which can be be derived from the jenkins build console output

License and Authors
-------------------
Authors: drew@liatrio.com
