# rails8-templates
Rails 8 now has [Application tamplates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb so I have placed them in seperate branches. You can use the template in a few different ways. To use a template you pass the "-m" flag in the command.

The main purpose for these was to quickly and easily modify the git ignore and git workflow file. Pushing or tracking the gems to gihub annoys me when it is so easy to run bundle and get them so quickly. I prefer to use the git ignore file to ignore the bundle folder, which greatly reduces the weight of an initial push. I also build a app with pg and tailwind. These will often break the github workflow test job and requires my attention. These templates address this issue and many more.

1. Open the prefered branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command.
2. Open the prefered branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Command for existing rails app

```bin/rails app:template LOCATION=https://raw.githubusercontent.com/Developer3027/rails8-templates/refs/heads/main/template.rb```

## Command for new rails app

```rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/Developer3027/rails8-templates/refs/heads/main/template.rb```

The main branch template is just the base version I use when building any default app I want to play, learn, or explore with. This template will rewrite two default files. The gitignore file to add the line to ignore the bundle folder inside the vendor folder. It will also add some configuration to the ci.yml file for the github workflow to set up pg and run bundle when setting up ruby by grabing the code before the ruby setup and setting the cache to true.
