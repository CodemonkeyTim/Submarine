class AddCanHaveDocumentToChecklistItem < ActiveRecord::Migration
  def self.up
    change_table :checklist_items do |t|    
      t.boolean :can_have_document     
    end
  end

  def self.down
    change_table :assignments do |t|    
      t.remove :can_have_document     
    end
  end
end
