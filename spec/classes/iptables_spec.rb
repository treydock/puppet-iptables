require 'spec_helper'


describe 'iptables' do

  let :facts do
    {
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
    }
  end

  it { should contain_class('iptables::pre') }
  it { should contain_class('iptables::post') }

  it do
    should contain_service('iptables').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
    })
  end
  
  it do
    should contain_exec('persist-firewall').with({
      'command'     => '/sbin/iptables-save > /etc/sysconfig/iptables',
      'refreshonly' => 'true',
    })
  end

  it do
    should contain_resources('firewall').with({
      'purge' => 'true',
    })
  end
  
  context 'iptables::pre' do
    it do
      should contain_exec('blank_iptables_start').with({
        'path'    => '/usr/bin:/usr/sbin:/bin',
        'unless'  => '/sbin/service iptables status',
        'command' => '/sbin/iptables -L',
        'before'  => 'Firewall[000 accept all icmp]',
      })
    end
    
    it do
      should contain_firewall('000 accept all icmp').with({
        'proto'   => 'icmp',
        'action'  => 'accept',
        'before'  => 'Firewall[001 accept all to lo interface]',
        'require' => nil,
        'notify'  => 'Exec[persist-firewall]',
      })
    end
    
    it do
      should contain_firewall('001 accept all to lo interface').with({
        'proto'   => 'all',
        'iniface' => 'lo',
        'action'  => 'accept',
        'before'  => 'Firewall[002 accept related established rules]',
        'require' => nil,
        'notify'  => 'Exec[persist-firewall]',
      })
    end
    
    it do
      should contain_firewall('002 accept related established rules').with({
        'proto'   => 'all',
        'state'   => ['RELATED', 'ESTABLISHED'],
        'action'  => 'accept',
        'before'  => 'Firewall[003 accept new ssh]',
        'require' => nil,
        'notify'  => 'Exec[persist-firewall]',
      })
    end
    
    it do
      should contain_firewall('003 accept new ssh').with({
        'proto'   => 'tcp',
        'state'   => ['NEW'],
        'action'  => 'accept',
        'dport'   => '22',
        'before'  => 'Class[Iptables::Post]',
        'require' => nil,
        'notify'  => 'Exec[persist-firewall]',
      })
    end
  end
  
  context 'iptables::post' do
    it do
      should contain_firewall('999 drop all').with({
        'proto'   => 'all',
        'action'  => 'drop',
        'before'  => nil,
        'require' => 'Class[Iptables::Pre]',
        'notify'  => 'Exec[persist-firewall]',
      })
    end
  end
end
