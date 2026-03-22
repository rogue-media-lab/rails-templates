# Replaces Minitest with RSpec, FactoryBot, and Faker in a Rails 8 app.
# Adds gems, runs the RSpec installer, creates support files for FactoryBot
# and Capybara, and updates the CI workflow if present.

say "Adding RSpec, FactoryBot, and Faker gems...", :cyan

gem_group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
end

gem_group :test do
  gem "rspec-rails"
end

after_bundle do
  say "Running RSpec installer...", :cyan
  generate "rspec:install"
  say "RSpec installed.", :green

  # --- Uncomment support file loading in rails_helper.rb ---
  # The generator adds this line commented out by default.
  uncomment_lines "spec/rails_helper.rb", /Dir\[Rails.root/

  # --- FactoryBot support file ---
  create_file "spec/support/factory_bot.rb", <<~RUBY
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY

  say "Created spec/support/factory_bot.rb.", :green

  # --- Capybara support file ---
  create_file "spec/support/capybara.rb", <<~RUBY
    require "capybara/rspec"

    Capybara.configure do |config|
      config.default_max_wait_time = 5
      config.server = :puma, { Silent: true }
    end
  RUBY

  say "Created spec/support/capybara.rb.", :green

  # --- Update CI workflow if present ---
  ci_path = ".github/workflows/ci.yml"

  if File.exist?(ci_path)
    say "Updating CI workflow to run RSpec...", :cyan

    # Replace the Minitest test run command with RSpec
    gsub_file ci_path,
      "run: bin/rails db:migrate db:test:prepare test test:system",
      "run: bin/rails db:migrate db:test:prepare && bundle exec rspec"

    say "Updated #{ci_path}.", :green
  else
    say "No CI workflow found — skipping. If you apply the base template later,", :yellow
    say "update the test run command to: bundle exec rspec", :yellow
  end

  say "\nRSpec setup complete.", :blue
  say "The test/ directory can be removed if it is no longer needed:", :yellow
  say "  rm -rf test/", :yellow
end
