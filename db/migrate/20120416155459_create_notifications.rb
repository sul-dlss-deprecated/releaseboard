class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :project_id
      t.integer :environment_id
      t.string  :from
      t.string  :to
      t.string  :subject
      t.text    :template
      t.timestamps
    end
  end
end
