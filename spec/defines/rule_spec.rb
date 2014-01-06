require 'spec_helper'


describe 'iptables::rule' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { '80' }

  let(:pre_condition) { "class { 'iptables': }" }

  it do
    should contain_firewall("100 open port 80").with({
      'ensure'  => 'present',
      'action'  => 'accept',
      'port'    => '80',
      'chain'   => 'INPUT',
      'proto'   => 'tcp',
      'before'  => 'Class[Iptables::Post]',
      'require' => 'Class[Iptables::Pre]',
    })
  end

  context 'with port => 443' do
    let(:params) {{ :port => '443' }}

    let(:title) { 'https' }

    it do
      should contain_firewall("100 open port 443 for https").with({
        'ensure'  => 'present',
        'action'  => 'accept',
        'port'    => '443',
        'chain'   => 'INPUT',
        'proto'   => 'tcp',
        'before'  => 'Class[Iptables::Post]',
        'require' => 'Class[Iptables::Pre]',
      })
    end
  end
end
