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

  if $iptables::ensure =~ /running/ {
    firewall { '999 drop all':
      proto   => 'all',
      action  => 'drop',
      before  => undef,
    }
  }
}
