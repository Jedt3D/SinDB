# Implementation Task List

## Phase 1: Project Setup
- [x] Initialize git repository
- [x] Create project specification
- [ ] Create Gemfile with dependencies
- [ ] Set up basic project directory structure

## Phase 2: Database Setup
- [ ] Create config/database.rb with connection logic
- [ ] Create db/schema.sql with guestbook_entries table
- [ ] Create migration utility for executing SQL files
- [ ] Set up database initialization script

## Phase 3: Core Application Logic
- [ ] Create lib/guestbook.rb database manager
- [ ] Implement GuestbookManager class
- [ ] Add validation methods for entry data
- [ ] Add query methods for retrieving entries

## Phase 4: Sinatra Application
- [ ] Create app.rb main application file
- [ ] Implement GET / route for displaying entries and form
- [ ] Implement POST /entries route for creating entries
- [ ] Add basic error handling
- [ ] Set up environment configuration

## Phase 5: User Interface
- [ ] Create views/layout.erb with structure
- [ ] Create views/index.erb to display entries
- [ ] Create views/form.erb for submission
- [ ] Create public/style.css for basic styling

## Phase 6: Testing & Finalization
- [ ] Manual testing of functionality
- [ ,#] Review code for improvements
- [ ] Final commit and push to GitHub

## Detailed Breakdown

### Database Manager Methods
- `all()` - Returns all entries in reverse chronological order
- `create(visitor_name, email, message)` - Creates new entry with validation
- `valid?()` - Validates required fields
- `exists?()` - Checks if database and tables exist

### Sinatra Route Handles
- `GET /` - Retrieve and display entries, show form
- `POST /entries` - Process form submission, create entry, redirect

### View Templates
- Layout with semantic HTML structure
- Form with validation feedback
- Entries display with proper formatting