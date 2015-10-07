# site.pp
# This gets ignored with future parser enabled and Puppet 4.x, so
# pre_condition is used instead
#Firewall {
#  before  => Class['iptables::post'],
#  require => Class['iptables::pre'],
#}
