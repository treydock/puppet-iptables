require 'spec_helper'

describe 'iptables' do
  include_context :defaults

  let(:facts) { default_facts }
  let(:pre_condition) { "Firewall { before  => Class['iptables::post'], require => Class['iptables::pre'] }" }

  it { should compile.with_all_deps }
  it { should create_class('iptables') }
  it { should contain_class('iptables::params') }
  it { should contain_class('firewall') }
  it { should contain_class('iptables::pre') }
  it { should contain_class('iptables::post') }

  it { should contain_resources('firewall').with_purge('true') }

  it do
    should contain_service('ip6tables').with({
      :ensure => 'stopped',
      :enable => 'false',
    })
  end

  describe 'iptables::pre' do
    it do
      should contain_firewall('00001 accept all icmp').with({
        :proto   => 'icmp',
        :action  => 'accept',
        :before  => ['Firewall[00001 loopback]'],
        :require => nil,
      })
    end

    it do
      should contain_firewall('00001 loopback').with({
        :proto   => 'all',
        :iniface => 'lo',
        :action  => 'accept',
        :before  => ['Firewall[00001 allow locally initiated inbound traffic]'],
        :require => nil,
      })
    end

    it do
      should contain_firewall('00001 allow locally initiated inbound traffic').with({
        :proto   => 'all',
        :state   => ['RELATED', 'ESTABLISHED'],
        :action  => 'accept',
        :before  => 'Class[Iptables::Post]',
        :require => nil,
      })
    end

=begin
    it do
      should contain_firewall('003 accept new ssh').with({
        :proto   => 'tcp',
        :state   => ['NEW'],
        :action  => 'accept',
        :dport   => '22',
        :before  => 'Class[Iptables::Post]',
        :require => nil,
      })
    end

    it do
      should contain_firewall('000 accept all ipv6-icmp').with({
        :proto    => 'ipv6-icmp',
        :action   => 'accept',
        :provider => 'ip6tables',
        :before   => ['Firewall[001 loopback - ipv6]'],
        :require  => nil,
      })
    end

    it do
      should contain_firewall('001 loopback - ipv6').with({
        :proto    => 'all',
        :iniface  => 'lo',
        :action   => 'accept',
        :provider => 'ip6tables',
        :before   => ['Firewall[002 allow locally initiated inbound traffic - ipv6]'],
        :require  => nil,
      })
    end

    it do
      should contain_firewall('002 allow locally initiated inbound traffic - ipv6').with({
        :proto    => 'all',
        :state    => ['RELATED', 'ESTABLISHED'],
        :action   => 'accept',
        :provider => 'ip6tables',
        :before   => 'Class[Iptables::Post]',
        :require  => nil,
      })
    end
=end
    context "when firewall::ensure => stopped" do
      let(:pre_condition) { "class { 'firewall': ensure => stopped }" }

      it { should_not contain_firewall('00001 accept all icmp') }
      it { should_not contain_firewall('00001 loopback') }
      it { should_not contain_firewall('00001 allow locally initiated inbound traffic') }
      #it { should_not contain_firewall('003 accept new ssh') }
      #it { should_not contain_firewall('000 accept all ipv6-icmp') }
      #it { should_not contain_firewall('001 loopback - ipv6') }
      #it { should_not contain_firewall('002 allow locally initiated inbound traffic - ipv6') }
    end
  end

  describe 'iptables::post' do
    it do
      should contain_firewall('99999 deny all').with({
        :proto   => 'all',
        :action  => 'drop',
        :reject  => nil,
        :before  => nil,
        :require => 'Class[Iptables::Pre]',
      })
    end

    it do
      should contain_firewall('99999 deny all FORWARD').with({
        :proto   => 'all',
        :action  => 'drop',
        :reject  => nil,
        :chain   => 'FORWARD',
        :before  => nil,
        :require => 'Class[Iptables::Pre]',
      })
    end
