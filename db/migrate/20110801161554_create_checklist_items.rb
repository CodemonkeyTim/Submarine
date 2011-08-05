class CreateChecklistItems < ActiveRecord::Migration
  def self.up
    create_table :checklist_items do |t|
      t.integer :assignment_id
      t.integer :cli_type
      t.string :item_data
      t.integer :state
      t.integer :sleep_time
      t.datetime :touched_at

      t.timestamps
    end
  end

  def self.down
    drop_table :checklist_items
  end
end
