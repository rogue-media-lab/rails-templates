# Rails 8 Templates
Rails 8 now has [Application templates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb and each branch in this repo contains a different template.

## Flash Message Template
*This template should be after Tailwind is set up with the Tailwindcss template.*

This template will:

1. Create a Stimulus controller for dismissing flash messages.

2. Create a shared partial for rendering flash message content.

3. Add the necessary CSS keyframes and animation classes.
   - It will check for a Tailwind CSS setup in `app/assets/stylesheets/tailwind`.
   - If found, it appends `@theme` compatible CSS.
   - If not, it falls back to standard CSS in `app/assets/stylesheets/application.css`.
   
4. Inject the partial into the main application layout file.

## Two ways to use
1. Open the preferred branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command, passing the -m flag.
2. Open the preferred branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Command for existing rails app
```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/flash-message/template.rb
```

## Command for new rails app
```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/flash-message/template.rb
```

