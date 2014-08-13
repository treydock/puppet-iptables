require 'spec_helper'

describe 'iptables::forward::rule' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { 'rubygems.org' }

  it { should create_iptables__forward__rule('rubygems.org') }

  it do
    should contain_firewall('100 FORWARD allow rubygems.org').only_with({
      :name         => '100 FORWARD allow rubygems.org',
      :chain        => 'FORWARD',
      :action       => 'accept',
      :proto        => 'all',
      :dport        => nil,
      :source       => nil,
      :destination  => 'rubygems.org',
    })
  end

  context 'when order => "200"' do
    let(:params) {{ :order => '200' }}
    it { contain_firewall('200 FORWARD allow rubygems.org') }
  end

  context 'when destination defined' do
    let(:title) { 'foo.com 10.1.0.0/16' }
    let(:params) {{ :destination => '10.1.0.0/16' }}

    it { should create_iptables__forward__rule('foo.com 10.1.0.0/16') }

    it do
      should contain_firewall('100 FORWARD allow foo.com 10.1.0.0/16').only_with({
        :name         => '100 FORWARD allow foo.com 10.1.0.0/16',
        :chain        => 'FORWARD',
        :action       => 'accept',
        :proto        => 'all',
        :dport        => nil,
        :source       => nil,
        :destination  => '10.1.0.0/16',
      })
    end
  end

  context 'when order is not numeric' do
    let(:params) {{ :order => 'foo' }}
    it {
      expect { should compile }.to raise_error(/order parameter must be numeric/)
    }
  end

  context 'when order is less than 3 characters' do
    let(:params) {{ :order => '10' }}
    it {
      expect { should compile }.to raise_error(/to be between 3 and 3, was 2/)
    }
  end


  context 'when order is greater than 3 characters' do
    let(:params) {{ :order => '1000' }}
    it {
      expect { should compile }.to raise_error(/to be between 3 and 3, was 4/)
    }
  end
end
