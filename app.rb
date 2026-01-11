# frozen_string_literal: true

# Require necessary gems and libraries
require 'sinatra/base'
require 'json'
require_relative './lib/guestbook'
require_relative './config/database'

# Main Sinatra application class
class GuestbookApp < Sinatra::Base
  # Enable sessions for flash messages (errors, success messages)
  enable :sessions
  
  # Set up public folder for static assets (CSS, images, etc.)
  set :public_folder, File.dirname(__FILE__) + '/public'
  
  # Show exceptions in development mode for easier debugging
  set :show_exceptions, true

  # Main route - display all entries and submission form
  get '/' do
    @entries = GuestbookManager.all
    @errors = session[:errors] if session[:errors]
    @success = session[:success] if session[:success]
    
    # Clear flash messages after displaying to prevent persistence
    session.delete(:errors)
    session.delete(:success)
    
    erb :index
  end

  # Route to handle form submission for new guestbook entries
  post '/entries' do
    # Extract form parameters
    visitor_name = params[:visitor_name]
    email = params[:email]  # This field is optional
    message = params[:message]
    
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
        redirect to('/')
      rescue StandardError => e
        # Store error message if something goes wrong with database operations
        session[:errors] = ["An error occurred: #{e.message}"]
        redirect to('/')
      end
    else
      # Store validation errors in session and redirect back to form
      session[:errors] = errors
      redirect to('/')
    end
  end
  
  # Simple health check route for monitoring if the application and database are ready
  get '/health' do
    if GuestbookManager.ready?
      content_type :json
      { status: 'ok', database: 'ready' }.to_json
    else
      halt 500, { status: 'error', database: 'not ready' }.to_json
    end
  end

  # Run the app when this file is executed directly (not when required by other files)
  run! if app_file == $0
end