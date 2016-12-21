#
# Cookbook Name:: cookbook-openshift3
# Recipe:: validate
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
master_servers = node['cookbook-openshift3']['master_servers']

if node['cookbook-openshift3']['ose_version']
  if node['cookbook-openshift3']['ose_version'].to_f.round(1) != node['cookbook-openshift3']['ose_major_version'].to_f.round(1)
    Chef::Application.fatal!("\"ose_version\" #{node['cookbook-openshift3']['ose_version']} should be a subset of \"ose_major_version\" #{node['cookbook-openshift3']['ose_major_version']}")
  end
end

if node['cookbook-openshift3']['use_wildcard_nodes'] && node['cookbook-openshift3']['wildcard_domain'].empty?
  Chef::Application.fatal!('"wildcard_domain" cannot be left empty when using "use_wildcard_nodes attribute"')
end

if node['cookbook-openshift3']['openshift_HA'] && node['cookbook-openshift3']['openshift_cluster_name'].nil?
  Chef::Application.fatal!('A Cluster Name must be defined via \"openshift_cluster_name\"')
end

