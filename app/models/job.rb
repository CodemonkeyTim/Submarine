class Job < ActiveRecord::Base
  has_many :logs, :as => :loggable
  has_many :documents, :as => :owner
  has_many :tags, :as => :taggable
  
  belongs_to :project_manager
  attr_accessor :state
  
  def state
    @state = self.checklist_items.collect {|i| i.state}.flatten.sort!.first
    if @state.nil?
      return 4
    else
      return @state
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
