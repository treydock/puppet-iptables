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
  $ensure       = running,
  $rules        = $iptables::params::rules
) inherits iptables::params {

  class { 'firewall': ensure  => $ensure }

  if $rules {
    validate_hash($rules)
  }

  #class { ['iptables::pre', 'iptables::post']: }
  include iptables::pre
  include iptables::post

  if $rules and !empty($rules) { create_resources('iptables::rule', $rules) }
}
