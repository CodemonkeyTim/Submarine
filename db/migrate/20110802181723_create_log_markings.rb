class CreateLogMarkings < ActiveRecord::Migration
  def self.up
    create_table :log_markings do |t|
      t.string :log_data
      t.integer :loggable_id
      t.string :loggable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :log_markings
  end
end
