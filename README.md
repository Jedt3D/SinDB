# SinaDB - Web-Based Guestbook Application

A simple, elegant web-based guestbook application built with Sinatra and SQLite. This project demonstrates modern web development practices including input validation, security, and clean code organization.

## Features

- **Sign the Guestbook:** Visitors can enter their name, email (optional), and message
- **View Entries:** All guestbook entries are displayed in reverse chronological order (newest first)
- **Data Persistence:** All entries are stored in a SQLite database
- **Input Validation:** Server-side validation ensures data integrity
- **XSS Protection:** User input is HTML-escaped before display
- **SQL Injection Prevention:** Parameterized database queries
- **Health Check:** Built-in monitoring endpoint for deployment pipelines
- **Responsive Design:** Clean, modern UI that works on all device sizes

## Requirements

- Ruby 3.2.8 or higher
- SQLite3
- Bundler

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/SinaDB.git
   cd SinaDB
   ```

2. **Install Ruby version**
   ```bash
   rbenv install 3.2.8
   rbenv local 3.2.8
   ```

3. **Install gems**
   ```bash
   bundle install
   ```

4. **Initialize the database**
   ```bash
   ruby db/migrate.rb
   ```

5. **Add sample data (optional)**
   ```bash
   ruby add_sample_records.rb
   ```

## Running the Application

Start the development server:

```bash
bundle exec ruby app.rb
```

The application will start on `http://localhost:4567`

For automatic server reload on code changes, use:

```bash
bundle exec rerun 'ruby app.rb'
```

## Project Structure

```
SinaDB/
├── README.md                  # This file
├── api.md                     # API documentation
├── app.rb                     # Main Sinatra application
├── config.ru                  # Rack configuration
├── Gemfile                    # Ruby gem dependencies
├── .rubocop.yml              # Code style configuration
│
├── config/
│   └── database.rb           # Database configuration and connection
│
├── db/
│   ├── migrate.rb            # Database schema setup
│   └── sina.db               # SQLite database (created after migration)
│
├── lib/
│   └── guestbook.rb          # GuestbookManager class (data access layer)
│
├── public/
│   └── style.css             # Styling for the application
│
├── views/
│   ├── index.erb             # Main guestbook page template
│   └── layout.erb            # Base HTML layout template
│
└── test/
    ├── test_guestbook.rb     # Unit tests for GuestbookManager
    └── test_submission.rb    # Integration tests for form submission
```

## Database

The application uses SQLite for data storage. The database schema includes a single table:

```sql
CREATE TABLE guestbook_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  visitor_name TEXT NOT NULL,
  email TEXT,
  message TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### Database Initialization

To set up the database schema:

```bash
ruby db/migrate.rb
```

This will create the SQLite database file at `db/sina.db` with the necessary table structure.

## API Endpoints

### GET /
Main page displaying all guestbook entries and the submission form.

### POST /entries
Creates a new guestbook entry with validation.

**Parameters:**
- `visitor_name` (required): Name of the visitor
- `email` (optional): Email address
- `message` (required): The message content

### GET /health
Health check endpoint returning JSON with application status.

See [api.md](api.md) for detailed API documentation.

## Code Quality

This project uses RuboCop for code quality enforcement. All code passes RuboCop checks with no offenses detected.

### Running RuboCop

```bash
bundle exec rubocop
```

Auto-correct fixable offenses:

```bash
bundle exec rubocop -a
```

## Testing

Run the test suite:

```bash
bundle exec ruby test/test_guestbook.rb
bundle exec ruby test/test_submission.rb
```

## Development

### Adding New Features

1. Follow the existing code structure and patterns
2. Add comprehensive documentation using YARD format
3. Ensure code passes RuboCop checks
4. Write tests for new functionality
5. Update API documentation if endpoints are added

### Code Documentation

This project uses YARD-style comments for code documentation. Key classes and methods include:

- **GuestbookApp:** Main Sinatra application class
- **GuestbookManager:** Database operations and data access layer
- **Database:** Database connection management

To view inline documentation:

```bash
bundle exec yard doc
```

## Deployment

### Environment Setup

The application looks for a SQLite database at `db/sina.db`. Ensure the `db` directory exists and is writable by the application process.

### Running on Production

Use a production-grade server like Puma:

```bash
bundle exec puma -t 8:16 -w 3
```

## Dependencies

Core dependencies:
- **sinatra** (~> 4.0): Web application framework
- **sqlite3** (~> 1.6): SQLite database adapter
- **puma** (~> 6.0): Web server

Development dependencies:
- **rerun** (~> 0.14): Auto-reload on file changes
- **rubocop** (~> 1.57): Code quality checker

## Security Considerations

This application implements several security best practices:

- **Input Validation:** All user input is validated server-side
- **XSS Prevention:** User-generated content is HTML-escaped before display
- **SQL Injection Prevention:** All SQL queries use parameterized values
- **Session Support:** Includes session management for flash messages

For production deployment, consider adding:
- User authentication
- Rate limiting
- HTTPS enforced
- Content Security Policy headers
- CSRF protection

## Contributing

Contributions are welcome! Please ensure:
1. Code follows RuboCop guidelines
2. All tests pass
3. Documentation is included for new features
4. Commit messages are clear and descriptive

## License

This project is open source and available under the MIT License.

## Support

For questions or issues, please open a GitHub issue or contact the development team.

## Changelog

### Version 1.0.0
- Initial release
- Guestbook entry creation and viewing
- Input validation and security features
- Health check endpoint
- Comprehensive documentation