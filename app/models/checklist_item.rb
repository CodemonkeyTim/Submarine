class ChecklistItem < ActiveRecord::Base
  belongs_to :assignment
  
  attr_accessor :status
  
  def status
    @status
  end
  
end
