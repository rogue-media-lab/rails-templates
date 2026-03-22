# Rails 8 Application Templates

![Rails](https://img.shields.io/badge/Rails-8-cc0000?logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-336791?logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

A collection of [Rails application templates](https://guides.rubyonrails.org/rails_application_templates.html) for scaffolding and configuring Rails 8 apps. Each branch contains a `template.rb` that can be applied to a new or existing app using the Rails template API.

## Available Templates

| Branch | Description |
|---|---|
| [`main`](../../tree/main) | Root template — applies all templates interactively in the recommended order |
| [`base`](../../tree/base) | Configures `.gitignore` and GitHub Actions CI with PostgreSQL |
| [`tailwindcss`](../../tree/tailwindcss) | Applies a custom Tailwind CSS v4 theme — colors, fonts, and animations |
| [`navbar`](../../tree/navbar) | Adds a responsive sticky navbar with a Stimulus-powered mobile menu |
| [`authentication`](../../tree/authentication) | Runs Rails 8 built-in auth generator and styles the views with the ivory theme |
| [`error-pages`](../../tree/error-pages) | Dynamic 404, 422, and 500 error pages styled with the ivory theme |
| [`rspec`](../../tree/rspec) | Replaces Minitest with RSpec, FactoryBot, and Faker; updates CI |
| [`letter-opener`](../../tree/letter-opener) | Configures ActionMailer to open emails in the browser during development |
| [`flash-message`](../../tree/flash-message) | Adds a Stimulus-powered flash message component |
| [`blog`](../../tree/blog) | Full blog with admin dashboard, Post CRUD, Action Text body, and Active Storage cover images |

## Recommended Order

When applying templates individually, apply them in this order:

```
1. base           → .gitignore and CI configuration
2. tailwindcss    → Tailwind theme (required before all UI templates)
3. navbar         → apply before flash-message for correct z-index stacking
4. authentication → injects nav links automatically if navbar is present
5. error-pages    → no dependencies beyond tailwindcss, apply any time
6. rspec          → apply after base so CI is updated automatically
7. letter-opener  → no dependencies, apply any time
8. flash-message  → depends on the Tailwind theme and navbar height
9. blog           → requires tailwindcss and authentication; apply after navbar and flash-message
```

The root template on this branch handles the ordering automatically.

## Usage

**Option 1 — Root template (recommended)**

Applies all templates interactively in a single command:

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

Or on an existing app:

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

**Option 2 — Individual templates**

Navigate to the branch for the template you want, open `template.rb`, click **Raw**, and pass the URL to the `-m` flag or `LOCATION=`. See each branch README for branch-specific usage instructions.

---

## Compatibility

- Rails 8+
- PostgreSQL
- [`tailwind-rails`](https://github.com/rails/tailwindcss-rails) gem — no Node.js required
