# Flash Message Template

Adds a Tailwind-styled, Stimulus-powered flash message component to a Rails 8 app. Handles both `notice` and `alert` flash types with auto-dismiss and click-to-dismiss behavior.

## What It Does

1. Creates a Stimulus controller at `app/javascript/controllers/flash_messages_controller.js`
   - Auto-dismisses messages after 5 seconds
   - Click anywhere on a message to dismiss immediately

2. Creates a shared ERB partial at `app/views/shared/_flash_messages.html.erb`
   - Renders `notice` (green) and `alert` (red) flash types
   - Styled with Tailwind utility classes

3. Adds `slideUp` animation CSS
   - If `app/assets/stylesheets/application.tailwind.css` is present, appends a `@theme` animation block
   - If the `tailwindcss` template was already applied, the `slideUp` animation is already defined and this step is skipped automatically
   - Falls back to standard CSS in `application.css` for non-Tailwind setups

4. Injects the flash container into `app/views/layouts/application.html.erb` after `<body>`

## Dependencies

- Rails 8 with Hotwire (Stimulus is included by default)
- The [`tailwindcss` template](../../tree/tailwindcss) applied first — provides the color theme (`--color-pastel-mint`) and animation variables used in the partial

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/flash-message/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/flash-message/template.rb
```

## Triggering Flash Messages

In any controller action:

```ruby
redirect_to root_path, notice: "Changes saved."
redirect_to root_path, alert: "Something went wrong."
```

---

For the full list of available templates see the [main branch](../../tree/main).
