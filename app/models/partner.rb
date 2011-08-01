class Partner < ActiveRecord::Base
  has_one :address
  
  
  def suppliers(job_id)
    @sup_ids = Assignment.find_all_by_job_id_and_parent_id_and_type(job_id, self.id, 2).collect {|i| i.partner_id}
    return Partner.find_all_by_id(@sup_ids)
  end
  
  def subcontractors(job_id)
    @sub_ids = Assignment.find_all_by_job_id_and_parent_id_and_type(job_id, self.id, 1).collect {|i| i.partner_id}
    return Partner.find_all_by_id(@sup_ids)
  end  
end
