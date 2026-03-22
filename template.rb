# Sets up a Tailwind-styled flash message component for Rails 8.
# Creates a Stimulus controller, a shared ERB partial, and injects it into the layout.
# Run the tailwindcss template first — this template builds on that theme.

say "Setting up flash message component...", :cyan

# --- Stimulus Controller ---
create_file "app/javascript/controllers/flash_messages_controller.js", <<~JS
  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    static targets = ["message"]

    connect() {
      this.messageTargets.forEach(message => {
        setTimeout(() => this.dismissMessage(message), 5000)
      })
    }

    dismiss(event) {
      const message = event.currentTarget.closest('[data-flash-messages-target="message"]')
      this.dismissMessage(message)
    }

    dismissMessage(message) {
      message.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out'
      message.style.opacity = '0'
      message.style.transform = 'translateX(100%)'
      setTimeout(() => message.remove(), 300)
    }
  }
JS

say "Created app/javascript/controllers/flash_messages_controller.js.", :green

# --- ERB Partial ---
create_file "app/views/shared/_flash_messages.html.erb", <<~ERB
  <% if notice %>
    <div class="bg-pastel-mint border border-green-200 text-green-800 px-4 py-3 rounded-md shadow-lg max-w-sm animate-slide-up"
         data-flash-messages-target="message"
         data-action="click->flash-messages#dismiss">
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
          </svg>
          <span class="text-sm font-medium"><%= notice %></span>
        </div>
        <button class="ml-2 text-green-600 hover:text-green-800">
          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
          </svg>
        </button>
      </div>
    </div>
  <% end %>

  <% if alert %>
    <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-md shadow-lg max-w-sm animate-slide-up"
         data-flash-messages-target="message"
         data-action="click->flash-messages#dismiss">
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
          </svg>
          <span class="text-sm font-medium"><%= alert %></span>
        </div>
        <button class="ml-2 text-red-600 hover:text-red-800">
          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
          </svg>
        </button>
      </div>
    </div>
  <% end %>
ERB

say "Created app/views/shared/_flash_messages.html.erb.", :green

# --- Animation CSS ---
# Detect Rails 8 tailwind-rails setup by the presence of application.tailwind.css.
# If the tailwindcss template was run first, slideUp is already defined — skip to avoid duplicates.
tailwind_css_path = "app/assets/stylesheets/application.tailwind.css"

if File.exist?(tailwind_css_path)
  if File.read(tailwind_css_path).include?("slideUp")
    say "slideUp animation already defined in #{tailwind_css_path}. Skipping.", :yellow
  else
    append_to_file tailwind_css_path, <<~CSS

      @keyframes slideUp {
        0% { transform: translateY(10px); opacity: 0; }
        100% { transform: translateY(0); opacity: 1; }
      }

      @theme {
        --animate-slide-up: slideUp 0.3s ease-out;
      }
    CSS
    say "Added slideUp animation to #{tailwind_css_path}.", :green
  end
else
  append_to_file "app/assets/stylesheets/application.css", <<~CSS

    /* Flash message animation */
    @keyframes slideUp {
      0% { transform: translateY(10px); opacity: 0; }
      100% { transform: translateY(0); opacity: 1; }
    }

    .animate-slide-up {
      animation: slideUp 0.3s ease-out;
    }
  CSS
  say "Added slideUp animation to app/assets/stylesheets/application.css.", :green
end

# --- Inject into Layout ---
insert_into_file "app/views/layouts/application.html.erb", after: "<body>" do
  <<~ERB

    <div class="fixed top-20 right-4 z-50 space-y-2" data-controller="flash-messages">
      <%= render "shared/flash_messages" %>
    </div>
  ERB
end

say "Injected flash container into app/views/layouts/application.html.erb.", :green
say "\nFlash message component setup complete.", :blue
