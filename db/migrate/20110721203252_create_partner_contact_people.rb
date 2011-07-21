class CreatePartnerContactPeople < ActiveRecord::Migration
  def self.up
    create_table :partner_contact_people do |t|
      t.integer :partner_id
      t.integer :contact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :partner_contact_people
  end
end
