class Project < ActiveRecord::Base
  attr_accessible :name, :kind, :maintainer, :email
  has_many :releases
  def to_s; name; end
end
