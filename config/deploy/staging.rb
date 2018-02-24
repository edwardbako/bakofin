server '46.101.248.95', port: 22, user: 'deploy', roles: %w(app web db)

set :stage, :staging
set :rails_env, :staging

set :branch, :development
