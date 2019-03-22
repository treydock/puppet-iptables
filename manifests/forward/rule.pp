# == Define: iptables::forward::rule
#
# Defines firewall resources for the FORWARD chain
#
define iptables::forward::rule (
  Integer[100,999] $order = 100,
  $action = 'accept',
  $proto = 'all',
  $dport = undef,
  $source = undef,
  $destination = 'UNSET',
  $dst_range = undef,
) {

  if $destination == 'UNSET' and ! $dst_range {
    $destination_real = $name
  } elsif $destination == 'UNSET' and $dst_range {
    $destination_real = undef
  } else {
    $destination_real = $destination
  }

  firewall { "${order} FORWARD allow ${name}":
    chain       => 'FORWARD',
    action      => $action,
    proto       => $proto,
    dport       => $dport,
    source      => $source,
    destination => $destination_real,
    dst_range   => $dst_range,
  }

}
