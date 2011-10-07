class Assignment < ActiveRecord::Base
  has_many :checklist_items
  has_many :logs, :as => :loggable
  has_many :documents, :as => :owner
  
  belongs_to :payment
  
  def assignments(payment_id)
    @asgs = Assignment.find_all_by_job_id_and_parent_id_and_partner_type_and_payment_id(self.job_id, self.partner_id, 2, payment_id) 
    @asgs2 = Assignment.find_all_by_job_id_and_parent_id_and_partner_type_and_payment_id(self.job_id, self.partner_id, 1, payment_id)
    
    @asgs.push(@asgs2)
    
    @asgs2.each do |i|
      @asgs.push(i.assignments(payment_id))
    end
        
    return @asgs.flatten
  end
end
