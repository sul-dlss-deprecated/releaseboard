class LinkEnvironments < ActiveRecord::Migration
  def change
    add_column :environments, :previous_environment_id, :integer
  end
end
