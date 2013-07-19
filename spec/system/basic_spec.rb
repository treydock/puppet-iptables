require 'spec_helper_system'

describe 'iptables class:' do
  context puppet_agent do
    its(:stderr) { should be_empty }
    its(:exit_code) { should_not == 1 }
  end

  context 'should run successfully' do
    pp = <<-EOS
      class { 'firewall': }
      class { 'iptables': }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
 
  context 'with param firewall ensure => stopped:' do
    pp = <<-EOS
      class { 'firewall': ensure => 'stopped' }
      class { 'iptables': }
    EOS

    context puppet_apply(pp) do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end
end