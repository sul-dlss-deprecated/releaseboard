class Project < ActiveRecord::Base
  attr_accessible :name, :kind, :description, :maintainer, :email, :source
  has_many :releases, :dependent => :delete_all
  has_many :notifications, :dependent => :delete_all
  has_many :environments, :through => :releases, :select => 'distinct environments.*'
  validates :name, :presence => true, :uniqueness => true

  after_create :add_default_notification
  
  def latest_releases
    releases.latest.also_index_by(:environment_name)
  end
  
  def add_default_notification
    env = Environment.find_by_name('production')
    unless env.nil?
      self.notifications.create :environment_id => env.id
      self.notifications.reject! { |n| n.new_record? }
    end
  end
end
