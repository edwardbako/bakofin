source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails'
gem 'pg', '~> 0.18' # Use postgresql as the database for Active Record
gem 'pg_search' # builds ActiveRecord named scopes that take advantage of PostgreSQL’s full text search
gem 'puma', '~> 3.0' # Use Puma as the app server
gem 'will_paginate' # Pagination library
gem 'will_paginate-bootstrap' # Bootstrap styles for pagination links
# gem 'dynamic_sitemaps'

gem 'russian' # I18n

gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'slim-rails' # Slim markup for templates
gem 'bootstrap-sass' # Bootstrap stylesheets
gem 'font-awesome-rails' # Font-awesome icons
# gem 'ionicons-rails' # Ion icons
# gem 'material_icons' # Material icons

gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails' # Use jquery as the JavaScript library
gem 'jquery-ui-rails'
# gem 'jquery-fileupload-rails'

gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster.
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# gem 'trix' # Trix WYSIWYG editor

gem 'redis'
gem 'hiredis'
gem 'sidekiq' # Queueing framework
gem 'sidekiq-cron' # Cron jobs for queueing
gem 'sinatra', :require => nil

gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
gem 'devise' # Rack authentication

gem 'money-rails'

# gem 'carrierwave' # solution for file uploads
# gem 'mini_magick'# A ruby wrapper for ImageMagick

gem 'pry-byebug' # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
gem 'pry-rails'
gem 'pry-doc'
gem 'pry-stack_explorer'
gem 'colorize' # Colorize strings output

group :development, :test do
  gem 'rspec-rails' # RSpec testing framework
  gem 'cucumber-rails', :require => false
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'letter_opener' # Open emails in browser

  gem 'capistrano', '3.6.0' # Deploy automation tool
  gem 'capistrano-rails'
  # gem 'capistrano-rvm'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma', require: false

  gem 'memory_profiler'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
