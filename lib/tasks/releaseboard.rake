desc 'Get application version'
task :app_version do
  require File.expand_path('../../../config/initializers/version',__FILE__)
  puts Releaseboard::VERSION
end
