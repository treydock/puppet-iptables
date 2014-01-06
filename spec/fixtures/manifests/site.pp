# site.pp
Firewall {
  before  => Class['iptables::post'],
  require => Class['iptables::pre'],
}
