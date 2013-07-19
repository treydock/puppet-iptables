require 'spec_helper'


describe 'iptables::rule' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { '80' }
  
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
    let :params do
      { :port => '443' }
    end

    let :title do
      'https'
    end

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
