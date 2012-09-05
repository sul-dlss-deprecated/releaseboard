class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :name
      t.string :deployment_host
      t.string :destination
      t.timestamps
    end
  end
end
