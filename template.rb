# Rails 8 application template — Rogue Media Lab
#
# Applies all available templates in the recommended order.
# Each template is opt-in. Press Enter to accept or type 'n' to skip.
#
# Recommended order:
#   base          → .gitignore and GitHub Actions CI
#   tailwindcss   → Tailwind CSS v4 theme (required before all UI templates)
#   navbar        → sticky navbar with mobile menu
#   authentication→ Rails 8 built-in auth with styled views
#   error-pages   → dynamic 404/422/500 pages
#   rspec         → RSpec, FactoryBot, and Faker (replaces Minitest)
#   letter-opener → opens emails in the browser during development
#   flash-message → Stimulus-powered flash message component

BASE_URL = "https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads"

say "\nRogue Media Lab — Rails 8 Templates", :blue
say "=====================================", :blue
say "Select which templates to apply. Press Enter to accept (Y) or type 'n' to skip.\n\n", :blue

TEMPLATES = [
  {
    name: "base",
    label: "Base",
    description: "configures .gitignore and GitHub Actions CI"
  },
  {
    name: "tailwindcss",
    label: "Tailwind CSS",
    description: "custom Tailwind CSS v4 theme — colors, fonts, and animations (required for all UI templates)"
  },
  {
    name: "navbar",
    label: "Navbar",
    description: "responsive sticky navbar with Stimulus-powered mobile menu"
  },
  {
    name: "authentication",
    label: "Authentication",
    description: "Rails 8 built-in auth generator with Tailwind-styled views"
  },
  {
    name: "error-pages",
    label: "Error Pages",
    description: "dynamic 404, 422, and 500 error pages styled with the ivory theme"
  },
  {
    name: "rspec",
    label: "RSpec",
    description: "replaces Minitest with RSpec, FactoryBot, and Faker; updates CI"
  },
  {
    name: "letter-opener",
    label: "Letter Opener",
    description: "opens emails in the browser during development"
  },
  {
    name: "flash-message",
    label: "Flash Message",
    description: "Stimulus-powered flash message component with auto-dismiss"
  }
]

selected = TEMPLATES.select do |t|
  answer = ask("  Apply #{t[:label]}? #{t[:description]} [Y/n]:")
  answer.strip.downcase != "n"
end

if selected.empty?
  say "\nNo templates selected. Nothing to apply.", :yellow
else
  say "\nApplying #{selected.length} template(s)...\n", :cyan

  selected.each do |t|
    say "\n--- Applying #{t[:label]} ---", :cyan
    apply "#{BASE_URL}/#{t[:name]}/template.rb"
  end

  say "\nAll done. Templates applied: #{selected.map { |t| t[:label] }.join(', ')}", :green
end
