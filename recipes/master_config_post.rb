#
# Cookbook Name:: cookbook-openshift3
# Recipe:: master_config_post
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

master_servers = node['cookbook-openshift3']['use_params_roles'] && !Chef::Config[:solo] ? search(:node, %(role:"#{node['cookbook-openshift3']['master_servers']}")).sort! : node['cookbook-openshift3']['master_servers']
node_servers = node['cookbook-openshift3']['use_params_roles'] && !Chef::Config[:solo] ? search(:node, %(role:"#{node['cookbook-openshift3']['node_servers']}")).sort! : node['cookbook-openshift3']['node_servers']

service_accounts = node['cookbook-openshift3']['openshift_common_service_accounts_additional'].any? ? node['cookbook-openshift3']['openshift_common_service_accounts'] + node['cookbook-openshift3']['openshift_common_service_accounts_additional'] : node['cookbook-openshift3']['openshift_common_service_accounts']

remote_file "#{Chef::Config[:file_cache_path]}/admin.kubeconfig" do
  source 'file:///etc/origin/master/admin.kubeconfig'
  mode '0644'
end

service_accounts.each do |serviceaccount|
  execute "Creation service account: \"#{serviceaccount['name']}\" ; Namespace: \"#{serviceaccount['namespace']}\"" do
    command 'echo "{\"kind\": \"ServiceAccount\",\"apiVersion\": \"v1\",\"metadata\": {\"name\": \"${serviceaccount}\"}}" | oc create -f - -n ${namespace} --config=admin.kubeconfig'
    environment(
      'serviceaccount' => serviceaccount['name'],
      'namespace' => serviceaccount['namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get sa #{serviceaccount['name']} -n #{serviceaccount['namespace']}"
    retries 5
    retry_delay 5
  end

  next unless serviceaccount.key?('scc')
  execute "Add SCC to service account: \"#{serviceaccount['name']}\" ; Namespace: \"#{serviceaccount['namespace']}\"" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} policy add-scc-to-user privileged system:serviceaccount:#{serviceaccount['namespace']}:#{serviceaccount['name']} --config=admin.kubeconfig"
    cwd Chef::Config[:file_cache_path]
    not_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get scc/privileged -n default -o yaml | grep default:#{serviceaccount['name']}"
    retries 5
    retry_delay 5
  end
end

node_servers.each do |nodes|
  execute "Set schedulability for node : #{nodes['fqdn']}" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} manage-node #{nodes['fqdn']} --schedulable=${schedulability} --config=admin.kubeconfig"
    environment(
      'schedulability' => master_servers.find { |server_node| server_node['fqdn'] == nodes['fqdn'] } ? 'False' : 'True'
    )
    cwd Chef::Config[:file_cache_path]
    only_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get node | grep #{nodes['fqdn']}"
  end
end
