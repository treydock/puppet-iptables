require 'spec_helper_acceptance'

describe 'iptables::rule define:' do
  context 'open port 80' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': rules => {'8080' => {}} }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/sysconfig/iptables') do
      its(:content) { should match /^-A INPUT -p tcp -m multiport --ports 8080 -m comment --comment "100 open port 8080" -j ACCEPT $/ }
    end

    describe iptables do
      it { should have_rule('-A INPUT -p tcp -m multiport --ports 8080 -m comment --comment "100 open port 8080" -j ACCEPT') }
    end
  end
end
