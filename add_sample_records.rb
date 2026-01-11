#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "lib/guestbook"

# Add 5 sample records to the database
sample_entries = [
  {
    visitor_name: "Alice Johnson",
    email: "alice@example.com",
    message: "This is a wonderful guestbook application! I love how clean the interface is."
  },
  {
    visitor_name: "Bob Smith",
    email: "",
    message: "Great work on this app. The design is modern and responsive."
  },
  {
    visitor_name: "Catherine Davis",
    email: "catherine@techblog.com",
    message: "I'm impressed with the Ruby/Sinatra implementation. Clean code architecture."
  },
  {
    visitor_name: "David Lee",
    email: "lee.dev@example.com",
    message: "Just wanted to say hello! This guestbook is working perfectly."
  },
  {
    visitor_name: "Emma Wilson",
    email: "emma@design.co",
    message: "Nice CSS styling! The purple theme gives it a professional look."
  }
]

puts "Adding 5 sample records to the guestbook..."
successful = 0

sample_entries.each_with_index do |entry, index|
  id = GuestbookManager.create(
    entry[:visitor_name],
    email: entry[:email],
    message: entry[:message]
  )
  puts "#{index + 1}. Added: #{entry[:visitor_name]} (ID: #{id})"
  successful += 1
rescue StandardError => e
  puts "Error adding entry for #{entry[:visitor_name]}: #{e.message}"
end

puts "\nSuccessfully added #{successful} out of 5 sample records."
puts "Total entries now: #{GuestbookManager.all.count}"
