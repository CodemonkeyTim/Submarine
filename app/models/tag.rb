class Tag < ActiveRecord::Base
  has_one :job
  has_one :partner  
end
