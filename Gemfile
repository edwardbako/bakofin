source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 7.2.0'
gem 'pg' # Use postgresql as the database for Active Record
gem 'pg_search' # builds ActiveRecord named scopes that take advantage of PostgreSQL’s full text search
gem 'puma' # Use Puma as the app server

gem 'russian' # I18n

# gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
# gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

gem 'slim-rails' # Slim markup for templates

gem 'jbuilder' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'redis'
gem 'hiredis'
gem 'redis-objects', github: "edwardbako/redis-objects", branch: "map_option" # Map Redis types directly to Ruby objects
gem 'sidekiq' # Queueing framework
gem 'sidekiq-cron' # Cron jobs for queueing
# gem 'sinatra', :require => nil

gem 'bcrypt' # Use ActiveModel has_secure_password
gem 'devise' # Rack authentication

gem 'money-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing"

gem 'exception_notification'

gem 'pry-byebug' # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
gem 'pry-rails'
gem 'pry-doc'
gem 'pry-stack_explorer'
gem 'colorize' # Colorize strings output
gem 'highline'
gem 'table_print'

group :development, :test do
  gem 'rspec-rails' # RSpec testing framework
  gem 'cucumber-rails', :require => false
  # gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'

  gem 'letter_opener' # Open emails in browser

  gem 'capistrano'
  gem 'capistrano-rails'
  # gem 'capistrano-rvm'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-nodenv'
  gem 'capistrano-yarn'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"

  gem 'memory_profiler'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
