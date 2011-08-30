class Assignment < ActiveRecord::Base
  has_many :checklist_items
  has_many :logs, :as => :loggable
  has_many :documents, :as => :owner
  
  def assignments
    @asgs = Assignment.find_all_by_job_id_and_parent_id_and_partner_type(self.job_id, self.partner_id, 2) 
    @asgs2 = Assignment.find_all_by_job_id_and_parent_id_and_partner_type(self.job_id, self.partner_id, 1)
    
    @asgs.push(@asgs2)
    
    @asgs2.each do |i|
      @asgs.push(i.assignments)
    end
        
    return @asgs.flatten
  end
end
