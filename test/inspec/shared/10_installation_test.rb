# It installs `oc` command
describe command('oc') do
  it { should exist }
end

# It installs `oadm` command
describe command('oadm') do
  it { should exist }
end
