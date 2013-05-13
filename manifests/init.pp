class iptables (
  $ensure       = 'running',
  $enable       = true,
  $rules        = false,
	$force_drop		= 'UNSET'
) {
  include iptables::pre
  include iptables::post

  service { 'iptables':
    ensure      => $ensure,
    enable      => $enable,
    hasstatus   => true,
    hasrestart  => true,
  }

  # Always persist firewall rules
  exec { 'persist-firewall':
    command     => '/sbin/iptables-save > /etc/sysconfig/iptables',
    refreshonly => true,
  }

  # Allow parameters from ENC or Hiera to define individual firewall rules
  # ENC value takes presedence over Hiera
#  if $::iptables_rules {
#    $iptables_rules = string2hash($::iptables_rules)
#  } elsif hiera('iptables_rules', false) {
#    $iptables_rules = hiera('iptables_rules')
#  } else {
#    $iptables_rules = false
#  }

  if $rules { create_resources('iptables::rule', $rules) }
}
