require 'spec_helper'


describe 'iptables' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('iptables') }
  it { should contain_class('firewall') }
  it { should contain_class('iptables::pre') }
  it { should contain_class('iptables::post') }

  it { should contain_resources('firewall').with_purge('true') }

  context "with purge_unmanaged_rules => false" do
    let(:params) {{ :purge_unmanaged_rules => false }}

    it { should contain_resources('firewall').with_purge('false') }
  end

  context "with rules => {'80' => {}}" do
    let(:params) {{ :rules => {'80' => {}} }}

    it { should contain_iptables__rule('80') }
  end

  context "with rules => {'http' => {'port' => '80'}}" do
    let(:params) {{ :rules => {'http' => {'port' => '80'}} }}

    it { should contain_iptables__rule('http').with_port('80') }
  end

  context "with rules => 'foo'" do
    let(:params) {{ :rules => 'foo' }}

    it { expect { should create_class('iptables') }.to raise_error(Puppet::Error, /is not a Hash/) }
  end

  # Test verify_boolean parameters
  [
    'purge_unmanaged_rules',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it { expect { should create_class('iptables') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
