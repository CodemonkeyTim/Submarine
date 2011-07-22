class CreateChecklistItems < ActiveRecord::Migration
  def self.up
    create_table :checklist_items do |t|
      t.string :item_data
      t.integer :listable_id
      t.string :listable_type
      t.integer :state
      t.datetime :touched_at

      t.timestamps
    end
  end

  def self.down
    drop_table :checklist_items
  end
end
