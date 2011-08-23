class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :job_id
      t.integer :parent_id
      t.integer :partner_id
      t.integer :partner_type
      t.integer :status
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
