#
# Cookbook Name:: cookbook-openshift3
# Recipe:: node
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

master_label = node['cookbook-openshift3']['openshift_cluster_name'].nil? ? node['cookbook-openshift3']['osev3-master_label'] : node['cookbook-openshift3']['osev3-master_cluster_label']

master_servers = Chef::Config[:solo] ? node['chef-solo']['master_servers'] : search(:node, %(role:"#{master_label}")).sort!

osn_cluster_dns_ip = node['cookbook-openshift3']['openshift_HA'] == true ? Mixlib::ShellOut.new("dig +short #{node['cookbook-openshift3']['openshift_common_public_hostname']}").run_command.stdout.strip : master_servers.first['ipaddress']

file '/usr/local/etc/.firewall_node_additional.txt' do
  content node['cookbook-openshift3']['enabled_firewall_additional_rules_node'].join('\n')
  owner 'root'
  group 'root'
end

node['cookbook-openshift3']['enabled_firewall_rules_node'].each do |rule|
  iptables_rule rule do
    action :enable
  end
end

directory node['cookbook-openshift3']['openshift_node_config_dir'] do
  recursive true
end

package "#{node['cookbook-openshift3']['openshift_service_type']}-node" do
  action :install
end

package "#{node['cookbook-openshift3']['openshift_service_type']}-sdn-ovs" do
  action :install
  only_if { node['cookbook-openshift3']['openshift_common_use_openshift_sdn'] == true }
end

remote_file "Retreive certificate from Master[#{master_servers.first['fqdn']}]" do
  path "#{node['cookbook-openshift3']['openshift_node_config_dir']}/#{node['fqdn']}.tgz"
  source "http://#{master_servers.first['ipaddress']}:#{node['cookbook-openshift3']['httpd_xfer_port']}/generated-configs/#{node['fqdn']}.tgz"
  action :create_if_missing
  notifies :run, 'execute[Extract certificate to Node folder]', :immediately
  retries 12
  retry_delay 5
end

execute 'Extract certificate to Node folder' do
  command "tar xzf #{node['fqdn']}.tgz"
  cwd node['cookbook-openshift3']['openshift_node_config_dir']
  action :nothing
end

template node['cookbook-openshift3']['openshift_node_config_file'] do
  source 'node.yaml.erb'
  variables osn_cluster_dns_ip: osn_cluster_dns_ip
  notifies :restart, "service[#{node['cookbook-openshift3']['openshift_service_type']}-node]", :immediately
  notifies :enable, "service[#{node['cookbook-openshift3']['openshift_service_type']}-node]", :immediately
end

ruby_block 'Configure OpenShift settings Node' do
  block do
    ose_settings = Chef::Util::FileEdit.new("/etc/sysconfig/#{node['cookbook-openshift3']['openshift_service_type']}-node")
    ose_settings.search_file_replace_line(/^OPTIONS=/, "OPTIONS=--loglevel=#{node['cookbook-openshift3']['openshift_node_debug_level']}")
    ose_settings.search_file_replace_line(/^CONFIG_FILE=/, "CONFIG_FILE=#{node['cookbook-openshift3']['openshift_node_config_file']}")
    ose_settings.write_file
  end
  notifies :restart, "service[#{node['cookbook-openshift3']['openshift_service_type']}-node]", :immediately
end

ruby_block 'Configure Docker settings' do
  block do
    ose_settings = Chef::Util::FileEdit.new('/etc/sysconfig/docker')
    ose_settings.search_file_replace_line(/^OPTIONS=/, "OPTIONS='--insecure-registry=#{node['cookbook-openshift3']['openshift_docker_insecure_registries'].join(' --insecure-registry=')} --selinux-enabled'")
    ose_settings.search_file_replace_line(/^ADD_REGISTRY=.*/, "ADD_REGISTRY='--add-registry #{node['cookbook-openshift3']['openshift_docker_add_registry_arg'].join(' --add-registry ')} --add-registry registry.access.redhat.com'") unless node['cookbook-openshift3']['openshift_docker_add_registry_arg'].nil?
    ose_settings.search_file_replace_line(/^[# ]*BLOCK_REGISTRY=.*/, "BLOCK_REGISTRY='--block-registry #{node['cookbook-openshift3']['openshift_docker_block_registry_arg'].join(' --block-registry ')}'") unless node['cookbook-openshift3']['openshift_docker_block_registry_arg'].nil?
    ose_settings.write_file
  end
  notifies :restart, "service[#{node['cookbook-openshift3']['openshift_service_type']}-node],service[docker]", :immediately
end

selinux_policy_boolean 'virt_use_nfs' do
  value true
end
