class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :name
      t.integer :job_number
      t.integer :PM_id
      t.string :location
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
