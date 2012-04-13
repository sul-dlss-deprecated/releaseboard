class Environment < ActiveRecord::Base
  belongs_to :previous, :class_name => Environment, :foreign_key => :previous_environment_id
  attr_accessible :name
  def to_s; name; end
end
