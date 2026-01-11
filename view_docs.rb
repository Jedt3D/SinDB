#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple script to open the generated YARD documentation in the default browser

require "launchy"

Dir.chdir(__dir__)
doc_path = File.join(Dir.pwd, "doc", "api", "index.html")

if File.exist?(doc_path)
  puts "Opening documentation..."
  Launchy.open(doc_path)
else
  puts "Documentation not found. Run 'bundle exec yard doc' first."
  puts "Command to generate: bundle exec yard doc"
end
