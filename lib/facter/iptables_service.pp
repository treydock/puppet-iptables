Facter.add(:iptables_enabled) do
  confine :kernel => :linux
  setcode do
    exit_code = Facter::Util::Resolution.exec('/sbin/service iptables status &> /dev/null; echo $?')
    if exit_code =~ /1/i
      status = 'false'
    elsif exit_code =~ /0/i
      status = 'true'
    else
      status = nil
    end
    status
  end
end
