# `oauth_Identity` saved for backward compatibility, please use `oauth_Identities` instead
default['cookbook-openshift3']['oauth_Identity'] = 'HTPasswdPasswordIdentityProvider'
default['cookbook-openshift3']['oauth_Identities'] = [node['cookbook-openshift3']['oauth_Identity']]

default['cookbook-openshift3']['openshift_master_identity_provider']['BasicAuthPasswordIdentityProvider'] = { 'name' => 'basic_auth', 'login' => true, 'challenge' => true, 'kind' => 'BasicAuthPasswordIdentityProvider', 'url' => 'https://www.example.com/remote-idp', 'ca' => '/path/to/ca.file', 'certFile' => '/path/to/client.crt', 'keyFile' => '/path/to/client.key' }

default['cookbook-openshift3']['openshift_master_identity_provider']['GitHubIdentityProvider'] = { 'name' => 'github_auth', 'login' => true, 'challenge' => false, 'kind' => 'GitHubIdentityProvider', 'clientID' => 'github_client_id', 'clientSecret' => 'github_client_secret', 'organizations' => ['myorganization1', 'myorganization2'] }

default['cookbook-openshift3']['openshift_master_identity_provider']['GoogleIdentityProvider'] = { 'name' => 'google_auth', 'login' => true, 'challenge' => false, 'kind' => 'GoogleIdentityProvider', 'clientID' => 'google_client_id', 'clientSecret' => 'google_client_secret', 'hostedDomain' => 'my.hosted.domain' }

default['cookbook-openshift3']['openshift_master_identity_provider']['HTPasswdPasswordIdentityProvider'] = { 'name' => 'htpasswd_auth', 'login' => true, 'challenge' => true, 'kind' => 'HTPasswdPasswordIdentityProvider', 'filename' => "#{default['cookbook-openshift3']['openshift_common_master_dir']}/openshift-passwd" }

default['cookbook-openshift3']['openshift_master_identity_provider']['LDAPPasswordIdentityProvider'] = { 'name' => 'ldap_identity1', 'login' => true, 'challenge' => true, 'kind' => 'LDAPPasswordIdentityProvider', 'ldap_server' => 'ldap1.domain.local', 'ldap_bind_dn' => '', 'ldap_bind_password' => '', 'ldap_insecure' => true, 'ldap_base_ou' => 'OU=people,DC=domain,DC=local', 'ldap_preferred_username' => 'uid' }

default['cookbook-openshift3']['openshift_master_identity_provider']['OpenIDIdentityProvider'] = { 'name' => 'openid_auth', 'login' => true, 'challenge' => true, 'kind' => 'OpenIDIdentityProvider', 'clientID' => 'openid_client_id', 'clientSecret' => 'openid_client_secret', 'claims' => { 'id' => 'sub', 'preferredUsername' => 'preferred_username', 'name' => 'name', 'email' => 'email' }, 'urls' => { 'authorize' => 'https://myidp.example.com/oauth2/authorize', 'token' => 'https://myidp.example.com/oauth2/token', 'userInfo' => 'https://myidp.example.com/oauth2/userinfo' }, 'extraScopes' => ['email', 'profile'], 'extraAuthorizeParameters' => { 'include_granted_scopes' => '"true"' } }

default['cookbook-openshift3']['openshift_master_identity_provider']['RequestHeaderIdentityProvider'] = { 'name' => 'header_provider_identify', 'login' => false, 'challenge' => false, 'kind' => 'RequestHeaderIdentityProvider', 'headers' => %w(X-Remote-User SSO-User), 'clientCA' => "#{default['cookbook-openshift3']['openshift_common_master_dir']}/master/ca.crt" }

default['cookbook-openshift3']['openshift_master_htpasswd'] = "#{node['cookbook-openshift3']['openshift_common_master_dir']}/openshift-passwd"

default['cookbook-openshift3']['openshift_master_htpasswd_users'] = []
