#!/usr/local/ey_resin/ruby/bin/ruby


require File.expand_path(__FILE__ + '/../lib/backup')

this_file = __FILE__

begin
  backup = Flexibackup::CLI::Backup.new(this_file, ARGV)
rescue => e
  puts "An error has occurred:"
  puts e
end