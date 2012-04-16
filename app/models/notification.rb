require 'ostruct'

class Notification < ActiveRecord::Base
  belongs_to :project
  belongs_to :environment
  attr_accessible :project_id, :environment_id, :from, :to, :subject, :template
  validates :project,     :presence => true
  validates :environment, :presence => true
  validates :from,        :presence => true
  validates :to,          :presence => true
  validates :subject,     :presence => true

  after_initialize :set_defaults
  cattr_reader :defaults

  def subject_for(release)
    generate_content_for(self.subject, release.project.name, release.environment.name, release.version)
  end
  
  def body_for(release)
    generate_content_for(self.template, release.project.name, release.environment.name, release.version)
  end
  
  protected
  def self.defaultable_attributes
    self.accessible_attributes.select(&:present?)
  end
  @@defaults = OpenStruct.new Hash[self.defaultable_attributes.select(&:present?).collect { |n| [n,nil] }]
  
  def set_defaults
    self.class.defaultable_attributes.each do |attrib|
      self[attrib.to_sym] ||= self.defaults.send(attrib.to_sym)
    end
  end

  def generate_content_for(template, project, environment, version)
    eval(%{<<-END_OF_TEMPLATE
      #{template}
    END_OF_TEMPLATE}, binding).strip
  end
end
