# Authentication Template

Sets up Rails 8 built-in authentication and styles the generated views with the ivory Tailwind theme. Uses the first-party `rails generate authentication` generator — no Devise or third-party gems required.

## What It Does

1. Runs `rails generate authentication`, which creates:
   - `User` and `Session` models with migrations
   - `SessionsController` (sign in / sign out)
   - `PasswordsController` (forgot password / reset password)
   - `Authentication` concern included in `ApplicationController`
   - Mailer for password reset emails

2. Runs `db:migrate`

3. Overwrites the generated views with Tailwind-styled versions:
   - `app/views/sessions/new.html.erb` — sign-in form
   - `app/views/passwords/new.html.erb` — forgot password form
   - `app/views/passwords/edit.html.erb` — reset password form

4. Injects sign-in / sign-out links into the navbar if `app/views/shared/_navbar.html.erb` exists (applied by the [`navbar` template](../../tree/navbar))
   - Uses `Current.session` to conditionally render the correct link
   - Adds links to both the desktop and mobile nav sections
   - Skipped gracefully if the navbar partial is not present

## Dependencies

- Rails 8
- The [`tailwindcss` template](../../tree/tailwindcss) applied first — provides the ivory color theme used in the styled views
- The [`navbar` template](../../tree/navbar) is optional — auth links are injected automatically if the navbar partial is present

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/authentication/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/authentication/template.rb
```

## Protecting Routes

The `Authentication` concern is included in `ApplicationController` by default. Use `allow_unauthenticated_access` to open specific actions:

```ruby
class HomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
  end
end
```

## Creating the First User

Rails 8 authentication does not ship with a registration flow. Create your first user in the console or via seeds:

```ruby
User.create!(email_address: "you@example.com", password: "your_password")
```

---

For the full list of available templates see the [main branch](../../tree/main).
