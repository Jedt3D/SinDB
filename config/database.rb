# frozen_string_literal: true

# Database configuration and connection handling
class Database
  require 'sqlite3'

  # Path where the database file will be stored
  DB_PATH = File.join(__dir__, '..', 'db', 'sina.db').freeze

  def self.connect
    @db ||= SQLite3::Database.new(DB_PATH)
    # Use rows as hashes for easier access
    @db.results_as_hash = true
    @db
  end

  def self.connection
    connect
  end

  def self.execute(sql, params = [])
    conn = connection
    conn.execute(sql, params)
  rescue SQLite3::Exception => e
    puts "Database error: #{e.message}"
    raise e
  end

  def self.setup_database
    # Create db directory if it doesn't exist
    db_dir = File.dirname(DB_PATH)
    Dir.mkdir(db_dir) unless Dir.exist?(db_dir)

    # Connect to create the file if it doesn't exist
    connection
  end

  def self.table_exists?(table_name)
    query = "SELECT name FROM sqlite_master WHERE type='table' AND name=?"
    result = execute(query, [table_name])
    !result.empty?
  end
end