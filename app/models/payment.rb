class Payment < ActiveRecord::Base
  has_many :assignments
  
  belongs_to :job
  
  def checklist_items
    self.assignments.collect {|i| i.checklist_items}.flatten
  end
end
