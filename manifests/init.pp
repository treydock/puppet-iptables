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
  $rules = $iptables::params::rules
) inherits iptables::params {

  validate_bool($manage)

  if $manage {
    validate_bool($purge_unmanaged_rules)

    include firewall

    $ensure = $firewall::ensure

    if $ensure =~ /running/ {
      resources { 'firewall':
        purge => $purge_unmanaged_rules,
      }
    }

    if $rules {
      validate_hash($rules)
    }

    include iptables::pre
    include iptables::post

    if $rules and !empty($rules) { create_resources('iptables::rule', $rules) }
  }

}
