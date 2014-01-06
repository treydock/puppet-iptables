# puppet-iptables

Wrapper for the puppetlabs-firewall module.

Also defines the 'pre' and 'post' firewall rules as documented by [puppetlabs-firewall](https://github.com/puppetlabs/puppetlabs-firewall)

## Setup

The following must be added to **site.pp**

    Firewall {
      before  => Class['iptables::post'],
      require => Class['iptables::pre'],
    }

## Usage

Apply this module:

    class { 'firewall': }
    class { 'iptables': }

Disable iptables:

    class { 'firewall': ensure => stopped }
    class { 'iptables': }

Add an iptables rule for HTTPS port 443:

    class { 'firewall': }
    class { 'iptables':
      rules => {'https' => {'port' => '443'}},
    }

## Development

### Dependencies

* Ruby 1.8.7
* Bundler

### Unit tests

Install gem dependencies

    bundle install

Run tests

    bundle exec rake ci

### System tests

If you have Vagrant >= 1.1.0 installed you can run system tests.

    bundle exec rake spec:system

## TODO

* Add common firewall presents such as Apache and NAT firewall rules

## Further Information

* [puppetlabs-firewall](https://github.com/puppetlabs/puppetlabs-firewall)
