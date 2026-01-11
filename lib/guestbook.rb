# frozen_string_literal: true

require_relative '../config/database'

# Database manager for guestbook operations
class GuestbookManager
  # Get all entries, sorted by created_at in descending order (newest first)
  def self.all
    query = "SELECT id, visitor_name, email, message, created_at, updated_at
             FROM guestbook_entries
             ORDER BY created_at DESC"
    Database.execute(query)
  end

  # Create a new guestbook entry
  # Returns id if successful, raises exception if validation fails
  def self.create(visitor_name, email: nil, message:)
    # Validate required fields
    raise ArgumentError, "Visitor name cannot be empty" if visitor_name.nil? || visitor_name.strip.empty?
    raise ArgumentError, "Message cannot be empty" if message.nil? || message.strip.empty?
    
    # Validate email format if provided
    if email && !email.empty?
      raise ArgumentError, "Invalid email format" unless valid_email?(email)
    end
    
    # Insert the new entry (SQL injection safe with parameterized queries)
    query = "INSERT INTO guestbook_entries (visitor_name, email, message)
             VALUES (?, ?, ?)"
    
    Database.execute(query, [visitor_name, email, message])
    Database.connection.last_insert_row_id
  rescue SQLite3::Exception => e
    puts "Error creating entry: #{e.message}"
    raise e
  end

  # Get a single entry by ID
  def self.find(id)
    query = "SELECT * FROM guestbook_entries WHERE id = ?"
    results = Database.execute(query, [id])
    results.empty? ? nil : results.first
  end

  # Check if the guestbook exists and is properly initialized
  def self.ready?
    Database.table_exists?('guestbook_entries')
  end

  # Basic email format validation
  def self.valid_email?(email)
    # Simple regex for email validation
    # In production, you'd want a more robust validation
    email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end
  
  # Validate entry data before attempting to create
  def self.valid_entry?(visitor_name:, email: nil, message:)
    errors = []
    
    errors << "Visitor name cannot be empty" if visitor_name.nil? || visitor_name.strip.empty?
    errors << "Message cannot be empty" if message.nil? || message.strip.empty?
    
    if email && !email.empty?
      errors << "Invalid email format" unless valid_email?(email)
    end
    
    errors
  end
end