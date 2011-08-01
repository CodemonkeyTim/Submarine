class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :log_data
      t.integer :loggable_id
      t.integer :loggable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
