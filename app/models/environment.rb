class Environment < ActiveRecord::Base
  belongs_to :previous, :class_name => Environment, :foreign_key => :previous_environment_id
  has_many :releases, :dependent => :delete_all
  attr_accessible :name
end
