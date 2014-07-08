# == Define: iptables::forward
#
# Defines a FORWARD rule for interfaces
#
define iptables::forward (
  $iniface,
) {

  firewall { "001 FORWARD ${name} to ${iniface}":
    chain     => 'FORWARD',
    action    => 'accept',
    proto     => 'all',
    iniface   => $iniface,
    outiface  => $name,
  }

}
