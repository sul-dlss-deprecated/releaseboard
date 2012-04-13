class Release < ActiveRecord::Base
  belongs_to :project
  belongs_to :environment
  attr_accessible :project_id, :environment_id, :version, :released_at, :link, :release_notes
  
  before_validation(:on => :create) do
    self.released_at ||= Time.now
  end
  
  attr_reader :diff
  
  class << self
    def find_latest
      result = {}
      releases = find(:all, :order => 'released_at DESC').group_by { |r| [r.project.name,r.environment.name] }.values.collect { |g| g.first }.group_by { |r| r.project.name }
      releases.each_pair { |p,r| 
        result[p] = {}
        r.each { |rs| result[p][rs.environment.name] = rs }
      }
      result
    end
  
    def release(project, environment, version, attrs = {})
      attrs.delete_if { |k,v| not self.accessible_attributes.include?(k) }
      project_id = ensure_referent_id(project, Project)
      env_id = ensure_referent_id(environment, Environment)
      hash = { :project_id => project_id, :environment_id => env_id, :version => version }.merge(attrs)
      self.create(hash)
    end

    def ensure_referent_id(thing, class_of_thing)
      if thing.is_a?(class_of_thing)
        thing.id
      elsif thing.is_a?(Fixnum)
        thing
      elsif thing.is_a?(String)
        class_of_thing.find_or_create_by_name(thing).id
      end
    end
#    protected :ensure_referent_id
  end

  def project_name=(value)
    self.project_id = Project.find_or_create_by_name(value).id
  end
  
  def to_s
    "#{project.name} [#{environment.name}] v#{version} (#{released_at.strftime('%c')})"
  end
  
end
