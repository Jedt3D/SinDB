# SinaDB API Documentation

This document outlines the API endpoints available in the SinaDB guestbook application.

## Base URL

```
http://localhost:4567
```

## Endpoints

### GET /

Retrieves all guestbook entries and displays the submission form.

#### Response

- **Content-Type:** HTML
- **Body:** HTML page with guestbook entries list and submission form
- **Entries are sorted by creation date in descending order (newest first)**

#### Example Response

```html
<!DOCTYPE html>
<html>
<head>...</head>
<body>
  <h2>Guest Messages</h2>
  <div class="entries-container">
    <article class="guestbook-entry">
      <h3 class="visitor-name">John Doe</h3>
      <div class="entry-content">
        Great website!
      </div>
    </article>
  </div>
  
  <h2>Sign Our Guestbook</h2>
  <form action="/entries" method="post">
    <input type="text" name="visitor_name" placeholder="Your name" required>
    <input type="email" name="email" placeholder="your.email@example.com">
    <textarea name="message" required></textarea>
    <button type="submit">Sign the Guestbook</button>
  </form>
</body>
</html>
```

### POST /entries

Creates a new guestbook entry.

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| visitor_name | String | Yes | The name of the person signing the guestbook |
| email | String | No | The email address of the person (optional) |
| message | String | Yes | The message to be posted |

#### Response

- **Content-Type:** Redirect
- **Location:** `/`
- **Success Flash Message:** "Your guestbook entry was added successfully!"
- **Error Flash Messages:** Displayed if validation fails

#### Validation Rules

- visitor_name: Cannot be empty
- message: Cannot be empty
- email: If provided, must be a valid email format (local-part@domain.tld)

#### Example Request

```bash
curl -X POST \
  -d "visitor_name=John%20Doe&email=john@example.com&message=Great%20website!" \
  "http://localhost:4567/entries"
```

#### Example Successful Response

```
HTTP/1.1 302 Found
Location: http://localhost:4567/
```

#### Example Validation Error Response

```
HTTP/1.1 302 Found
Location: http://localhost:4567/
```

### GET /health

Health check endpoint for monitoring.

#### Response

- **Content-Type:** JSON

#### Example Successful Response

```json
{
  "status": "ok",
  "database": "ready"
}
```

#### Example Database Not Ready Response

```json
{
  "status": "error",
  "database": "not ready"
}
```

#### HTTP Return Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Health check successful |
| 500 | Database not available or not ready |

## Error Handling

The application uses flash messages for error reporting. Errors are displayed on the main page after form submission validation fails.

### Common Error Messages

- "Visitor name cannot be empty"
- "Message cannot be empty"
- "Invalid email format"
- "An error occurred: [database error message]" (if database operations fail)

## Data Schema

Guestbook entries have the following schema:

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

## Rate Limiting

This application does not implement rate limiting. Consider adding it for production use.

## Security Considerations

- User input is HTML-escaped before display to prevent XSS attacks
- SQL queries use parameterized values to prevent SQL injection
- No authentication is implemented; consider adding it for production use