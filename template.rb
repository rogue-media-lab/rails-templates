require 'fileutils'

# Modify gitignore and workflow for rails and node for basic setup.
# The added weight of the gem files should not be pushed up to github.

# On setting up testing, When cloning the repo, run bundle or bundle install and Rails will review 
# the gem / gem-lock file and install the missing gems. Pushing that weight is not needed.

# This templates will add the lines to the gitignore, cutting the weight of the tracked 
# files, and modify the workflow job - test to ensure the container is set up properly
# and working. Uses PostgreSQL in workflow. 

# NOTE - This will append to .gitignore and overwrite ci.yml if it exists.

# Method to write a file, overwriting existing content
def write_file(file_path, content)
  if File.exist?(file_path)
    puts "Warning: #{file_path} already exists. Overwriting it."
  end
  File.open(file_path, 'w') do |file|
    file.write(content)
  end
  puts "Created/updated file: #{file_path}"
rescue => e
  puts "Error writing to #{file_path}: #{e.message}"
end

# Method to append content to a file if it doesn't already exist
def append_to_file(file_path, content)
  existing_content = File.read(file_path) if File.exist?(file_path)
  unless existing_content&.include?(content)
    File.open(file_path, 'a') do |file|
      file.puts(content)
    end
    puts "Appended to #{file_path}."
  else
    puts "Content already exists in #{file_path}. Skipping."
  end
rescue => e
  puts "Error updating #{file_path}: #{e.message}"
end

# Add lines to .gitignore
append_to_file('.gitignore', <<-CODE
# ignore the gems of bundle
/vendor/bundle
CODE
)

# Ensure the workflows directory exists
workflow_dir = '.github/workflows'
FileUtils.mkdir_p(workflow_dir) unless Dir.exist?(workflow_dir)
puts "Created directory: #{workflow_dir}"

# Modify the ci.yml file
inside(workflow_dir) do
  write_file('ci.yml', <<-YAML
name: CI

on:
  pull_request:
  push:
    branches: [ main ]

jobs:
  scan_ruby:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Scan for common Rails security vulnerabilities using static analysis
        run: bin/brakeman --no-pager

  scan_js:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Scan for security vulnerabilities in JavaScript dependencies
        run: bin/importmap audit

  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Lint code for consistent style
        run: bin/rubocop -f github

  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres
        env:
          POSTGRES_USER: postgres # Default for postgres. Container will be destroyed after run.
          POSTGRES_PASSWORD: postgres # Default for postgres.
        ports:
          - 5432:5432
        options: --health-cmd="pg_isready" --health-interval=10s --health-timeout=5s --health-retries=3

    steps:
      - name: Install packages
        run: sudo apt-get update && sudo apt-get install --no-install-recommends -y google-chrome-stable curl libjemalloc2 libvips postgresql-client

      - name: Checkout code # Grab the code for the package json
        uses: actions/checkout@v4

      - name: Set up Ruby # Will run bundle auto on setup I assume because bundler-cache true.
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Run tests # Run Rails app tests
        env:
          RAILS_ENV: test
          DATABASE_URL: postgres://postgres:postgres@localhost:5432
        run: 
          bin/rails db:migrate db:test:prepare test test:system

      - name: Keep screenshots from failed system tests
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: screenshots
          path: ${{ github.workspace }}/tmp/screenshots
          if-no-files-found: ignore

YAML
  )
end
