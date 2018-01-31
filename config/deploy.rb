# config valid only for current version of Capistrano
lock '3.6.0'

set :rbenv_ruby, File.read('.ruby-version').strip

set :application, 'bakofin'
set :repo_url, 'git@github.com:edwardbako/bakofin.git'

set :deploy_to, '/home/deploy/www/bakofin'

set :puma_threads, [2, 16]
set :puma_workers, 1

append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/cable.yml',
       'config/redis.yml', 'config/schedule.yml', 'public/robots.txt'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system',
       'public/uploads'

set :keep_releases, 5
set :pty,  false

# after 'deploy:published', 'puma:restart'
after 'deploy:published', 'seed'
