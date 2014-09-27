require 'spec_helper'

describe 'iptables::post' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'iptables': }" }

  it do
    should contain_firewall('999 deny all').with({
      :proto   => 'all',
      :action  => 'drop',
      :reject  => nil,
      :before  => nil,
      :require => 'Class[Iptables::Pre]',
    })
  end

  it do
    should contain_firewall('999 deny all FORWARD').with({
      :proto   => 'all',
      :action  => 'drop',
      :reject  => nil,
      :chain   => 'FORWARD',
      :before  => nil,
      :require => 'Class[Iptables::Pre]',
    })
  end

  context "when firewall::ensure => stopped" do
    let(:pre_condition) {["class { 'firewall': ensure => stopped }", "class { 'iptables': }" ]}

    it { should_not contain_firewall('999 drop all') }
  end

  context 'when iptables::deny_action => "reject"' do
    let(:pre_condition) { "class { 'iptables': deny_action => 'reject' }" }

    it do
      should contain_firewall('999 deny all').with({
        :proto   => 'all',
        :action  => 'reject',
        :reject  => 'icmp-host-prohibited',
        :before  => nil,
        :require => 'Class[Iptables::Pre]',
      })
    end

    it do
      should contain_firewall('999 deny all FORWARD').with({
        :proto   => 'all',
        :action  => 'reject',
        :reject  => 'icmp-host-prohibited',
        :chain   => 'FORWARD',
        :before  => nil,
        :require => 'Class[Iptables::Pre]',
      })
    end
  end
end
