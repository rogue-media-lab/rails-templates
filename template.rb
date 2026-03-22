# Blog template for Rails 8 — Rogue Media Lab
#
# Adds a full blog with admin dashboard to an existing Rails 8 app.
# Generates a Post model with Action Text body and Active Storage cover image,
# an admin namespace with full CRUD, and a public-facing index and show.
#
# Required — apply these first:
#   1. base           → .gitignore and CI
#   2. tailwindcss    → Tailwind CSS v4 theme
#   3. authentication → User model and session management
#
# Recommended — apply before this:
#   4. navbar         → sticky navbar (blog index renders below it)
#   5. flash-message  → flash notifications in the public layout

# --- Pre-flight check ---
unless File.exist?("app/models/user.rb")
  say "\nError: User model not found.", :red
  say "Apply the authentication template first:", :yellow
  say "  bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/authentication/template.rb"
  exit 1
end

say "\nSetting up blog...", :cyan

# --- Gems ---
say "Adding image_processing gem...", :cyan
gem "image_processing", "~> 1.2"

after_bundle do
  # --- Admin column on users ---
  say "Adding admin column to users...", :cyan
  generate :migration, "AddAdminToUsers admin:boolean"

  admin_migration = Dir.glob("db/migrate/*_add_admin_to_users.rb").max_by { |f| File.basename(f) }
  if admin_migration
    gsub_file admin_migration,
      "add_column :users, :admin, :boolean",
      "add_column :users, :admin, :boolean, default: false, null: false"
  end

  # --- Action Text + Active Storage ---
  say "Installing Action Text...", :cyan
  rails_command "action_text:install"

  say "Installing Active Storage...", :cyan
  rails_command "active_storage:install"

  # --- Post model ---
  say "Generating Post model...", :cyan
  generate :model, "Post title:string subtitle:string featured:boolean published_at:datetime user:references"

  post_migration = Dir.glob("db/migrate/*_create_posts.rb").max_by { |f| File.basename(f) }
  if post_migration
    gsub_file post_migration,
      "t.boolean :featured",
      "t.boolean :featured, default: false, null: false"

    gsub_file post_migration,
      "      t.timestamps\n    end\n  end",
      "      t.timestamps\n    end\n\n    add_index :posts, :featured, unique: true, where: \"(featured = TRUE)\"\n  end"
  end

  # --- Run all migrations ---
  say "Running migrations...", :cyan
  rails_command "db:migrate"

  # --- Update User model ---
  say "Updating User model...", :cyan
  inject_into_file "app/models/user.rb", before: "end" do
    <<~RUBY

        has_many :posts, dependent: :destroy

        def admin?
          admin
        end
    RUBY
  end

  # --- Update Post model ---
  say "Updating Post model...", :cyan
  gsub_file "app/models/post.rb", /belongs_to :user/, <<~RUBY
    belongs_to :user
    has_rich_text :body
    has_one_attached :cover_image

    scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current).order(published_at: :desc) }
    scope :featured,  -> { where(featured: true) }
    scope :drafts,    -> { where(published_at: nil) }

    def published?
      published_at.present? && published_at <= Time.current
    end

    def draft?
      !published?
    end
  RUBY

  # --- Admin::BaseController ---
  say "Creating admin controllers...", :cyan
  empty_directory "app/controllers/admin"

  create_file "app/controllers/admin/base_controller.rb", <<~RUBY
    class Admin::BaseController < ApplicationController
      before_action :require_admin

      layout "admin"

      private

      def require_admin
        redirect_to root_path, alert: "Not authorized." unless Current.session&.user&.admin?
      end

      def current_user
        Current.session&.user
      end
    end
  RUBY

  # --- Admin::DashboardController ---
  create_file "app/controllers/admin/dashboard_controller.rb", <<~RUBY
    class Admin::DashboardController < Admin::BaseController
      def index
        @post_count      = Post.count
        @published_count = Post.published.count
        @draft_count     = Post.drafts.count
        @recent_posts    = Post.order(created_at: :desc).limit(5)
      end
    end
  RUBY

  # --- Admin::PostsController ---
  create_file "app/controllers/admin/posts_controller.rb", <<~RUBY
    class Admin::PostsController < Admin::BaseController
      before_action :set_post, only: [:show, :edit, :update, :destroy]

      def index
        @posts = Post.order(created_at: :desc)
      end

      def show
      end

      def new
        @post = current_user.posts.new
      end

      def create
        @post = current_user.posts.new(post_params)
        if @post.save
          redirect_to admin_post_path(@post), notice: "Post created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @post.update(post_params)
          redirect_to admin_post_path(@post), notice: "Post updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy
        redirect_to admin_posts_path, notice: "Post deleted."
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :subtitle, :body, :featured, :published_at, :cover_image)
      end
    end
  RUBY

  # --- PostsController (public) ---
  create_file "app/controllers/posts_controller.rb", <<~RUBY
    class PostsController < ApplicationController
      allow_unauthenticated_access

      def index
        @featured_post = Post.published.featured.first
        @posts = Post.published.where.not(id: @featured_post&.id).order(published_at: :desc)
      end

      def show
        @post = Post.published.find(params[:id])
      end
    end
  RUBY

  # --- Routes ---
  say "Updating routes...", :cyan
  route <<~RUBY
    root "posts#index"
    resources :posts, only: [:index, :show]

    namespace :admin do
      root "dashboard#index"
      resources :posts
    end
  RUBY

  # --- Admin layout ---
  say "Creating admin layout...", :cyan

  create_file "app/views/layouts/admin.html.erb", <<~ERB
    <!DOCTYPE html>
    <html>
      <head>
        <title><%= content_for(:title) { "Admin" } %> | <%= Rails.application.class.module_parent_name %></title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <%= csrf_meta_tags %>
        <%= csp_meta_tag %>
        <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
        <%= javascript_importmap_tags %>
      </head>
      <body class="bg-ivory-50 font-sans text-ivory-900">
        <div class="flex h-screen overflow-hidden">

          <aside class="w-60 bg-ivory-900 text-ivory-100 flex flex-col flex-shrink-0">
            <div class="px-6 py-5 border-b border-ivory-700">
              <span class="text-base font-semibold tracking-tight">Admin</span>
            </div>
            <nav class="flex-1 px-3 py-5 space-y-1">
              <%= link_to "Dashboard", admin_root_path,
                    class: "flex items-center px-3 py-2 rounded-md text-sm font-medium text-ivory-300 hover:text-ivory-50 hover:bg-ivory-700 transition-colors" %>
              <%= link_to "Posts", admin_posts_path,
                    class: "flex items-center px-3 py-2 rounded-md text-sm font-medium text-ivory-300 hover:text-ivory-50 hover:bg-ivory-700 transition-colors" %>
              <%= link_to "New Post", new_admin_post_path,
                    class: "flex items-center px-3 py-2 rounded-md text-sm font-medium text-ivory-300 hover:text-ivory-50 hover:bg-ivory-700 transition-colors" %>
            </nav>
            <div class="px-3 py-4 border-t border-ivory-700 space-y-1">
              <%= link_to "View Site →", root_path,
                    class: "block px-3 py-2 rounded-md text-sm text-ivory-400 hover:text-ivory-200 transition-colors" %>
              <%= button_to "Sign out", session_path(Current.session), method: :delete,
                    class: "w-full text-left px-3 py-2 rounded-md text-sm text-ivory-400 hover:text-ivory-200 transition-colors bg-transparent border-0 cursor-pointer" %>
            </div>
          </aside>

          <div class="flex-1 flex flex-col overflow-hidden">
            <header class="bg-white border-b border-ivory-200 px-6 py-4 flex items-center justify-between">
              <h1 class="text-base font-semibold text-ivory-900"><%= content_for(:page_title) { "Dashboard" } %></h1>
              <span class="text-sm text-ivory-400"><%= Current.session&.user&.email_address %></span>
            </header>
            <main class="flex-1 overflow-y-auto p-6">
              <% if notice %>
                <div class="mb-4 bg-pastel-mint border border-green-200 text-green-800 px-4 py-3 rounded-md text-sm"><%= notice %></div>
              <% end %>
              <% if alert %>
                <div class="mb-4 bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-md text-sm"><%= alert %></div>
              <% end %>
              <%= yield %>
            </main>
          </div>

        </div>
      </body>
    </html>
  ERB

  # --- Admin views ---
  say "Creating admin views...", :cyan
  empty_directory "app/views/admin/dashboard"
  empty_directory "app/views/admin/posts"

  create_file "app/views/admin/dashboard/index.html.erb", <<~ERB
    <% content_for :page_title, "Dashboard" %>

    <div class="grid grid-cols-3 gap-6 mb-8">
      <div class="bg-white rounded-lg border border-ivory-200 p-6">
        <p class="text-sm text-ivory-500 mb-1">Total Posts</p>
        <p class="text-3xl font-bold text-ivory-900"><%= @post_count %></p>
      </div>
      <div class="bg-white rounded-lg border border-ivory-200 p-6">
        <p class="text-sm text-ivory-500 mb-1">Published</p>
        <p class="text-3xl font-bold text-green-700"><%= @published_count %></p>
      </div>
      <div class="bg-white rounded-lg border border-ivory-200 p-6">
        <p class="text-sm text-ivory-500 mb-1">Drafts</p>
        <p class="text-3xl font-bold text-ivory-400"><%= @draft_count %></p>
      </div>
    </div>

    <div class="bg-white rounded-lg border border-ivory-200">
      <div class="px-6 py-4 border-b border-ivory-100 flex items-center justify-between">
        <h2 class="text-sm font-semibold text-ivory-700">Recent Posts</h2>
        <%= link_to "View all", admin_posts_path, class: "text-sm text-ivory-400 hover:text-ivory-900 transition-colors" %>
      </div>
      <ul class="divide-y divide-ivory-100">
        <% @recent_posts.each do |post| %>
          <li class="px-6 py-4 flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-ivory-900"><%= post.title %></p>
              <p class="text-xs text-ivory-400 mt-0.5">
                <%= post.published? ? "Published #{post.published_at.strftime('%b %-d, %Y')}" : "Draft" %>
              </p>
            </div>
            <%= link_to "Edit", edit_admin_post_path(post), class: "text-xs text-ivory-400 hover:text-ivory-900 transition-colors" %>
          </li>
        <% end %>
        <% if @recent_posts.empty? %>
          <li class="px-6 py-8 text-center text-sm text-ivory-400">
            No posts yet. <%= link_to "Create one", new_admin_post_path, class: "text-ivory-700 underline" %>
          </li>
        <% end %>
      </ul>
    </div>
  ERB

  create_file "app/views/admin/posts/index.html.erb", <<~ERB
    <% content_for :page_title, "Posts" %>

    <div class="flex items-center justify-between mb-6">
      <p class="text-sm text-ivory-500"><%= @posts.count %> posts</p>
      <%= link_to "New Post", new_admin_post_path,
            class: "px-4 py-2 bg-ivory-900 text-ivory-50 text-sm font-medium rounded-md hover:bg-ivory-700 transition-colors" %>
    </div>

    <div class="bg-white rounded-lg border border-ivory-200 overflow-hidden">
      <% if @posts.empty? %>
        <p class="px-6 py-8 text-center text-sm text-ivory-400">No posts yet.</p>
      <% else %>
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-ivory-100 bg-ivory-50">
              <th class="px-6 py-3 text-left text-xs font-semibold text-ivory-500 uppercase tracking-wider">Title</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-ivory-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-ivory-500 uppercase tracking-wider">Featured</th>
              <th class="px-6 py-3 text-left text-xs font-semibold text-ivory-500 uppercase tracking-wider">Date</th>
              <th class="px-6 py-3"></th>
            </tr>
          </thead>
          <tbody class="divide-y divide-ivory-100">
            <% @posts.each do |post| %>
              <tr class="hover:bg-ivory-50">
                <td class="px-6 py-4">
                  <p class="font-medium text-ivory-900"><%= post.title %></p>
                  <p class="text-xs text-ivory-400 mt-0.5"><%= post.subtitle&.truncate(60) %></p>
                </td>
                <td class="px-6 py-4">
                  <% if post.published? %>
                    <span class="inline-flex px-2 py-0.5 rounded text-xs font-medium bg-pastel-mint text-green-800">Published</span>
                  <% else %>
                    <span class="inline-flex px-2 py-0.5 rounded text-xs font-medium bg-ivory-100 text-ivory-600">Draft</span>
                  <% end %>
                </td>
                <td class="px-6 py-4">
                  <% if post.featured? %>
                    <span class="inline-flex px-2 py-0.5 rounded text-xs font-medium bg-pastel-lavender text-purple-800">Featured</span>
                  <% end %>
                </td>
                <td class="px-6 py-4 text-ivory-400 text-xs">
                  <%= (post.published_at || post.created_at).strftime("%b %-d, %Y") %>
                </td>
                <td class="px-6 py-4 text-right space-x-4">
                  <%= link_to "Edit", edit_admin_post_path(post), class: "text-xs text-ivory-500 hover:text-ivory-900 transition-colors" %>
                  <%= button_to "Delete", admin_post_path(post), method: :delete,
                        data: { turbo_confirm: "Delete \"#{post.title}\"?" },
                        class: "text-xs text-red-400 hover:text-red-600 bg-transparent border-0 p-0 cursor-pointer transition-colors" %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </div>
  ERB

  create_file "app/views/admin/posts/_form.html.erb", <<~ERB
    <%= form_with model: [:admin, post], class: "space-y-6" do |f| %>
      <% if post.errors.any? %>
        <div class="bg-red-50 border border-red-200 rounded-md px-4 py-3 text-sm text-red-800">
          <ul class="list-disc list-inside space-y-1">
            <% post.errors.full_messages.each do |msg| %>
              <li><%= msg %></li>
            <% end %>
          </ul>
        </div>
      <% end %>

      <div class="grid grid-cols-3 gap-6">

        <%# Main content column %>
        <div class="col-span-2 space-y-6">
          <div class="bg-white rounded-lg border border-ivory-200 p-6 space-y-4">
            <div>
              <%= f.label :title, class: "block text-sm font-medium text-ivory-700 mb-1" %>
              <%= f.text_field :title, class: "w-full border border-ivory-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-ivory-400" %>
            </div>
            <div>
              <%= f.label :subtitle, class: "block text-sm font-medium text-ivory-700 mb-1" %>
              <%= f.text_field :subtitle, class: "w-full border border-ivory-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-ivory-400" %>
            </div>
            <div>
              <%= f.label :body, class: "block text-sm font-medium text-ivory-700 mb-1" %>
              <%= f.rich_text_area :body, class: "w-full min-h-64 border border-ivory-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-ivory-400" %>
            </div>
          </div>
        </div>

        <%# Sidebar column %>
        <div class="space-y-4">
          <div class="bg-white rounded-lg border border-ivory-200 p-6 space-y-4">
            <h3 class="text-sm font-semibold text-ivory-700">Publishing</h3>
            <div>
              <%= f.label :published_at, "Publish date", class: "block text-sm font-medium text-ivory-700 mb-1" %>
              <%= f.datetime_local_field :published_at, class: "w-full border border-ivory-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-ivory-400" %>
              <p class="text-xs text-ivory-400 mt-1">Leave blank to save as draft.</p>
            </div>
            <div class="flex items-center gap-2">
              <%= f.check_box :featured, class: "rounded border-ivory-300 text-ivory-900 focus:ring-ivory-400" %>
              <%= f.label :featured, "Featured post", class: "text-sm font-medium text-ivory-700" %>
            </div>
          </div>

          <div class="bg-white rounded-lg border border-ivory-200 p-6 space-y-3">
            <h3 class="text-sm font-semibold text-ivory-700">Cover Image</h3>
            <% if post.cover_image.attached? %>
              <%= image_tag post.cover_image, class: "w-full rounded-md object-cover max-h-40" %>
            <% end %>
            <%= f.file_field :cover_image, accept: "image/*",
                  class: "w-full text-sm text-ivory-500 file:mr-3 file:py-1.5 file:px-3 file:rounded file:border-0 file:text-sm file:font-medium file:bg-ivory-100 file:text-ivory-700 hover:file:bg-ivory-200 cursor-pointer" %>
          </div>

          <div class="flex gap-3">
            <%= f.submit(post.new_record? ? "Create Post" : "Update Post",
                  class: "flex-1 bg-ivory-900 text-ivory-50 text-sm font-medium px-4 py-2 rounded-md hover:bg-ivory-700 transition-colors cursor-pointer") %>
            <%= link_to "Cancel", admin_posts_path,
                  class: "flex-1 text-center bg-ivory-100 text-ivory-700 text-sm font-medium px-4 py-2 rounded-md hover:bg-ivory-200 transition-colors" %>
          </div>
        </div>

      </div>
    <% end %>
  ERB

  create_file "app/views/admin/posts/new.html.erb", <<~ERB
    <% content_for :page_title, "New Post" %>
    <%= render "form", post: @post %>
  ERB

  create_file "app/views/admin/posts/edit.html.erb", <<~ERB
    <% content_for :page_title, "Edit Post" %>
    <%= render "form", post: @post %>
  ERB

  create_file "app/views/admin/posts/show.html.erb", <<~ERB
    <% content_for :page_title, @post.title %>

    <div class="max-w-3xl space-y-6">
      <div class="flex gap-3">
        <%= link_to "Edit", edit_admin_post_path(@post),
              class: "px-4 py-2 bg-ivory-900 text-ivory-50 text-sm font-medium rounded-md hover:bg-ivory-700 transition-colors" %>
        <%= link_to "All Posts", admin_posts_path,
              class: "px-4 py-2 bg-ivory-100 text-ivory-700 text-sm font-medium rounded-md hover:bg-ivory-200 transition-colors" %>
      </div>

      <div class="bg-white rounded-lg border border-ivory-200 p-8">
        <% if @post.cover_image.attached? %>
          <%= image_tag @post.cover_image, class: "w-full rounded-lg object-cover mb-6 max-h-64" %>
        <% end %>
        <div class="flex items-center gap-2 mb-4">
          <% if @post.published? %>
            <span class="inline-flex px-2 py-0.5 rounded text-xs font-medium bg-pastel-mint text-green-800">
              Published <%= @post.published_at.strftime("%b %-d, %Y") %>
            </span>
          <% else %>
            <span class="inline-flex px-2 py-0.5 rounded text-xs font-medium bg-ivory-100 text-ivory-600">Draft</span>
          <% end %>
          <% if @post.featured? %>
            <span class="inline-flex px-2 py-0.5 rounded text-xs font-medium bg-pastel-lavender text-purple-800">Featured</span>
          <% end %>
        </div>
        <h1 class="text-2xl font-bold text-ivory-900 mb-2"><%= @post.title %></h1>
        <p class="text-ivory-500 mb-6"><%= @post.subtitle %></p>
        <div class="prose prose-slate max-w-none">
          <%= @post.body %>
        </div>
      </div>
    </div>
  ERB

  # --- Public views ---
  say "Creating public views...", :cyan
  empty_directory "app/views/posts"

  create_file "app/views/posts/index.html.erb", <<~ERB
    <div class="max-w-6xl mx-auto px-4 py-10">

      <%# Featured post hero %>
      <% if @featured_post %>
        <section class="bg-ivory-900 text-ivory-50 rounded-xl overflow-hidden mb-12">
          <div class="flex flex-col md:flex-row">
            <% if @featured_post.cover_image.attached? %>
              <div class="md:w-1/2">
                <%= image_tag @featured_post.cover_image, class: "w-full h-64 md:h-full object-cover" %>
              </div>
            <% end %>
            <div class="flex-1 p-8 md:p-12 flex flex-col justify-center">
              <span class="text-xs font-semibold uppercase tracking-widest text-ivory-400 mb-3">Featured</span>
              <h2 class="text-2xl md:text-3xl font-bold mb-3">
                <%= link_to @featured_post.title, post_path(@featured_post),
                      class: "hover:text-ivory-300 transition-colors" %>
              </h2>
              <% if @featured_post.subtitle.present? %>
                <p class="text-ivory-400 mb-6"><%= @featured_post.subtitle %></p>
              <% end %>
              <%= link_to "Read article →", post_path(@featured_post),
                    class: "self-start text-sm font-medium text-ivory-200 hover:text-ivory-50 transition-colors" %>
            </div>
          </div>
        </section>
      <% end %>

      <%# Post grid %>
      <% if @posts.any? %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <% @posts.each do |post| %>
            <article class="bg-white rounded-xl border border-ivory-200 overflow-hidden hover:shadow-md transition-shadow">
              <% if post.cover_image.attached? %>
                <%= link_to post_path(post) do %>
                  <%= image_tag post.cover_image, class: "w-full h-48 object-cover" %>
                <% end %>
              <% end %>
              <div class="p-6">
                <p class="text-xs text-ivory-400 mb-2"><%= post.published_at.strftime("%b %-d, %Y") %></p>
                <h3 class="text-base font-bold text-ivory-900 mb-2">
                  <%= link_to post.title, post_path(post),
                        class: "hover:text-ivory-600 transition-colors" %>
                </h3>
                <% if post.subtitle.present? %>
                  <p class="text-sm text-ivory-500 mb-4"><%= post.subtitle.truncate(100) %></p>
                <% end %>
                <%= link_to "Read →", post_path(post),
                      class: "text-sm font-medium text-ivory-700 hover:text-ivory-900 transition-colors" %>
              </div>
            </article>
          <% end %>
        </div>
      <% elsif @featured_post.nil? %>
        <p class="text-center text-ivory-400 py-20 text-sm">No posts published yet.</p>
      <% end %>

    </div>
  ERB

  create_file "app/views/posts/show.html.erb", <<~ERB
    <div class="max-w-2xl mx-auto px-4 py-10">
      <article>
        <% if @post.cover_image.attached? %>
          <%= image_tag @post.cover_image, class: "w-full rounded-xl object-cover max-h-80 mb-8" %>
        <% end %>

        <header class="mb-8">
          <p class="text-xs text-ivory-400 uppercase tracking-widest mb-3">
            <%= @post.published_at.strftime("%B %-d, %Y") %>
          </p>
          <h1 class="text-3xl md:text-4xl font-bold text-ivory-900 mb-4"><%= @post.title %></h1>
          <% if @post.subtitle.present? %>
            <p class="text-xl text-ivory-500"><%= @post.subtitle %></p>
          <% end %>
        </header>

        <div class="prose prose-slate max-w-none">
          <%= @post.body %>
        </div>

        <footer class="mt-12 pt-8 border-t border-ivory-200">
          <%= link_to "← Back to all posts", posts_path,
                class: "text-sm text-ivory-500 hover:text-ivory-900 transition-colors" %>
        </footer>
      </article>
    </div>
  ERB

  # --- Seeds ---
  say "\nAdmin user setup", :blue
  say "This user will have full access to the admin dashboard.", :yellow

  admin_email    = ask("  Admin email address:")
  admin_password = ask("  Admin password (min 12 characters):")

  append_to_file "db/seeds.rb", <<~RUBY

    # Blog seeds — generated by the blog template.
    # Remove or update credentials before sharing this file.

    admin = User.find_or_create_by!(email_address: "#{admin_email}") do |u|
      u.password = "#{admin_password}"
      u.admin    = true
    end
    puts "Admin: \#{admin.email_address}"

    featured = Post.find_or_create_by!(title: "Welcome to the Blog") do |p|
      p.subtitle     = "A fresh start — edit or replace this from the admin dashboard."
      p.body         = "<p>This is your featured post. Sign in at <strong>/session/new</strong> to manage your content.</p>"
      p.featured     = true
      p.published_at = Time.current
      p.user         = admin
    end

    3.times do |i|
      Post.find_or_create_by!(title: "Sample Post \#{i + 1}") do |p|
        p.subtitle     = "A short description for sample post \#{i + 1}."
        p.body         = "<p>Replace this with your own writing.</p>"
        p.published_at = (i + 1).days.ago
        p.user         = admin
      end
    end

    puts "Posts: \#{Post.count} total"
  RUBY

  rails_command "db:seed"

  say "\nBlog setup complete.", :green
  say "  Public blog:     /", :cyan
  say "  Admin dashboard: /admin", :cyan
  say "  Sign in:         /session/new", :cyan
  say "  Admin email:     #{admin_email}", :cyan
end
