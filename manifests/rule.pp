define iptables::rule (
  $port=false,
  $proto='tcp'
) {

	firewall { "001 ${name} by Puppet":
		ensure  => present,
		action	=> 'accept',
		dport		=> "${port}",
		chain		=> 'INPUT',
		proto		=> "${proto}",
  }

}
