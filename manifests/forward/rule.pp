# == Define: iptables::forward::rule
#
# Defines firewall resources for the FORWARD chain
#
define iptables::forward::rule (
  $order = '100',
  $action = 'accept',
  $proto = 'all',
  $dport = undef,
  $source = undef,
  $destination = 'UNSET',
  $dst_range = undef,
) {

  validate_string($order)
  validate_slength($order, 3, 3)

  if ! is_numeric($order) {
    fail("iptables::forward::rule: order parameter must be numeric but ${order} was given.")
  }

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