class iptables {

  # ENC value takes presedence over Hiera
  if $::iptables_rules {
    $iptables_rules = string2hash($::iptables_rules)
  } elsif hiera('iptables_rules', false) {
    $iptables_rules = hiera('iptables_rules')
  } else {
    $iptables_rules = false
  }

  if $iptables_rules { create_resources('iptables::rule', $iptables_rules) }
}
