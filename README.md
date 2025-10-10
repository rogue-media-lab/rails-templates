# Rails 8 Templates
Rails 8 now has [Application templates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb and each branch in this repo contains a different template.

## Tailwindcss Template
This template will create the application.css file at `app/assets/tailwind/application.css`. It will include a basic theme configuration for Tailwind. It will also create a `tailwind-config.md` document in the root with instructions on how to use and modify the theme. For Rails 8, this gets you up and running quickly with Tailwind as the basic configuration is preset. Open the app and start using Tailwind!

## Two ways to use
1. Open the preferred branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command, passing the -m flag.
2. Open the preferred branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Command for existing rails app
```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/tailwindcss/template.rb
```

## Command for new rails app
```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/tailwindcss/template.rb
```

