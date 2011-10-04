class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :job_id
      t.integer :number
      t.date :overdue_on
      t.boolean :received
      t.date :received_on

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
