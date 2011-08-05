class CreateRecentJobs < ActiveRecord::Migration
  def self.up
    create_table :recent_jobs do |t|
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recent_jobs
  end
end
