class Log < ActiveRecord::Base
  belongs_to :jobs
  belongs_to :assignments
  
  attr_accessor :log_data
  
  def log_data
    @log_data
  end
end
