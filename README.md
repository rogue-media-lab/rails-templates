# Navbar Template

Adds a responsive, sticky navbar to a Rails 8 app. Includes a Stimulus controller for the mobile menu toggle and a shared ERB partial styled with the ivory color theme.

## What It Does

1. Creates a Stimulus controller at `app/javascript/controllers/navbar_controller.js`
   - Toggles the mobile menu open and closed
   - Swaps the hamburger and close icons on toggle

2. Creates a shared ERB partial at `app/views/shared/_navbar.html.erb`
   - Sticky top positioning (`sticky top-0 z-40`) — stays visible while scrolling
   - Brand link auto-populated from the Rails app name
   - Desktop nav links (horizontal, hidden on mobile)
   - Mobile hamburger menu with a slide-down link list
   - Styled with the ivory palette from the `tailwindcss` template

3. Injects `<%= render "shared/navbar" %>` into `app/views/layouts/application.html.erb` before `<%= yield %>`

## Dependencies

- Rails 8 with Hotwire (Stimulus is included by default)
- The [`tailwindcss` template](../../tree/tailwindcss) applied first — provides the ivory color theme used for backgrounds, borders, and text

## Compatibility with Flash Messages

The [`flash-message` template](../../tree/flash-message) positions its container at `top-20` (80px), which aligns with this navbar's `h-16` (64px) height. Apply `navbar` before `flash-message` for correct stacking.

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/navbar/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/navbar/template.rb
```

## Customizing Nav Links

Add links to the desktop and mobile sections of `app/views/shared/_navbar.html.erb`:

```erb
<%# Desktop — add inside the sm:flex div %>
<%= link_to "About", about_path,
      class: "text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>

<%# Mobile — add inside the mobile menu div %>
<%= link_to "About", about_path,
      class: "block text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
```

---

For the full list of available templates see the [main branch](../../tree/main).
