class AddFieldGlobalToLog < ActiveRecord::Migration
  def self.up
    change_table :logs do |t|    
      t.boolean :global     
    end
  end

  def self.down
    change_table :assignments do |t|    
      t.remove :global     
    end
  end
end
