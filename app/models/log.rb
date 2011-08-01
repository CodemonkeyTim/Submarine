class Log < ActiveRecord::Base
  belongs_to :job
  belongs_to :supplier
  belongs_to :subcontractor
end
