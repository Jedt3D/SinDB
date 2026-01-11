#!/usr/bin/env ruby
# frozen_string_literal: true

require "./app"

# Run the application using Puma when deployed to production
# this allows the app to be run with rackup
run GuestbookApp
