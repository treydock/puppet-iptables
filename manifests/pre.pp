# == Class: iptables::pre
#
# Sets the firewall rules that are added at the beginning
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
class iptables::pre {
  include iptables

  if $iptables::ensure =~ /running/ {
    Firewall {
      require => undef,
    }

    firewall { '000 accept all icmp':
      proto   => 'icmp',
      action  => 'accept',
    }->
    firewall { '001 accept all to lo interface':
      proto   => 'all',
      iniface => 'lo',
      action  => 'accept',
    }->
    firewall { '002 accept related established rules':
      proto   => 'all',
      state   => ['RELATED', 'ESTABLISHED'],
      action  => 'accept',
    }->
    firewall { '003 accept new ssh':
      proto   => 'tcp',
      state   => ['NEW'],
      action  => 'accept',
      dport   => '22',
    }
  }
}
