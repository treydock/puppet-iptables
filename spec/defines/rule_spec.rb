require 'spec_helper'


describe 'iptables::rule' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { '8080' }

  it { should create_iptables__rule('8080') }

  it do
    should contain_firewall("100 open port 8080").with({
      :ensure  => 'present',
      :action  => 'accept',
      :port    => '8080',
      :chain   => 'INPUT',
      :proto   => 'tcp',
      :before  => 'Class[Iptables::Post]',
      :require => 'Class[Iptables::Pre]',
    })
  end

  context 'with port => 8080' do
    let(:params) {{ :port => '8080' }}

    let(:title) { 'http alternate' }

    it { should create_iptables__rule('http alternate') }

    it do
      should contain_firewall("100 open port 8080 for http alternate").with({
        :ensure  => 'present',
        :action  => 'accept',
        :port    => '8080',
        :chain   => 'INPUT',
        :proto   => 'tcp',
        :before  => 'Class[Iptables::Post]',
        :require => 'Class[Iptables::Pre]',
      })
    end
  end

  context 'with port => 50000-51000' do
    let(:params) {{ :port => '50000-51000' }}

    let(:title) { 'GridFTP' }

    it { should create_iptables__rule('GridFTP') }

    it do
      should contain_firewall("100 open port 50000-51000 for GridFTP").with({
        :ensure  => 'present',
        :action  => 'accept',
        :port    => '50000-51000',
        :chain   => 'INPUT',
        :proto   => 'tcp',
        :before  => 'Class[Iptables::Post]',
        :require => 'Class[Iptables::Pre]',
      })
    end
  end
end
