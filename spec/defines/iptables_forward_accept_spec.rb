require 'spec_helper'

describe 'iptables::forward::accept' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { 'rubygems.org' }

  it { should create_iptables__forward__accept('rubygems.org') }

  it do
    should contain_firewall('100 iptables::forward::accept rubygems.org').only_with({
      :name         => '100 iptables::forward::accept rubygems.org',
      :chain        => 'FORWARD',
      :action       => 'accept',
      :proto        => 'tcp',
      :dport        => nil,
      :source       => nil,
      :destination  => 'rubygems.org',
    })
  end
end
