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
  Boolean $manage         = true,
  Boolean $purge_unmanaged_rules  = true,
  $purge_input_chain      = undef,
  $purge_forward_chain    = undef,
  $purge_output_chain     = undef,
  $input_chain_ignore     = undef,
  $forward_chain_ignore   = undef,
  $output_chain_ignore    = undef,
  $deny_action            = 'drop',
  #$rules = {},
  $manage_nat_chains      = false,
) inherits iptables::params {

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
    include firewall

    if $firewall::ensure == 'running' {
      class { ['iptables::pre', 'iptables::post']: }
      contain 'iptables::pre'
      contain 'iptables::post'

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
      if $manage_nat_chains {
        firewallchain { 'INPUT:nat:IPv4':
          purge  => $purge_unmanaged_rules,
        }
        firewallchain { 'PREROUTING:nat:IPv4':
          purge  => $purge_unmanaged_rules,
        }
        firewallchain { 'POSTROUTING:nat:IPv4':
          purge  => $purge_unmanaged_rules,
        }
        firewallchain { 'OUTPUT:nat:IPv4':
          purge  => $purge_unmanaged_rules,
        }
      }
      # These chains must be managed on EL7 to avoid errors
      # Set to release 9 to make invalid
      if $::operatingsystemmajrelease == '9' {
        firewallchain { 'INPUT:filter:IPv6':
          purge  => $_purge_input_chain,
          ignore => $input_chain_ignore,
        }
        firewallchain { 'FORWARD:filter:IPv6':
          purge  => $_purge_forward_chain,
          ignore => $forward_chain_ignore,
        }
        firewallchain { 'OUTPUT:filter:IPv6':
          purge  => $_purge_output_chain,
          ignore => $output_chain_ignore,
        }
        firewallchain { 'INPUT:nat:IPv6':
          purge  => $_purge_input_chain,
          ignore => $input_chain_ignore,
        }
        firewallchain { 'OUTPUT:nat:IPv6':
          purge  => $_purge_output_chain,
          ignore => $output_chain_ignore,
        }
        firewallchain { 'PREROUTING:nat:IPv6':
          purge  => $_purge_output_chain,
          ignore => $output_chain_ignore,
        }
        firewallchain { 'POSTROUTING:nat:IPv6':
          purge  => $_purge_output_chain,
          ignore => $output_chain_ignore,
        }
      }
      # Purging unmanaged chains on EL7 causes a lot of headaches
      #resources { 'firewallchain': purge => $purge_unmanaged_rules }
      #resources { 'firewall': purge => $purge_unmanaged_rules }

      # Purge then stop ip6tables
      # Removal of ip6tables rules will make the service look like it's back on
      #Firewallchain <| |> -> Service['ip6tables']
      #Resources['firewall'] -> Service['ip6tables']
      # Unnecessary even if purging unmanaged chains
      #Resources['firewallchain'] -> Service['ip6tables']
    }
  }

}
