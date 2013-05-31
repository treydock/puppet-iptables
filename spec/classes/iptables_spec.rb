require 'spec_helper'


describe 'iptables' do

  let :facts do
    {
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
      :kernel                   => 'Linux',
    }
  end

  it { should contain_class('iptables::pre') }
  it { should contain_class('iptables::post') }

end
