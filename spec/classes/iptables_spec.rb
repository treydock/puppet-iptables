require 'spec_helper'


describe 'iptables' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should contain_class('iptables::pre') }
  it { should contain_class('iptables::post') }

end
