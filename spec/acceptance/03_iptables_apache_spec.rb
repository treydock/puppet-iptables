require 'spec_helper_acceptance'

describe 'iptables::services::apache class:' do
  context 'with default parameters' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': }
        class { 'iptables::services::apache': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/sysconfig/iptables') do
      its(:content) { should match /^-A INPUT -p tcp -m multiport --ports 80 -m comment --comment "100 allow http" -j ACCEPT $/ }
      its(:content) { should match /^-A INPUT -p tcp -m multiport --ports 443 -m comment --comment "100 allow https" -j ACCEPT $/ }
    end

    describe iptables do
      it { should have_rule('-A INPUT -p tcp -m multiport --ports 80 -m comment --comment "100 allow http" -j ACCEPT') }
      it { should have_rule('-A INPUT -p tcp -m multiport --ports 443 -m comment --comment "100 allow https" -j ACCEPT') }
    end
  end
end
