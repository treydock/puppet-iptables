# == Class: iptables
#
# Class to set the firewall pre and post rules and
# allow defining of iptables rules
#
# === Parameters:
#
# [*purge_unmanaged_rules*]
#   Boolean.  Determines if unmanaged firewall rules are purged.
#   Default: true
#
# [*rules*]
#   Hash defining simple Firewall instances to be passed to
#   the Iptables::Rule defined resource.
#
# === Examples:
#
#  class { 'iptables': }
#
# === Authors:
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright:
#
# Copyright 2012 Trey Dockendorf, unless otherwise noted.
#
class iptables (
  $manage = true,
  $purge_unmanaged_rules = true,
  $purge_input_chain = undef,
  $purge_forward_chain = undef,
  $purge_output_chain = undef,
  $input_chain_ignore = undef,
  $forward_chain_ignore = undef,
  $output_chain_ignore = undef,
  $deny_action = 'drop',
  $rules = {},
) inherits iptables::params {

  validate_bool($manage)
  validate_hash($rules)

  case $deny_action {
    'drop': {
      $post_rules_action      = 'drop'
      $post_rules_reject      = undef
      $post_rules_ipv6_reject = undef
    }
    'reject': {
      $post_rules_action      = 'reject'
      $post_rules_reject      = 'icmp-host-prohibited'
      $post_rules_ipv6_reject = 'icmp6-adm-prohibited'
    }
    default: {
      fail("Module ${module_name}: deny_action parameter must be drop or reject, ${deny_action} given.")
    }
  }

  $_purge_input_chain = pick($purge_input_chain, $purge_unmanaged_rules)
  $_purge_forward_chain = pick($purge_forward_chain, $purge_unmanaged_rules)
  $_purge_output_chain = pick($purge_output_chain, $purge_unmanaged_rules)

  if $manage {
    validate_bool($purge_unmanaged_rules)

    include firewall

    $_ensure = $firewall::ensure
    $_enable = $firewall::ensure ? {
      'running' => true,
      'stopped' => false,
    }

    if $firewall::ensure == 'running' {
      class { ['iptables::pre', 'iptables::post']: }
      firewallchain { 'INPUT:filter:IPv4':
        purge  => $_purge_input_chain,
        ignore => $input_chain_ignore,
      }
      firewallchain { 'FORWARD:filter:IPv4':
        purge  => $_purge_forward_chain,
        ignore => $forward_chain_ignore,
      }
      firewallchain { 'OUTPUT:filter:IPv4':
        purge  => $_purge_output_chain,
        ignore => $output_chain_ignore,
      }
      #resources { 'firewall': purge => $purge_unmanaged_rules }
    }

    service { 'ip6tables':
      ensure  => $_ensure,
      enable  => $_enable,
      require => Package[$firewall::package_name],
    }

    create_resources('iptables::rule', $rules)
  }

}
