class UpdateFieldParamsInContactPerson < ActiveRecord::Migration
  def self.up
    change_column("contact_people", "phone_number", "varchar(15)")
  end

  def self.down
  end
end
