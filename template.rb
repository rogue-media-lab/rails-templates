# Configures ActionMailer to open emails in the browser during development.
# Uses the letter_opener gem — no emails are sent; each delivery opens a
# new browser tab showing the rendered email.

say "Configuring letter_opener for development mail...", :cyan

gem "letter_opener", group: :development

after_bundle do
  # Set the delivery method to letter_opener in development
  environment "config.action_mailer.delivery_method   = :letter_opener", env: "development"
  environment "config.action_mailer.perform_deliveries = true",           env: "development"

  # Provide a default host so mailers can generate full URLs (e.g. password reset links)
  environment 'config.action_mailer.default_url_options = { host: "localhost", port: 3000 }',
              env: "development"

  say "Configured ActionMailer in config/environments/development.rb.", :green
  say "\nLetter opener setup complete.", :blue
  say "Emails sent in development will open automatically in your browser.", :yellow
end
