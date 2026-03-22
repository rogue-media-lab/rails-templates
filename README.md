# Blog Template

Adds a full blog to a Rails 8 app — public-facing index and article view, an admin dashboard with full post CRUD, Action Text body editing, and Active Storage cover images. The admin namespace is fully secured; no unauthenticated or non-admin user can access it.

## What It Does

1. Adds an `admin` boolean column to the `User` model (default `false`)

2. Installs Action Text and Active Storage

3. Generates a `Post` model with:
   - `title`, `subtitle` — string fields
   - `body` — rich text via Action Text
   - `cover_image` — file attachment via Active Storage
   - `featured` — boolean, unique partial index enforces only one featured post at a time
   - `published_at` — datetime; `nil` means draft

4. Creates the admin namespace at `/admin`:
   - `Admin::BaseController` — enforces authentication and admin privilege; applies the admin layout
   - `Admin::DashboardController` — post counts and recent activity
   - `Admin::PostsController` — full CRUD with cover image upload and rich text editing

5. Creates the public namespace:
   - `PostsController` — `index` (featured hero + post grid) and `show` (full article); unauthenticated access allowed

6. Sets `root "posts#index"`

7. Creates an admin layout with a persistent sidebar (dashboard, posts, new post, view site, sign out)

8. Seeds the database — prompts for admin email and password at run time, creates the admin user and sample posts

## Admin Security

The admin namespace is protected at two layers:

- **Authentication** — `ApplicationController` includes the Rails 8 `Authentication` concern; unauthenticated requests are redirected to sign in
- **Authorization** — `Admin::BaseController` checks `Current.session&.user&.admin?` before every action; non-admin users are redirected to the public root

No guest or regular user can escalate to admin privilege through the app. Admin accounts must be created via the Rails console or seeds.

```ruby
# Grant admin in the console
User.find_by(email_address: "you@example.com").update!(admin: true)
```

## Dependencies

Apply these templates first, in order:

| Template | Required | Notes |
|---|---|---|
| [`base`](../../tree/base) | Recommended | .gitignore and CI |
| [`tailwindcss`](../../tree/tailwindcss) | **Required** | provides the ivory color theme and animation utilities |
| [`authentication`](../../tree/authentication) | **Required** | provides the `User` model and session management |
| [`navbar`](../../tree/navbar) | Recommended | public blog renders below the sticky navbar |
| [`flash-message`](../../tree/flash-message) | Recommended | flash notices appear in the public layout |

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app (all templates via root)

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

Select `base`, `tailwindcss`, `authentication`, `navbar`, `flash-message`, and `blog` at the prompts.

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/blog/template.rb
```

## After Applying

| URL | Description |
|---|---|
| `/` | Public blog index |
| `/session/new` | Sign in |
| `/admin` | Admin dashboard |
| `/admin/posts` | Manage posts |

## Post Scopes

```ruby
Post.published   # published_at is set and in the past, ordered by published_at desc
Post.featured    # featured: true
Post.drafts      # published_at is nil
```

A `published?` and `draft?` instance method are also available.

---

For the full list of available templates see the [main branch](../../tree/main).
