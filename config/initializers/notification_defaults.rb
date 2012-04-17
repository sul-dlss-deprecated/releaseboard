settings = YAML.load(File.read(File.join(Rails.root,'config/notification.yml')))[Rails.env.to_sym]
ActionMailer::Base.smtp_settings.merge!(settings[:smtp_settings])
NotificationDefaults = settings[:defaults]
