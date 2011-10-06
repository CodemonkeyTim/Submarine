class AddPaymemntIdToAssignment < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|    
      t.integer :payment_id     
    end
    
    Assignment.update_all ["payment_id = ?", 1]
  end

  def self.down
    change_table :assignments do |t|    
      t.remove :payment_id     
    end
  end
end
