class AddRelationShipTable < ActiveRecord::Migration
  def self.up
    create_table :subcontractors_suppliers, :id => false do |t|
      t.references :subcontractor, :supplier
    end
  end
    
  def self.down
    drop_table "subonctractors_suppliers"
  end
end
