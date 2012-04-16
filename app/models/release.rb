class Release < ActiveRecord::Base
  belongs_to :project
  belongs_to :environment
  attr_accessible :project_id, :environment_id, :version, :released_at, :link, :release_notes
  validates :project, :presence => true
  validates :environment, :presence => true
  scope :latest, lambda {
    # DANGER: Selecting on MAX(id) isn't a great way to do this, but I can't
    # figure out how to select the ID of the row with MAX(released_id) without
    # a complicated self-join. This way will *almost* always work.
    rt = self.arel_table
    where(:id => rt.project(rt[:id].maximum).group(rt[:project_id], rt[:environment_id]))
  }
  
  before_validation(:on => :create) do
    self.released_at ||= Time.now
  end

  after_create :send_announcements
  
  def diff version
    cv = self.version.split(/\./)
    nv = version.split(/\./)
    result = nil
    cv.each_with_index { |v,i| if v != nv[i]; result = i; break; end }
    result
  end
  
  def environment_name
    environment.name
  end
  
  def send_announcements
    self.project.notifications.where(:environment_id => self.environment.id).each do |notification|
      Announcement.notify(self, notification).deliver
    end
  end
  
end
