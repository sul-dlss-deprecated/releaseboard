class Project < ActiveRecord::Base
  attr_accessible :name, :kind, :description, :maintainer, :email, :source
  has_many :releases, :dependent => :delete_all
  has_many :notifications, :dependent => :delete_all
  has_many :environments, :through => :releases, :select => 'distinct environments.*'
  validates :name, :presence => true, :uniqueness => true

  after_create :add_default_notification
  
  def latest_releases
    source = releases.latest

    dev = source.select { |x| x.environment.name =~ /dev/ }
    test = source.select { |x| x.environment.name =~ /test/ }
    prod = source.select { |x| x.environment.name =~ /prod/ }

    leftover = source - dev - test - prod

    [dev,test,prod,leftover].flatten
  end

  def latest_release_for_environment environment
    latest_releases.select { |x| x.environment.id == environment.id }.first
  end
  
  def add_default_notification
    env = Environment.find_by_name('production')
    unless env.nil?
      self.notifications.create :environment_id => env.id
      self.notifications.reject! { |n| n.new_record? }
    end
  end

  def latest_release 
    @latest_release ||= releases.latest.sort_by { |x| x.version }.last
  end

  def max_version
    latest_release.version
  rescue
    '0.0.0'
  end

  def to_param
    name
  end
end
