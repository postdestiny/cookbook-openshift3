default['cookbook-openshift3']['openshift_cloud_provider'] = nil
default['cookbook-openshift3']['openshift_cloud_providers']['aws'] = { 'data_bag_name' => 'cloud-provider', 'data_bag_item_name' => 'aws', 'secret_file' => nil }
