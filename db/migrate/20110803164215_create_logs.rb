class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :target_type
      t.string :target_name
      t.string :action
      t.string :date
      t.string :time
      t.integer :loggable_id
      t.string :loggable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
