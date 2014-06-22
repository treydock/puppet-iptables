require 'spec_helper_acceptance'

describe 'iptables class:' do
  context 'with default parameters' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('iptables') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  context 'with param ensure => stopped:' do
    it "should stop iptables" do
      pp = <<-EOS
        class { 'firewall': ensure => 'stopped' }
        class { 'iptables': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('iptables') do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end
