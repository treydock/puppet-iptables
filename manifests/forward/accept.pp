# == Define: iptables::forward::accept
#
# Defines firewall resources to accept through FORWARD chain
#
define iptables::forward::accept (
  $proto = 'tcp',
  $dport = undef,
  $source = undef,
  $destination = 'UNSET',
) {

  $destination_real = $destination ? {
    'UNSET' => $name,
    default => $destination,
  }

  firewall { "100 iptables::forward::accept ${name}":
    chain       => 'FORWARD',
    action      => 'accept',
    proto       => $proto,
    dport       => $dport,
    source      => $source,
    destination => $destination_real,
  }

}
