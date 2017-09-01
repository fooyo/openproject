# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "openproject"
set :full_app_name, "openproject"
set :repo_url, "git@github.com:fooyo/openproject.git"

set :stages, %w(staging production)
set :default_stage, 'production'

set :scm, :git

set :passenger_restart_with_sudo, true

# set :nvm_type, :user # or :system, depends on your nvm setup
# set :nvm_node, 'v6.11.0'
# set :nvm_map_bins, %w{node npm}


# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :bundle_flags, ' --path vendor/bundle'
set :linked_dirs, %w(public/images/uploads)
set :npm_flags, '--production'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# Default value for keep_releases is 5
set :keep_releases, 3



namespace :deploy do

  # after :started, :'nginx:stop'
  # after 'deploy:assets:precompile', :upload_assets

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        run "RAILS_ENV=production bin/delayed_job restart"
      end
    end
  end

  after :finishing, :'nginx:restart'

  #


end

namespace :bundler do
  desc 'Bundle pack'
  task :pack do
    on roles(:web) do
      within release_path do
        execute :bundle, 'pack'
      end
    end
  end
end

before 'bundler:install', 'bundler:pack'


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
