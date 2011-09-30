class CreateProjectEngineers < ActiveRecord::Migration
  def self.up
    create_table :project_engineers do |t|
      t.string :name

      t.timestamps
    end
    
    ProjectEngineer.create(:name => "unassigned")
    ProjectEngineer.create(:name => "Justin Massie")
    ProjectEngineer.create(:name => "Josiah Thomas")
    ProjectEngineer.create(:name => "Loviisa Wisti")
    ProjectEngineer.create(:name => "Randy Redinger")
    ProjectEngineer.create(:name => "Lason McDaniels")
    ProjectEngineer.create(:name => "Lisa Snell")
    ProjectEngineer.create(:name => "Danelle Herr")
    
  end

  def self.down
    drop_table :project_engineers
  end
end
