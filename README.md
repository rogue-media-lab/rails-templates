# Tailwind CSS v4 Theme Template

Applies a custom Tailwind CSS v4 `@theme` to a Rails 8 app using the `tailwind-rails` gem. Overwrites `app/assets/stylesheets/application.tailwind.css` with a preset color palette, font stack, and animation utilities.

## What It Does

- Writes `app/assets/stylesheets/application.tailwind.css` with a custom `@theme` containing:
  - **Ivory scale** — 9-step neutral palette (50–900)
  - **Pastel accents** — pink, lavender, mint, peach, sky, sage
  - **Font stack** — Inter var as the default sans-serif
  - **Animations** — `fadeIn` and `slideUp` utilities via CSS custom properties

## Dependencies

- Rails 8 with the `tailwind-rails` gem (`rails new my-app -c tailwind`)
- No Node.js required — uses the standalone Tailwind CSS CLI bundled with `tailwind-rails`

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/tailwindcss/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/tailwindcss/template.rb
```

## Using the Theme

Values defined in `@theme` generate Tailwind utility classes directly — no arbitrary value syntax needed:

```html
<!-- Colors -->
<div class="bg-ivory-100 text-ivory-900 border-ivory-300">...</div>
<div class="bg-pastel-mint text-green-800">...</div>

<!-- Animations -->
<div class="animate-fade-in">...</div>
<div class="animate-slide-up">...</div>

<!-- Font (overrides the default font-sans utility) -->
<p class="font-sans">Renders in Inter var</p>
```

To add or modify values, edit the `@theme` block in `app/assets/stylesheets/application.tailwind.css`.

---

For the full list of available templates see the [main branch](../../tree/main).
