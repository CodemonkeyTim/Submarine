class CreateProjectManagers < ActiveRecord::Migration
  def self.up
    create_table :project_managers do |t|
      t.string :name

      t.timestamps
    end
    
    ProjectManager.create(:name => "unassigned")
    ProjectManager.create(:name => "John Cichosz")
    ProjectManager.create(:name => "Darren Cahoon")
    ProjectManager.create(:name => "Aaron Halling")
    ProjectManager.create(:name => "Tyler Miller")
    ProjectManager.create(:name => "Tyler Tapani")
    ProjectManager.create(:name => "Tod Tapani")
    ProjectManager.create(:name => "Chad Mahoney")
    
  end

  def self.down
    drop_table :project_managers
  end
end
