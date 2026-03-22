# Error Pages Template

Sets up dynamic, Tailwind-styled error pages for 404, 422, and 500 responses. Routes errors through the Rails stack instead of serving static HTML files from `/public`, so pages render with the full application layout and ivory theme.

## What It Does

1. Adds `config.exceptions_app = self.routes` to `config/application.rb`
   - Tells Rails to route exceptions through the app instead of serving static files

2. Adds three catch-all routes to `config/routes.rb`:
   ```
   /404 → errors#not_found
   /422 → errors#unprocessable_entity
   /500 → errors#internal_server_error
   ```

3. Creates `app/controllers/errors_controller.rb`
   - Skips `require_authentication` (with `raise: false` so it's safe whether or not the authentication template was applied)
   - Renders each action with the appropriate HTTP status code

4. Creates three views in `app/views/errors/`:
   - `not_found.html.erb` — 404, page not found
   - `unprocessable_entity.html.erb` — 422, invalid request
   - `internal_server_error.html.erb` — 500, unexpected error
   - Each renders with the full application layout, displaying a large error code, a short title, a plain-language description, and a link back to home

## Dependencies

- Rails 8
- The [`tailwindcss` template](../../tree/tailwindcss) applied first — provides the ivory color theme used in the views

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/error-pages/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/error-pages/template.rb
```

## Testing Error Pages Locally

Rails does not render custom error pages in development by default. To preview them:

```ruby
# config/environments/development.rb
config.consider_all_requests_local = false
```

Revert that change after testing — it suppresses the development error page.

---

For the full list of available templates see the [main branch](../../tree/main).
