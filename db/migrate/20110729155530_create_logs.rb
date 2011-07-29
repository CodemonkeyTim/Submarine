class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :job_id
      t.string :log_data
      t.integer :log_level

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
