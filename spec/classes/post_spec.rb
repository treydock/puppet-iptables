require 'spec_helper'


describe 'iptables::post' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'iptables': }" }

  it do
    should contain_firewall('999 drop all').with({
      'proto'   => 'all',
      'action'  => 'drop',
      'before'  => nil,
      'require' => 'Class[Iptables::Pre]',
    })
  end

  context "when firewall::ensure => stopped" do
    let(:pre_condition) {["class { 'firewall': ensure => stopped }", "class { 'iptables': }" ]}

    it { should_not contain_firewall('999 drop all') }
  end
end
