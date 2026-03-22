# Sets up Rails 8 built-in authentication and styles the generated views
# with the ivory Tailwind theme.
#
# Runs `rails generate authentication`, which creates:
#   - User and Session models with migrations
#   - SessionsController and PasswordsController
#   - Authentication concern (app/controllers/concerns/authentication.rb)
#   - Views for sign-in and password reset
#
# This template then overwrites those views with Tailwind-styled versions.

say "Running Rails 8 authentication generator...", :cyan

generate "authentication"
rails_command "db:migrate"

say "Authentication scaffold generated.", :green

# Shared input field class used across all auth forms
INPUT_CLASS  = "w-full px-3 py-2 border border-ivory-300 rounded-md text-ivory-900 " \
               "placeholder-ivory-400 bg-white focus:outline-none focus:ring-2 " \
               "focus:ring-ivory-500 focus:border-transparent text-sm"
LABEL_CLASS  = "block text-sm font-medium text-ivory-700 mb-1"
BUTTON_CLASS = "w-full bg-ivory-800 hover:bg-ivory-900 text-white font-medium " \
               "py-2 px-4 rounded-md transition-colors cursor-pointer text-sm"
CARD_WRAP    = "min-h-screen bg-ivory-50 flex items-center justify-center px-4"
CARD_INNER   = "w-full max-w-md bg-white border border-ivory-200 rounded-lg shadow-sm px-8 py-10"

say "Styling authentication views...", :cyan

# --- Sign In ---
create_file "app/views/sessions/new.html.erb", force: true do
  <<~ERB
    <div class="#{CARD_WRAP}">
      <div class="#{CARD_INNER}">
        <h1 class="text-2xl font-bold text-ivory-900 mb-8 text-center">Sign in</h1>

        <%= form_with url: session_path do |form| %>
          <div class="space-y-5">

            <div>
              <%= form.label :email_address, "Email", class: "#{LABEL_CLASS}" %>
              <%= form.email_field :email_address,
                    required: true,
                    autofocus: true,
                    autocomplete: "username",
                    class: "#{INPUT_CLASS}" %>
            </div>

            <div>
              <%= form.label :password, "Password", class: "#{LABEL_CLASS}" %>
              <%= form.password_field :password,
                    required: true,
                    autocomplete: "current-password",
                    class: "#{INPUT_CLASS}" %>
            </div>

            <div class="flex justify-end">
              <%= link_to "Forgot password?", new_password_path,
                    class: "text-sm text-ivory-600 hover:text-ivory-900 transition-colors" %>
            </div>

            <%= form.submit "Sign in", class: "#{BUTTON_CLASS}" %>

          </div>
        <% end %>
      </div>
    </div>
  ERB
end

say "Styled app/views/sessions/new.html.erb.", :green

# --- Forgot Password ---
create_file "app/views/passwords/new.html.erb", force: true do
  <<~ERB
    <div class="#{CARD_WRAP}">
      <div class="#{CARD_INNER}">
        <h1 class="text-2xl font-bold text-ivory-900 mb-2 text-center">Forgot password?</h1>
        <p class="text-sm text-ivory-600 text-center mb-8">Enter your email and we'll send you a reset link.</p>

        <%= form_with url: passwords_path do |form| %>
          <div class="space-y-5">

            <div>
              <%= form.label :email_address, "Email", class: "#{LABEL_CLASS}" %>
              <%= form.email_field :email_address,
                    required: true,
                    autofocus: true,
                    autocomplete: "username",
                    class: "#{INPUT_CLASS}" %>
            </div>

            <%= form.submit "Send reset link", class: "#{BUTTON_CLASS}" %>

          </div>
        <% end %>

        <p class="mt-6 text-center text-sm text-ivory-600">
          <%= link_to "Back to sign in", new_session_path,
                class: "font-medium text-ivory-700 hover:text-ivory-900 transition-colors" %>
        </p>
      </div>
    </div>
  ERB
end

say "Styled app/views/passwords/new.html.erb.", :green

# --- Reset Password ---
create_file "app/views/passwords/edit.html.erb", force: true do
  <<~ERB
    <div class="#{CARD_WRAP}">
      <div class="#{CARD_INNER}">
        <h1 class="text-2xl font-bold text-ivory-900 mb-8 text-center">Reset password</h1>

        <%= form_with url: password_path(params[:token]), method: :patch do |form| %>
          <div class="space-y-5">

            <div>
              <%= form.label :password, "New password", class: "#{LABEL_CLASS}" %>
              <%= form.password_field :password,
                    required: true,
                    autocomplete: "new-password",
                    class: "#{INPUT_CLASS}" %>
            </div>

            <div>
              <%= form.label :password_confirmation, "Confirm new password", class: "#{LABEL_CLASS}" %>
              <%= form.password_field :password_confirmation,
                    required: true,
                    autocomplete: "new-password",
                    class: "#{INPUT_CLASS}" %>
            </div>

            <%= form.submit "Reset password", class: "#{BUTTON_CLASS}" %>

          </div>
        <% end %>
      </div>
    </div>
  ERB
end

say "Styled app/views/passwords/edit.html.erb.", :green

# --- Navbar integration (optional) ---
# If the navbar template has been applied, inject sign-in/sign-out links
# into the desktop and mobile nav sections.
navbar_partial = "app/views/shared/_navbar.html.erb"

if File.exist?(navbar_partial)
  say "Navbar detected — injecting auth links...", :cyan

  # Desktop: insert auth links before the closing </div> of the sm:flex section
  gsub_file navbar_partial,
    /(<div class="hidden sm:flex sm:items-center sm:gap-1">)(.*?)(        <\/div>)/m do |match|
    desktop_auth = <<~ERB.chomp
          <% if Current.session %>
            <%= link_to "Sign out", session_path, data: { turbo_method: :delete },
                  class: "text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
          <% else %>
            <%= link_to "Sign in", new_session_path,
                  class: "text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
          <% end %>
    ERB
    $1 + $2 + desktop_auth + "\n" + $3
  end

  # Mobile: insert auth links before the closing </div> of the mobile menu
  gsub_file navbar_partial,
    /(<div class="px-2 py-2 space-y-1">)(.*?)(      <\/div>)/m do |match|
    mobile_auth = <<~ERB.chomp
          <% if Current.session %>
            <%= link_to "Sign out", session_path, data: { turbo_method: :delete },
                  class: "block text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
          <% else %>
            <%= link_to "Sign in", new_session_path,
                  class: "block text-ivory-700 hover:text-ivory-900 hover:bg-ivory-200 px-3 py-2 rounded-md text-sm font-medium transition-colors" %>
          <% end %>
    ERB
    $1 + $2 + mobile_auth + "\n" + $3
  end

  say "Auth links injected into navbar.", :green
else
  say "Navbar partial not found — skipping navbar integration.", :yellow
  say "If you apply the navbar template later, add sign-in/sign-out links manually.", :yellow
end

say "\nAuthentication setup complete.", :blue
