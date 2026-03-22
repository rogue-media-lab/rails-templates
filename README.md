# Letter Opener Template

Configures ActionMailer to open emails in the browser during development using the [`letter_opener`](https://github.com/ryanb/letter_opener) gem. No emails are sent — each delivery opens a new browser tab showing the rendered email.

## What It Does

1. Adds `letter_opener` to the `development` group in the `Gemfile`

2. Adds three lines to `config/environments/development.rb`:
   ```ruby
   config.action_mailer.delivery_method    = :letter_opener
   config.action_mailer.perform_deliveries = true
   config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
   ```
   The `default_url_options` setting provides a host so mailers can generate full URLs — required for things like password reset links from the `authentication` template.

## Dependencies

- Rails 8
- The [`authentication` template](../../tree/authentication) is optional — if applied, password reset emails will open in the browser automatically with no additional setup

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/letter-opener/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/letter-opener/template.rb
```

## Sending a Test Email

Trigger any mailer action from the Rails console to verify the setup:

```ruby
# With the authentication template applied:
PasswordsMailer.reset(User.first).deliver_now
```

A browser tab will open with the rendered email.

---

For the full list of available templates see the [main branch](../../tree/main).
