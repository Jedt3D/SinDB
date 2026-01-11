#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "lib/guestbook"
require_relative "config/database"

puts "Testing GuestbookManager.create method..."

# Test 1: Create a valid entry
begin
  puts "\nTest 1: Creating a valid entry with all fields..."
  id = GuestbookManager.create(
    visitor_name: "John Doe",
    email: "john@example.com",
    message: "This is a test message"
  )
  puts "✓ Success! Entry created with ID: #{id}"
rescue StandardError => e
  puts "✗ Failed: #{e.message}"
  puts e.backtrace
end

# Test 2: Create entry without email
begin
  puts "\nTest 2: Creating entry without email..."
  id = GuestbookManager.create(
    visitor_name: "Jane Smith",
    message: "Another test message without email"
  )
  puts "✓ Success! Entry created with ID: #{id}"
rescue StandardError => e
  puts "✗ Failed: #{e.message}"
end

# Test 3: Verify entries are in database
begin
  puts "\nTest 3: Retrieving all entries from database..."
  entries = GuestbookManager.all
  puts "✓ Success! Found #{entries.count} entries in database"
  entries.each do |entry|
    puts "  - #{entry['visitor_name']} (#{entry['email']}): #{entry['message'][0..30]}..."
  end
rescue StandardError => e
  puts "✗ Failed: #{e.message}"
end

puts "\n✓ All tests completed!"
