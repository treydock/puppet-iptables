require 'spec_helper'

describe 'iptables::services::apache' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:params) {{}}

  it { should create_class('iptables::services::apache') }
  it { should contain_class('iptables') }

  it do
    should contain_firewall('100 allow http').only_with({
      :ensure   => 'present',
      :name     => '100 allow http',
      :chain    => 'INPUT',
      :port     => '80',
      :proto    => 'tcp',
      :action   => 'accept',
      :before   => ['Class[Iptables::Post]'],
      :require  => ['Class[Iptables::Pre]'],
    })
  end

  it do
    should contain_firewall('100 allow https').only_with({
      :ensure   => 'present',
      :name     => '100 allow https',
      :chain    => 'INPUT',
      :port     => '443',
      :proto    => 'tcp',
      :action   => 'accept',
      :before   => ['Class[Iptables::Post]'],
      :require  => ['Class[Iptables::Pre]'],
    })
  end
end
