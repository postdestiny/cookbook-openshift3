Description
===========

* Installs OSEv3 and related packages.

Requirements
============

## Platform ##

* Tested on Red Hat RHEL 7.2
* Tested on Centos 7.2

## Openshift Version ##

* Support OSE version from 3.1.0.4+
* Support Origin version from 1.1.1+

Override Attributes
===================

### Common setting ###

* `node['cookbook-openshift3']['openshift_deployment_type']` = Set the deployment type for OSE ('origin' or 'enterprise'). Default to 'enterprise'
* `node['cookbook-openshift3']['openshift_common_public_hostname']` = Set the master public hostname. Default to 'ohai fqdn'
* `node['cookbook-openshift3']['openshift_HA']` - Set whether or not to deploy a highly-available services for OSE. Default to 'false'
* `node['cookbook-openshift3']['install_method']` - Set the installing method for packing. Default to 'yum'
* `node['cookbook-openshift3']['yum_repositories']` = Set the yum repositories. [*yum_repos*](https://github.com/chef-cookbooks/yum/blob/master/README.md#parameters)
* `node['cookbook-openshift3']['httpd_xfer_port']` = Set the port used for retrieving certificates. Default to '9999'
* `node['cookbook-openshift3']['set_nameserver']` = Set the nameserver(s) for the host. Default to 'false'
* `node['cookbook-openshift3']['register_dns']` = Set the registration of the host against the SOA nameserver. Default to 'false'
* `node['cookbook-openshift3']['core_packages']` = Set the list of the pre-requisite packages. Default to ['libselinux-python', 'wget', 'vim-enhanced', 'net-tools', 'bind-utils', 'git', 'bash-completion docker', 'bash-completion']
* `node['cookbook-openshift3']['osn_cluster_dns_domain']` = Set the SkyDNS domain name. Default to 'cluster.local'
* `node['cookbook-openshift3']['enabled_firewall_additional_rules_node']` = Set the list of additional FW rules to set for a node. Default to  '[]'
* `node['cookbook-openshift3']['openshift_data_dir']` = Set the default directory for OSE data. Default to '/var/lib/origin'
* `node['cookbook-openshift3']['openshift_master_cluster_password']` = Set the default password for the pcs administration account. Default 'openshift_cluster'
* `node['cookbook-openshift3']['openshift_common_master_dir']` = Set the default root directory for master. Default '/etc/origin'
* `node['cookbook-openshift3']['openshift_common_node_dir']` = Set the default root directory for node. Default '/etc/origin'
* `node['cookbook-openshift3']['openshift_common_portal_net']` = Set the default user-defined networks for Kubernetes. Default to '172.17.0.0/16'
* `node['cookbook-openshift3']['openshift_docker_insecure_registry_arg']` = Set the list of insecure registries for Docker. Default to 'nil'
* `node['cookbook-openshift3']['openshift_docker_add_registry_arg']` = Set the list of registries to add to Docker. Default to 'nil'
* `node['cookbook-openshift3']['openshift_docker_block_registry_arg']` = Set the list of registries to block in Docker. Default to 'nil'
* `node['cookbook-openshift3']['openshift_common_default_nodeSelector']` = Set the default label for node selector. Default to 'region=user'
* `node['cookbook-openshift3']['openshift_common_infra_label']` = Set the default label for Infra project (default, openshift-infra). Default to 'region=infra'
* `node['cookbook-openshift3']['openshift_common_examples_base']` = '/usr/share/openshift/examples'
* `node['cookbook-openshift3']['openshift_common_hostname']` = Set the master common name. Default to 'ohai fqdn'
* `node['cookbook-openshift3']['openshift_common_ip']` = Set the default IP for the node. Default to 'ohai ipaddress'
* `node['cookbook-openshift3']['openshift_common_infra_project']` = Set the list of default Infra project. Default to ['default', 'openshift-infra']
* `node['cookbook-openshift3']['openshift_common_service_accounts_additional']` = Set the list of additional service accounts to create. Default to '[]'
* `node['cookbook-openshift3']['openshift_common_use_openshift_sdn']` = Set whether or not to use SDN network. Default to 'true'
* `node['cookbook-openshift3']['openshift_common_sdn_network_plugin_name']` = Set the default SDN plugin name. Default to 'redhat/openshift-ovs-subnet'
* `node['cookbook-openshift3']['openshift_common_registry_url']` = Set the default registry URL. Default to 'openshift3/ose-${component}:${version}'
* `node['cookbook-openshift3']['openshift_master_bind_addr']` = Set default bind address. Default to '0.0.0.0'
* `node['cookbook-openshift3']['openshift_master_api_port']` = Set default listening port for Master API. Default to '8443'
* `node['cookbook-openshift3']['openshift_master_console_port']` = Set the default listening port for console. Default to '8443'
* `node['cookbook-openshift3']['openshift_master_controllers_port']` = Set the default listening port for controllers. Default '8444'
* `node['cookbook-openshift3']['openshift_master_controller_lease_ttl']` = Set the default lease TTL for controllers. Default '30'
* `node['cookbook-openshift3']['openshift_master_embedded_dns']` = Set whether or not to use the embedded DNS. Default to 'true'
* `node['cookbook-openshift3']['openshift_master_embedded_kube']` = Set whether ot not the use the embedded kubernete server. Default to 'true'
* `node['cookbook-openshift3']['openshift_master_debug_level']` = Set the default level for master logging. Default to '2'
* `node['cookbook-openshift3']['openshift_master_dns_port']` = Set the default port for SkyDNS. Default to '53'
* `node['cookbook-openshift3']['openshift_master_label']` = Set the default label for master selector. Default to 'region=infra'
* `node['cookbook-openshift3']['openshift_master_generated_configs_dir']` = Set the default directory for generating the node certificates. Default to '/var/www/html/generated-configs'
* `node['cookbook-openshift3']['openshift_master_router_subdomain']` = Set the default domain for the HaProxy routeaProxy. Default to 'cloudapps.domain.local'
* `node['cookbook-openshift3']['openshift_master_sdn_cluster_network_cidr']` = Set the default SDN Network address. Default to '10.1.0.0/16'
* `node['cookbook-openshift3']['openshift_master_sdn_host_subnet_length']` = Set the default number of allocated bit for hosts. Default to '8'
* `node['cookbook-openshift3']['openshift_master_session_max_seconds']` = Set maximum session time in second. Default to '3600'
* `node['cookbook-openshift3']['openshift_master_access_token_max_seconds']` = Set maximum access token lifetime in second. Default to '86400'
* `node['cookbook-openshift3']['openshift_master_auth_token_max_seconds']` = Set maximum Oauth token lifetime in second. Default to '500'
* `node['cookbook-openshift3']['openshift_node_debug_level']` = Set the default level for node logging. Default to '2'
* `node['cookbook-openshift3']['openshift_node_iptables_sync_period']` = Set the default kube-proxy iptables sync period. Default to '5s'
* `node['cookbook-openshift3']['openshift_node_max_pod']` = Set the maximum number of running PODs on a node. Default to '40'
* `node['cookbook-openshift3']['openshift_node_sdn_mtu_sdn']` = Set the default MTU size for SDN. Default '1450'
* `node['cookbook-openshift3']['master_generated_certs_dir']` = Set the default directory for generating the master certificates. Default to '/var/www/html/master/generated_certs'
* `node['cookbook-openshift3']['etcd_generated_certs_dir']` = Set the default directory for generating the etcd certificates. Default to '/var/www/html/etcd/generated_certs'
* `node['cookbook-openshift3']['etcd_conf_dir']` = Set the default root directory for etcd configs. Default to '/etc/etcd'
* `node['cookbook-openshift3']['etcd_initial_cluster_token']` = 'etcd-cluster-1'
* `node['cookbook-openshift3']['etcd_data_dir']` = Set the default root directory for etcd data. Default to '/var/lib/etcd/'
* `node['cookbook-openshift3']['etcd_client_port']` = Set default listening port for ETCD Client. Default to '2379'
* `node['cookbook-openshift3']['etcd_peer_port']` = Set default listening port for ETCD Peer. Default to '2380'

### Highly-available setting ###

* `node['cookbook-openshift3']['openshift_cluster_name']` = Set the cluster public hostname. Default to 'nil'
* `node['cookbook-openshift3']['openshift_master_cluster_vip']` = Set the cluster public IP address (Mandatory when using Pacemaker deployment). Default to 'nil'
* `node['cookbook-openshift3']['openshift_HA_method']` = Set the HA Master method ('native' or 'pacemaker'). Default to 'native'

### Identity Provider setting ###

* `node['cookbook-openshift3']['oauth_Identity']` = Set the default identity provider ('HTPasswdPasswordIdentityProvider', 'LDAPPasswordIdentityProvider', 'RequestHeaderIdentityProvider'). Default to 'HTPasswdPasswordIdentityProvider'

#### Structure ####
-------------------

* `node['cookbook-openshift3']['openshift_master_identity_provider']['HTPasswdPasswordIdentityProvider']`

```json
{
 "name" : "htpasswd_auth", 
 "login" : true, 
 "challenge" : true, 
 "kind" : "HTPasswdPasswordIdentityProvider", 
 "filename" : "/etc/openshift/openshift-passwd"
}
```

* `node['cookbook-openshift3']['openshift_master_identity_provider']['LDAPPasswordIdentityProvider']`

```json
{
 "name" : "ldap_identity", 
 "login" : true, 
 "challenge" : true, 
 "kind" : "LDAPPasswordIdentityProvider", 
 "ldap_server" : "ldap.domain.local",
 "ldap_bind_dn" : "", 
 "ldap_bind_password" : "",
 "ldap_insecure" : true, 
 "ldap_base_ou" : "OU=people,DC=domain,DC=local", 
 "ldap_preferred_username" : "uid"
}
```

* `node['cookbook-openshift3']['openshift_master_asset_config']`

```json
{
 "extensionStylesheets":["/path/to/css"],
 "extensionScripts":["/path/to/script"],
 "extensions":"/path/to/my_images",
 "templates":"/path/to/template"
}
```

* `node['cookbook-openshift3']['nameserver']` 

```json
{
 "search": "domain.local",
 "domain": "domain.local",
 "nameservers": ["8.8.8.8","8.8.4.4"],
 "key_algorithm": "hmac-md5",
 "key_name": "domain.local.key",
 "key_secret": "DTngw5O8I5Axx631GjQ9pA=="
}
```

Usage
=====

Include the recipes in roles so as to ease the deployment. 

## Roles (Examples) 

* BASE

```json
{
  "name": "base",
  "description": "Common Base Role",
  "json_class": "Chef::Role",
  "default_attributes": {

  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[cookbook-openshift3]",
    "recipe[cookbook-openshift3::common]"
  ],
  "env_run_lists": {

  }
}
```

* COMMON-MASTER

```json
{
  "name": "common-master",
  "description": "Common Master Role",
  "json_class": "Chef::Role",
  "default_attributes": {

  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[base]",
    "recipe[cookbook-openshift3::master]"
  ],
  "env_run_lists": {

  }
}
```

* COMMON-NODE

```json
{
  "name": "common-node",
  "description": "Common Node Role",
  "json_class": "Chef::Role",
  "default_attributes": {

  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[base]",
    "recipe[cookbook-openshift3::node]"
  ],
  "env_run_lists": {

  }
}
```

ENVIRONMENT
===========

Create at least 3 environments which would be assigned to nodes based on their profiles (single, cluster-native, cluster-pcs).
Modify the attributes as required in your environments to change how various configurations are applied per the attributes section above. 
In general, override attributes in the environment should be used when changing attributes.

### Minimal example ###

* CLUSTER-NATIVE

```json
{
  "name": "cluster_native",
  "description": "",
  "cookbook_versions": {

  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {

  },
  "override_attributes": {
    "cookbook-openshift3": {
      "openshift_HA": true,
      "openshift_cluster_name": "ose-cluster.domain.local",
      "openshiftv3-master_label": "common-master",
      "openshiftv3-master_cluster_label": "common-master",
      "openshiftv3-etcd_cluster_label": "common-master",
      "openshiftv3-node_label": "common-node"
    }
  }
}
```

* CLUSTER-PCS

```json
{
  "name": "cluster_pcs",
  "description": "",
  "cookbook_versions": {

  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {

  },
  "override_attributes": {
    "cookbook-openshift3": {
      "openshift_HA": true,
      "openshift_HA_method": "pcs",
      "openshift_master_cluster_vip": "192.168.124.99",
      "openshift_cluster_name": "ose-cluster.domain.local",
      "openshiftv3-master_label": "common-master",
      "openshiftv3-master_cluster_label": "common-master",
      "openshiftv3-etcd_cluster_label": "common-master",
      "openshiftv3-node_label": "common-node"
    }
  }
}
```

* SINGLE

```json
{
  "name": "single",
  "description": "",
  "cookbook_versions": {

  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {

  },
  "override_attributes": {
    "cookbook-openshift3": {
      "openshiftv3-master_label": "common-master",
      "openshiftv3-node_label": "common-node"
    }
  }
}
```

###Once it is done you should assign the node to the relevant environment.###
```
knife node environment set NODE_NAME ENVIRONMENT_NAME
```

LWRP
==================

*Create a DNS record using LWRP - ose_reghost*

```ruby
ose_reghost node["fqdn"] do
  type :a
  keyalgo "HMAC-MD5"
  keyname "example.com"
  keysecret "ddwDEdeedEEEdddd=ee=de=="
  action :create
end
```

*Delete a DNS record using LWRP - ose_reghost*

```ruby
ose_reghost node["fqdn"] do
  type :a
  keyalgo "HMAC-MD5"
  keyname "example.com"
  keysecret "ddwDEdeedEEEdddd=ee=de=="
  action :delete
end
```

```ruby
ose_setup_cluster 'Setup Pacemaker' do
  master_hosts ['1.1.1.1', '2.2.2.2', '3.3.3.3'] 
  cluster_password 'password_for_pacemaker'
  action :setup
end
```

```ruby
ose_setup_cluster 'Wait until the VIP is up and running on the master server' do 
  action :init
end
```

Run list
==================

* MASTER ONLY
```
knife node run_list add NODE_NAME 'role[common-master], recipe[cookbook-openshift3::node_config_post]'
```
* NODE ONLY
```
knife node run_list add NODE_NAME 'role[common-node]'
```
* ALL IN THE BOX (MASTER + NODE)
```
knife node run_list add NODE_NAME 'role[common-master], role[common-node], recipe[cookbook-openshift3::node_config_post]'
```

Development
==================


License and Author
==================

- Author: William Burton (<wburton@redhat.com>)
