class Release < ActiveRecord::Base
  belongs_to :project
  belongs_to :environment
  attr_accessible :project_id, :environment_id, :version, :released_at, :link, :release_notes
  
  before_validation(:on => :create) do
    self.released_at ||= Time.now
  end
  
  def to_s
    "#{project.name} [#{environment.name}] v#{version} (#{released_at.strftime('%c')})"
  end
  
end
