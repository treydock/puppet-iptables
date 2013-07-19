require 'puppetlabs_spec_helper/module_spec_helper'

shared_context :firewall_defaults do
  let :pre_condition do
    'resources { "firewall":
      purge => true
    }
    Firewall {
      before  => Class["iptables::post"],
      require => Class["iptables::pre"],
    }'
  end
end

shared_context :defaults do
  let :default_facts do
    {
      :osfamily                 => 'RedHat',
      :operatingsystemrelease   => '6.4',
      :kernel                   => 'Linux',
    }
  end
end