# encoding: utf-8
# author: Mesaguy

describe file('/opt/prometheus/exporters/keepalived_exporter_gen2brain/active') do
    it { should be_symlink }
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'prometheus' }
end

describe file('/opt/prometheus/exporters/keepalived_exporter_gen2brain/active/keepalived_exporter') do
    it { should be_file }
    it { should be_executable }
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'prometheus' }
end

# Verify the 'keepalived_exporter_gen2brain' service is running
control '01' do
  impact 1.0
  title 'Verify keepalived_exporter_gen2brain service'
  desc 'Ensures keepalived_exporter_gen2brain service is up and running'
  describe service('keepalived_exporter_gen2brain') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end
end

describe processes(Regexp.new("^/opt/prometheus/exporters/keepalived_exporter_gen2brain/([0-9.]+|[0-9.a-z\-]+__go-[0-9.]+)/keepalived_exporter")) do
    it { should exist }
    its('entries.length') { should eq 1 }
    its('users') { should include 'prometheus' }
end

describe port(9650) do
    it { should be_listening }
end

describe http('http://127.0.0.1:9650/metrics') do
    its('status') { should cmp 200 }
    its('body') { should match /^keepalived_up/ }
end
