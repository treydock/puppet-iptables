require 'spec_helper_system'

describe 'iptables class:' do
  context 'with default parameters' do
    it "should run successfully" do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': }
      EOS

      puppet_apply(pp) do |r|
       r.exit_code.should_not == 1
       r.refresh
       r.exit_code.should be_zero
      end
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

      puppet_apply(pp) do |r|
       r.exit_code.should_not == 1
       r.refresh
       r.exit_code.should be_zero
      end
    end

    describe service('iptables') do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end
