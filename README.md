# Rails 8 Application Templates

A collection of [Rails application templates](https://guides.rubyonrails.org/rails_application_templates.html) for scaffolding and configuring Rails 8 apps. Each branch contains a `template.rb` that can be applied to a new or existing app using the Rails template API.

## Available Templates

| Branch | Description |
|---|---|
| [`main`](../../tree/main) | Configures `.gitignore` and GitHub Actions CI with PostgreSQL |
| [`tailwindcss`](../../tree/tailwindcss) | Applies a custom Tailwind CSS v4 theme — colors, fonts, and animations |
| [`navbar`](../../tree/navbar) | Adds a responsive sticky navbar with a Stimulus-powered mobile menu |
| [`authentication`](../../tree/authentication) | Runs Rails 8 built-in auth generator and styles the views with the ivory theme |
| [`error-pages`](../../tree/error-pages) | Dynamic 404, 422, and 500 error pages styled with the ivory theme |
| [`rspec`](../../tree/rspec) | Replaces Minitest with RSpec, FactoryBot, and Faker; updates CI |
| [`flash-message`](../../tree/flash-message) | Adds a Stimulus-powered flash message component |

## Recommended Order

When setting up a new app, apply templates in this order:

```
1. main           → base git and CI configuration
2. tailwindcss    → Tailwind theme (required before all UI templates)
3. navbar         → apply before flash-message for correct z-index stacking
4. authentication → injects nav links automatically if navbar is present
5. error-pages    → no dependencies beyond tailwindcss, apply any time
6. rspec          → apply after main so CI is updated automatically
7. flash-message  → depends on the Tailwind theme and navbar height
```

## Usage

**Option 1 — Raw URL**

Navigate to the branch, open `template.rb`, click **Raw**, and pass the URL to the `-m` flag or `LOCATION=`.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

---

## Main Template

Appends `/vendor/bundle` to `.gitignore` and writes a full GitHub Actions CI workflow configured for PostgreSQL. The pipeline includes Brakeman (Ruby security scan), importmap audit (JS dependency scan), RuboCop (linting), and Minitest with system tests.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

---

## Tailwind CSS Template

See the [`tailwindcss` branch](../../tree/tailwindcss) for full details.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/tailwindcss/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/tailwindcss/template.rb
```

---

## Navbar Template

See the [`navbar` branch](../../tree/navbar) for full details.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/navbar/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/navbar/template.rb
```

---

## Authentication Template

See the [`authentication` branch](../../tree/authentication) for full details.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/authentication/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/authentication/template.rb
```

---

## Error Pages Template

See the [`error-pages` branch](../../tree/error-pages) for full details.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/error-pages/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/error-pages/template.rb
```

---

## RSpec Template

See the [`rspec` branch](../../tree/rspec) for full details.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/rspec/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/rspec/template.rb
```

---

## Flash Message Template

See the [`flash-message` branch](../../tree/flash-message) for full details.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/flash-message/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/flash-message/template.rb
```

---

## Compatibility

- Rails 8+
- PostgreSQL
- [`tailwind-rails`](https://github.com/rails/tailwindcss-rails) gem — no Node.js required
