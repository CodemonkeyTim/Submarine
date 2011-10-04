class DeleteRecentJobs < ActiveRecord::Migration
  def self.up
    drop_table :recent_jobs
  end

  def self.down
  end
end
