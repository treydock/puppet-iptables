require 'spec_helper'


describe 'iptables::forward' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { 'private' }

  let(:params) do
    {
      :internal => 'eth0',
      :external => 'eth1',
    }
  end

  it { should create_iptables__forward('private') }

  it do
    pp catalogue.resource('firewall', '000 FORWARD related established private').send(:parameters)
    should contain_firewall('000 FORWARD related established private').only_with({
      :ensure   => 'present',
      :name     => '000 FORWARD related established private',
      :chain    => 'FORWARD',
      :action   => 'accept',
      :proto    => 'all',
      :state    => ['RELATED', 'ESTABLISHED'],
      :iniface  => 'eth1',
      :outiface => 'eth0',
      :before   => 'Class[Iptables::Post]',
      :require  => 'Class[Iptables::Pre]',
    })
  end

  it do
    should contain_firewall('001 FORWARD all private').only_with({
      :ensure   => 'present',
      :name     => '001 FORWARD all private',
      :chain    => 'FORWARD',
      :action   => 'accept',
      :proto    => 'all',
      :iniface  => 'eth0',
      :outiface => 'eth1',
      :before   => 'Class[Iptables::Post]',
      :require  => 'Class[Iptables::Pre]',
    })
  end

  context 'when allow_all => false' do
    let(:params) do
      {
        :internal   => 'eth0',
        :external   => 'eth1',
        :allow_all  => false,
      }
    end

    it do
      should contain_firewall('001 FORWARD all private').with_ensure('absent')
    end
  end

  # Test validate_bool parameters
  [
    :allow_established,
    :allow_all,
  ].each do |p|
    context "when #{p} => 'foo'" do
      let(:params) do
        {
          :internal   => 'eth0',
          :external   => 'eth1',
          p           => 'foo',
        }
      end

      it { expect { should compile }.to raise_error(/is not a boolean/) }
    end
  end
end
