class AddProjectFields < ActiveRecord::Migration
  def change
    add_column :projects, :description, :text
    add_column :projects, :source, :string
  end
end
