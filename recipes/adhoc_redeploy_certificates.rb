#
# Cookbook Name:: cookbook-openshift3
# Recipe:: adhoc_redeploy_certificates
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

openshift_redeploy_certificate node['fqdn']
