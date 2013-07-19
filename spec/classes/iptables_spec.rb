require 'spec_helper'


describe 'iptables' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('iptables') }
  it { should contain_class('iptables::pre') }
  it { should contain_class('iptables::post') }

end