=begin
    it do
      should contain_firewall('99999 deny all - ipv6').with({
        :proto    => 'all',
        :action   => 'drop',
        :reject   => nil,
        :provider => 'ip6tables',
        :before   => nil,
        :require  => 'Class[Iptables::Pre]',
      })
    end

    it do
      should contain_firewall('999 deny all FORWARD - ipv6').with({
        :proto    => 'all',
        :action   => 'drop',
        :reject   => nil,
        :chain    => 'FORWARD',
        :provider => 'ip6tables',
        :before   => nil,
        :require  => 'Class[Iptables::Pre]',
      })
    end
=end
    context "when firewall::ensure => stopped" do
      let(:pre_condition) { "class { 'firewall': ensure => stopped }" }

      it { should_not contain_firewall('99999 drop all') }
      it { should_not contain_firewall('99999 deny all FORWARD') }
      #it { should_not contain_firewall('999 deny all - ipv6') }
      #it { should_not contain_firewall('999 deny all FORWARD - ipv6') }
    end

    context 'when iptables::deny_action => "reject"' do
      let(:params) {{ :deny_action => 'reject' }}

      it do
        should contain_firewall('99999 deny all').with({
          :proto   => 'all',
          :action  => 'reject',
          :reject  => 'icmp-host-prohibited',
          :before  => nil,
          :require => 'Class[Iptables::Pre]',
        })
      end

      it do
        should contain_firewall('99999 deny all FORWARD').with({
          :proto   => 'all',
          :action  => 'reject',
          :reject  => 'icmp-host-prohibited',
          :chain   => 'FORWARD',
          :before  => nil,
          :require => 'Class[Iptables::Pre]',
        })
      end
=begin
      it do
        should contain_firewall('999 deny all - ipv6').with({
          :proto    => 'all',
          :action   => 'reject',
          :reject   => 'icmp6-adm-prohibited',
          :provider => 'ip6tables',
          :before   => nil,
          :require  => 'Class[Iptables::Pre]',
        })
      end

      it do
        should contain_firewall('999 deny all FORWARD - ipv6').with({
          :proto    => 'all',
          :action   => 'reject',
          :reject   => 'icmp6-adm-prohibited',
          :chain    => 'FORWARD',
          :provider => 'ip6tables',
          :before   => nil,
          :require  => 'Class[Iptables::Pre]',
        })
      end
=end
    end
  end

  context "when firewall::ensure => stopped" do
    let(:pre_condition) { "class { 'firewall': ensure => stopped }" }

    it do
      should contain_service('ip6tables').with({
        :ensure => 'stopped',
        :enable => 'false',
      })
    end
  end

  context "with purge_unmanaged_rules => false" do
    let(:params) {{ :purge_unmanaged_rules => false }}

    it { should contain_resources('firewall').with_purge('false') }
  end
=begin
  context "with rules => {'80' => {}}" do
    let(:params) {{ :rules => {'80' => {}} }}

    it { should contain_iptables__rule('80') }
    it { should contain_firewall('100 open port 80') }
  end

  context "with rules => {'http' => {'port' => '80'}}" do
    let(:params) {{ :rules => {'http' => {'port' => '80'}} }}

    it { should contain_iptables__rule('http').with_port('80') }
    it { should contain_firewall('100 open port 80 for http') }
  end

  context "with rules => 'foo'" do
    let(:params) {{ :rules => 'foo' }}

    it { expect { should create_class('iptables') }.to raise_error(Puppet::Error, /is not a Hash/) }
  end
=end
  context "when manage => false" do
    let(:params) {{ :manage => false }}

    it { should_not contain_class('firewall') }
    it { should_not contain_class('iptables::pre') }
    it { should_not contain_class('iptables::post') }
    it { should_not contain_resources('firewall') }
  end

  # Test verify_boolean parameters
  [
    'manage',
    'purge_unmanaged_rules',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it { expect { should create_class('iptables') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
