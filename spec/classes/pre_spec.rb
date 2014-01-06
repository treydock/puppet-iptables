require 'spec_helper'


describe 'iptables::pre' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'iptables': }" }

  it do
    should contain_firewall('000 accept all icmp').with({
      'proto'   => 'icmp',
      'action'  => 'accept',
      'before'  => 'Firewall[001 accept all to lo interface]',
      'require' => nil,
    })
  end
  
  it do
    should contain_firewall('001 accept all to lo interface').with({
      'proto'   => 'all',
      'iniface' => 'lo',
      'action'  => 'accept',
      'before'  => 'Firewall[002 accept related established rules]',
      'require' => nil,
    })
  end
  
  it do
    should contain_firewall('002 accept related established rules').with({
      'proto'   => 'all',
      'state'   => ['RELATED', 'ESTABLISHED'],
      'action'  => 'accept',
      'before'  => 'Firewall[003 accept new ssh]',
      'require' => nil,
    })
  end
  
  it do
    should contain_firewall('003 accept new ssh').with({
      'proto'   => 'tcp',
      'state'   => ['NEW'],
      'action'  => 'accept',
      'dport'   => '22',
      'before'  => 'Class[Iptables::Post]',
      'require' => nil,
    })
  end

  context "when firewall::ensure => stopped" do
    let(:pre_condition) {["class { 'firewall': ensure => stopped }", "class { 'iptables': }" ]}

    it { should_not contain_firewall('000 accept all icmp') }
    it { should_not contain_firewall('001 accept all to lo interface') }
    it { should_not contain_firewall('002 accept related established rules') }
    it { should_not contain_firewall('003 accept new ssh') }
  end
end
