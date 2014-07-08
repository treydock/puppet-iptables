require 'spec_helper'


describe 'iptables::forward' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { 'eth0' }

  let(:params) {{ :iniface => 'eth2' }}

  it { should create_iptables__forward('eth0') }

  it do
    should contain_firewall("001 FORWARD eth0 to eth2").with({
      :chain     => 'FORWARD',
      :action    => 'accept',
      :proto     => 'all',
      :iniface   => 'eth2',
      :outiface  => 'eth0',
    })
  end
end
