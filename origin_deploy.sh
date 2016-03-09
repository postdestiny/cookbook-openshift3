#!/bin/bash
#
### Update the server
yum -y update
### Create the chef-local mode infrastructure
mkdir -p chef-solo-example/{backup,cache}
cd chef-solo-example
cat << EOF > Gemfile
source "https://rubygems.org"
gem 'knife-solo'
gem 'librarian-chef'
EOF
### Installing dependencies
yum -y install rubygem-bundler kernel-devel ruby-devel gcc make git
### Installing gems 
bundle
### Create a kitchen by knife
knife solo init .
### Modify the librarian Cheffile for manage the cookbooks
echo "cookbook 'cookbook-openshift3', :git => 'https://github.com/IshentRas/cookbook-openshift3.git'" >> Cheffile 
librarian-chef install
### Create the dedicated environment for Origin deployment
cat << EOF > environments/origin.json
{
  "name": "origin",
  "description": "",
  "cookbook_versions": {

  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {

  },
  "override_attributes": {
    "cookbook-openshift3": {
      "openshift_deployment_type": "origin",
      "master_servers": [
        {
          "fqdn": "$(hostname -f)",
          "ipaddress": "$(hostname -i)"
        }
      ],
      "node_servers": [
        {
          "fqdn": "$(hostname -f)",
          "ipaddress": "$(hostname -i)"
        }
      ]
    }
  }
}
EOF
### Create the dedicated role for the Chef run_list
cat << EOF > roles/origin.json 
{
  "name": "origin",
  "description": "",
  "default_attributes": {

  },
  "override_attributes": {

  },
  "chef_type": "role",
  "run_list": [
    "recipe[cookbook-openshift3]",
    "recipe[cookbook-openshift3::common]",
    "recipe[cookbook-openshift3::master]",
    "recipe[cookbook-openshift3::node]",
    "recipe[cookbook-openshift3::node_config_post]"
  ],
  "env_run_lists": {

  }
}
EOF
### Specify the configuration details for chef-solo
cat << EOF > solo.rb
cookbook_path [
               '/root/chef-solo-example/cookbooks',
               '/root/chef-solo-example/site-cookbooks'
              ]
environment_path '/root/chef-solo-example/environments'
file_backup_path '/root/chef-solo-example/backup'
file_cache_path '/root/chef-solo-example/cache'
log_level :info
log_location STDOUT
solo true
EOF
### Deploy OSE !!!!
chef-client -z --environment origin -j roles/origin.json -c ~/chef-solo-example/solo.rb
echo -e "\nThe END\n"
