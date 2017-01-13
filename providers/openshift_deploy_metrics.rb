#
# Cookbook Name:: cookbook-openshift3
# Resources:: openshift_deploy_metrics
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

use_inline_resources
provides :openshift_deploy_metrics if defined? provides

def whyrun_supported?
  true
end

action :create do
  remote_file "#{Chef::Config[:file_cache_path]}/admin.kubeconfig" do
    source 'file:///etc/origin/master/admin.kubeconfig'
    mode '0644'
  end

  execute 'Deploy metrics-deployer secret' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} secrets new metrics-deployer ${metrics_deployer_secrets} -n openshift-infra --config=admin.kubeconfig"
    environment(
      'metrics_deployer_secrets' => node['cookbook-openshift3']['openshift_hosted_metrics_secrets'].empty? ? '/dev/null' : node['cookbook-openshift3']['openshift_hosted_metrics_secrets'].map { |opt, value| " #{opt}=#{value}" }
    )
    cwd Chef::Config[:file_cache_path]
    only_if '[[ `oc get secrets/metrics-deployer -n openshift-infra --no-headers --config=admin.kubeconfig | wc -l` -eq 0 ]]'
  end

  execute 'Create metrics-deployer Service Account' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} create serviceaccount metrics-deployer -n openshift-infra --config=admin.kubeconfig"
    cwd Chef::Config[:file_cache_path]
    only_if '[[ `oc get sa/metrics-deployer -n openshift-infra --no-headers --config=admin.kubeconfig | wc -l` -eq 0 ]]'
  end

  execute 'Link secret to metrics-deployer Service Account' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} secrets link metrics-deployer metrics-deployer -n openshift-infra --config=admin.kubeconfig"
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get -o template sa/metrics-deployer --template={{.secrets}} -n openshift-infra --config=admin.kubeconfig` =~ \'name:metrics-deployer]\' ]]'
  end

  execute 'Add edit permission to the openshift-infra project to metrics-deployer SA' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} adm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer -n openshift-infra --config=admin.kubeconfig"
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get rolebindings -o jsonpath=\'{.items[?(@.metadata.name == "edit")].userNames}\' -n openshift-infra --config=admin.kubeconfig` =~ "system:serviceaccount:openshift-infra:metrics-deployer" ]]'
  end

  execute 'Add cluster-reader permission to the openshift-infra project to heapster SA' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster"
    cwd Chef::Config[:file_cache_path]
    not_if '[[ `oc get clusterrolebindings -o jsonpath=\'{.items[?(@.metadata.name == "cluster-readers")].userNames}\' -n openshift-infra --config=admin.kubeconfig` =~ "system:serviceaccount:openshift-infra:heapster" ]]'
  end

  execute 'Deploy Cluster Metrics' do
    command "#{node['cookbook-openshift3']['openshift_common_client_binary']} new-app --template=metrics-deployer-template --as=system:serviceaccount:openshift-infra:metrics-deployer #{new_resource.metrics_params.map { |opt, value| " -p #{opt}=#{value}" }.join(' ')} -n openshift-infra --config=admin.kubeconfig"
    cwd Chef::Config[:file_cache_path]
    not_if '[ `oc get pod -l \'metrics-infra in (hawkular-cassandra,hawkular-metrics,heapster)\' --no-headers -n openshift-infra | grep -cw Running` -ge 3 ]'
    notifies :run, 'execute[Wait for image pull and deployer pod to be completed (300 seconds max)]', :immediately
  end

  execute 'Wait for image pull and deployer pod to be completed (300 seconds max)' do
    cwd Chef::Config[:file_cache_path]
    command '[ `oc get pod --selector=app=metrics-deployer-template --sort-by=\'{.metadata.creationTimestamp}\' | tail -1 | awk \'{print $3}\'` == \'Completed\' ]'
    action :nothing
    retries 30
    retry_delay 10
  end
  new_resource.updated_by_last_action(true)
end
