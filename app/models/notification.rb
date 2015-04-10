require 'ostruct'

class Notification < ActiveRecord::Base
  belongs_to :project
  belongs_to :environment

  validates :project,     :presence => true
  validates :environment, :presence => true
  validates :from,        :presence => true
  validates :to,          :presence => true
  validates :subject,     :presence => true
  validates :template,    :presence => true

  after_initialize :set_defaults

  def subject_for(release)
    generate_content_for(self.subject, release.project.name, release.environment.name, release.version)
  end
  
  def body_for(release)
    generate_content_for(self.template, release.project.name, release.environment.name, release.version)
  end
  
  protected
  
  def set_defaults
    NotificationDefaults.each_pair { |k,v| self[k] ||= v }
  end

  def generate_content_for(template, project, environment, version)
    eval(%{<<-END_OF_TEMPLATE
      #{template}
    END_OF_TEMPLATE}, binding).strip
  end
end
