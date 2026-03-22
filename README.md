# RSpec Template

Replaces Minitest with RSpec, FactoryBot, and Faker in a Rails 8 app. Installs and configures the full testing stack and updates the CI workflow if the `main` template has already been applied.

## What It Does

1. Adds gems to the `Gemfile`:
   - `rspec-rails` (test)
   - `factory_bot_rails` (development, test)
   - `faker` (development, test)

2. Runs `rails generate rspec:install`, which creates:
   - `.rspec`
   - `spec/spec_helper.rb`
   - `spec/rails_helper.rb`

3. Uncomments the support file autoloader in `spec/rails_helper.rb`
   ```ruby
   Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
   ```

4. Creates `spec/support/factory_bot.rb` — includes `FactoryBot::Syntax::Methods` so factories can be called without the `FactoryBot.` prefix

5. Creates `spec/support/capybara.rb` — configures Capybara with a 5-second wait time and silent Puma server for system specs

6. Updates `.github/workflows/ci.yml` if present — replaces the Minitest test command with `bundle exec rspec`

## Dependencies

- Rails 8
- The [`base` template](../../tree/base) is optional — if the CI workflow exists, the test command is updated automatically

## Usage

**Option 1 — Raw URL**

Navigate to this branch, open `template.rb`, click **Raw**, and pass the URL.

**Option 2 — Local file**

Copy `template.rb` into your project directory and pass the local path instead.

### New app

```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/rspec/template.rb
```

### Existing app

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/rspec/template.rb
```

## After Applying

Remove the Minitest directory if it is no longer needed:

```bash
rm -rf test/
```

## Writing Tests

**Model spec**

```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  it "is valid with a valid email" do
    user = build(:user)
    expect(user).to be_valid
  end
end
```

**Factory**

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.unique.email }
    password      { "password" }
  end
end
```

**System spec**

```ruby
# spec/system/sign_in_spec.rb
RSpec.describe "Sign in", type: :system do
  let(:user) { create(:user) }

  it "signs in with valid credentials" do
    visit new_session_path
    fill_in "Email", with: user.email_address
    fill_in "Password", with: "password"
    click_button "Sign in"
    expect(page).to have_current_path(root_path)
  end
end
```

---

For the full list of available templates see the [main branch](../../tree/main).
