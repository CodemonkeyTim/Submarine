class CreateJobPartnerPartners < ActiveRecord::Migration
  def self.up
    create_table :job_partner_partners do |t|
      t.integer :job_number
      t.integer :partner_id
      t.integer :p_partner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_partner_partners
  end
end
