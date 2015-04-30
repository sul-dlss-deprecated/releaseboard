server 'dlss-releases-prod.stanford.edu', user: 'releases', roles: %w{web db app}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, "production"
