class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.integer :project_id
      t.integer :environment_id
      t.datetime :released_at
      t.string :version
      t.string :link
      t.text :release_notes
      t.timestamps
    end
  end
end
