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
) {

  validate_string($order)
  validate_slength($order, 3, 3)

  if ! is_numeric($order) {
    fail("iptables::forward::accept: order parameter must be numeric but ${order} was given.")
  }

  $destination_real = $destination ? {
    'UNSET' => $name,
    default => $destination,
  }

  firewall { "${order} FORWARD allow ${name}":
    chain       => 'FORWARD',
    action      => $action,
    proto       => $proto,
    dport       => $dport,
    source      => $source,
    destination => $destination_real,
  }

}
