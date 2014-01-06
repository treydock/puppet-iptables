require 'spec_helper_system'

describe 'iptables::rule define:' do
  context 'open port 80' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': rules => {'80' => {}} }
      EOS

      puppet_apply(pp) do |r|
       r.exit_code.should_not == 1
       r.refresh
       r.exit_code.should be_zero
      end
    end

    describe file('/etc/sysconfig/iptables') do
      its(:content) { should match /^-A INPUT -p tcp -m multiport --ports 80 -m comment --comment "100 open port 80" -j ACCEPT $/ }
    end

    describe iptables do
      it { should have_rule('-A INPUT -p tcp -m multiport --ports 80 -m comment --comment "100 open port 80" -j ACCEPT') }
    end
  end

  context 'open port 443' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': rules => {'https' => {'port' => '443'}} }
      EOS

      puppet_apply(pp) do |r|
       r.exit_code.should_not == 1
       r.refresh
       r.exit_code.should be_zero
      end
    end

    describe file('/etc/sysconfig/iptables') do
      its(:content) { should match /^-A INPUT -p tcp -m multiport --ports 443 -m comment --comment "100 open port 443 for https" -j ACCEPT $/ }
    end

    describe iptables do
      it { should have_rule('-A INPUT -p tcp -m multiport --ports 443 -m comment --comment "100 open port 443 for https" -j ACCEPT') }
    end
  end
end
