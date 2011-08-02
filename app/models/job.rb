class Job < ActiveRecord::Base
  has_many :logs, :as => :loggable
  
  attr_accessor :state
  
  def state
    @stat = self.checklist_items.collect {|i| i.state}.flatten.sort!.first
    if @stat.nil?
      return 4
    else
      return @stat
    end
  end
  
  def subcontractors
    @ids = Assignment.find_all_by_job_id_and_parent_id(self.id, 0).collect {|i| i.partner_id}.flatten
    return Partner.find(@ids)
  end
  
  def checklist_items
    return (Assignment.find_all_by_job_id(self.id).collect {|i| i.checklist_items}).flatten
  end
  
  def partners
    return Partner.find_all_by_id(Assignment.find_all_by_job_id(self.id).collect {|i| i.partner_id})
  end
  
end
