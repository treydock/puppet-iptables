# == Define: iptables::forward
#
# Defines a FORWARD rule for interfaces
#
define iptables::forward (
  $internal,
  $external,
  Boolean $allow_established = true,
  Boolean $allow_all = true,
) {

  if $allow_established {
    $ensure_established = 'present'
  } else {
    $ensure_established = 'absent'
  }

  if $allow_all {
    $ensure_all = 'present'
  } else {
    $ensure_all = 'absent'
  }

  firewall { "100 FORWARD related established ${name}":
    ensure   => $ensure_established,
    chain    => 'FORWARD',
    action   => 'accept',
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    iniface  => $external,
    outiface => $internal,
  }

  firewall { "101 FORWARD all ${name}":
    ensure   => $ensure_all,
    chain    => 'FORWARD',
    action   => 'accept',
    proto    => 'all',
    iniface  => $internal,
    outiface => $external,
  }

}
