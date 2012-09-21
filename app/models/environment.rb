class Environment < ActiveRecord::Base
  has_many :releases, :dependent => :delete_all
  attr_accessible :name, :deployment_host, :destination

  def name
    self[:name] || self[:deployment_host]
  end

  def anchor
    "#{name.parameterize}Releases"
  end

  def latest_release
    Release.where(:environment_id => self.id).latest
  end

  def ordering_index
    case name
      when /dev/
        "2-#{name}"
      when /test/
        "1-#{name}"
      when /prod/
        "0-#{name}"
      else
        name
    end  
  end
end
