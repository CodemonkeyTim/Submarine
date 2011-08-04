class Log < ActiveRecord::Base
  belongs_to :jobs
  belongs_to :assignments
end
