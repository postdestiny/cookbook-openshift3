#
# Cookbook Name:: cookbook-openshift3
# Recipe:: common
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'iptables::default'
include_recipe 'selinux_policy::default'

if node['cookbook-openshift3']['ose_version']
  if node['cookbook-openshift3']['ose_version'].to_f.round(1) != node['cookbook-openshift3']['ose_major_version'].to_f.round(1)
    Chef::Application.fatal!("\"ose_version\" #{node['cookbook-openshift3']['ose_version']} should be a subset of \"ose_major_version\" #{node['cookbook-openshift3']['ose_major_version']}")
  end
end

if node['cookbook-openshift3']['use_wildcard_nodes'] && node['cookbook-openshift3']['wildcard_domain'].empty?
  Chef::Application.fatal!('"wildcard_domain" cannot be left empty when using "use_wildcard_nodes attribute"')
end

if node['cookbook-openshift3']['install_method'].eql? 'yum'
  node['cookbook-openshift3']['yum_repositories'].each do |repo|
    yum_repository repo['name'] do
      description "#{repo['name'].capitalize} aPaaS Repository"
      baseurl repo['baseurl']
      gpgcheck repo['gpgcheck'] if repo.key?(:gpgcheck) && !repo['gpgcheck'].nil?
      gpgkey repo['gpgkey'] if repo.key?(:gpgkey) && !repo['gpgkey'].nil?
      sslverify repo['sslverify'] if repo.key?(:sslverify) && !repo['sslverify'].nil?
      exclude repo['exclude'] if repo.key?(:exclude) && !repo['exclude'].nil?
      enabled repo['enabled'] if repo.key?(:enabled) && !repo['enabled'].nil?
      action :create
    end
  end
end

service 'firewalld' do
  action [:stop, :disable]
end

package 'deltarpm'

node['cookbook-openshift3']['core_packages'].each do |pkg|
  package pkg
end

package 'docker' do
  version node['cookbook-openshift3']['docker_version'] unless node['cookbook-openshift3']['docker_version'].nil?
end

bash "Configure Docker to use the default FS type for #{node['fqdn']}" do
  code <<-EOF
    correct_fs=$(df -T /var | egrep -o 'xfs|ext4')
    sed -i "s/xfs/$correct_fs/" /usr/bin/docker-storage-setup
  EOF
  not_if "grep $(df -T /var | egrep -o 'xfs|ext4') /usr/bin/docker-storage-setup"
end

template '/etc/sysconfig/docker-storage-setup' do
  source 'docker-storage.erb'
end

template '/etc/sysconfig/docker' do
  source 'service_docker.sysconfig.erb'
  notifies :restart, 'service[docker]', :immediately
  notifies :enable, 'service[docker]', :immediately
end

ruby_block 'Change HTTPD port xfer' do
  block do
    openshift_settings = Chef::Util::FileEdit.new('/etc/httpd/conf/httpd.conf')
    openshift_settings.search_file_replace_line(/^Listen/, "Listen #{node['cookbook-openshift3']['httpd_xfer_port']}")
    openshift_settings.write_file
  end
  action :nothing
  notifies :restart, 'service[httpd]', :immediately
end
