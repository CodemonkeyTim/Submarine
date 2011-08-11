class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :job_number
      t.string :location
      t.string :name
      t.integer :project_manager_id
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
