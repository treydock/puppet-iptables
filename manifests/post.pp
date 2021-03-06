# == Class: iptables::post
#
# Sets the firewall rules that are added at the end
# of the chain
#
# === Authors:
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright:
#
# Copyright 2012 Trey Dockendorf, unless otherwise noted.
#
class iptables::post {
  include iptables

  firewall { '99999 deny all':
    proto  => 'all',
    action => $iptables::post_rules_action,
    reject => $iptables::post_rules_reject,
    before => undef,
  }

  firewall { '99999 deny all FORWARD':
    proto  => 'all',
    action => $iptables::post_rules_action,
    reject => $iptables::post_rules_reject,
    chain  => 'FORWARD',
    before => undef,
  }

#  firewall { '999 deny all - ipv6':
#    proto    => 'all',
#    action   => $iptables::post_rules_action,
#    reject   => $iptables::post_rules_ipv6_reject,
#    provider => 'ip6tables',
#    before   => undef,
#  }

#  firewall { '999 deny all FORWARD - ipv6':
#    proto    => 'all',
#    action   => $iptables::post_rules_action,
#    reject   => $iptables::post_rules_ipv6_reject,
#    chain    => 'FORWARD',
#    provider => 'ip6tables',
#    before   => undef,
#  }

}
