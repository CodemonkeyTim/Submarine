class ChangeFieldTypeInContactPerson < ActiveRecord::Migration
  def self.up
    change_column("contact_people", "phone_number", "varchar(11)")
  end

  def self.down
  end
end
