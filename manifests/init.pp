class iptables {

  if $iptables_rules {
    $rule = string2hash($iptables_rules)
    create_resources('iptables::rule', $rule)
  }

}
