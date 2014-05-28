require 'spec_helper'


describe 'iptables::nat' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:params) {{  }}

  it { should create_class('iptables::nat') }

  it do
    should contain_sysctl('net.ipv4.ip_forward').with({
      :value  => '1',
    })
  end

  it do
    should contain_firewall('100 snat').with({
      :chain    => 'POSTROUTING',
      :jump     => 'MASQUERADE',
      :proto    => 'all',
      :outiface => 'eth0',
      :table    => 'nat',
    })
  end

  context "when outiface => 'eth2'" do
    let(:params) {{ :outiface => 'eth2' }}

    it { should contain_firewall('100 snat').with_outiface('eth2') }
  end
end
