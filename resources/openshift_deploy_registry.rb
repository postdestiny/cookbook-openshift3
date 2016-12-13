#
# Cookbook Name:: cookbook-openshift3
# Resources:: openshift_deploy_registry
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

resource_name :openshift_deploy_registry

default_action :create

property :number_instances, [String, Integer], required: true
property :persistent_registry, [TrueClass, FalseClass], required: true

action :create do
  remote_file "#{Chef::Config[:file_cache_path]}/admin.kubeconfig" do
    source 'file:///etc/origin/master/admin.kubeconfig'
    mode '0644'
  end

  execute 'Deploy Hosted Registry' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} adm registry --selector=${selector_router} --replicas=${replica_number} -n ${namespace_registry} --config=admin.kubeconfig"
    environment(
      'selector_registry' => node['cookbook-openshift3']['openshift_hosted_registry_selector'],
      'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace'],
      'replica_number' => persistent_registry ? number_instances : '1'
    )
    cwd Chef::Config[:file_cache_path]
    only_if '[[ `oc get pod --selector=docker-registry=default --no-headers --config=admin.kubeconfig | wc -l` -ne $replica_number || `oc get pod --selector=docker-registry=default --no-headers --config=admin.kubeconfig | wc -l` -eq 0 ]]'
  end

  # bash 'Create PV / PVC for registry' do
  #   code <<-EOC
  #     echo -e "---\napiVersion: v1\nkind: PersistentVolume\nmetadata:\n name: #{node['cookbook-openshift3']['registry_persistent_volume']['volume_name']}-pv\nspec:\n capacity:\n  storage: #{node['cookbook-openshift3']['registry_persistent_volume']['volume_size']}\n accessModes:\n  - ReadWriteMany\n persistentVolumeReclaimPolicy: Retain\n nfs:\n  path: #{node['cookbook-openshift3']['registry_persistent_volume']['nfs_directory']}/#{node['cookbook-openshift3']['registry_persistent_volume']['volume_name']}\n  server: #{node['cookbook-openshift3']['registry_persistent_volume']['host']}\n  readOnly: false\n" | oc create -f -
  #   EOC
  #   # only_if do
  #   #   persistent_registry
  #   #   !Mixlib::ShellOut.new("oc get pvc | grep #{node['cookbook-openshift3']['registry_persistent_volume']['volume_name']}-pvc").run_command.error?
  #   # end
  # end
end
