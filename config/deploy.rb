# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "qaa"
set :repo_url, "git@github.com:TurianKoYoT/QaA.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qaa"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

set :default_shell, '/bin/bash -l'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
