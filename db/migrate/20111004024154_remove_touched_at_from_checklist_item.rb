class RemoveTouchedAtFromChecklistItem < ActiveRecord::Migration
  def self.up
    change_table :checklist_items do |t|    
      t.remove :touched_at     
    end
  end

  def self.down
    change_table :checklist_items do |t|    
      t.date :touched_at     
    end
  end
end
