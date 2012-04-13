set :rails_env, "production"
set :deployment_host, "lyberapps-prod.stanford.edu"
set :repository,  "ssh://corn.stanford.edu/afs/ir/dev/dlss/git/lyberteam/releaseboard.git"
set :branch, "master"
set :bundle_without, [:deployment,:development,:test]

role :web, deployment_host
role :app, deployment_host
role :db,  deployment_host, :primary => true
