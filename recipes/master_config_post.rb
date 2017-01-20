#
# Cookbook Name:: cookbook-openshift3
# Recipe:: master_config_post
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

master_servers = node['cookbook-openshift3']['master_servers']
node_servers = node['cookbook-openshift3']['node_servers']
service_accounts = node['cookbook-openshift3']['openshift_common_service_accounts_additional'].any? ? node['cookbook-openshift3']['openshift_common_service_accounts'] + node['cookbook-openshift3']['openshift_common_service_accounts_additional'] : node['cookbook-openshift3']['openshift_common_service_accounts']

remote_file "#{Chef::Config[:file_cache_path]}/admin.kubeconfig" do
  source 'file:///etc/origin/master/admin.kubeconfig'
  mode '0644'
end

service_accounts.each do |serviceaccount|
  execute "Creation service account: \"#{serviceaccount['name']}\" ; Namespace: \"#{serviceaccount['namespace']}\"" do
    command 'oc create sa ${serviceaccount} -n ${namespace} --config=admin.kubeconfig'
    environment(
      'serviceaccount' => serviceaccount['name'],
      'namespace' => serviceaccount['namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get sa #{serviceaccount['name']} -n #{serviceaccount['namespace']} --config=admin.kubeconfig"
  end

  next unless serviceaccount.key?('scc')

  execute "Add SCC to service account: \"#{serviceaccount['name']}\" ; Namespace: \"#{serviceaccount['namespace']}\"" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} policy add-scc-to-user #{serviceaccount['scc']} -z #{serviceaccount['name']} --config=admin.kubeconfig -n #{serviceaccount['namespace']}"
    cwd Chef::Config[:file_cache_path]
    not_if "#{node['cookbook-openshift3']['openshift_common_client_binary']} get scc/#{serviceaccount['scc']} -n #{serviceaccount['namespace']} -o yaml --config=admin.kubeconfig | grep system:serviceaccount:#{serviceaccount['namespace']}:#{serviceaccount['name']}"
  end
end

execute 'Import Openshift Hosted Examples' do
  command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create -f #{node['cookbook-openshift3']['openshift_common_hosted_base']} --recursive --config=admin.kubeconfig -n openshift || #{node['cookbook-openshift3']['openshift_common_client_binary']} replace -f #{node['cookbook-openshift3']['openshift_common_hosted_base']} --recursive --config=admin.kubeconfig -n openshift"
  cwd Chef::Config[:file_cache_path]
  ignore_failure true
end

execute 'Import Openshift db templates' do
  command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/db-templates --recursive --config=admin.kubeconfig -n openshift || #{node['cookbook-openshift3']['openshift_common_client_binary']} replace -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/db-templates --recursive --config=admin.kubeconfig -n openshift"
  cwd Chef::Config[:file_cache_path]
  only_if { node['cookbook-openshift3']['deploy_example'] && node['cookbook-openshift3']['deploy_example_db_templates'] }
  ignore_failure true
end

execute 'Import Openshift Examples Base image-streams' do
  command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/image-streams/#{node['cookbook-openshift3']['openshift_base_images']} --recursive --config=admin.kubeconfig -n openshift || #{node['cookbook-openshift3']['openshift_common_client_binary']} replace -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/image-streams/#{node['cookbook-openshift3']['openshift_base_images']} --recursive --config=admin.kubeconfig -n openshift"
  cwd Chef::Config[:file_cache_path]
  only_if { node['cookbook-openshift3']['deploy_example'] && node['cookbook-openshift3']['deploy_example_image-streams'] }
  ignore_failure true
end

execute 'Import Openshift Examples quickstart-templates' do
  command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/quickstart-templates --recursive --config=admin.kubeconfig -n openshift"
  cwd Chef::Config[:file_cache_path]
  only_if { node['cookbook-openshift3']['deploy_example'] && node['cookbook-openshift3']['deploy_example_quickstart-templates'] }
  ignore_failure true
end

execute 'Import Openshift Examples xpaas-streams' do
  command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/xpaas-streams --recursive --config=admin.kubeconfig -n openshift"
  cwd Chef::Config[:file_cache_path]
  only_if { node['cookbook-openshift3']['deploy_example'] && node['cookbook-openshift3']['deploy_example_xpaas-streams'] }
  ignore_failure true
end

execute 'Import Openshift Examples xpaas-templates' do
  command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create -f #{node['cookbook-openshift3']['openshift_common_examples_base']}/xpaas-templates --recursive --config=admin.kubeconfig -n openshift"
  cwd Chef::Config[:file_cache_path]
  only_if { node['cookbook-openshift3']['deploy_example'] && node['cookbook-openshift3']['deploy_example_xpaas-templates'] }
  ignore_failure true
end

openshift_create_pv 'Create Persistent Storage' do
  persistent_storage node['cookbook-openshift3']['persistent_storage']
end

node_servers.each do |nodes|
  execute "Set schedulability for Master node : #{nodes['fqdn']}" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} manage-node #{nodes['fqdn']} --schedulable=${schedulability} --config=admin.kubeconfig"
    environment(
      'schedulability' => !nodes.key?(:schedulable) && master_servers.find { |server_node| server_node['fqdn'] == nodes['fqdn'] } ? 'False' : nodes['schedulable'].to_s
    )
    cwd Chef::Config[:file_cache_path]
    only_if do
      master_servers.find { |server_node| server_node['fqdn'] == nodes['fqdn'] } &&
        !Mixlib::ShellOut.new("oc get node | grep #{nodes['fqdn']}").run_command.error?
    end
  end

  execute "Set schedulability for node : #{nodes['fqdn']}" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} manage-node #{nodes['fqdn']} --schedulable=${schedulability} --config=admin.kubeconfig"
    environment(
      'schedulability' => !nodes.key?(:schedulable) && node_servers.find { |server_node| server_node['fqdn'] == nodes['fqdn'] } ? 'True' : nodes['schedulable'].to_s
    )
    cwd Chef::Config[:file_cache_path]
    not_if do
      master_servers.find { |server_node| server_node['fqdn'] == nodes['fqdn'] } ||
        Mixlib::ShellOut.new("oc get node | grep #{nodes['fqdn']}").run_command.error?
    end
  end

  execute "Set Labels for node : #{nodes['fqdn']}" do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} label node #{nodes['fqdn']} ${labels} --overwrite --config=admin.kubeconfig"
    environment(
      'labels' => nodes['labels'].to_s
    )
    cwd Chef::Config[:file_cache_path]
    only_if do
      nodes.key?('labels') &&
        !Mixlib::ShellOut.new("oc get node | grep #{nodes['fqdn']}").run_command.error?
    end
  end
