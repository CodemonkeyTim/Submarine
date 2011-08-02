class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :partner_id
      t.integer :building_number
      t.string :street
      t.string :city
      t.integer :zip_code
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
