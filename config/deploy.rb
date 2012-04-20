require "rvm/capistrano"                               # Load RVM's capistrano plugin.
require 'net/ssh/kerberos'
require 'bundler/setup'
require 'bundler/capistrano'
require 'dlss/capistrano'
require 'delayed/recipes'

set :stages, %W(dev testing prod)
set :default_stage, "prod"
set :bundle_flags, "--quiet"
set :rvm_ruby_string, "1.8.7@releaseboard"
set :rvm_type, :system

require 'capistrano/ext/multistage'

after "deploy:assets:symlink", "rvm:trust_rvmrc"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
after "deploy:restart", "dlss:log_release"

set :shared_children, %w(log config/database.yml config/notification.yml config/auth.yml)

set :user, "lyberadmin" 
set :runner, "lyberadmin"
set :ssh_options, {:auth_methods => %w(gssapi-with-mic publickey hostbased), :forward_agent => true}

set :destination, "/var/opt/home/lyberadmin"
set :application, "releaseboard"

set :scm, :git
set :copy_cache, true
set :copy_exclude, [".git"]
set :use_sudo, false
set :keep_releases, 10

set :deploy_to, "#{destination}/#{application}"

namespace :rvm do
  task :trust_rvmrc do
    run "/usr/local/rvm/bin/rvm rvmrc trust #{latest_release}"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end