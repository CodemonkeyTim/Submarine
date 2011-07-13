class CreateJobPartners < ActiveRecord::Migration
  def self.up
    create_table :job_partners do |t|
      t.integer :job_number
      t.integer :partner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_partners
  end
end
