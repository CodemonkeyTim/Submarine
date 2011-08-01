class RenameFieldInAssignment < ActiveRecord::Migration
  def self.up
    rename_column :assignments, :type, :partner_type
  end

  def self.down
    rename_column :assignments, :partner_type, :type 
  end
end
