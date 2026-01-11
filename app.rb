# frozen_string_literal: true

#= SinaDB - A Web-based Guestbook Application
#
# This is a simple web-based guestbook application built with Sinatra.
# It allows users to sign a guestbook by entering their name, email (optional),
# and a message. All entries are stored in a SQLite database and displayed
# in reverse chronological order.

# Require necessary gems and libraries
# Sinatra::Base provides the web framework functionality
require "sinatra/base"
# JSON is used for the health check endpoint
require "json"
# Rack::Utils provides HTML escaping for security
require "rack/utils"
# The GuestbookManager handles all database operations
require_relative "lib/guestbook"
# Database configuration and connection management
require_relative "config/database"

# The main Sinatra application class that handles all web requests
#
# @author Your Name
# @version 1.0.0
class GuestbookApp < Sinatra::Base
  # Enable sessions for flash messages (errors, success messages)
  enable :sessions

  # Add HTML escaping helper to templates
  helpers do
    # HTML escaping helper to prevent XSS attacks
    #
    # @param text [String] The text to escape
    # @return [String] The HTML-escaped text
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  # Set up public folder for static assets (CSS, images, etc.)
  set :public_folder, "#{File.dirname(__FILE__)}/public"

  # Show exceptions in development mode for easier debugging
  set :show_exceptions, true

  # Main route - display all entries and submission form
  #
  # Displays all guestbook entries in reverse chronological order
  # along with a form for submitting new entries. Any error or success
  # messages are displayed and then cleared from the session.
  #
  # @return [String] Rendered HTML template with guestbook entries and form
  get "/" do
    # Get all entries in reverse chronological order
    @entries = GuestbookManager.all
    # Display any error messages from previous submissions
    @errors = session[:errors] if session[:errors]
    # Display any success messages from previous submissions
    @success = session[:success] if session[:success]

    # Clear flash messages after displaying to prevent persistence
    session.delete(:errors)
    session.delete(:success)

    # Render the main template
    erb :index
  end

  # Route to handle form submission for new guestbook entries
  #
  # Accepts form data for a new guestbook entry, validates it,
  # and creates the entry in the database. On success or failure,
  # redirects back to the main page with an appropriate message.
  #
  # @return [Redirect] Redirects to the main page after processing
  post "/entries" do
    # Extract form parameters
    visitor_name = params[:visitor_name] # [String] Required visitor name
    email = params[:email]                 # [String] Optional email address
    message = params[:message]             # [String] Required message

    # Validate the entry using our GuestbookManager validation method
    errors = GuestbookManager.valid_entry?(
      visitor_name: visitor_name,
      email: email,
      message: message
    )

    # If validation passes, create the entry
    if errors.empty?
      # Create the guestbook entry with proper error handling
      begin
        @entry_id = GuestbookManager.create(
          visitor_name: visitor_name,
          email: email,
          message: message
        )
        # Store success message in session for display after redirect
        session[:success] = "Your guestbook entry was added successfully!"
        redirect to("/")
      rescue StandardError => e
        # Store error message if something goes wrong with database operations
        session[:errors] = ["An error occurred: #{e.message}"]
        redirect to("/")
      end
    else
      # Store validation errors in session and redirect back to form
      session[:errors] = errors
      redirect to("/")
    end
  end

  # Simple health check route for monitoring if the application and database are ready
  #
  # Returns JSON response indicating application and database status.
  # Used by monitoring systems and deployment scripts to verify
  # that the application is running and can connect to the database.
  #
  # @return [JSON] JSON response with application and database status
  #   - Success: {"status": "ok", "database": "ready"}
  #   - Error: {"status": "error", "database": "not ready"}
  #
  # @example Successful health check
  #   GET /health
  #   # => {"status": "ok", "database": "ready"}
  get "/health" do
    if GuestbookManager.ready?
      content_type :json
      { status: "ok", database: "ready" }.to_json
    else
      halt 500, { status: "error", database: "not ready" }.to_json
    end
  end

  # Run the app when this file is executed directly (not when required by other files)
  run! if app_file == $PROGRAM_NAME
end
