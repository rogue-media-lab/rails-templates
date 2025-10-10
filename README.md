# Rails 8 Templates
Rails 8 now has [Application templates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb and each branch in this repo contains a different template.

## Main Template
This template will modify the git environment and git workflow. Specifically it will add a line to the gitignore to ignore the gems in bundle. There is no need to push this weight to github. Just run bundle install when cloning the repo. It will also modify the workflow to run bundle after grabbing the code when performing the action.

The main branch template is just the base version I use when building any default app I want to play, learn, or explore with. This template will rewrite two default files. The gitignore file to add the line to ignore the bundle folder inside the vendor folder. It will also add some configuration to the ci.yml file for the github workflow to set up pg and run bundle when setting up ruby by grabbing the code before the ruby setup and setting the cache to true.

## Two ways to use
1. Open the preferred branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command.
2. Open the preferred branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Command for existing rails app
```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

## Command for new rails app
```bash
rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/rogue-media-lab/rails-templates/refs/heads/main/template.rb
```

