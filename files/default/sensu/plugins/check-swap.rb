#!/usr/bin/env ruby
#
# Check Swap Plugin
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'

class CheckSwap < Sensu::Plugin::Check::CLI

  option :megabytes,
    :short  => '-m',
    :long  => '--megabytes',
    :description => 'Unless --megabytes is specified the thresholds are in percents',
    :boolean => true,
    :default => true

  option :warn,
    :short => '-w WARN',
    :proc => proc { |a| a.to_i },
    :default => 512

  option :crit,
    :short => '-c CRIT',
    :proc => proc { |a| a.to_i },
    :default => 1024

  def run
    total_swap, used_swap = 0, 0

    `free -m`.split("\n").each do |line|
      if line =~ /^Swap:/
        total_swap, used_swap = [ line.split[1].to_i, line.split[2].to_i ]
      end
    end

    if config[:megabytes]
      message "#{used_swap} megabytes of Swap used"

      critical if used_swap > config[:crit]
      warning if used_swap > config[:warn]
      ok
    else
      unknown "invalid percentage" if config[:crit] > 100 || config[:warn] > 100

      percent_used = used_swap * 100 / total_swap
      message "#{percent_used}% Swap used"

      critical if percent_used > config[:crit]
      warning if percent_used > config[:warn]
      ok
    end
  end
end