end

execute 'Wait up to 30s for nodes registration' do
  command '[[ `oc get node --no-headers --config=admin.kubeconfig | grep -wc "Ready"` -ne 0 ]]'
  cwd Chef::Config[:file_cache_path]
  only_if '[[ `oc get node --no-headers --config=admin.kubeconfig | grep -wc "Ready"` -eq 0 ]]'
  retries 6
  retry_delay 5
end

if node['cookbook-openshift3']['openshift_hosted_manage_router']
  execute 'Deploy Hosted Router' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} adm router --selector=${selector_router} -n ${namespace_router} --config=admin.kubeconfig || true"
    environment(
      'selector_router' => node['cookbook-openshift3']['openshift_hosted_router_selector'],
      'namespace_router' => node['cookbook-openshift3']['openshift_hosted_router_namespace']
    )
    cwd Chef::Config[:file_cache_path]
    only_if '[[ `oc get pod --selector=router=router --config=admin.kubeconfig | wc -l` -eq 0 ]]'
  end
  execute 'Auto Scale Router based on label' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} scale dc/router --replicas=${replica_number} -n ${namespace_router} --config=admin.kubeconfig"
    environment(
      'replica_number' => Mixlib::ShellOut.new("oc get node --no-headers --selector=#{node['cookbook-openshift3']['openshift_hosted_router_selector']} --config=#{Chef::Config[:file_cache_path]}/admin.kubeconfig | wc -l").run_command.stdout.strip,
      'namespace_router' => node['cookbook-openshift3']['openshift_hosted_router_namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get pod --selector=router=router --config=admin.kubeconfig --no-headers | wc -l` -eq ${replica_number} ]]'
  end
end

openshift_deploy_registry 'Deploy Registry' do
  persistent_registry node['cookbook-openshift3']['registry_persistent_volume'].empty? ? false : true
  persistent_volume_claim_name "#{node['cookbook-openshift3']['registry_persistent_volume']}-claim"
  only_if do
    node['cookbook-openshift3']['openshift_hosted_manage_registry']
  end
end

openshift_deploy_metrics 'Deploy Cluster Metrics' do
  metrics_params Hash[node['cookbook-openshift3']['openshift_hosted_metrics_parameters'].map { |k, v| [k.upcase, v] }]
  only_if do
    node['cookbook-openshift3']['openshift_hosted_cluster_metrics']
  end
end
