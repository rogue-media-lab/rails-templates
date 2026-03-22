# Rails 8 Application Templates

A collection of [Rails application templates](https://guides.rubyonrails.org/rails_application_templates.html) for scaffolding and configuring Rails 8 apps. Each branch contains a `template.rb` that can be applied to a new or existing app using the Rails template API.

## Available Templates

| Branch | Description |
|---|---|
| [`main`](../../tree/main) | Configures `.gitignore` and GitHub Actions CI with PostgreSQL |
| [`tailwindcss`](../../tree/tailwindcss) | Applies a custom Tailwind CSS v4 theme — colors, fonts, and animations |
| [`flash-message`](../../tree/flash-message) | Adds a Stimulus-powered flash message component |

## Recommended Order

When setting up a new app, apply templates in this order:

```
1. main          → base git and CI configuration
2. tailwindcss   → Tailwind theme (required before flash-message)
3. flash-message → depends on the Tailwind theme from step 2
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
