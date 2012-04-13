class Project < ActiveRecord::Base
  attr_accessible :name, :kind, :description, :maintainer, :email, :source
  has_many :releases, :dependent => :delete_all
  has_many :environments, :through => :releases
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 20 }
  validates :kind, :presence => true
  
  def to_s; name; end
  
  def latest_releases
    result = self.releases.group_by { |r| r.environment.name }
    result.keys.each { |k| result[k] = result[k].sort_by(&:released_at).last }
    result
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
