# frozen_string_literal: true

require_relative "../config/database"

#= GuestbookManager
#
# A database manager class that handles all guestbook operations.
# This class provides methods for creating, retrieving, and validating
# guestbook entries in the SQLite database. All methods are class methods
# as this serves as a data access layer rather than an object-oriented
# entity.
#
# @author Your Name
# @version 1.0.0
class GuestbookManager
  # Get all entries from the database
  #
  # Retrieves all guestbook entries from the database, sorted by creation
  # date in descending order (newest first). Each entry includes the ID,
  # visitor name, email, message, and timestamp information.
  #
  # @return [Array<Hash>] An array of guestbook entries as hash objects
  #   - Each hash has keys: 'id', 'visitor_name', 'email', 'message', 'created_at', 'updated_at'
  #   - Empty array if no entries exist
  def self.all
    query = "SELECT id, visitor_name, email, message, created_at, updated_at
             FROM guestbook_entries
             ORDER BY created_at DESC"
    Database.execute(query)
  end

  # Create a new guestbook entry in the database
  #
  # Validates the provided data and creates a new guestbook entry.
  # Uses parameterized queries to prevent SQL injection.
  #
  # @param visitor_name [String] The name of the visitor (required)
  # @param email [String, nil] The email address of the visitor (optional)
  # @param message [String] The message content (required)
  #
  # @return [Integer] The ID of the newly created entry
  #
  # @raise [ArgumentError] If validation fails (empty name/message or invalid email)
  # @raise [SQLite3::Exception] If database operations fail
  #
  # @example Creating an entry with email
  #   GuestbookManager.create(
  #     visitor_name: "John Doe",
  #     email: "john@example.com",
  #     message: "Great site!"
  #   )
  #   # => 42
  #
  # @example Creating an entry without email
  #   GuestbookManager.create(
  #     visitor_name: "Jane Smith",
  #     message: "Nice work!"
  #   )
  #   # => 43
  def self.create(visitor_name:, message:, email: nil)
    # Validate required fields
    raise ArgumentError, "Visitor name cannot be empty" if visitor_name.nil? || visitor_name.strip.empty?
    raise ArgumentError, "Message cannot be empty" if message.nil? || message.strip.empty?

    # Validate email format if provided
    raise ArgumentError, "Invalid email format" if email && !email.empty? && !valid_email?(email)

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
  #
  # Retrieves a single guestbook entry from the database based on its ID.
  #
  # @param id [Integer] The ID of the entry to retrieve
  #
  # @return [Hash, nil] The entry as a hash if found, nil if not found
  #   - Hash keys: 'id', 'visitor_name', 'email', 'message', 'created_at', 'updated_at'
  #
  # @example Finding an existing entry
  #   GuestbookManager.find(42)
  #   # => {'id' => 42, 'visitor_name' => 'John Doe', ...}
  #
  # @example Finding a non-existent entry
  #   GuestbookManager.find(999)
  #   # => nil
  def self.find(id)
    query = "SELECT * FROM guestbook_entries WHERE id = ?"
    results = Database.execute(query, [id])
    results.empty? ? nil : results.first
  end

  # Check if the database exists and is properly initialized
  #
  # Verifies that the database file exists and that the guestbook_entries
  # table has been created. This is used for health checks and for
  # application startup validation.
  #
  # @return [Boolean] true if the database and table exist, false otherwise
  def self.ready?
    Database.table_exists?("guestbook_entries")
  end

  # Basic email format validation
  # Checks if the provided string follows a standard email format
  #
  # Validates email addresses against a regex pattern that matches
  # standard email format (local-part@domain.tld) with optional
  # subdomains. This prevents obviously invalid addresses but
  # doesn't guarantee deliverability.
  #
  # @param email [String, nil] The email address to validate
  #
  # @return [Boolean] true if the email format is valid, false otherwise
  #
  # @example Valid emails
  #   GuestbookManager.valid_email?('user@example.com')
  #   # => true
  #   GuestbookManager.valid_email?('user.name@example.co.uk')
  #   # => true
  #
  # @example Invalid emails
  #   GuestbookManager.valid_email?('invalid-email')
  #   # => false
  #   GuestbookManager.valid_email?('@example.com')
  #   # => false
  #   GuestbookManager.valid_email?(nil)
  #   # => false
  def self.valid_email?(email)
    # More comprehensive regex for email validation
    return false if email.nil? || email.strip.empty?

    # Enhanced email validation - matches standard email format
    # Format: local-part@domain.tld (with subdomains allowed)
    email.match?(/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/i)
  end

  # Validate entry data before attempting to create
  #
  # Checks if the provided data meets all validation requirements
  # for creating a new guestbook entry. This method only validates
  # the input without performing any database operations.
  #
  # @param visitor_name [String] The name of the visitor (required)
  # @param email [String, nil] The email address of the visitor (optional)
  # @param message [String] The message content (required)
  #
  # @return [Array<String>] An array of validation error messages
  #   - Empty array if validation passes
  #   - Array with one or more error messages if validation fails
  #   - Possible errors: "Visitor name cannot be empty", "Message cannot be empty", "Invalid email format"
  #
  # @example Valid entry
  #   GuestbookManager.valid_entry?(
  #     visitor_name: "John Doe",
  #     email: "john@example.com",
  #     message: "Great site!"
  #   )
  #   # => []
  #
  # @example Entry with missing name
  #   GuestbookManager.valid_entry?(
  #     visitor_name: "",
  #     email: "john@example.com",
  #     message: "Great site!"
  #   )
  #   # => ["Visitor name cannot be empty"]
  def self.valid_entry?(visitor_name:, message:, email: nil)
    errors = []

    errors << "Visitor name cannot be empty" if visitor_name.nil? || visitor_name.strip.empty?
    errors << "Message cannot be empty" if message.nil? || message.strip.empty?

    errors << "Invalid email format" if email && !email.empty? && !valid_email?(email)

    errors
  end
end
