class Job < ActiveRecord::Base
  has_and_belongs_to_many :subcontractors
  
  attr_accessor :state
  
  def state
    @state
  end
  
end
