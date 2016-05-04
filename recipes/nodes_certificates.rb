#
# Cookbook Name:: cookbook-openshift3
# Recipe:: nodes_certificates
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node_servers = Chef::Config[:solo] ? node['cookbook-openshift3']['node_servers'] : search(:node, %(role:"#{node['cookbook-openshift3']['openshiftv3-node_label']}")).sort!

directory node['cookbook-openshift3']['openshift_master_generated_configs_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

node_servers.each do |node_server|
  execute "Generate certificate directory for #{node_server['fqdn']}" do
    command "mkdir -p #{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}"
    creates "#{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}.tgz"
  end

  execute "Generate certificate for #{node_server['fqdn']}" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} create-api-client-config \
            --client-dir=#{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']} \
            --certificate-authority=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.crt \
            --signer-cert=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.crt --signer-key=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.key \
            --signer-serial=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.serial.txt --user='system:node:#{node_server['fqdn']}' \
            --groups=system:nodes --master=#{node['cookbook-openshift3']['openshift_master_api_url']}"
    creates "#{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}.tgz"
  end

  execute "Generate the node server certificate for #{node_server['fqdn']}" do
    command "#{node['cookbook-openshift3']['openshift_common_admin_binary']} create-server-cert --cert=server.crt --key=server.key --overwrite=true \
            --hostnames=#{node_server['fqdn'] + "," + node_server['ipaddress']} --signer-cert=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.crt --signer-key=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.key \
            --signer-serial=#{node['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.serial.txt"
    cwd "#{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}"
    creates "#{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}.tgz"
  end

  execute "Generate a tarball for #{node_server['fqdn']}" do
    command "tar czvf #{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}.tgz \
             -C #{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']} . --remove-files && chown apache: #{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}.tgz"
    creates "#{node['cookbook-openshift3']['openshift_master_generated_configs_dir']}/#{node_server['fqdn']}.tgz"
  end
end
