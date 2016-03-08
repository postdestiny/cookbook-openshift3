#
# Cookbook Name:: cookbook-openshift3
# Recipe:: master
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

master_label = node['cookbook-openshift3']['openshift_cluster_name'].nil? ? node['cookbook-openshift3']['openshiftv3-master_label'] : node['cookbook-openshift3']['openshiftv3-master_cluster_label']

master_servers = Chef::Config[:solo] ? node['chef-solo']['master_servers'] : search(:node, %(role:"#{master_label}")).sort!

package node['cookbook-openshift3']['openshift_service_type']

package 'httpd' do
  notifies :run, 'ruby_block[Change HTTPD port xfer]', :immediately
end

node['cookbook-openshift3']['enabled_firewall_rules_master'].each do |rule|
  iptables_rule rule do
    action :enable
  end
end

directory node['cookbook-openshift3']['openshift_master_config_dir'] do
  recursive true
end

template node['cookbook-openshift3']['openshift_master_session_secrets_file'] do
  source 'session-secrets.yaml.erb'
  variables lazy {
    {
      secret_authentication: Mixlib::ShellOut.new('/usr/bin/openssl rand -base64 24').run_command.stdout.strip,
      secret_encryption: Mixlib::ShellOut.new('/usr/bin/openssl rand -base64 24').run_command.stdout.strip
    }
  }
  action :create_if_missing
end

remote_directory node['cookbook-openshift3']['openshift_common_examples_base'] do
  source 'openshift_examples/examples'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

if node['cookbook-openshift3']['openshift_HA']
  case node['cookbook-openshift3']['openshift_HA_method']
  when 'native'
    if node['cookbook-openshift3']['openshift_cluster_name'].nil?
      Chef::Application.fatal!('A Cluster Name must be defined via \"openshift_cluster_name\"')
    end
  else
    if node['cookbook-openshift3']['openshift_cluster_name'].nil? && node['cookbook-openshift3']['openshift_master_cluster_vip'].nil?
      Chef::Application.fatal!('A Cluster Name and IP must be defined via \"openshift_cluster_name\" and \"openshift_master_cluster_vip\"')
    end
  end
  include_recipe 'cookbook-openshift3::etcd_cluster'
  include_recipe 'cookbook-openshift3::master_cluster'
else
  include_recipe 'cookbook-openshift3::master_standalone'
end

directory '/root/.kube' do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end

execute 'Copy the OpenShift admin client config' do
  command "cp #{node['cookbook-openshift3']['openshift_master_config_dir']}/admin.kubeconfig /root/.kube/config && chmod 700 /root/.kube/config"
  creates '/root/.kube/config'
end

if master_servers.first['fqdn'] == node['fqdn']
  include_recipe 'cookbook-openshift3::nodes_certificates'
  include_recipe 'cookbook-openshift3::master_config_post'
end
