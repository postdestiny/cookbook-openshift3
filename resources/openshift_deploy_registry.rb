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

  execute 'Generate certificates for Hosted Registry' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} adm ca create-server-cert --signer-cert=#{node['cookbook-openshift3']['openshift_master_config_dir']}/ca.crt --signer-key=#{node['cookbook-openshift3']['openshift_master_config_dir']}/ca.key --signer-serial=#{node['cookbook-openshift3']['openshift_master_config_dir']}/ca.serial.txt --hostnames=\"${registry_svc_ip},docker-registry.#{node['cookbook-openshift3']['openshift_hosted_registry_namespace']}.svc.cluster.local,${docker_registry_route_hostname}\" --cert=#{node['cookbook-openshift3']['openshift_master_config_dir']}/registry.crt --key=#{node['cookbook-openshift3']['openshift_master_config_dir']}/registry.key --config=admin.kubeconfig"
    environment(
      'registry_svc_ip' => `#{node['cookbook-openshift3']['openshift_common_client_binary']} get service docker-registry -o jsonpath='{.spec.clusterIP}' --config=admin.kubeconfig -n #{node['cookbook-openshift3']['openshift_hosted_registry_namespace']}`,
      'docker_registry_route_hostname' => "docker-registry-#{node['cookbook-openshift3']['openshift_hosted_registry_namespace']}-#{node['cookbook-openshift3']['openshift_master_router_subdomain']}"
    )
    cwd Chef::Config[:file_cache_path]
    not_if "[[ -f #{node['cookbook-openshift3']['openshift_master_config_dir']}/registry.crt && -f #{node['cookbook-openshift3']['openshift_master_config_dir']}/registry.key ]]"
  end

  execute 'Create secret for certificates' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} secrets new registry-certificates #{node['cookbook-openshift3']['openshift_master_config_dir']}/registry.crt #{node['cookbook-openshift3']['openshift_master_config_dir']}/registry.key -n ${namespace_registry} --config=admin.kubeconfig"
    environment(
      'registry_svc_ip' => `#{node['cookbook-openshift3']['openshift_common_client_binary']} get service docker-registry -o jsonpath='{.spec.clusterIP}' --config=admin.kubeconfig -n #{node['cookbook-openshift3']['openshift_hosted_registry_namespace']}`,
      'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace'],
      'docker_registry_route_hostname' => "docker-registry-#{node['cookbook-openshift3']['openshift_hosted_registry_namespace']}-#{node['cookbook-openshift3']['openshift_master_router_subdomain']}"
    )
    cwd Chef::Config[:file_cache_path]
    only_if '[[ `oc get secret registry-certificates -n ${namespace_registry} --no-headers --config=admin.kubeconfig | wc -l` -eq 0 ]]'
  end

  %w(default registry).each do |service_account|
    execute "Add secret to registry's pod service accounts (#{service_account})" do
      command "#{node['cookbook-openshift3']['openshift_common_client_binary']} secrets add #{service_account} registry-certificates -n ${namespace_registry} --config=admin.kubeconfig"
      environment(
        'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace']
      )
      cwd Chef::Config[:file_cache_path]
    end
  end

  execute 'Attach registry-certificates secret volume' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} volume dc/docker-registry --add --type=secret --secret-name=registry-certificates -m /etc/secrets secrets -n ${namespace_registry} --config=admin.kubeconfig"
    environment(
      'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get dc/docker-registry -o jsonpath=\'{.spec.template.spec.volumes[*].secret.secretName}\' -n ${namespace_registry} --no-headers --config=admin.kubeconfig` =~ registry-certificate ]]'
  end

  execute 'Configure certificates in registry deplomentConfig' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} env dc/docker-registry REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/registry.crt REGISTRY_HTTP_TLS_KEY=/etc/secrets/registry.key -n ${namespace_registry} --config=admin.kubeconfig"
    environment(
      'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc env dc/docker-registry --list -n ${namespace_registry} --no-headers --config=admin.kubeconfig` =~ "REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/registry.crt" && `oc env dc/docker-registry --list -n ${namespace_registry} --no-headers --config=admin.kubeconfig` =~ "REGISTRY_HTTP_TLS_KEY=/etc/secrets/registry.key" ]]'
  end

  execute 'Update registry liveness probe from HTTP to HTTPS' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} patch dc/docker-registry -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"registry\",\"livenessProbe\":{\"httpGet\":{\"scheme\":\"HTTPS\"}}}]}}}}' -n ${namespace_registry} --config=admin.kubeconfig"
    environment(
      'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get dc/docker-registry -o jsonpath=\'{.spec.template.spec.containers[*].livenessProbe.httpGet.scheme}\' -n ${namespace_registry} --no-headers --config=admin.kubeconfig` =~ "HTTPS" ]]'
  end

  execute 'Update registry readiness probe from HTTP to HTTPS' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} patch dc/docker-registry -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"registry\",\"readinessProbe\":{\"httpGet\":{\"scheme\":\"HTTPS\"}}}]}}}}' -n ${namespace_registry} --config=admin.kubeconfig"
    environment(
      'namespace_registry' => node['cookbook-openshift3']['openshift_hosted_registry_namespace']
    )
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get dc/docker-registry -o jsonpath=\'{.spec.template.spec.containers[*].readinessProbe.httpGet.scheme}\' -n ${namespace_registry} --no-headers --config=admin.kubeconfig` =~ "HTTPS" ]]'
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
