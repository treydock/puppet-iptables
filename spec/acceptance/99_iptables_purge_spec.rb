require 'spec_helper_acceptance'

describe 'iptables:' do
  context 'purge unmanaged rules' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/sysconfig/iptables') do
      its(:content) { should_not match /^-A INPUT -p tcp -m multiport --ports 8080 -m comment --comment "100 open port 8080" -j ACCEPT $/ }
      its(:content) { should_not match /^-A INPUT -p tcp -m multiport --ports 80 -m comment --comment "100 open port 80" -j ACCEPT $/ }
      its(:content) { should_not match /^-A INPUT -p tcp -m multiport --ports 443 -m comment --comment "100 open port 443 for https" -j ACCEPT $/ }
    end

    describe iptables do
      it { should_not have_rule('-A INPUT -p tcp -m multiport --ports 8080 -m comment --comment "100 open port 8080" -j ACCEPT') }
      it { should_not have_rule('-A INPUT -p tcp -m multiport --ports 80 -m comment --comment "100 open port 80" -j ACCEPT') }
      it { should_not have_rule('-A INPUT -p tcp -m multiport --ports 443 -m comment --comment "100 open port 443 for https" -j ACCEPT') }
    end
  end
end
