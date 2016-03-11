#
# Cookbook Name:: cookbook-openshift3
# Recipe:: master_standalone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node_servers = Chef::Config[:solo] ? node['cookbook-openshift3']['node_servers'] : search(:node, %(role:"#{node['cookbook-openshift3']['openshiftv3-node_label']}")).sort!

execute 'Create the master certificates' do
  command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} ca create-master-certs \
          --hostnames=#{node['cookbook-openshift3']['erb_corsAllowedOrigins'].join(',')} \
          --master=#{node['cookbook-openshift3']['openshift_master_api_url']} \
          --public-master=#{node['cookbook-openshift3']['openshift_master_api_url']} \
          --cert-dir=#{node['cookbook-openshift3']['openshift_master_config_dir']} --overwrite=false"
  creates "#{node['cookbook-openshift3']['openshift_master_config_dir']}/master.server.key"
end

package "#{node['cookbook-openshift3']['openshift_service_type']}-master" do
  action :install
  notifies :reload, 'service[daemon-reload]', :immediately
end

ruby_block 'Configure OpenShift settings Master' do
  block do
    openshift_settings = Chef::Util::FileEdit.new("/etc/sysconfig/#{node['cookbook-openshift3']['openshift_service_type']}-master")
    openshift_settings.search_file_replace_line(/^OPTIONS=/, "OPTIONS=--loglevel=#{node['cookbook-openshift3']['openshift_master_debug_level']}")
    openshift_settings.search_file_replace_line(/^CONFIG_FILE=/, "CONFIG_FILE=#{node['cookbook-openshift3']['openshift_master_config_file']}")
    openshift_settings.write_file
  end
end

execute 'Create the policy file' do
  command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} create-bootstrap-policy-file --filename=#{node['cookbook-openshift3']['openshift_master_policy']}"
  creates node['cookbook-openshift3']['openshift_master_policy']
  notifies :restart, "service[#{node['cookbook-openshift3']['openshift_service_type']}-master]", :delayed
end

template node['cookbook-openshift3']['openshift_master_scheduler_conf'] do
  source 'scheduler.json.erb'
  notifies :restart, "service[#{node['cookbook-openshift3']['openshift_service_type']}-master]", :delayed
end

if node['cookbook-openshift3']['oauth_Identity'] == 'HTPasswdPasswordIdentityProvider'
  package 'httpd-tools'

  file node['cookbook-openshift3']['openshift_master_identity_provider'][node['cookbook-openshift3']['oauth_Identity']]['filename'] do
    action :create_if_missing
    mode '600'
  end
end

template node['cookbook-openshift3']['openshift_master_config_file'] do
  source 'master.yaml.erb'
  variables(
    erb_corsAllowedOrigins: node['cookbook-openshift3']['erb_corsAllowedOrigins'].uniq,
    single_instance: node_servers.size.eql?(1) && node_servers.first['fqdn'].eql?(node['fqdn']) ? true : false,
    erb_master_named_certificates: node['cookbook-openshift3']['openshift_master_named_certificates']
  )
  notifies :restart, "service[#{node['cookbook-openshift3']['openshift_service_type']}-master]", :immediately
end

service "#{node['cookbook-openshift3']['openshift_service_type']}-master" do
  action [:start, :enable]
end
