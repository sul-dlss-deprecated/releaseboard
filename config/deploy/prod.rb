set :rails_env, "production"
set :deployment_host, "sulstats.stanford.edu"
set :repository,  "git://github.com/sul-dlss/releaseboard.git"
set :deploy_via, :remote_cache
set :branch, "master"
set :bundle_without, [:deployment,:development,:test]

role :web, deployment_host
role :app, deployment_host
role :db,  deployment_host, :primary => true
