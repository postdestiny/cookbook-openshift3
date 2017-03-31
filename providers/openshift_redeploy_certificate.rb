#
# Cookbook Name:: cookbook-openshift3
# Resources:: openshift_redeploy_certificate
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

use_inline_resources
provides :openshift_redeploy_certificate if defined? provides

def whyrun_supported?
  true
end

action :redeploy do
  execute 'Backup etcd stuff' do
    command 'tar czvf etcd-backup-$(date +%s).tar.gz -C /etc/etcd/ca /etc/etcd/ca.crt /var/www/html/etcd --ignore-failed-read --remove-files || true'
    cwd '/etc/etcd'
  end
  %W(peer* server* etcd-#{node['fqdn']}.tgz).each do |certs|
    execute 'Delete Peer/Server certs' do
      command "rm -rf #{certs} || true"
      cwd '/etc/etcd'
    end
  end
  execute 'Backup master stuff' do
    command 'tar czvf master-backup-$(date +%s).tar.gz /etc/origin/master /var/www/html/master --ignore-failed-read && rm -rf /var/www/html/master'
    cwd '/etc/origin'
    only_if '[ -a /etc/origin/master ]'
  end
  execute 'Backup node stuff' do
    command 'tar czvf node-backup-$(date +%s).tar.gz /etc/origin/node /var/www/html/node --ignore-failed-read --remove-files'
    cwd '/etc/origin'
    only_if '[ -a /etc/origin/node ]'
  end
  execute 'Delete old certs' do
    command 'rm -f $(ls -I serviceaccounts\* -I registry\*)'
    cwd '/etc/origin/master'
    only_if '[ -a /etc/origin/master ]'
  end
  execute 'Remove root kubeconfig' do
    command 'rm -f config'
    cwd '/root/.kube'
    only_if '[ -a /root/.kube ]'
  end
  include_recipe 'cookbook-openshift3::default'
  new_resource.updated_by_last_action(true)
end
