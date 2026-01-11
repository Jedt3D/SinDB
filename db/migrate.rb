#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../config/database'

# Run all SQL migration files in the db directory
def run_migrations
  # Set up the database
  Database.setup_database
  
  # Run schema.sql if guestbook_entries table doesn't exist
  unless Database.table_exists?('guestbook_entries')
    schema_file = File.join(__dir__, 'schema.sql')
    puts "Running schema migration: #{File.basename(schema_file)}"
    
    # Read and execute the schema file
    sql = File.read(schema_file)
    Database.execute(sql)
    puts "Migration complete: guestbook_entries table created"
  else
    puts "guestbook_entries table already exists"
  end
end

# Run migrations if this script is executed directly
if __FILE__ == $0
  run_migrations
end