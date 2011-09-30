class AddProjectEngineersToJob < ActiveRecord::Migration
  def self.up
    change_table :jobs do |t|    
      t.integer :project_engineer_id     
    end
    Job.update_all ["project_engineer_id = ?", 1]
  end

  def self.down
    change_table :jobs do |t|    
      t.remove :project_engineer_id     
    end
  end
end
