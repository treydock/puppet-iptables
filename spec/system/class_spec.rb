require 'spec_helper_system'

describe 'iptables class:' do
  
  it 'make sure a puppet agent has ran' do
    puppet_agent do |r|
      r.stderr.should be_empty
      r.exit_code.should_not eq(1)
    end
  end

  context 'no params:' do
    let(:pp) do
      pp = <<-EOS
        class { 'firewall': }
        class { 'iptables': }
      EOS
    end

    it 'should run with no errors' do
      puppet_apply(pp) do |r|
        r.stderr.should be_empty
        r.exit_code.should_not eq(1)
      end
    end

    it 'should be idempotent' do
      puppet_apply(pp) do |r|
        r.stderr.should be_empty
        r.exit_code.should be_zero
      end
    end
  end
 
  context 'with param firewall ensure => stopped:' do
    let(:pp) do
      pp = <<-EOS
        class { 'firewall': ensure => 'stopped' }
        class { 'iptables': }
      EOS
    end

    it 'should run with no errors' do
      puppet_apply(pp) do |r|
        r.stderr.should be_empty
        r.exit_code.should_not eq(1)
      end
    end

    it 'should be idempotent' do
      puppet_apply(pp) do |r|
        r.stderr.should be_empty
        r.exit_code.should be_zero
      end
    end
  end
end