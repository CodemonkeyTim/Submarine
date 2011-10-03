class Job < ActiveRecord::Base
  has_many :logs, :as => :loggable
  has_many :documents, :as => :owner
  has_many :tags, :as => :taggable
  has_many :payments
  
  belongs_to :project_manager
  belongs_to :project_engineer
  attr_accessor :state
  
  def state
    @state = self.checklist_items.collect {|i| i.state}.flatten.sort!.first
    if @state.nil?
      return 4
    else
      return @state
    end
  end
  
  def subcontractors(payment_id)
    @ids = Assignment.find_all_by_job_id_and_parent_id_and_payment_id(self.id, 0, payment_id).collect {|i| i.partner_id}.flatten
    return Partner.find(@ids)
  end
  
  def checklist_items
    return (Assignment.find_all_by_job_id(self.id).collect {|i| i.checklist_items}).flatten
  end
  
  def active_checklist_items(payment_id)
    return ((Assignment.find_all_by_job_id_and_status_and_payment_id(self.id, 1, payment_id).collect {|i| i.checklist_items}).flatten+(Assignment.find_all_by_job_id_and_status_and_payment_id(self.id, 2, payment_id).collect {|i| i.checklist_items}).flatten).flatten
  end
  
  def partners
    return Partner.find_all_by_id(Assignment.find_all_by_job_id(self.id).collect {|i| i.partner_id})
  end
  
end
