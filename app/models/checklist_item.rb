class ChecklistItem < ActiveRecord::Base
  belongs_to :assignment
  has_one :document, :as => :owner
  
  attr_accessor :status
  
  def status
    @status
  end
  
end
