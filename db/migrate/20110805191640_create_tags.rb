class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :taggable_id
      t.string :taggable_type
      t.string :tag_name

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
