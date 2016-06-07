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

<table>
<thead><tr><td><b>cookbook-openshift3 config item</b></td><td><b>Description</b></td><td><b>Default</b></td></tr></thead>
<tbody>
<tr><td>
openshift\_deployment\_type</td><td>Set the deployment type for OSE ('origin' or 'enterprise'). Default to 'enterprise'
</td></tr>
<tr><td>
openshift\_common\_public\_hostname</td><td>Set the master public hostname. Default to 'ohai fqdn'
</td></tr>
<tr><td>
openshift\_HA</td><td>Set whether or not to deploy a highly-available services for OSE. Default to 'false'
</td></tr>
<tr><td>
docker\_version</td><td>Set the version of Docker to be installed. Default to 'nil'
</td></tr>
<tr><td>
deploy\_containerized</td><td>Set whether or not to deploy a containerized version of Openshift. Default to 'false'
</td></tr>
<tr><td>
deploy\_example</td><td>Set whether or not to deploy the openshift example templates files. Default to 'true'
</td></tr>
<tr><td>
install\_method</td><td>Set the installing method for packing. Default to 'yum'
</td></tr>
<tr><td>
yum\_repositories</td><td>Set the yum repositories. [*yum_repos*](https://github.com/chef-cookbooks/yum/blob/master/README.md#parameters)
</td></tr>
<tr><td>
httpd\_xfer\_port</td><td>Set the port used for retrieving certificates. Default to '9999'
</td></tr>
<tr><td>
set\_nameserver</td><td>Set the nameserver(s) for the host. Default to 'false'
</td></tr>
<tr><td>
register\_dns</td><td>Set the registration of the host against the SOA nameserver. Default to 'false'
</td></tr>
<tr><td>
core\_packages</td><td>Set the list of the pre-requisite packages. Default to ['libselinux-python', 'wget', 'vim-enhanced', 'net-tools', 'bind-utils', 'git', 'bash-completion docker', 'bash-completion']
</td></tr>
<tr><td>
osn\_cluster\_dns\_domain</td><td>Set the SkyDNS domain name. Default to 'cluster.local'
</td></tr>
<tr><td>
enabled\_firewall\_additional\_rules\_node</td><td>Set the list of additional FW rules to set for a node. Default to  '[]'
</td></tr>
<tr><td>
openshift\_data\_dir</td><td>Set the default directory for OSE data. Default to '/var/lib/origin'
</td></tr>
<tr><td>
openshift\_master\_cluster\_password</td><td>Set the default password for the pcs administration account. Default 'openshift\_cluster'
</td></tr>
<tr><td>
openshift\_common\_master\_dir</td><td>Set the default root directory for master. Default '/etc/origin'
</td></tr>
<tr><td>
openshift\_common\_node\_dir</td><td>Set the default root directory for node. Default '/etc/origin'
</td></tr>
<tr><td>
openshift\_common\_portal\_net</td><td>Set the default user-defined networks for Kubernetes. Default to '172.17.0.0/16'
</td></tr>
<tr><td>
openshift\_docker\_insecure\_registry\_arg</td><td>Set the list of insecure registries for Docker. Default to 'nil'
</td></tr>
<tr><td>
openshift\_docker\_add\_registry\_arg</td><td>Set the list of registries to add to Docker. Default to 'nil'
</td></tr>
<tr><td>
openshift\_docker\_block\_registry\_arg</td><td>Set the list of registries to block in Docker. Default to 'nil'
</td></tr>
<tr><td>
openshift\_common\_default\_nodeSelector</td><td>Set the default label for node selector. Default to 'region=user'
</td></tr>
<tr><td>
openshift\_common\_infra\_label</td><td>Set the default label for Infra project (default, openshift-infra). Default to 'region=infra'
</td></tr>
<tr><td>
openshift\_common\_examples\_base</td><td>'/usr/share/openshift/examples'
</td></tr>
<tr><td>
openshift\_common\_hostname</td><td>Set the master common name. Default to 'ohai fqdn'
</td></tr>
<tr><td>
openshift\_common\_ip</td><td>Set the default IP for the node. Default to 'ohai ipaddress'
</td></tr>
<tr><td>
openshift\_common\_infra\_project</td><td>Set the list of default Infra project. Default to ['default', 'openshift-infra']
</td></tr>
<tr><td>
openshift\_common\_service\_accounts\_additional</td><td>Set the list of additional service accounts to create. Default to '[]'
</td></tr>
<tr><td>
openshift\_common\_use\_openshift\_sdn</td><td>Set whether or not to use SDN network. Default to 'true'
</td></tr>
<tr><td>
openshift\_common\_sdn\_network\_plugin\_name</td><td>Set the default SDN plugin name. Default to 'redhat/openshift-ovs-subnet'
</td></tr>
<tr><td>
openshift\_common\_registry\_url</td><td>Set the default registry URL. Default to 'openshift3/ose-${component}:${version}'
</td></tr>
<tr><td>
openshift\_master\_bind\_addr</td><td>Set default bind address. Default to '0.0.0.0'
</td></tr>
<tr><td>
openshift\_master\_api\_port</td><td>Set default listening port for Master API. Default to '8443'
</td></tr>
<tr><td>
openshift\_master\_console\_port</td><td>Set the default listening port for console. Default to '8443'
</td></tr>
<tr><td>
openshift\_master\_controllers\_port</td><td>Set the default listening port for controllers. Default '8444'
</td></tr>
<tr><td>
openshift\_master\_controller\_lease\_ttl</td><td>Set the default lease TTL for controllers. Default '30'
</td></tr>
<tr><td>
openshift\_master\_embedded\_dns</td><td>Set whether or not to use the embedded DNS. Default to 'true'
</td></tr>
<tr><td>
openshift\_master\_embedded\_kube</td><td>Set whether ot not the use the embedded kubernete server. Default to 'true'
</td></tr>
<tr><td>
openshift\_master\_debug\_level</td><td>Set the default level for master logging. Default to '2'
</td></tr>
<tr><td>
openshift\_master\_dns\_port</td><td>Set the default port for SkyDNS. Default to '53'
</td></tr>
<tr><td>
openshift\_master\_label</td><td>Set the default label for master selector. Default to 'region=infra'
</td></tr>
<tr><td>
openshift\_master\_generated\_configs\_dir</td><td>Set the default directory for generating the node certificates. Default to '/var/www/html/generated-configs'
</td></tr>
<tr><td>
openshift\_master\_router\_subdomain</td><td>Set the default domain for the HaProxy routeaProxy. Default to 'cloudapps.domain.local'
</td></tr>
<tr><td>
openshift\_master\_sdn\_cluster\_network\_cidr</td><td>Set the default SDN Network address. Default to '10.1.0.0/16'
</td></tr>
<tr><td>
openshift\_master\_sdn\_host\_subnet\_length</td><td>Set the default number of allocated bit for hosts. Default to '8'
</td></tr>
<tr><td>
openshift\_master\_session\_max\_seconds</td><td>Set maximum session time in second. Default to '3600'
</td></tr>
<tr><td>
openshift\_master\_access\_token\_max\_seconds</td><td>Set maximum access token lifetime in second. Default to '86400'
</td></tr>
<tr><td>
openshift\_master\_auth\_token\_max\_seconds</td><td>Set maximum Oauth token lifetime in second. Default to '500'
</td></tr>
<tr><td>
openshift\_node\_debug\_level</td><td>Set the default level for node logging. Default to '2'
</td></tr>
<tr><td>
openshift\_node\_iptables\_sync\_period</td><td>Set the default kube-proxy iptables sync period. Default to '5s'
</td></tr>
<tr><td>
openshift\_node\_max\_pod</td><td>Set the maximum number of running PODs on a node. Default to '40'
</td></tr>
<tr><td>
openshift\_node\_sdn\_mtu\_sdn</td><td>Set the default MTU size for SDN. Default '1450'
</td></tr>
<tr><td>
openshift\_node\_sdn\_mtu\_sdn</td><td>Set the default MTU size for SDN. Default '1450'
</td></tr>
<tr><td>
openshift\_node\_minimum\_container\_ttl\_duration']</td><td>The minimum age that a container is eligible for garbage collection. Default '10s'    
</td></tr>
<tr><td>
openshift\_node\_maximum\_dead\_containers\_per\_container']</td><td>The number of instances to retain per pod container. Default '2'
</td></tr>
<tr><td>
openshift\_node\_maximum\_dead\_containers']</td><td>The maximum number of total dead containers in the node. Default '100'
</td></tr>
<tr><td>
openshift\_node\_image\_gc\_high\_threshold']</td><td>The percent of disk usage which triggers image garbage collection. Default '90'
</td></tr>
<tr><td>
openshift\_node\_image\_gc\_low\_threshold']</td><td>The percent of disk usage to which image garbage collection attempts to free. Default '80'
</td></tr>
<tr><td>
master\_generated\_certs\_dir</td><td>Set the default directory for generating the master certificates. Default to '/var/www/html/master/generated\_certs'
</td></tr>
<tr><td>
etcd\_generated\_certs\_dir</td><td>Set the default directory for generating the etcd certificates. Default to '/var/www/html/etcd/generated\_certs'
</td></tr>
<tr><td>
etcd\_conf\_dir</td><td>Set the default root directory for etcd configs. Default to '/etc/etcd'
</td></tr>
<tr><td>
etcd\_initial\_cluster\_token</td><td>'etcd-cluster-1'
</td></tr>
<tr><td>
etcd\_data\_dir</td><td>Set the default root directory for etcd data. Default to '/var/lib/etcd/'
</td></tr>
<tr><td>
etcd\_client\_port</td><td>Set default listening port for ETCD Client. Default to '2379'
</td></tr>
<tr><td>
etcd\_peer\_port</td><td>Set default listening port for ETCD Peer. Default to '2380'
</td></tr>
</tbody>
</table>

### Highly-available settings ###

<table>
<thead><tr><td><b>cookbook-openshift3 config item</b></td><td><b>Description</b></td><td><b>Default</b></td></tr></thead>
<tr><td>
openshift\_cluster\_name</td><td>Set the cluster public hostname. Default to 'nil'
</td></tr>
<tr><td>
openshift\_master\_cluster\_vip</td><td>Set the cluster public IP address (Mandatory when using Pacemaker deployment). Default to 'nil'
</td></tr>
<tr><td>
openshift\_HA\_method</td><td>Set the HA Master method ('native' or 'pacemaker'). Default to 'native'
</td></tr>
</table>

### Identity Provider settings ###

<table>
<thead><tr><td><b>cookbook-openshift3 config item</b></td><td><b>Description</b></td><td><b>Default</b></td></tr></thead>
<tr><td>
oauth\_Identity</td><td>Set the default identity provider ('HTPasswdPasswordIdentityProvider', 'LDAPPasswordIdentityProvider', 'RequestHeaderIdentityProvider'). Default to 'HTPasswdPasswordIdentityProvider'
</td></tr>
</table>

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

* `node['cookbook-openshift3']['openshift_node_docker-storage']`

```json
{
 "DEVS": ["/dev/sdb","/dev/sdc"],
 "VG": "docker-vg",
 "DATA_SIZE": "80%FREE"
}
```

* `node['cookbook-openshift3']['openshift_master_named_certificates']`

* CN or SAN names are automatically detected from the certificate file.

```json
[
  {
   "certfile": "/etc/where_is/my_certfile",
   "keyfile": "/etc/where_is/my_keyfile"
  }
]
```
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

Test (ORIGIN)
==================

There is a way to quickly test this cookbook. 
You will need a CentOS 7.1+  with "Minimal" installation option and at least 10GB left on the Volume group. (Later used by Docker)

* Deploy ORIGIN ALL IN THE BOX Flavour (MASTER + NODE)
```
bash <(curl -s https://raw.githubusercontent.com/IshentRas/cookbook-openshift3/master/origin_deploy.sh)
```

Development
==================

License and Author
==================

Author: William Burton (<wburton@redhat.com>)

The MIT License (MIT)

Copyright (C) 2014 OpenBet Limited

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
