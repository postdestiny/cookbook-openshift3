# should create service-account for metrics-deployer
describe command("oc get sa/metrics-deployer -n openshift-infra --template '{{.metadata.name}}'") do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/metrics-deployer/) }
end

# should create secret for metrics-deployer
describe command("oc get secret/metrics-deployer -n openshift-infra --template '{{.metadata.name}}'") do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/metrics-deployer/) }
end

# should create some 'metrics-*' pods (which probably won't have time to complete)
# at start the pod is metrics-deployer-ID then should be metrics-hawkular etc.
describe command("oc get pods -n openshift-infra --no-headers | egrep -q '^(metrics|heapster|hawkular)'") do
  its('exit_status') { should eq 0 }
end
