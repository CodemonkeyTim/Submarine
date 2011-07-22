class CreateSubcontractors < ActiveRecord::Migration
  def self.up
    create_table :subcontractors do |t|
      t.integer :address_id
      t.integer :contact_person_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :subcontractors
  end
end
