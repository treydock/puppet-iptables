require 'beaker-rspec'

hosts.each do |host|
  # Install Puppet
  # Install Puppet
  if host['platform'] =~ /el-(5|6)/
    relver = $1
    on host, "rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-#{relver}.noarch.rpm", { :acceptable_exit_codes => [0,1] }
    on host, 'yum install -y puppet puppet-server', { :acceptable_exit_codes => [0,1] }
    on host, 'service puppetmaster start', { :acceptable_exit_codes => [0,1] }
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  fixtures_root = File.expand_path(File.join(proj_root, 'spec', 'fixtures'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies

    hosts.each do |host|
      copy_root_module_to(host, :module_name => 'iptables')
      scp_to host, File.join(fixtures_root, 'manifests', 'site.pp'), '/etc/puppet/manifests/site.pp'
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version', '">=3.2.0 <5.0.0"'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-firewall', '--version', '"1.x"'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'domcleal-augeasproviders', '--version', '"1.x"'), { :acceptable_exit_codes => [0,1] }
    end
  end
end