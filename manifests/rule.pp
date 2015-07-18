# == Define: iptables::instance
#
# Define basic firewall rules
#
# === Parameters:
#
# === Examples:
#
# === Authors:
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright:
#
# Copyright 2013 Trey Dockendorf, unless otherwise noted.
#
define iptables::rule (
  $ensure       = 'present',
  $action       = 'accept',
  $port         = 'UNSET',
  $proto        = 'tcp',
  $chain        = 'INPUT',
  $iniface      = undef,
  $outiface     = undef
) {

  include iptables

  $port_real = $port ? {
    'UNSET' => is_integer($name) ? {
      true    => $name,
      false   => fail('Must specify port as integer for firewall rule'),
    },
    default => $port,
  }

  if $port =~ /UNSET/ {
    $firewall_name  = "100 open port ${port_real}"
  } else {
    $firewall_name  = "100 open port ${port_real} for ${name}"
  }

  if $iptables::_ensure == 'running' {
    firewall { $firewall_name:
      ensure   => $ensure,
      action   => $action,
      port     => $port_real,
      proto    => $proto,
      chain    => $chain,
      iniface  => $iniface,
      outiface => $outiface,
    }
  }
}
