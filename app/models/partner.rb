class Partner < ActiveRecord::Base
  has_one :address
  has_one :contact_person
  
  has_many :tags, :as => :taggable
  
  attr_accessor :state
  attr_accessor :status
  
  def get_status
    @status
  end
  
  def get_state(job_id, parent_id)
    @stat =[]
    unless self.checklist_items(job_id, parent_id).first.nil?
      @stat.push(self.checklist_items(job_id, parent_id).collect {|i| i.state}.flatten) 
    end
    unless self.suppliers(job_id).first.nil?
      self.suppliers(job_id).each do |i|
        @i_stat = i.get_state(job_id, self.id)
        @stat.push(@i_stat)
      end
    end
    unless self.subcontractors(job_id).first.nil?
      self.subcontractors(job_id).each do |i|
        @i_stat = i.get_state(job_id, self.id)
        @stat.push(@i_stat)
      end
    end
    
    if @stat.nil? || @stat.first.nil?
      return 4
    else
      @stat = @stat.flatten.sort!.first
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
      return @asg.checklist_items.sort_by {|i| i.cli_type}
    end
    
  end
end