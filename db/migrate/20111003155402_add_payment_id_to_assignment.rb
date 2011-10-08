class AddPaymentIdToAssignment < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|    
      t.integer :payment_id     
    end
    
    Job.all.each do |i|
      @payment = Payment.create(:number => 1, :job_id => i.id)
      @asgs = Assignment.find_all_by_job_id(i.id)
      @asgs.each do |j|
        j.payment_id = @payment.id
        j.save
      end
    end
  end
  
  def self.down
    change_table :assignments do |t|    
      t.remove :payment_id     
    end
  end
end
