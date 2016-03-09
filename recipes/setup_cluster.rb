#
# Cookbook Name:: cookbook-openshift3
# Recipe:: setup_cluster
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

master_hosts = []

master_servers = Chef::Config[:solo] ? node['cookbook-openshift3']['master_servers'] : search(:node, %(role:"#{node['cookbook-openshift3']['openshiftv3-master_cluster_label']}")).sort!

master_servers.each do |master_member|
  master_hosts << master_member['ipaddress']
end

openshift_setup_cluster 'Setup Pacemaker' do
  master_hosts master_hosts
  cluster_password node['cookbook-openshift3']['openshift_master_cluster_password']
end

bash 'Setup cluster' do
  code <<-EOF
    pcs resource defaults resource-stickiness=100
    pcs resource create virtual-ip IPaddr2 ip=#{node['cookbook-openshift3']['openshift_master_cluster_vip']} --group openshift-master
    pcs resource create master systemd:"#{node['cookbook-openshift3']['openshift_service_type']}-master" op start timeout=90s stop timeout=90s --group openshift-master
    pcs constraint colocation add virtual-ip master INFINITY
    pcs property set stonith-enabled=false
  EOF
  only_if 'crm_resource --list| grep \'NO resources configured\''
end
