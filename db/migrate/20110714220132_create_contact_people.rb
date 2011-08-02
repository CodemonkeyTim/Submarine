class CreateContactPeople < ActiveRecord::Migration
  def self.up
    create_table :contact_people do |t|
      t.integer :partner_id
      t.string :name
      t.string :title
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_people
  end
end
