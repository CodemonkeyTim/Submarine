class CreatePartners < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
      t.string :name
      t.integer :category_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :partners
  end
end
