class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.string :item_data
      t.integer :job_number
      t.integer :partner_id
      t.boolean :is_done

      t.timestamps
    end
  end

  def self.down
    drop_table :list_items
  end
end
