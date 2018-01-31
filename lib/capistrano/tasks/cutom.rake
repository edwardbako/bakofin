desc 'Seed database with rake'
task :seed do
  puts "\n=== Seeding Database ===\n"
  on primary :db do
    within current_path do
      with rails_env: fetch(:stage) do
        execute :rake, 'db:seed'
      end
    end
  end
end

desc 'tail production log files'
task :tail_logs do
  set :log_name, ask('Enter the log name:')
  on roles(:app) do
    execute "tail -f #{current_path}/log/#{fetch(:log_name)}.log"
  end
end

desc 'generate server error page'
task :generate_500_html do
  on roles(:web) do |host|
    public_500_html = File.join(release_path, "public/500.html")
    execute :curl, "-k", "http://#{host.hostname}/500", "> #{public_500_html}"
  end
end


desc 'sitemap generation'
task :generate_sitemap do
  on roles(:app) do
    within current_path do
      with rails_env: fetch(:stage) do
        execute :rails, 'sitemap:generate'
        execute "ln -s #{release_path}/public/sitemaps/sitemap.xml #{release_path}/public/sitemap.xml"
      end
    end
  end
end