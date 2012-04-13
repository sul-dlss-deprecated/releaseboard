set :rails_env, "development"
set :deployment_host, "lyberapps-dev.stanford.edu"
set :repository,  "."
set :branch, "master"
set :bundle_without, [:deployment]

role :web, deployment_host
role :app, deployment_host
role :db,  deployment_host, :primary => true
