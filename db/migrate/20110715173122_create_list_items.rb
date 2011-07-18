class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.string :item_data
      t.integer :state
      t.integer :job_num
      t.integer :partner_id
      t.date :touched_at

      t.timestamps
    end
  end

  def self.down
    drop_table :list_items
  end
end
