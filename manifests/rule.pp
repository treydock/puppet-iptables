define iptables::rule (
  $port   = 'UNSET',
  $proto  = 'tcp'
) {

  $port_real = $port ? {
    'UNSET' => is_integer($name) ? {
      true    => $name,
      false   => fail("Must specify port as integer for firewall rule"),
    },
    default => $port,
  }

	firewall { "001 ${name} by Puppet":
		ensure  => present,
		action  => 'accept',
		dport   => $port_real,
		chain   => 'INPUT',
		proto   => $proto,
  }

}
