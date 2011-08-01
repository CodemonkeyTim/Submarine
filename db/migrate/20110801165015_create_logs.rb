class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :assignment_id
      t.string :log_data

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
