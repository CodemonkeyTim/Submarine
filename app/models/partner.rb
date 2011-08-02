class Partner < ActiveRecord::Base
  has_one :address
  has_one :contact_person
  
  has_many :log_markings, :as => :loggable
  has_many :documents, :as => :owner
  
  attr_accessor :state
  
  def get_state(job_id, parent_id)
    @stat = self.checklist_items(job_id, parent_id).collect {|i| i.state}.flatten.sort!.first
    if @stat.nil?
      return 4
    else
      return @stat
    end
  end
  
  def suppliers(job_id)
    @sup_ids = Assignment.find_all_by_job_id_and_parent_id_and_partner_type(job_id, self.id, 2).collect {|i| i.partner_id}
    return Partner.find_all_by_id(@sup_ids)
  end
  
  def subcontractors(job_id)
    @sub_ids = Assignment.find_all_by_job_id_and_parent_id_and_partner_type(job_id, self.id, 1).collect {|i| i.partner_id}
    return Partner.find_all_by_id(@sub_ids)
  end
  
  def checklist_items(job_id, parent_id)
    @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id(job_id, parent_id, self.id)
    
    if @asg.nil?
      return []
    else
      return @asg.checklist_items
    end
    
  end
end