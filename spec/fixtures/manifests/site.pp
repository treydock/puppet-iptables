resources { 'firewall':
  purge => true
}
Firewall {
  before  => Class['iptables::post'],
  require => Class['iptables::pre'],
}
