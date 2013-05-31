# puppet-iptables

Wrapper for the puppetlabs-firewall module.

Also defines the 'pre' and 'post' firewall rules as documented by [puppetlabs-firewall](https://github.com/puppetlabs/puppetlabs-firewall)

## Usage

The following should be added to site.pp

    resources { "firewall":
      purge => true
    }
    Firewall {
      before  => Class['iptables::post'],
      require => Class['iptables::pre'],
    }

Apply this module:

    class { 'iptables': }

## Development

### Dependencies

* Ruby 1.8.7
* Bundler
* Vagrant >= 1.2.0

### Unit testing

1. To install dependencies run `bundle install`
2. Run tests using `bundle exec rake spec:all`

### Vagrant system tests

1. Have Vagrant >= 1.2.0 installed
2. Run tests using `bundle exec rake spec:system`

For active development the `RSPEC_DESTROY=no` environment variable can be passed to keep the Vagrant VM from being destroyed after a test run.

    RSPEC_DESTROY=no bundle exec rake spec:system


## TODO

* Add common firewall presents such as Apache and NAT firewall rules

## Further Information

* [puppetlabs-firewall](https://github.com/puppetlabs/puppetlabs-firewall)
