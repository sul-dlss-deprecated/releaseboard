class Project < ActiveRecord::Base
  attr_accessible :name, :kind, :description, :maintainer, :email, :source
  has_many :releases, :dependent => :delete_all
  has_many :notifications, :dependent => :delete_all
  has_many :environments, :through => :releases, :select => 'distinct environments.*'
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 20 }
  
  def latest_releases
    releases.latest.also_index_by(:environment_name)
  end
end
