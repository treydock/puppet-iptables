require 'spec_helper'


describe 'iptables::post' do
  include_context :defaults

  let(:facts) { default_facts }

  it do
    should contain_firewall('999 drop all').with({
      'proto'   => 'all',
      'action'  => 'drop',
      'before'  => nil,
      'require' => 'Class[Iptables::Pre]',
    })
  end
end
