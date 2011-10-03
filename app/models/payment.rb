class Payment < ActiveRecord::Base
  has_many :assignments
  
end
