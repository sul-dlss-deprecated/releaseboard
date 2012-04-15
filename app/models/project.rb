class Project < ActiveRecord::Base
  attr_accessible :name, :kind, :description, :maintainer, :email, :source
  has_many :releases, :dependent => :delete_all
  has_many :environments, :through => :releases, :select => 'distinct environments.*'
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 20 }
  
  def latest_releases
    releases.latest.also_index_by(:environment_name)
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
  protected :ensure_referent_id
end
