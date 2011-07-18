class CreateListItemTemplates < ActiveRecord::Migration
  def self.up
    create_table :list_item_templates do |t|
      t.string :item_data

      t.timestamps
    end
  end

  def self.down
    drop_table :list_item_templates
  end
end
