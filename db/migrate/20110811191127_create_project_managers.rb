class CreateProjectManagers < ActiveRecord::Migration
  def self.up
    create_table :project_managers do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :project_managers
  end
end
