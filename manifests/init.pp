class iptables (
  $rules        = false
) {
  class ( ['iptables::pre', 'iptables::post']: }

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
