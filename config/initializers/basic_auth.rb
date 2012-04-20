auth_file = File.join(Rails.root, 'config/auth.yml')
if File.exists?(auth_file)
  ApplicationController.credentials = YAML.load(File.read(auth_file))
else
  Rails.logger.warn "#{auth_file} not found. Create/Update/Destroy requests will not be protected!"
end