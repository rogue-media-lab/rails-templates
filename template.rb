# flash_template.rb (v2)

# This template will:
# 1. Create a Stimulus controller for dismissing flash messages.
# 2. Create a shared partial for rendering flash message content.
# 3. Add the necessary CSS keyframes and animation classes.
#    - It will check for `tailwind.config.js` to detect a Tailwind CSS setup.
#    - If found, it appends `@theme` compatible CSS to `app/assets/stylesheets/tailwind/application.css`.
#    - If not, it falls back to standard CSS in `app/assets/stylesheets/application.css`.
# 4. Inject the partial into the main application layout file with correct indentation.

say "Setting up modern flash message component...", :cyan

# --- Create Stimulus Controller ---
create_file "app/javascript/controllers/flash_messages_controller.js", <<~JS
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Auto-dismiss flash messages after 5 seconds
    this.messageTargets.forEach(message => {
      setTimeout(() => {
        this.dismissMessage(message)
      }, 5000)
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

    setTimeout(() => {
      message.remove()
    }, 300)
  }
}
JS
say "✅ Created Stimulus controller: app/javascript/controllers/flash_messages_controller.js", :green

# --- Create ERB Partial ---
create_file "app/views/shared/_flash_messages.html.erb", <<~ERB
<%# This partial renders the individual flash message cards %>
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
say "✅ Created flash partial: app/views/shared/_flash_messages.html.erb", :green

# --- Add CSS for Animations ---
# CHANGED: Now checks for tailwind.config.js for more reliable detection.
if File.exist?("tailwind.config.js")
  say "tailwind.config.js detected. Appending @theme animation.", :blue
  css_to_add = <<~CSS

    @keyframes slideUp {
      0% { transform: translateY(10px); opacity: 0; }
      100% { transform: translateY(0); opacity: 1; }
    }

    @theme {
      --animate-slide-up: slideUp 0.3s ease-out;
    }
  CSS

  # Check if the @theme directive is already present to avoid duplicates.
  tailwind_css_path = "app/assets/stylesheets/tailwind/application.css"
  if File.read(tailwind_css_path).include?("@theme")
    say "⏩ Animation styles already exist in #{tailwind_css_path}. Skipping.", :yellow
  else
    append_to_file tailwind_css_path, css_to_add
  end
else
  say "Standard CSS setup detected. Appending fallback animation class.", :blue
  append_to_file "app/assets/stylesheets/application.css", <<~CSS

    /* Keyframe for flash message animation */
    @keyframes slideUp {
      0% { transform: translateY(10px); opacity: 0; }
      100% { transform: translateY(0); opacity: 1; }
    }

    /* Animation class for flash messages */
    .animate-slide-up {
      animation: slideUp 0.3s ease-out;
    }
  CSS
  say "⚠️  Warning: A fallback CSS class was added. Your `animate-slide-up` class may not be processed by Tailwind.", :yellow
end

# --- Inject into Layout ---
# CHANGED: Snippet is now indented by two spaces for proper formatting.
layout_snippet = <<~ERB

  <div class="fixed top-20 right-4 z-50 space-y-2" data-controller="flash-messages">
    <%= render "shared/flash_messages" %>
  </div>
ERB

insert_into_file 'app/views/layouts/application.html.erb', layout_snippet, after: "<body>"

say "✅ Injected flash messages into layout: app/views/layouts/application.html.erb", :green

say "\nFlash message component created successfully!", :blue
