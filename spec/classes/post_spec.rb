require 'spec_helper'


describe 'iptables::post' do

  let :facts do
    {
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
      :kernel                   => 'Linux',
    }
  end

  it do
    should contain_firewall('999 drop all').with({
      'proto'   => 'all',
      'action'  => 'drop',
      'before'  => nil,
      'require' => 'Class[Iptables::Pre]',
    })
  end
end
