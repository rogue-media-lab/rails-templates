# Sets up dynamic error pages (404, 422, 500) for a Rails 8 app.
# Routes errors through the Rails stack instead of serving static HTML files,
# so pages render with the full Tailwind layout and ivory theme.

say "Setting up error pages...", :cyan

# --- Route errors through Rails ---
# This replaces the default static file serving for exceptions.
environment "config.exceptions_app = self.routes"

say "Configured exceptions_app in application.rb.", :green

# --- Error routes ---
# Added at the end of routes.rb. These paths are what Rails internally
# redirects to when an exception occurs.
route <<~RUBY
  # Error pages
  match "/404", to: "errors#not_found",             via: :all
  match "/422", to: "errors#unprocessable_entity",  via: :all
  match "/500", to: "errors#internal_server_error", via: :all
RUBY

say "Added error routes to config/routes.rb.", :green

# --- ErrorsController ---
create_file "app/controllers/errors_controller.rb" do
  <<~RUBY
    class ErrorsController < ApplicationController
      # Skip authentication so error pages are always accessible,
      # even if the authentication before_action or session lookup fails.
      skip_before_action :require_authentication, raise: false

      def not_found
        render status: :not_found
      end

      def unprocessable_entity
        render status: :unprocessable_entity
      end

      def internal_server_error
        render status: :internal_server_error
      end
    end
  RUBY
end

say "Created app/controllers/errors_controller.rb.", :green

# --- Views ---
# Shared classes for DRY view generation
error_page_wrap  = "min-h-screen bg-ivory-50 flex items-center justify-center px-4"
error_code_class = "text-8xl font-bold text-ivory-300 mb-4 select-none"
error_title      = "text-2xl font-bold text-ivory-900 mb-3"
error_body       = "text-ivory-600 mb-8 leading-relaxed"
error_link       = "inline-block bg-ivory-800 hover:bg-ivory-900 text-white font-medium py-2 px-6 rounded-md transition-colors text-sm"

create_file "app/views/errors/not_found.html.erb" do
  <<~ERB
    <div class="#{error_page_wrap}">
      <div class="text-center max-w-md">
        <p class="#{error_code_class}">404</p>
        <h1 class="#{error_title}">Page not found.</h1>
        <p class="#{error_body}">The page you're looking for doesn't exist or has been moved.</p>
        <%= link_to "Back to home", root_path, class: "#{error_link}" %>
      </div>
    </div>
  ERB
end

create_file "app/views/errors/unprocessable_entity.html.erb" do
  <<~ERB
    <div class="#{error_page_wrap}">
      <div class="text-center max-w-md">
        <p class="#{error_code_class}">422</p>
        <h1 class="#{error_title}">Invalid request.</h1>
        <p class="#{error_body}">The server couldn't process your request. This can happen if a form was submitted twice or your session expired. Try going back and submitting again.</p>
        <%= link_to "Back to home", root_path, class: "#{error_link}" %>
      </div>
    </div>
  ERB
end

create_file "app/views/errors/internal_server_error.html.erb" do
  <<~ERB
    <div class="#{error_page_wrap}">
      <div class="text-center max-w-md">
        <p class="#{error_code_class}">500</p>
        <h1 class="#{error_title}">Something went wrong.</h1>
        <p class="#{error_body}">An unexpected error occurred on our end. Please try again in a moment.</p>
        <%= link_to "Back to home", root_path, class: "#{error_link}" %>
      </div>
    </div>
  ERB
end

say "Created error page views.", :green
say "\nError pages setup complete.", :blue
