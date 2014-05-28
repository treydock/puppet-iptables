# == Class: iptables::forward
#
# Sets the nat POSTROUTING rule
#
define iptables::forward (
  $iniface,
) {

  firewall { "100 FORWARD ${name} to ${iniface}":
    chain     => 'FORWARD',
    action    => 'accept',
    proto     => 'all',
    iniface   => $iniface,
    outiface  => $name,
  }

}
