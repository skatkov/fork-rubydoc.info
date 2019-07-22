#!/usr/bin/env ruby

require 'shellwords'

if File.exist?('.yardopts')
  args = Shellwords.split(File.read('.yardopts').gsub(/^[ \t]*#.+/m, ''))
  args.each_with_index do |arg, i|
    next unless arg == '--plugin'
    next unless arguments[i + 1]
    system "gem install yard-#{arguments[i + 1]}"
  end
end

require 'yard'

class YARD::CLI::Yardoc
  def yardopts(file = options_file)
    list = IO.read(file).shell_split
    list.map {|a| %w(-c --use-cache --db -b --query).include?(a) ? '-o' : a }
  rescue Errno::ENOENT
    []
  end
end

YARD::CLI::Yardoc.run('-n', '-q')