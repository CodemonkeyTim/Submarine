class Payment < ActiveRecord::Base
  has_many :assignments
  
  belongs_to :job
  
end
