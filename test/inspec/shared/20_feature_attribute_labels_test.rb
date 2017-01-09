# node should have all labels configured in attributes
describe command('oc get node/$HOSTNAME --template="{{.metadata.labels}}"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/region:infra/) }
  its('stdout') { should match(/custom:label/) }
end
