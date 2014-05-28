# == Class: iptables::forward
#
# Sets the nat POSTROUTING rule
#
define iptables::forward (
  $iniface,
) {

  firewall { "100 FORWARD ${iniface} to ${name}":
    chain     => 'FORWARD',
    action    => 'accept',
    proto     => 'all',
    iniface   => $iniface,
    outiface  => $name,
  }

}
