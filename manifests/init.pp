# == Class: iptables
#
# Class to set the firewall pre and post rules and
# allow defining of iptables rules
#
# === Parameters:
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
  $rules        = false
) {

  class { ['iptables::pre', 'iptables::post']: }

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
