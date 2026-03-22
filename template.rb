# Adds a responsive navbar to a Rails 8 app.
# Creates a Stimulus controller for the mobile menu and a shared ERB partial,
# then injects a render call into the application layout.
# Designed to work with the tailwindcss template — uses the ivory color theme.

say "Setting up navbar component...", :cyan

# --- Stimulus Controller ---
create_file "app/javascript/controllers/navbar_controller.js", <<~JS
  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    static targets = ["menu", "openIcon", "closeIcon"]

    toggle() {
      this.menuTarget.classList.toggle("hidden")
      this.openIconTarget.classList.toggle("hidden")
      this.closeIconTarget.classList.toggle("hidden")
    }
  }
JS

say "Created app/javascript/controllers/navbar_controller.js.", :green

# --- Navbar Partial ---
app_name = Rails.application.class.module_parent_name.underscore.humanize rescue "My App"

create_file "app/views/shared/_navbar.html.erb", <<~ERB
  <nav class="sticky top-0 z-40 bg-ivory-100 border-b border-ivory-300" data-controller="navbar">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between h-16">

        <%# Brand %>
        <div class="flex items-center">
          <%= link_to root_path, class: "text-ivory-900 font-bold text-lg tracking-tight hover:text-ivory-700 transition-colors" do %>
            #{app_name}
          <% end %>
        </div>

        <%# Desktop nav links %>
        <div class="hidden sm:flex sm:items-center sm:gap-1">
          <%= link_to "Home", root_path,
                class: "text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
        </div>

        <%# Mobile menu button %>
        <div class="flex items-center sm:hidden">
          <button data-action="click->navbar#toggle"
                  class="text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 p-2 rounded-md transition-colors"
                  aria-label="Toggle navigation menu">

            <%# Hamburger icon (shown by default) %>
            <svg data-navbar-target="openIcon" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>

            <%# Close icon (hidden by default) %>
            <svg data-navbar-target="closeIcon" class="w-6 h-6 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>

          </button>
        </div>

      </div>
    </div>

    <%# Mobile menu (hidden by default) %>
    <div data-navbar-target="menu" class="hidden sm:hidden border-t border-ivory-300 bg-ivory-50">
      <div class="px-2 py-2 space-y-1">
        <%= link_to "Home", root_path,
              class: "block text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
      </div>
    </div>
  </nav>
ERB

say "Created app/views/shared/_navbar.html.erb.", :green

# --- Inject into Layout ---
# Insert before <%= yield %> so the navbar sits above the main content
# regardless of what other templates have already injected into the layout.
insert_into_file "app/views/layouts/application.html.erb",
  "    <%= render \"shared/navbar\" %>\n",
  before: "    <%= yield %>"

say "Injected navbar into app/views/layouts/application.html.erb.", :green
say "\nNavbar setup complete.", :blue
