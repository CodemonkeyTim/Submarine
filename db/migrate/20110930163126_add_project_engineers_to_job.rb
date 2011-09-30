class AddProjectEngineersToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :project_engineer, :integer
  end

  def self.down
    remove_column :jobs, :project_engineer, :integer
  end
end
