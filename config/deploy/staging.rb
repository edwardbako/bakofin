server '91.240.87.3', port: 22, user: 'deploy', roles: %w(app web db)

set :stage, :staging
set :rails_env, :staging

set :branch, :development
