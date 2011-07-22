class AddAnotherRelationShipTable < ActiveRecord::Migration
  def self.up
    create_table :jobs_subcontractors, :id => false do |t|
      t.references :job, :subcontractor
    end
  end

  def self.down
    drop_table "jobs_subonctractors"
  end
end