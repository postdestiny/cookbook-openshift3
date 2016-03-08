#
# Cookbook Name:: cookbook-openshift3
# Recipe:: node_config_post
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

master_label = node['cookbook-openshift3']['openshift_cluster_name'].nil? ? node['cookbook-openshift3']['osev3-master_label'] : node['cookbook-openshift3']['osev3-master_cluster_label']

master_servers = Chef::Config[:solo] ? node['chef-solo']['master_servers'] : search(:node, %(role:"#{master_label}")).sort!
node_servers = Chef::Config[:solo] ? node['chef-solo']['node_servers'] : search(:node, %(role:"#{node['cookbook-openshift3']['osev3-node_label']}")).sort!

if master_servers.first['fqdn'] == node['fqdn']
  infra_node = []
  master_servers.each do |master|
    infra_node << master['fqdn']
  end

  node_servers.each do |node_server|
    label = infra_node.include?(node_server['fqdn']) ? node['cookbook-openshift3']['openshift_master_label'] : node['cookbook-openshift3']['openshift_node_label']

    execute "Wait for Node Registration for #{node_server['fqdn']}" do
      command "#{node['cookbook-openshift3']['openshift_common_client_binary']} label --overwrite node #{node_server['fqdn']} #{label}"
      retries 24
      retry_delay 5
      only_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get node #{node_server['fqdn']} | grep -w Ready"
      not_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get node #{node_server['fqdn']} --template={{.metadata.labels}}| grep #{label.tr('=', ':')}"
    end
  end
end
