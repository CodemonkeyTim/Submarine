class AddAnotherAndFinalRelationShipTable < ActiveRecord::Migration
  def self.up
    create_table :subcontractors_ssubcontractors, :id => false do |t|
      t.references :subcontractor, :subcontractor
    end
  end

  def self.down
    drop_table "jobs_subonctractors"
  end
end