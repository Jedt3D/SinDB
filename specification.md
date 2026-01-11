# Guestbook Database Application Specification

## Overview
A simple web application built with Sinatra 4 and SQLite that allows visitors to sign a digital guestbook without requiring authentication.

## Requirements

### Functional Requirements
1. Visitors can submit guestbook entries with:
   - Visitor name (required)
   - Email address (optional)
   - Message (required)
   - Automatic timestamp recording

2. All guestbook entries can be viewed in reverse chronological order (newest first)

3. Simple web interface for viewing and submitting entries

### Non-Functional Requirements
- Built with Sinatra 4 framework
- Ruby 3.2.8 compatibility
- SQLite database
- Direct SQL queries (no ORM)
- Simple, clean user interface

### Database Schema
- Table: guestbook_entries
- Fields:
  - id (INTEGER PRIMARY KEY AUTOINCREMENT)
  - visitor_name (TEXT NOT NULL)
  - email (TEXT)
  - message (TEXT NOT NULL)
  - created_at (DATETIME DEFAULT CURRENT_TIMESTAMP)
  - updated_at (DATETIME DEFAULT CURRENT_TIMESTAMP)

### Development Approach
Following Spec-Kit Spec-Driven Development methodology:
1. Specification (this document) - Define what to build
2. Plan - Technical implementation approach
3. Tasks - Actionable task list
4. Implement - Execute the implementation