# == Class: iptables::params
#
# The iptables configuration settings.
#
# === Variables
#
# [*iptables_rules*]
#   Hash that defines firewall rules
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class iptables::params {

  case $::osfamily {
    'RedHat': {
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}

