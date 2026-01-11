# frozen_string_literal: true

require_relative "../lib/guestbook"

# Simulate form submissions to validate the backend logic
class TestSubmission
  def self.simulate_form_submission(params)
    # Simulate the app.rb POST parameters extraction
    visitor_name = params[:visitor_name]
    email = params[:email]
    message = params[:message]

    # Call the validation method like the endpoint does
    errors = GuestbookManager.valid_entry?(
      visitor_name: visitor_name,
      email: email,
      message: message
    )

    # If validation passes, create the entry
    if errors.empty?
      begin
        entry_id = GuestbookManager.create(
          visitor_name, email: email, message: message
        )
        { success: true, entry_id: entry_id }
      rescue StandardError => e
        { success: false, error: e.message }
      end
    else
      { success: false, validation_errors: errors }
    end
  end
end

puts "Test 1: Valid form submission"
result = TestSubmission.simulate_form_submission({
                                                   visitor_name: "John Doe",
                                                   email: "john@example.com",
                                                   message: "This is a test message"
                                                 })
puts "Result: #{result}"

puts "\nTest 2: Empty message submission"
result = TestSubmission.simulate_form_submission({
                                                   visitor_name: "John Doe",
                                                   email: "john@example.com",
                                                   message: ""
                                                 })
puts "Result: #{result}"

puts "\nTest 3: Empty name submission"
result = TestSubmission.simulate_form_submission({
                                                   visitor_name: "",
                                                   email: "john@example.com",
                                                   message: "Test message"
                                                 })
puts "Result: #{result}"
