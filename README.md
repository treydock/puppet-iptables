# iptables module for Puppet

## Dependencies

* Ruby 1.8.7
* Bundler

## Usage

The following should be added to site.pp

    resources { "firewall":
      purge => true
    }
    Firewall {
      before  => Class['iptables::post'],
      require => Class['iptables::pre'],
    }

## Running tests

1. To install dependencies run `bundle install`
2. Run tests using `rake spec`
3. Verbose test output available using `rake all`
