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
  $deny_action = 'drop',
  $rules = {},
) inherits iptables::params {

  validate_bool($manage)
  validate_re($deny_action, ['^drop$', '^reject$'])
  validate_hash($rules)

  case $deny_action {
    'drop': {
      $post_rules_action = 'drop'
      $post_rules_reject = undef
    }
    'reject': {
      $post_rules_action = 'reject'
      $post_rules_reject = 'icmp-host-prohibited'
    }
    default: {
      fail("Module ${module_name}: deny_action parameter must be drop or reject, ${deny_action} given.")
    }
  }

  if $manage {
    validate_bool($purge_unmanaged_rules)

    include firewall

    $ensure = $firewall::ensure
    $enable = $firewall::ensure ? {
      'running' => true,
      'stopped' => false,
    }

    if $ensure =~ /running/ {
      class { ['iptables::pre', 'iptables::post']: }->
      resources { 'firewall': purge => $purge_unmanaged_rules }
    }

    service { 'ip6tables':
      ensure  => $ensure,
      enable  => $enable,
      require => Package[$firewall::package_name],
    }

    create_resources('iptables::rule', $rules)
  }

}
