class AddColumnToChecklistItem < ActiveRecord::Migration
  def self.up
    add_column :checklist_items, :job_number, :integer
  end

  def self.down
    remove_column :checklist_items, :job_number
  end
end
