class Release < ActiveRecord::Base
  belongs_to :project
  belongs_to :environment
  validates :project, :presence => true
  validates :environment, :presence => true
  scope :latest, lambda {
    group(:environment_id).having("MAX(id)")
  }

  scope :recent, lambda {
    where("released_at > ?", (Time.now - 7.days)).includes(:project, :environment).reverse_order
  }
  
  before_validation(:on => :create) do
    self.released_at ||= Time.now
  end

  after_create :send_announcements
  
  def diff version, direction = :forward
    cv = (self.version || "").split(/\./)
    nv = (version || "").split(/\./)
    result = nil
    op = direction == :forward ? :< : :>
    cv.each_with_index do |v,i| 
      if v.to_i.send(op, nv[i].to_i)
        result = i
        break
      end
    end
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

  def previous
    other_releases = project.releases.where(:environment_id => self.environment.id)
    idx = other_releases.index { |x| x.id == self.id }
    other_releases[idx - 1] || self
  end

  def to_param
    version
  end
  handle_asynchronously :send_announcements
  
end
