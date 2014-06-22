# == Class: iptables::services::apache
#
# Manage apache firewall rules.
#
# === Authors
#
# Trey Dockendorf <treydock@tamu.edu>
#
# === Copyright
#
# Copyright 2014 Trey Dockendorf
#
class iptables::services::apache (
  $chain = 'INPUT',
  $http_ensure = 'present',
  $http_port = '80',
  $http_action = 'accept',
  $https_ensure = 'present',
  $https_port = '443',
  $https_action = 'accept',
) {

  include iptables

  firewall { '100 allow http':
    ensure  => $http_ensure,
    chain   => $chain,
    port    => $http_port,
    proto   => 'tcp',
    action  => $http_action,
  }

  firewall { '100 allow https':
    ensure  => $https_ensure,
    chain   => $chain,
    port    => $https_port,
    proto   => 'tcp',
    action  => $https_action,
  }

}
