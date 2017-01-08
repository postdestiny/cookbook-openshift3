describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# It configures docker to use journald logging driver
describe command('ps aux | grep docker | grep -v grep') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/log-driver=journald/) }
end
