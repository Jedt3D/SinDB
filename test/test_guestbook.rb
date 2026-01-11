# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/guestbook"

# Test suite for GuestbookManager
class TestGuestbookManager < Minitest::Test
  def setup
    # Clean up any test data before each test
    Database.execute("DELETE FROM guestbook_entries")
  end

  def test_valid_entry_with_all_fields
    errors = GuestbookManager.valid_entry?(
      visitor_name: "John Doe",
      email: "john@example.com",
      message: "Great guestbook!"
    )
    assert_empty errors, "Should have no validation errors"
  end

  def test_valid_entry_without_email
    errors = GuestbookManager.valid_entry?(
      visitor_name: "Jane Doe",
      email: "",
      message: "Love this guestbook!"
    )
    assert_empty errors, "Should have no validation errors when email is empty"
  end

  def test_invalid_entry_empty_name
    errors = GuestbookManager.valid_entry?(
      visitor_name: "",
      email: "test@example.com",
      message: "Test message"
    )
    assert_includes errors, "Visitor name cannot be empty"
  end

  def test_invalid_entry_empty_message
    errors = GuestbookManager.valid_entry?(
      visitor_name: "John Doe",
      email: "john@example.com",
      message: ""
    )
    assert_includes errors, "Message cannot be empty"
  end

  def test_invalid_entry_nil_message
    errors = GuestbookManager.valid_entry?(
      visitor_name: "John Doe",
      email: "john@example.com",
      message: nil
    )
    assert_includes errors, "Message cannot be empty"
  end

  def test_invalid_email_format
    errors = GuestbookManager.valid_entry?(
      visitor_name: "John Doe",
      email: "invalid-email",
      message: "Test message"
    )
    assert_includes errors, "Invalid email format"
  end

  def test_valid_email_formats
    valid_emails = [
      "user@example.com",
      "user.name@example.com",
      "user+tag@example.co.uk",
      "user_name@example-domain.com"
    ]

    valid_emails.each do |email|
      assert GuestbookManager.valid_email?(email), "#{email} should be valid"
    end
  end

  def test_invalid_email_formats
    invalid_emails = [
      "invalid",
      "invalid@",
      "@example.com",
      "user@.com",
      "user@example",
      ""
    ]

    invalid_emails.each do |email|
      refute GuestbookManager.valid_email?(email), "#{email} should be invalid"
    end
  end

  def test_create_entry_success
    entry_id = GuestbookManager.create(
      visitor_name: "Test User",
      email: "test@example.com",
      message: "This is a test message"
    )

    assert entry_id, "Should return an entry ID"

    # Verify entry was created
    entry = GuestbookManager.find(entry_id)
    assert entry, "Should be able to retrieve the created entry"
    assert_equal "Test User", entry["visitor_name"]
    assert_equal "test@example.com", entry["email"]
    assert_equal "This is a test message", entry["message"]
  end

  def test_create_entry_failure_empty_name
    assert_raises(ArgumentError, "Visitor name cannot be empty") do
      GuestbookManager.create(
        visitor_name: "",
        email: "test@example.com",
        message: "Test message"
      )
    end
  end

  def test_create_entry_failure_empty_message
    assert_raises(ArgumentError, "Message cannot be empty") do
      GuestbookManager.create(
        visitor_name: "Test User",
        email: "test@example.com",
        message: ""
      )
    end
  end

  def test_all_entries_ordered_newest_first
    # Create multiple entries
    GuestbookManager.create(
      visitor_name: "First User",
      message: "First message"
    )

    sleep(0.1) # Ensure different timestamps

    GuestbookManager.create(
      visitor_name: "Second User",
      message: "Second message"
    )

    entries = GuestbookManager.all

    assert_equal 2, entries.length
    # Most recent should be first
    assert_equal "Second User", entries[0]["visitor_name"]
    assert_equal "First User", entries[1]["visitor_name"]
  end
end
