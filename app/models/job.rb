class Job < ActiveRecord::Base
    
  has_many :logs, :as => :loggable
  
  attr_accessor :state
  
  def state
    @state
  end
  
  def subcontractors
    @ids = Assignment.find_all_by_id_and_parent_id(self.id, 0).collect {|i| i.partner_id}.flatten
    return Partner.find_all_by_id(@ids)
  end
  
  
end
